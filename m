Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6B5C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 21:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C3B611EE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 21:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhFPV0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbhFPV0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 17:26:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1783C061574
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 14:24:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so4820068pjn.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 14:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lrV+ueQw2mChzjJgiTXDK/L3+//gtPI2oodrs6gshXc=;
        b=dYv7ft+5JxzGTipiy2Fm/x8bo8exXoj89+zxuAGTHokLLgukt246QXBLrvZCa0NsAt
         y04/hjuEhGMfwYTEAQhOEQ6IGYiV2VvDWfx0IL4RQJ5tThdsNMm6ChxS9whndgjrL+wV
         KBdPPzsu1XdLo+kzRIjztUwhr6dtf8sMdEzFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lrV+ueQw2mChzjJgiTXDK/L3+//gtPI2oodrs6gshXc=;
        b=eSht/CeIzyaL7lPL3txsyHFpkk06tIrJT6gDCDXOqxEApJxQ/IsS4n1UvcZkDpDgO5
         lTTIaTotSFJVx12rYEuwlqEKyaqls9T1IJwsO7McvudTGBaqiXj8C+2LtFkcVB5EVCUR
         tOns/m2oNTaCZo5wT2VlSdormLoMUnQ3TA18sZlxIsRSiquEWN7Vy6r57KS7SWRx8dhw
         b1pBZDaNa5prbKqOJTDehzewdZ4B9b40BJvXNCcJ7Qwy32Pbg5nWYdIDR0tK1XaVsio3
         ZcBFi/O0xXXBzpqIuMsUOBEN45vMqTltAt9QPVjgKGQmWGun08ljtrJGVD700h8tlPpM
         lS8Q==
X-Gm-Message-State: AOAM533qiA+FtcwdaCakCsUbDu8JX76Lypnm6jNviGBKqeub2g4ZVowF
        alHg976hFJbxyvUNTzBBMFL2ZQ==
X-Google-Smtp-Source: ABdhPJzUqw1yUanvUQq2LEW3+7GBz+E9b0d1RqyFyFmoHMnn9gZ/JV1+NpGUQcQYlfOJBejriV+luA==
X-Received: by 2002:a17:90b:b03:: with SMTP id bf3mr13046031pjb.47.1623878652429;
        Wed, 16 Jun 2021 14:24:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g141sm2893309pfb.210.2021.06.16.14.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 14:24:11 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: ips: Avoid over-read of sense buffer
Date:   Wed, 16 Jun 2021 14:24:08 -0700
Message-Id: <20210616212408.1726812-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=a45165ee6e303292dbff30e56107273987022b9a; i=65WG4EHUcWGu4u7EnXW2AIYkM9ZhByz86aliewtu4Nc=; m=aVYDbR6DQ67Yybp2qkXQ10FqPUrlSymxU4u3fowec6M=; p=iePJMnRav+rZPhc97kUOyBj5ZvfWWx0gYo+VxgvUscc=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKa/cACgkQiXL039xtwCaFKRAAjut abpUlwT9OaXmZd07ExGATL6WIMjLyBMPPBVJgwiEYMeCmRPzmCqKmMenUBVTCeu4DldGQj8Ybo4Mp sJJdAxS1ZGXga3/uIh1HwLKWS9hUVr8C2kLoqdz6gI4hNz/3HndZo/cp9rKP5ycKiJTBM0Utjmnb4 58usWd3s9wAIFWVTNg97gypK/kgxb1151BzaWOe/egt5+OlfMRKAu4De8oPN/QC+oQ5xEylXJuAjx psG5H5m3kAEQbQB9GRRYIfv9UpHJOeZCgY3guVir3YbAB8RyAOKxyJTljIwIvxSJ9494DJMoOaO+a LWCGmjbmaMexhU4UP9ak33N8vcPydY/sf6IKmEjPrJYvKdKaTULXTy3D+elzvU46nZUamda2l5SR6 ICBuhbGrhIq1czsZWR4mUxezkwKycBJFYMneG32J9QKBrq341YqwIJVH9AGAWN0SphpIc1ARF1t4N w0FJPfum6uLXv7xzgq4UOqxoS3bOYn4xnZX8ZrOnCLtqHcXtdyczuJzwOeCySE9Qek6I1WZO/n6wr x56Ye3+4ZnHHIRpMuyIqqMC5fPiVwRx6fARWBEhoDViwKsj7iGMPWcPfFespBUHdrVie3714eygHK 9xjyH6/ylVjTEAGvieJwNnI0ZkXFxx3pcpsmjd2wTc/YQBsrCXlOlH7EY1K4qWcI=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy() avoid intentionally reading across
neighboring array fields.

scb->scsi_cmd->sense_buffer is 96 bytes:
	#define SCSI_SENSE_BUFFERSIZE        96

tapeDCDB->sense_info is 56 bytes:
	typedef struct {
	   ...
	   uint8_t   sense_info[56];
	} IPS_DCDB_TABLE_TAPE, ...

scb->dcdb.sense_info is 64 bytes:
	typedef struct {
	   ...
	   uint8_t   sense_info[64];
	   ...
	} IPS_DCDB_TABLE, ...

Copying 96 bytes from either was copying beyond the end of the respective
buffers, leading to potential memory content exposures. Correctly copy
the actual buffer contents and zero pad the remaining bytes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/ips.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bc33d54a4011..8b33c9871484 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3344,13 +3344,15 @@ ips_map_status(ips_ha_t * ha, ips_scb_t * scb, ips_stat_t * sp)
 					IPS_CMD_EXTENDED_DCDB_SG)) {
 					tapeDCDB =
 					    (IPS_DCDB_TABLE_TAPE *) & scb->dcdb;
-					memcpy(scb->scsi_cmd->sense_buffer,
+					memcpy_and_pad(scb->scsi_cmd->sense_buffer,
+					       SCSI_SENSE_BUFFERSIZE,
 					       tapeDCDB->sense_info,
-					       SCSI_SENSE_BUFFERSIZE);
+					       sizeof(tapeDCDB->sense_info), 0);
 				} else {
-					memcpy(scb->scsi_cmd->sense_buffer,
+					memcpy_and_pad(scb->scsi_cmd->sense_buffer,
+					       SCSI_SENSE_BUFFERSIZE,
 					       scb->dcdb.sense_info,
-					       SCSI_SENSE_BUFFERSIZE);
+					       sizeof(scb->dcdb.sense_info), 0);
 				}
 				device_error = 2;	/* check condition */
 			}
-- 
2.25.1

