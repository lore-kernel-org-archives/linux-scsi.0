Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D60CC64E90
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F35592415B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:27:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tA1icIen"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgKTS1L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgKTS1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 13:27:10 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E4B2224C;
        Fri, 20 Nov 2020 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896830;
        bh=vP1pzWhkGwwWv6FzOv+URxtbtUlNGFlbUP2oQS5TKxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tA1icIencF53P0QW8UZqa7XH0Xl4nU95vfP7QXYVDXWRoD4vSG/Fca2HE2varBRdt
         Jfto8rwURmjLanWM9UbOrqyZ7eqo62OUtcdovxGj15s4d5Vm+1fqUQX1MNsMOq+OHS
         inhT6JcYNGqvnyeyTRVQulEAOAJ3LpmKCAnxIbqg=
Date:   Fri, 20 Nov 2020 12:27:16 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 020/141] scsi: aic7xxx: Fix fall-through warnings for Clang
Message-ID: <1a7cd2f77623e6ab46bbec0b6103b18491419206.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case, and by adding fallthrough
statements in places where the code is intended to fall through, and
finally by replacing /* FALLTHROUGH */ comments with the new
pseudo-keyword macro fallthrough.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 4 +++-
 drivers/scsi/aic7xxx/aic7xxx_core.c | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 98b02e7d38bb..dd8d6646b06f 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6130,6 +6130,7 @@ ahd_free(struct ahd_softc *ahd)
 		fallthrough;
 	case 2:
 		ahd_dma_tag_destroy(ahd, ahd->shared_data_dmat);
+		break;
 	case 1:
 		break;
 	case 0:
@@ -6542,8 +6543,8 @@ ahd_fini_scbdata(struct ahd_softc *ahd)
 			kfree(hscb_map);
 		}
 		ahd_dma_tag_destroy(ahd, scb_data->hscb_dmat);
-		/* FALLTHROUGH */
 	}
+		fallthrough;
 	case 4:
 	case 3:
 	case 2:
@@ -8911,6 +8912,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 					break;
 				case SIU_PFC_ILLEGAL_REQUEST:
 					printk("Illegal request\n");
+					break;
 				default:
 					break;
 				}
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 725bb7f58054..2df664e3e954 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4478,6 +4478,7 @@ ahc_free(struct ahc_softc *ahc)
 		fallthrough;
 	case 2:
 		ahc_dma_tag_destroy(ahc, ahc->shared_data_dmat);
+		fallthrough;
 	case 1:
 		break;
 	case 0:
@@ -5867,9 +5868,8 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int target, char channel,
 				if ((scb->flags & SCB_ACTIVE) == 0)
 					printk("Inactive SCB in qinfifo\n");
 				ahc_done(ahc, scb);
-
-				/* FALLTHROUGH */
 			}
+				fallthrough;
 			case SEARCH_REMOVE:
 				break;
 			case SEARCH_COUNT:
-- 
2.27.0

