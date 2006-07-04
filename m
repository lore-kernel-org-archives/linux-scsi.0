From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Limit max_luns to 16k
Date: Tue, 04 Jul 2006 10:18:31 +0200
Message-ID: <44AA2457.1000805@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060803020002060503000406"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:46018 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750984AbWGDISh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jul 2006 04:18:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: David Wagner <david.wagner@qlogic.com>, James Smart <James.Smart@Emulex.Com>

This is a multi-part message in MIME format.
--------------060803020002060503000406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

I have encountered a really nice aliasing error in the SCSI stack.
(I only hope Luben is not reading this, it'll be just the thing he'd 
want to hear :-)

Some device allow for a max lun number larger than 16k.
Eg qla2xxx has this:

#define MAX_FIBRE_LUNS         0xFFFF

If we encounter a SCSI-2 device with has
BLIST_SPARSELUN | BLIST_LARGELUN
set we'll end up doing a sequential scan of all 64k luns.

However, according to SAM the top two bits are reserved for hierarchical 
addressing. So if we're using a lun _number_ larger than 16k we'll 
infact are using the flat addressing model of the LUN with mask 0xC000.

So essentially a device at LUN 0x0 will be aliased to LUN 0xC000 et al 
and hence will be seen detected several times from SCSI ML.

The easy way out here is to _not_ scan past 16k; this will 'fix' this 
issue. Affected drivers are qla2xxx and lpfc.

However, I feel in the long run we should at least detect hierarchical 
luns and issue a warning there. Just think of hierarchical LUNs being 
returned from REPORT_LUNS ...

Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------060803020002060503000406
Content-Type: text/plain;
 name="limit-luns-to-16k"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="limit-luns-to-16k"

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b62a72d..af4dd6f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -696,10 +696,10 @@ LPFC_ATTR(discovery_threads, 32, 1, 64, 
 
 /*
 # lpfc_max_luns: maximum number of LUNs per target driver will support
-# Value range is [1,32768]. Default value is 256.
+# Value range is [1,16384]. Default value is 256.
 # NOTE: The SCSI layer will scan each target for this many luns
 */
-LPFC_ATTR_R(max_luns, 256, 1, 32768,
+LPFC_ATTR_R(max_luns, 256, 1, 16384,
 	     "Maximum number of LUNs per target driver will support");
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 139ea0e..3183ad7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -119,7 +119,7 @@ #define WRT_REG_WORD_PIO(addr, data)	(ou
  */
 #define WWN_SIZE		8	/* Size of WWPN, WWN & WWNN */
 #define MAX_FIBRE_DEVICES	512
-#define MAX_FIBRE_LUNS  	0xFFFF
+#define MAX_FIBRE_LUNS  	0x3FFF
 #define	MAX_RSCN_COUNT		32
 #define	MAX_HOST_COUNT		16
 

--------------060803020002060503000406--
