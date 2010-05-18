From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] [tgt]: Add proper SG_IO struct cmd CDB passthrough
Date: Tue, 18 May 2010 13:39:16 +0900
Message-ID: <20100518134113M.fujita.tomonori@lab.ntt.co.jp>
References: <1274159574-6053-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42415 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0EREjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2010 00:39:45 -0400
In-Reply-To: <1274159574-6053-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, James.Bottomley@suse.de, dgilbert@interlog.com

On Mon, 17 May 2010 22:12:54 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> These are two patches to allow the STGT SG_IO backstore to function using a
> new struct scsi_cmd->sg_iovec member with sg_io_hdr->iovec_count=1, and to update
> usr/scsi.c:scsi_cmd_perform() to allow for a hand off incoming descriptors into the
> struct device_type_template->cmd_passthrough() function pointer.
> 
> I initially updated usr/sbc.c to set sbc_rw() as it's CDB passthrough function for
> TYPE_DISK, but the logic should apply to any device types *_rw() functions.  Please let
> me know if this makes sense, and I will look at updating the other stgt device types.
> 
> So far with this patch, I am able to successfully mkfs new iSCSI TYPE_DISK LUNS with
> Open-iSCSI to the userspace STGT iSCSI fabric module + SG_IO into kernel level TCM_Loop
> virtual iSCSI target ports on a x86 HVM, and bulk 512KB DATA_SG_IO payloads between STGT
> and TCM_Loop are now functioning as expected.
> 
> There is one unresolved issue that I ran into while running initially with TCM_Loop
> and struct scsi_device->max_sectors=256.  SG_IO writes larger than the
> struct scsi_device->max_sectors are being returned with -EINVAL, but it appears that
> the CHECK_CONDITION is not actually being propigated back into STGT/iSCSI.
> 
> After increasing the TCM_Loop ports to struct scsi_device->max_sectors=1024 following
> the Open-iSCSI Initiator default, the 512KB paylods begin work as expected.  I will need
> to have a look at the case for CDB length > max_sectors, which means that bs_sg.c getting
> the correct scsi_status and sense data out of the kernel might still need more work.
> 
> In the mean time, please have a look at applying these patches.
> 
> Best,
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> Nicholas Bellinger (2):
>   [tgt]: Add proper CDB passthrough for SG_IO backstores
>   [tgt]: Add support for SG_IO CDB passthrough in scsi_cmd_perform()
> 
>  usr/bs_sg.c     |   31 ++++++++++++++++++++++++-------
>  usr/sbc.c       |    1 +
>  usr/scsi.c      |   11 +++++++++++
>  usr/scsi_cmnd.h |    4 ++++
>  usr/tgtd.h      |    2 ++
>  5 files changed, 42 insertions(+), 7 deletions(-)

Thanks! Surely, the first patch looks fine.

I thought that you want to send all SCSI commands to your in-kernel
target code via SG_IO. That's, you want the proper 'pass-through' code
since tgt's pass-through code is broken.

However, looks like non I/O commands are still performed in user-space
tgt code and only I/O commands goes to kernel via SG_IO. Hmm, that's
what you want to do?
