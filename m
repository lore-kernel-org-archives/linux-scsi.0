From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] pm80xx: Fix for 32 bit compilation issue.
Date: Wed, 07 Aug 2013 11:05:00 -0700
Message-ID: <1375898700.2309.28.camel@dabdike.int.hansenpartnership.com>
References: <5201FC9B.5030701@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37738 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352Ab3HGSFD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 14:05:03 -0400
In-Reply-To: <5201FC9B.5030701@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Rich.Bono@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

On Wed, 2013-08-07 at 00:51 -0700, Anand wrote:
> >From cc606631fae60a38ab9532bab79fd93523f4c579 Mon Sep 17 00:00:00 2001
> From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Date: Mon, 5 Aug 2013 14:16:52 +0530
> Subject: [PATCH] pm80xx: Fix for 32 bit compilation issue.
> 
> pm80xx driver does not compile under 32 bit linux. This patch
> fixes the same.

It doesn't?  I see one warning:

drivers/scsi/pm8001/pm8001_init.c:424:4: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]

Which is actually one of these annoying gcc isms, since casting a
pointer to an unsigned long long for the purposes of printing is
perfectly fine.  The usual way of squashing this is the below.

James

---

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3861aa1..4ba8f4d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -424,7 +424,7 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
 			PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
 				"base addr %llx virt_addr=%llx len=%d\n",
 				(u64)pm8001_ha->io_mem[logicalBar].membase,
-				(u64)pm8001_ha->io_mem[logicalBar].memvirtaddr,
+				(u64)(unsigned long)pm8001_ha->io_mem[logicalBar].memvirtaddr,
 				pm8001_ha->io_mem[logicalBar].memsize));
 		} else {
 			pm8001_ha->io_mem[logicalBar].membase	= 0;


