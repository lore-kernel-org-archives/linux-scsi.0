From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Fri, 6 Apr 2018 19:42:38 -0400
Message-ID: <20180406234237.GA6043@animx.eu.org>
References: <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
 <20180331221252.GA25573@animx.eu.org>
 <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
 <20180401113721.GA8471@animx.eu.org>
 <20180401163604.GB25011@animx.eu.org>
 <20180401182723.GA31755@animx.eu.org>
 <595a10cfb387e6b2ab4d2053b84fed9b3da9e079.camel@wdc.com>
 <20180406014644.GA16112@animx.eu.org>
 <20180406020651.GB16112@animx.eu.org>
 <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Thu, 2018-04-05 at 22:06 -0400, Wakko Warner wrote:
> > I know now why scsi_print_command isn't doing anything.  cmd->cmnd is null.
> > I added a dev_printk in scsi_print_command where the 2 if statements return.
> > Logs:
> > [  29.866415] sr 3:0:0:0: cmd->cmnd is NULL
> 
> That's something that should never happen. As one can see in
> scsi_setup_scsi_cmnd() and scsi_setup_fs_cmnd() both functions initialize
> that pointer. Since I have not yet been able to reproduce myself what you
> reported, would it be possible for you to bisect this issue? You will need
> to follow something like the following procedure (see also
> https://git-scm.com/docs/git-bisect):

I don't know how relevent it is, but this machine boots nfs and exports it's
dvd drives over iscsi with the target modules.  My scsi_target.lio is at the
end.  I removed the iqn name.  The options are default except for a few. 
Non default options I tabbed over.
eth0 is the nfs/localnet nic and eth1 is the
nic that iscsi goes over.
eth0 is onboard pci 8086:1502 (subsystem 1028:05d3)
eth1 is pci 8086:107d (subsystem 8086:1084)
Both use the e1000e driver

The initiator is running 4.4.107.
When running on the initiator, /dev/sr1 is the target /dev/sr0.  Therefor
cat /dev/sr1 > /dev/null seems to work.
mount /dev/sr1 /cdrom works
find /cdrom -type f | xargs cat > /dev/null immediately crashes the target.
Burning to /dev/sr1 seems to work.

I have another nic that uses igb instead, I'll see if that makes a
difference.

> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> git bisect start
> git bisect bad v4.10
> git bisect good v4.9
> 
> and then build the kernel, install it, boot the kernel and test it.
> Depending on the result, run either git bisect bad or git bisect good and
> keep going until git bisect comes to a conclusion. This can take an hour or
> more.

I'll try this.

Here's my scsi_target.lio:
storage pscsi {
	disk dvd0 {
	path /dev/sr0 
attribute {
emulate_3pc yes 
emulate_caw yes 
emulate_dpo no 
emulate_fua_read no 
emulate_model_alias no 
emulate_rest_reord no 
emulate_tas yes 
emulate_tpu no 
emulate_tpws no 
emulate_ua_intlck_ctrl no 
emulate_write_cache no 
enforce_pr_isids yes 
fabric_max_sectors 8192 
is_nonrot yes 
max_unmap_block_desc_count 0 
max_unmap_lba_count 0 
max_write_same_len 65535 
queue_depth 128 
unmap_granularity 0 
unmap_granularity_alignment 0 
}
}
	disk dvd1 {
	path /dev/sr1 
attribute {
emulate_3pc yes 
emulate_caw yes 
emulate_dpo no 
emulate_fua_read no 
emulate_model_alias no 
emulate_rest_reord no 
emulate_tas yes 
emulate_tpu no 
emulate_tpws no 
emulate_ua_intlck_ctrl no 
emulate_write_cache no 
enforce_pr_isids yes 
fabric_max_sectors 8192 
is_nonrot yes 
max_unmap_block_desc_count 0 
max_unmap_lba_count 0 
max_write_same_len 65535 
queue_depth 128 
unmap_granularity 0 
unmap_granularity_alignment 0 
}
}
	disk dvd2 {
	path /dev/sr2 
attribute {
emulate_3pc yes 
emulate_caw yes 
emulate_dpo no 
emulate_fua_read no 
emulate_model_alias no 
emulate_rest_reord no 
emulate_tas yes 
emulate_tpu no 
emulate_tpws no 
emulate_ua_intlck_ctrl no 
emulate_write_cache no 
enforce_pr_isids yes 
fabric_max_sectors 8192 
is_nonrot yes 
max_unmap_block_desc_count 0 
max_unmap_lba_count 0 
max_write_same_len 65535 
queue_depth 128 
unmap_granularity 0 
unmap_granularity_alignment 0 
}
}
}
fabric iscsi {
discovery_auth {
enable no 
mutual_password "" 
mutual_userid "" 
password "" 
userid "" 
}
	target iqn.<myiqn>:dvd tpgt 1 {
enable yes 
attribute {
	authentication no 
cache_dynamic_acls yes 
default_cmdsn_depth 64 
default_erl 0 
demo_mode_discovery yes 
	demo_mode_write_protect no 
fabric_prot_type 0 
	generate_node_acls yes 
login_timeout 15 
netif_timeout 2 
prod_mode_write_protect no 
t10_pi 0 
tpg_enabled_sendtargets 1 
}
auth {
password "" 
password_mutual "" 
userid "" 
userid_mutual "" 
}
parameter {
AuthMethod "CHAP,None" 
DataDigest "CRC32C,None" 
DataPDUInOrder yes 
DataSequenceInOrder yes 
DefaultTime2Retain 20 
DefaultTime2Wait 2 
ErrorRecoveryLevel no 
FirstBurstLength 65536 
HeaderDigest "CRC32C,None" 
IFMarkInt Reject 
IFMarker no 
ImmediateData yes 
InitialR2T yes 
MaxBurstLength 262144 
MaxConnections 1 
MaxOutstandingR2T 1 
MaxRecvDataSegmentLength 8192 
MaxXmitDataSegmentLength 262144 
OFMarkInt Reject 
OFMarker no 
TargetAlias "LIO Target" 
}
	lun 0 backend pscsi:dvd0 
	lun 1 backend pscsi:dvd1 
	lun 2 backend pscsi:dvd2 
	portal 0.0.0.0:3260 
}
}


-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
