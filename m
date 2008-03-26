From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Adaptec AIC-9410W (AIC94xx) + SATA HDDs
Date: Wed, 26 Mar 2008 09:26:13 -0700
Message-ID: <1206548773.3019.35.camel@localhost.localdomain>
References: <47EA5A3B.1070200@ipax.at>
	 <1206542109.3019.3.camel@localhost.localdomain>  <47EA7533.8030304@ipax.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43782 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbYCZQ0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 12:26:20 -0400
In-Reply-To: <47EA7533.8030304@ipax.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-03-26 at 17:09 +0100, Raoul Bhatia [IPAX] wrote:
> James Bottomley wrote:
> > On Wed, 2008-03-26 at 15:14 +0100, Raoul Bhatia [IPAX] wrote:
> >> can anyone point me out, why the adaptec aic-9410W sas controller
> >> detects my sata drive but the kernel does not?
> > [...]
> >> sas: unhandled device 5
> > 
> > This is what libsas produces when it's compiled with CONFIG_SCSI_SAS_ATA
> > set to N.  You need to recompile libsas with support for ATA devices
> > (it's a separate compile option because it sucks in the whole of libata
> > and thus doubles the size of the code).
> 
> thanks, this is working now. sorry for bothering you ;)

It's no bother and the warning is, um, a bit cryptic.  I'm not sure how
anyone who didn't know the code intimately could work out what's going
on.

How about this update just in case anyone else falls into the same trap?

James

---

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 31b9af2..e7d6c63 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -295,11 +295,14 @@ static void sas_discover_domain(struct work_struct *work)
 	case FANOUT_DEV:
 		error = sas_discover_root_expander(dev);
 		break;
-#ifdef CONFIG_SCSI_SAS_ATA
 	case SATA_DEV:
 	case SATA_PM:
+#ifdef CONFIG_SCSI_SAS_ATA
 		error = sas_discover_sata(dev);
 		break;
+#else
+		SAS_DPRINTK("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
+		/* Fall through */
 #endif
 	default:
 		error = -ENXIO;


