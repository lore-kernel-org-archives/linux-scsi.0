From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch 0/2] Update aic79xx
Date: Sat, 30 Jul 2005 10:37:55 -0500
Message-ID: <1122737875.5055.8.camel@mulgrave>
References: <42E10572.6030105@suse.de> <1122048829.5128.1.camel@mulgrave>
	 <42E49DBD.2010708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50142 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262735AbVG3PiD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 11:38:03 -0400
In-Reply-To: <42E49DBD.2010708@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

On Mon, 2005-07-25 at 10:07 +0200, Hannes Reinecke wrote:
> But this is not the root problem.
> 
>  target5:0:10: FAST-160 WIDE SCSI 320.0 MB/s ST IU (6.25 ns, offset 127)
> scsi5: target 10 synchronous with period = 0x8, offset =
> 0x7f(RDSTRM|DT|IU|QAS)
> 
> So, the ppr_options (which have generated the second line) are set ok,
> but they somehow haven't been transferred into the scsi_transport attribute.

Fortunately, HP gave me a U160 AIC card at OLS, so I can now boot it up
and see that the aic7xxx driver has the same problem.  Attached is the
fix (basically it was a single bit variable rounding error).

James

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1635,9 +1635,9 @@ ahc_send_async(struct ahc_softc *ahc, ch
 		spi_period(starget) = tinfo->curr.period;
 		spi_width(starget) = tinfo->curr.width;
 		spi_offset(starget) = tinfo->curr.offset;
-		spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ;
-		spi_qas(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ;
-		spi_iu(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ;
+		spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ ? 1 : 0;
+		spi_qas(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ ? 1 : 0;
+		spi_iu(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ ? 1 : 0;
 		spi_display_xfer_agreement(starget);
 		break;
 	}
@@ -2435,8 +2435,10 @@ static void ahc_linux_set_dt(struct scsi
 	if (dt) {
 		period = 9;	/* 12.5ns is the only period valid for DT */
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
-	} else if (period == 9)
+	} else if (period == 9) {
 		period = 10;	/* if resetting DT, period must be >= 25ns */
+		ppr_options &= ~MSG_EXT_PPR_DT_REQ;
+	}
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);


