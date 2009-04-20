From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional
	legacy	scsi_execute_async() usage for Linux/SCSI passthrough
Date: Mon, 20 Apr 2009 13:36:05 -0700
Message-ID: <1240259765.4176.764.camel@haakon2.linux-iscsi.org>
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org>
	 <49EB036B.8090607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46505 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754294AbZDTUgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 16:36:09 -0400
In-Reply-To: <49EB036B.8090607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Paul Mundt <lethal@linux-sh.org>

On Sun, 2009-04-19 at 13:56 +0300, Boaz Harrosh wrote:
> On 04/17/2009 04:09 AM, Nicholas A. Bellinger wrote:
> > Greetings all,
> > 
> > This patch modifies the Target_Core_Mod/ConfigFS v3.0 PSCSI subsystem plugin for target_core_mod v3.0 to add
> > a configurable method of choosing legacy scsi_execute_async() usage for underlying SCSI HTCL struct scsi_device.
> > This method is still the only method of issuing I/O to the Linux SCSI subsystem is used for non TYPE_DISK hardware
> > SCSI and SATA devices that appear under Linux-SCSI, but have not yet been updated to accept raw struct request
> > operations directly.  Some of these include TYPE_ROM, TYPE_TYPE and TYPE_MEDIUM_CHANGER hardware.
> > 
> > This method can be used be used via ConfigFS as follows:
> > 
> > 	export TARGET=/sys/kernel/config/target/core/
> >         # load target_core_mod
> > 	modprobe target_core_mod
> > 	# The Linux/SCSI scsi host id is part of pscsi_$HOST_ID HBA name..
> > 	mkdir -p $TARGET/pscsi_0/sr0
> > 	# echo CTL to the control configfs attribute
> > 	echo scsi_channel_id=0,scsi_target_id=0,scsi_lun_id=0 > $TARGET/pscsi_0/sr0/control
> >         # Activate the target_core_mod/ConfigFS PSCSI storage object
> > 	echo 1 > $TARGET/pscsi_0/sr0/enable
> > 
> > At this point, creating symlinks for SCSI target ports to configfs enabled fabric modules
> > against PSCSI hardware passthrough using te HCTL reference will work.
> > 
> > This patch are made against lio-core-2.6.git/master and tested on
> > v2.6.29 x86 32-bit HVM with TYPE_DISK and v2.6.29 ppc64 with TYPE_ROM.
> > The lio-core-2.6.git tree can be found at: 
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary
> > 
> > :-)
> > 
> 
> Are you aware that scsi_execute_async() has gone in 2.6.30-rc1?
> 
> I'm not sure what would be the best alternative for you. I would say
> a bio, but it is still being debated. Your current options are:
> 
> 1. bio_alloc then loop () bio_add_pc_page, and finally blk_rq_append_bio
>    (Which block people don't like)
> 2. sglist => page-pointers-array translation and blk_rq_map_user with 
>    struct rq_map_data mode. (not possible with all kind of sglists)
> 2. sglist => iovec translation and blk_rq_map_user_iov()
>    (Very very ugly mapping of pages to virtual pointers)
> 
> I have a similar situation with my OSD code.
> 

Hey,

Thanks for the pointers on this..  Yeah, I knew it was going away soon,
but needed it for some legacy drivers..:-)

Anyways, I will drop this patch for scsi_execute_async() when I branch
for v2.6.30-rcX and look and updating target_core_mod/pSCSI to one of
the listed methods to get up and running.  From the looks of it however
we might want something slightly better than blk_rq_map_user() for the
kernel space pages attached to struct scatterlist and page_links..

Just FYI, the target_core_mod struct scatterlist memory will be in
struct list_head with struct page for allocated se_cmd_t (received CDB),
so it will be pretty easy from the target_core_mod+subsystem plugin side
side to put something that along the lines of list =>
page-pointers-array translation and blk_rq_map_user() into a new
function..

lio-core-2.6.git/drivers/target/target_core_transport.c is using
include/linux/scatterlist.h macros when interacting with struct
scatterlist allocated for each subsystem plugin (from the linked list
struct page memory)  I will have a look and see what would need to be
down to allow all kinds of sglists with something new..

Thanks for your comments!

--nab


