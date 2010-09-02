From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 02/22] configfs: Add struct
	configfs_item_operations->check_link() in configfs_unlink()
Date: Thu, 02 Sep 2010 12:40:40 -0700
Message-ID: <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
	 <201009020031.08750.konrad@darnok.org>
	 <20100902064814.GB27904@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100902064814.GB27904@mail.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-01 at 23:48 -0700, Joel Becker wrote:
> On Thu, Sep 02, 2010 at 12:31:07AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Monday 30 August 2010 05:20:25 Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > >
> > > This patch adds a optional struct configfs_item_operations->check_link()
> > > check called in fs/configfs/symlink.c:configfs_unlink() that can be used by
> > > configfs consumers to check for an explict struct config_group dependence
> > > with active symlink and fail with -EPERM before the unlink(2) syscall is
> > > allowed to occur.
> > >
> > > Currently without this patch, there is not a method that a consumer can
> > > tell configfs_unlink() that it needs to fail for this particular case. 
> > > Allowing ->check_link() to propigate up the errno to VFS is also another
> > > option for the call, but currently for TCM using the existing -EPERM in
> > > configfs_unlink() is fine here.
> > >
> > > Note this patch is used by TCM v4 generic configfs fabric module
> > > infrastructure to allow  explict Initiator Port MappedLUNs symlinks to
> > > create a dependency for the fabric TPG Port LUNs living in a configfs group
> > > that is not a direct struct config_group parent.
> > >
> > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> 	I NAK'd this a while back.  I'm willing to be convinced, but so
> far it remains that way.
> 

Hi Joel,

Thanks for bringing this point up again.  So a brief refresh on why this
is currently required in the fabric independent configfs handlers in
drivers/target/target_core_fabric_configfs.c (patch #19).

So, say we have an TCM fabric module endpoint (a LIO-Target iSCSI
TargetName+TargetPortalGroupTag in the example below) 

target# tree /sys/kernel/config/target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.e475ed6fcdd0/tpgt_1/       
<SNIP>
|-- lun
|   |-- lun_0
|   |   |-- alua_tg_pt_gp
|   |   |-- alua_tg_pt_offline
|   |   |-- alua_tg_pt_status
|   |   |-- alua_tg_pt_write_md
|   |   `-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
|   |-- lun_1
|   |   |-- alua_tg_pt_gp
|   |   |-- alua_tg_pt_offline
|   |   |-- alua_tg_pt_status
|   |   |-- alua_tg_pt_write_md
|   |   `-- lio_east_port -> ../../../../../../target/core/pscsi_0/sdd
|   |-- lun_2
|   |   |-- alua_tg_pt_gp
|   |   |-- alua_tg_pt_offline
|   |   |-- alua_tg_pt_status
|   |   |-- alua_tg_pt_write_md
|   |   `-- ramdisk_port -> ../../../../../../target/core/rd_dr_0/ramdisk
|   |-- lun_3
|   |   |-- alua_tg_pt_gp
|   |   |-- alua_tg_pt_offline
|   |   |-- alua_tg_pt_status
|   |   |-- alua_tg_pt_write_md
|   |   `-- fileio_port -> ../../../../../../target/core/fileio_0/fileio
|   `-- lun_4
|       |-- alua_tg_pt_gp
|       |-- alua_tg_pt_offline
|       |-- alua_tg_pt_status
|       |-- alua_tg_pt_write_md
|       `-- lio_sync_fileio -> ../../../../../../target/core/fileio_1/sync_file
<SNIP>

with some Port/LUNs that are using configfs symlinks back to TCM Core (a seperate module) in
/sys/kernel/config/target/core/$HBA/$DEV/.

So this symlink happens in target_fabric_port_link() here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_fabric_configfs.c;hb=refs/heads/lio-4.0#l619

Then, we add an iSCSI Initiator NodeACL with MappedLUNs using the same
fabric independent handler code in target_core_fabric_configfs.c:

target# tree /sys/kernel/config/target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.e475ed6fcdd0/tpgt_1/acls/   
<SNIP>
|   `-- iqn.2008-04.com.sun.virtualbox.initiator
|       |-- attrib
|       |   |-- dataout_timeout
|       |   |-- dataout_timeout_retries
|       |   |-- default_erl
|       |   |-- nopin_response_timeout
|       |   |-- nopin_timeout
|       |   |-- random_datain_pdu_offsets
|       |   |-- random_datain_seq_offsets
|       |   `-- random_r2t_offsets
|       |-- auth
|       |   |-- authenticate_target
|       |   |-- password
|       |   |-- password_mutual
|       |   |-- userid
|       |   `-- userid_mutual
|       |-- cmdsn_depth
|       |-- info
|       |-- lun_0
|       |   |-- lun_0 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tp
gt_1/lun/lun_0
|       |   `-- write_protect
|       |-- lun_1
|       |   |-- lun_1 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tp
gt_1/lun/lun_1
|       |   `-- write_protect
|       |-- lun_2
|       |   |-- lun_2 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tp
gt_1/lun/lun_2
|       |   `-- write_protect
|       |-- lun_3
|       |   |-- lun_3 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_3
|       |   `-- write_protect
<SNIP>

So minus the fabric dependent groups and attributes listed above, notice
the explict LUN ACLs for the iqn.2008-04.com.sun.virtualbox.initiator
NodeACL (known in TCM lingo at MappedLUNs), which contain a symlink back
to the fabric module's $IQN/$TPGT/lun/lun_$ID configfs group that
contains parent struct se_lun->lun_group.  You can see how this works in
target_fabric_mappedlun_link() here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_fabric_configfs.c;hb=refs/heads/lio-4.0#l67

So, the reason why something like this patch is required is if unlink(2)
is called on the struct lun_group -> struct
se_subsystem_dev->se_dev_group, the ->check_link() is called in
target_fabric_port_check_link(), and we know to fail the unlink(2) by
checking the struct se_lun->lun_acl_count (eg: if LUN ACls for NodeACLs
exist)

This method has been working fine for the ~12 months, if of course the
configfs consumer is aware of limitiations with symlinks, and provides
the special caller to do the check.  However, if you don't like the idea
of configfs consumers handling this, I would also be open to looking
into a patch that would do this referencing counting for parent / child
symlinks within configfs.ko itself.

What do you think..?

Thanks!

--nab
