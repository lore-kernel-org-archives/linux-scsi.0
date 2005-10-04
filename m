From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [PATCH] megaraid_sas: fix compat ioctl handling
Date: Tue, 4 Oct 2005 18:48:38 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD21B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55426 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965020AbVJDWss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 18:48:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: linux-scsi@vger.kernel.org

>Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.h
>===================================================================
>--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.h	
>2005-10-04 20:07:32.000000000 +0200
>+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.h	
>2005-10-04 20:28:27.000000000 +0200
>@@ -1124,12 +1124,10 @@
> 	} frame;
> 	struct compat_iovec sgl[MAX_IOCTL_SGE];  } 
>__attribute__ ((packed));
>-
>-#define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct 
>compat_megasas_iocpacket)
>-#else
>-#define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct megasas_iocpacket)
> #endif
> 
>+#define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct megasas_iocpacket)
>+#define MEGASAS_IOC_FIRMWARE32	_IOWR('M', 1, struct 
>compat_megasas_iocpacket)
> #define MEGASAS_IOC_GET_AEN	_IOW('M', 3, struct megasas_aen)
> 
> struct megasas_mgmt_info {
>

MEGASAS_IOC_FIRMWARE32 which is defined outside CONFIG_COMPAT is using
struct compat_megasas_iocpacket which is inside the CONFIG_COMPAT. It
still works because MEGASAS_IOC_FIRMWARE32 is not referenced elsewhere
in the code. I wasn't sure if you inteneded this to be like this (to 
force driver not to use FIRMWARE32 value in outside CONFIG_COMPAT).

The patch looks ok to me.

Sreenivas
