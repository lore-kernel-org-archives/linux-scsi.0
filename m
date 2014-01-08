From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
Date: Wed, 8 Jan 2014 12:27:30 +0000
Message-ID: <bd7f5bb0d19c45e2af9702c1cb6068ea@DM2PR07MB400.namprd07.prod.outlook.com>
References: <20131025144452.GA28451@ngolde.de>
 <20131030171351.GB4130@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1lp0151.outbound.protection.outlook.com ([207.46.163.151]:33985
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbaAHM1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 07:27:34 -0500
In-Reply-To: <20131030171351.GB4130@longonot.mountain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "security@kernel.org" <security@kernel.org>, Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>



>-----Original Message-----
>From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
>Sent: Wednesday, October 30, 2013 10:44 PM
>To: DL-MegaRAID Linux
>Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org; security@kernel.org;
>Nico Golde; Fabian Yamaguchi
>Subject: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
>
>pthru32->dataxferlen comes from the user so we need to check that it's
>not too large so we don't overflow the buffer.
>
>Reported-by: Nico Golde <nico@ngolde.de>
>Reported-by: Fabian Yamaguchi <fabs@goesec.de>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>---
>Please review this carefully because I have not tested it.
>
>diff --git a/drivers/scsi/megaraid/megaraid_mm.c
>b/drivers/scsi/megaraid/megaraid_mm.c
>index dfffd0f..a706927 100644
>--- a/drivers/scsi/megaraid/megaraid_mm.c
>+++ b/drivers/scsi/megaraid/megaraid_mm.c
>@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd,
>mraid_mmadp_t *adp, uioc_t *kioc)
>
> 	pthru32->dataxferaddr	= kioc->buf_paddr;
> 	if (kioc->data_dir & UIOC_WR) {
>+		if (pthru32->dataxferlen > kioc->xferlen)
>+			return -EINVAL;
> 		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
> 						pthru32->dataxferlen)) {
> 			return (-EFAULT);

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

Sumit
