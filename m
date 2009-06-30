From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
 2.6.31-rc1
Date: Tue, 30 Jun 2009 15:48:19 +0000
Message-ID: <1246376899.3816.60.camel@mulgrave.site>
References: <20090629130835.GA3657@mother.pipebreaker.pl>
	 <20090629133431.GM5480@parisc-linux.org>
	 <20090629134602.GN5480@parisc-linux.org>
	 <20090630094046.GE3657@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34734 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbZF3PsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 11:48:18 -0400
In-Reply-To: <20090630094046.GE3657@mother.pipebreaker.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Tue, 2009-06-30 at 11:40 +0200, Tomasz Torcz wrote:
>   I did a rebuild and driver is not happy with above changes. Take a look
> (I have one RAID5 LUN exported which consist 8x500GB, so about 3.5 TB big):

Actually, looks like a simple thinko in the aic7xxx core code ... it
should be indexing of the saved tag not the original tag.  Can you try
this as a fresh patch?

James

---

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index e6f2bb7..56e431e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -593,7 +593,7 @@ ahc_swap_with_next_hscb(struct ahc_softc *ahc, struct scb *scb)
 	memcpy(q_hscb, scb->hscb, sizeof(*scb->hscb));
 	if ((scb->flags & SCB_CDB32_PTR) != 0) {
 		q_hscb->shared_data.cdb_ptr =
-		    ahc_htole32(ahc_hscb_busaddr(ahc, q_hscb->tag)
+		    ahc_htole32(ahc_hscb_busaddr(ahc, saved_tag)
 			      + offsetof(struct hardware_scb, cdb32));
 	}
 	q_hscb->tag = saved_tag;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fd2b978..2d069de 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1115,6 +1115,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
 	host->sg_tablesize = AHC_NSEG;
+	host->max_cmd_len = 32;
 	ahc_lock(ahc, &s);
 	ahc_set_unit(ahc, ahc_linux_unit++);
 	ahc_unlock(ahc, &s);


