From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 09/10] scsi: Conditionally compile in constants.c
Date: Fri, 14 Nov 2014 22:40:17 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A8648@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:59565 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaKNWoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 17:44:15 -0500
In-Reply-To: <1415262639-121586-10-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 09/10] scsi: Conditionally compile in constants.c
> 
> Instead of having constants.c littered with ifdef statements
> we should be moving dummy functions into the header and
> condintionally compile in constants.c if selected.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/Makefile      |  4 +--
>  drivers/scsi/constants.c   | 42 ----------------------------
>  drivers/xen/xen-scsiback.c |  1 +
>  include/scsi/scsi_dbg.h    | 68
> +++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 67 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 4991b62..76f8932 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -158,9 +158,9 @@ obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
> 
>  # This goes last, so that "real" scsi devices probe earlier
>  obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
> -
> -scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
> +scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
>  				   scsicam.o scsi_error.o scsi_lib.o
> +scsi_mod-$(CONFIG_SCSI_CONSTANTS) += constants.o
>  scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
>  scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
>  scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
...

I has no compile issues with and without CONFIG_SCSI_CONSTANTS.

make menuconfig says SCSI_CONSTANTS causes "(kernel size +=12K)".
That appears low now (although other config settings might
be exaggerating that on my machine).

Without CONFIG_SCSI_CONSTANTS:
-rwxrwxr-x 1 relliott relliott 133057434 Nov 14 16:27 vmlinux
-rw-rw-r-- 1 relliott relliott 313306350 Nov 14 16:27 vmlinux.o

With CONFIG_SCSI_CONSTANTS:
-rwxrwxr-x 1 relliott relliott 133132674 Nov 14 16:33 vmlinux
-rw-rw-r-- 1 relliott relliott 313575486 Nov 14 16:33 vmlinux.o

vmlinux is 75,240 bytes different.  So, you might want to
modify the Kconfig description.

Reviewed-by: Robert Elliott <elliott@hp.com>

---
Rob Elliott    HP Server Storage



