From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Thu, 28 Aug 2008 16:28:12 -0700
Message-ID: <1219966092.13470.519.camel@haakon2.linux-iscsi.org>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>
	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
	 <48B59556.7050108@vlnb.net>
	 <1219875219.13470.380.camel@haakon2.linux-iscsi.org>
	 <48B6E5C8.2000306@vlnb.net>
	 <1219964919.13470.505.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:40877 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753187AbYH1X2P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 19:28:15 -0400
In-Reply-To: <1219964919.13470.505.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>, Greg KH <greg@kroah.com>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jerome Martin <tramjoe.merin@gmail.com>

On Thu, 2008-08-28 at 16:08 -0700, Nicholas A. Bellinger wrote:

<snip>

> > Thus, looks like we'd better stay with /proc. After all, networking and 
> > VM widely use /proc for internal configuration. Why SCSI target is worse?
> > 
> 
> So yeah, RW configuration data going with /proc is completely
> unacceptable for my purposes.  However since all of the LIO iSCSI and
> SCSI MIB code is procfs + seq_file based (and is read-only) I figure
> that considering there are other MIBs related procfs code in other
> subsystems, that this would not be too much of a stumbling point.
> 
> So this configfs stuff is really starting to grow on me, I am surprised
> that I have missed it for so long, I know the author (and alot of the
> OCFSv2 team) and I believe their reasons for creating and moving ocfs2
> to use configfs (even though a production ocfs2 create has much *FEWER*
> configuration information respresented in configfs directories and
> entries than a production iSCSI target would) provide compelling
> evidence to move our efforts for a generic kernel target engine in this
> direction.  So yes, I do feel your pain wrt to existing code, but I
> believe that using procfs from my current IOCTL would quite honestly be
> a step back.  
> 
> How about this, I will begin to implement the LIO-Target pieces in
> configfs for lio-core-2.6.git, and leave LIO-Core in IOCTL for now, and
> once I have some running code, I will look at the process to begin to
> incorporate the requirements to preform the "dumb registration" with a
> generic target engine.  From there, that would give me a good idea of
> what would be required with SCST and configfs.  From the above example
> with configfs, these would be:
> 
> # Create TPGT=1,LUN=0 from Linux LVM Block Device using UUID from
> # 'lvs -v' output
> mkdir $MY_TARGETIQN/tpgt_1/lun_0
> echo $LVM_UUID > $MY_TARGETIQN/tpgt_1/lun_0/location
> 
> # Create TPGT=1,LUN=1 from SCSI Layer h/c/t/l Parameters from lsscsi
> # or /proc/scsi/scsi output
> mkdir $MY_TARGETIQN/tpgt_1/lun_1
> echo $SCSI_HCTL_LOCATION > $MY_TARGETIQN/tpgt_1/lun_1/location
> 

I should mention in this example that the registration of $LVM_UUID and
$SCSI_HCTL_LOCATION storage objects would be done behind the scenes with
these two 'addluntotpg' configfs mkdir's are called.

This means that it would be possible to do storage object registration
before hand and tweak storage object settings / attributes:

# Import $LVM_UUID into Target-Core
mkdir /config/target/core/$LVM_UUID
# Make all LUN Mappings READ-ONLY to $LVM_UUID
echo 0 > /config/target/core/$LVM_UUID/lun_access

... <run other /config/target/$IQN calls>

# Create TPGT=1,LUN=0 from Linux LVM Block Device using UUID from
> # 'lvs -v' output
mkdir $MY_TARGETIQN/tpgt_1/lun_0
# If $LVM_UUID storage object is not already registered with generic 
# target core, automatic registration will occur
echo $LVM_UUID > $MY_TARGETIQN/tpgt_1/lun_0/location

# Finally, allow iSCSI Initiators login to the TargetName+TPGT endpoint
echo 1 > $MY_TARGETIQN/tpgt_1/enable_tpg

--nab

