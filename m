Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2AFC71156
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19852224C
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="f93oMKFq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgKTS1U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgKTS1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 13:27:20 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7297E2224C;
        Fri, 20 Nov 2020 18:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896839;
        bh=rp9HshBp5vIHfY1d6mQT63jYESmM7l8DqdmVLj3RdpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f93oMKFq6azd4gEOV9MEKEi0ZK1I8qyjS9o7kdAIEpazY9qpSRlgZaaaWjR2J07cS
         p+bXuTXxbCgRzk+ibn728mnohYGyGcQwqasJHkPhRkVh4rLq4KxTgV3E4G764+uSMa
         ZpoT+8ASE+f0yH3fsE/nW4YX5laJWmNK7zKPeDvU=
Date:   Fri, 20 Nov 2020 12:27:24 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 021/141] scsi: aic94xx: Fix fall-through warnings for Clang
Message-ID: <9b58459045d303bbea0160f2e349f5799402a2bf.1605896059.git.gustavoars@kernel.org>
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
warnings by explicitly adding a couple of break and fallthrough statements
instead of just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aic94xx/aic94xx_scb.c  | 2 ++
 drivers/scsi/aic94xx/aic94xx_task.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index e2d880a5f391..13677973da5c 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -721,6 +721,7 @@ static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
 		fallthrough;
 	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask |= SAS_SPEED_15_DIS;
+		fallthrough;
 	default:
 	case SAS_LINK_RATE_1_5_GBPS:
 		/* nothing to do */
@@ -739,6 +740,7 @@ static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
 	switch (pd->min_sata_lrate) {
 	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask |= SATA_SPEED_15_DIS;
+		fallthrough;
 	default:
 	case SAS_LINK_RATE_1_5_GBPS:
 		/* nothing to do */
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index f923ed019d4a..3d345057ede6 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -316,6 +316,7 @@ static void asd_task_tasklet_complete(struct asd_ascb *ascb,
 		break;
 	case SAS_PROTOCOL_SSP:
 		asd_unbuild_ssp_ascb(ascb);
+		break;
 	default:
 		break;
 	}
@@ -610,6 +611,7 @@ int asd_execute_task(struct sas_task *task, gfp_t gfp_flags)
 				break;
 			case SAS_PROTOCOL_SSP:
 				asd_unbuild_ssp_ascb(a);
+				break;
 			default:
 				break;
 			}
-- 
2.27.0

