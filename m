Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3621C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 05:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7F3E60FD7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 05:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhHZFFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 01:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238353AbhHZFFu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2021 01:05:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908FDC061796
        for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2021 22:05:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so1506197pjx.5
        for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2021 22:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fQOw84Q+0nXTS439fkG942FAnjDvqnWfwdQqvALTohQ=;
        b=mBIJf6cF++on2w7AujWCveBhy0CESIqRracrI4E+ReA9rzTkRtqNOIlcy6OoyMY9rA
         fVp6vRqdfABOysoWaBwtNlxCGcEfJc+LWjjt7Ug4t+rHu1C9f9TTZFqRONpkHBJ9c3gp
         TKzREeVw5QxC8MUXXm70TDsfZJAYCuA2pO3mA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fQOw84Q+0nXTS439fkG942FAnjDvqnWfwdQqvALTohQ=;
        b=uT8mMouynOcq8Ty9X5S7nEBdxSIHJZapmJYS/26grlUb1sId8FkYzRChDjxMIxX5Hf
         Q9jQCSNet5I71PRGmlaBtkB7kwvr6aGDcY4cKX38xutAuyqXtculZbCsH1efyCSET4U3
         OBkafpt8UGn6yhHpRNT/xD6fCag48Sc08jMhh7qbi9bvayEkTiJYIw4QcABUs87Nta9I
         BqDhpGZD5bgjTY9pY5zrajW9gj2kHb4MFf5KnideuW2csoPCKhV4oeBe9lO8YjfIteiJ
         IRG6p0TNV4TyftMyOOQQXK7reHPA/lJlWyNSId18VGibWeH5SUDCcxUTkIVr288Q/6aW
         jatA==
X-Gm-Message-State: AOAM5312LuN1Gzhmp5pY3wsfcNZFvd8hywWLH3K81vq5v7icRhim0oPj
        Yt6RPQuJMxMCNyRUNV0eJDtwtw==
X-Google-Smtp-Source: ABdhPJwo6VGS8sgKUC/lXBcJ3A2OczgUkjeK4pZ7P3TBrDAjZPBQPQLeVWGiqnBaLDF+/uFr4CyJyQ==
X-Received: by 2002:a17:90b:4d91:: with SMTP id oj17mr14662366pjb.209.1629954303060;
        Wed, 25 Aug 2021 22:05:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t13sm1119130pjg.25.2021.08.25.22.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 22:05:00 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Ross Schmidt <ross.schm.dev@gmail.com>,
        Marco Cesati <marcocesati@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-staging@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Keith Packard <keithp@keithp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        clang-built-linux@googlegroups.com, linux-hardening@vger.kernel.org
Subject: [PATCH v2 3/5] treewide: Replace 0-element memcpy() destinations with flexible arrays
Date:   Wed, 25 Aug 2021 22:04:56 -0700
Message-Id: <20210826050458.1540622-4-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826050458.1540622-1-keescook@chromium.org>
References: <20210826050458.1540622-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9605; h=from:subject; bh=tuToPGIO1fwcT/OaQE7CJFyWXS25t8uKJXExyhn0DhY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhJyD5WMohc3p5GetuWgfUYA3hlc3eWWWJdl37Tmzk tsRDR+6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYScg+QAKCRCJcvTf3G3AJjLxD/ 0WbSS7m0+jhuZ0yEDDmx1f3f3Fd4ylc4n8eEvJqyWQTOEBeC52HalM7Wv0GoqDZsr409+b70Kj9En7 2n3jS2Nmosga/L9RN7YC9u8qi0OdqGXVUmPmOeeAy6vMY3nf32TfdIzBf0OFgzOF693Uri3lQdQkGt X1n7jN2/ma2qJETdJEoWZeFuLUJzQFnFmLtffWGvJelOhGoZJVCtEqyChndE2RRsiGw9sxkJrtip/M wVQhx9fXljN7jgmfAnkuyY8cPPfzM8tFAZk5QNk1DwKxkTY6kSjPMt3wQIP2PWVeJxve8cxG6tBEBy 9QcRSQin4AKCk5e1K9dRUpr2rBZ2pxTpu9+h1fQLeq9crY4tlIWA1N9IE+CYenSB5QS/ElgexfKNWg QRC7FAybRvx09RpC7bmtInRliESEbFkmAyXw51g8m6wzhInC4+FQEU3btvs3iAdymFag/3LI+VDOqN 5i89pzAUXDMY+BMrDEHQd5bsBN4FxGIZeLO0x4J0nF3WZCfnqplq/MCuM8U9cVBQWVBkao42uT4M03 Yy3Q3ELveBean30nqem7NAzic3v+h/HJEV+FbLPiM77rxRQPDLqVPu8NjkMJdVAcDTZpjIfLbI/bt/ ZPL1usCDRxrpqI9YR6ZS/0XI6opvoGU0RxLd5AQLk0ekgfIvkKpQ5pCyGAaQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 0-element arrays that are used as memcpy() destinations are actually
flexible arrays. Adjust their structures accordingly so that memcpy()
can better reason able their destination size (i.e. they need to be seen
as "unknown" length rather than "zero").

In some cases, use of the flex_array() helper is needed when a flexible
array is part of a union.

Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Fabio Aiuto <fabioaiuto83@gmail.com>
Cc: Ross Schmidt <ross.schm.dev@gmail.com>
Cc: Marco Cesati <marcocesati@gmail.com>
Cc: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-staging@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath10k/bmi.h         | 10 +++----
 drivers/scsi/qla4xxx/ql4_def.h                |  4 +--
 drivers/staging/rtl8188eu/include/ieee80211.h |  6 ++--
 drivers/staging/rtl8712/ieee80211.h           |  4 +--
 drivers/staging/rtl8723bs/include/ieee80211.h |  6 ++--
 include/linux/ieee80211.h                     | 30 +++++++++----------
 include/uapi/linux/dlm_device.h               |  4 +--
 7 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index f6fadcbdd86e..0685c0d2d4ea 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -109,7 +109,7 @@ struct bmi_cmd {
 		struct {
 			__le32 addr;
 			__le32 len;
-			u8 payload[0];
+			u8 payload[];
 		} write_mem;
 		struct {
 			__le32 addr;
@@ -138,18 +138,18 @@ struct bmi_cmd {
 		} rompatch_uninstall;
 		struct {
 			__le32 count;
-			__le32 patch_ids[0]; /* length of @count */
+			__le32 patch_ids[]; /* length of @count */
 		} rompatch_activate;
 		struct {
 			__le32 count;
-			__le32 patch_ids[0]; /* length of @count */
+			__le32 patch_ids[]; /* length of @count */
 		} rompatch_deactivate;
 		struct {
 			__le32 addr;
 		} lz_start;
 		struct {
 			__le32 len; /* max BMI_MAX_DATA_SIZE */
-			u8 payload[0]; /* length of @len */
+			u8 payload[]; /* length of @len */
 		} lz_data;
 		struct {
 			u8 name[BMI_NVRAM_SEG_NAME_SZ];
@@ -160,7 +160,7 @@ struct bmi_cmd {
 
 union bmi_resp {
 	struct {
-		u8 payload[0];
+		DECLARE_FLEX_ARRAY(u8, payload);
 	} read_mem;
 	struct {
 		__le32 result;
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 031569c496e5..69a590546bf9 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -366,13 +366,13 @@ struct qla4_work_evt {
 		struct {
 			enum iscsi_host_event_code code;
 			uint32_t data_size;
-			uint8_t data[0];
+			uint8_t data[];
 		} aen;
 		struct {
 			uint32_t status;
 			uint32_t pid;
 			uint32_t data_size;
-			uint8_t data[0];
+			uint8_t data[];
 		} ping;
 	} u;
 };
diff --git a/drivers/staging/rtl8188eu/include/ieee80211.h b/drivers/staging/rtl8188eu/include/ieee80211.h
index da6245a77d5d..aa5c1a513495 100644
--- a/drivers/staging/rtl8188eu/include/ieee80211.h
+++ b/drivers/staging/rtl8188eu/include/ieee80211.h
@@ -199,7 +199,7 @@ struct ieee_param {
 		struct {
 			u32 len;
 			u8 reserved[32];
-			u8 data[0];
+			u8 data[];
 		} wpa_ie;
 		struct {
 			int command;
@@ -212,7 +212,7 @@ struct ieee_param {
 			u8 idx;
 			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
 			u16 key_len;
-			u8 key[0];
+			u8 key[];
 		} crypt;
 #ifdef CONFIG_88EU_AP_MODE
 		struct {
@@ -224,7 +224,7 @@ struct ieee_param {
 		} add_sta;
 		struct {
 			u8	reserved[2];/* for set max_num_sta */
-			u8	buf[0];
+			u8	buf[];
 		} bcn_ie;
 #endif
 
diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index 61eff7c5746b..65ceaca9b51e 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -78,7 +78,7 @@ struct ieee_param {
 		struct {
 			u32 len;
 			u8 reserved[32];
-			u8 data[0];
+			u8 data[];
 		} wpa_ie;
 		struct {
 			int command;
@@ -91,7 +91,7 @@ struct ieee_param {
 			u8 idx;
 			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
 			u16 key_len;
-			u8 key[0];
+			u8 key[];
 		} crypt;
 	} u;
 };
diff --git a/drivers/staging/rtl8723bs/include/ieee80211.h b/drivers/staging/rtl8723bs/include/ieee80211.h
index 378c21595e05..89c311cd20a6 100644
--- a/drivers/staging/rtl8723bs/include/ieee80211.h
+++ b/drivers/staging/rtl8723bs/include/ieee80211.h
@@ -180,7 +180,7 @@ struct ieee_param {
 		struct {
 			u32 len;
 			u8 reserved[32];
-			u8 data[0];
+			u8 data[];
 		} wpa_ie;
 	        struct{
 			int command;
@@ -193,7 +193,7 @@ struct ieee_param {
 			u8 idx;
 			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
 			u16 key_len;
-			u8 key[0];
+			u8 key[];
 		} crypt;
 		struct {
 			u16 aid;
@@ -204,7 +204,7 @@ struct ieee_param {
 		} add_sta;
 		struct {
 			u8 reserved[2];/* for set max_num_sta */
-			u8 buf[0];
+			u8 buf[];
 		} bcn_ie;
 	} u;
 };
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a6730072d13a..445597c03cd1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1101,7 +1101,7 @@ struct ieee80211_mgmt {
 			__le16 auth_transaction;
 			__le16 status_code;
 			/* possibly followed by Challenge text */
-			u8 variable[0];
+			u8 variable[];
 		} __packed auth;
 		struct {
 			__le16 reason_code;
@@ -1110,26 +1110,26 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			__le16 listen_interval;
 			/* followed by SSID and Supported rates */
-			u8 variable[0];
+			u8 variable[];
 		} __packed assoc_req;
 		struct {
 			__le16 capab_info;
 			__le16 status_code;
 			__le16 aid;
 			/* followed by Supported rates */
-			u8 variable[0];
+			u8 variable[];
 		} __packed assoc_resp, reassoc_resp;
 		struct {
 			__le16 capab_info;
 			__le16 status_code;
-			u8 variable[0];
+			u8 variable[];
 		} __packed s1g_assoc_resp, s1g_reassoc_resp;
 		struct {
 			__le16 capab_info;
 			__le16 listen_interval;
 			u8 current_ap[ETH_ALEN];
 			/* followed by SSID and Supported rates */
-			u8 variable[0];
+			u8 variable[];
 		} __packed reassoc_req;
 		struct {
 			__le16 reason_code;
@@ -1140,11 +1140,11 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params, TIM */
-			u8 variable[0];
+			u8 variable[];
 		} __packed beacon;
 		struct {
 			/* only variable items: SSID, Supported rates */
-			u8 variable[0];
+			DECLARE_FLEX_ARRAY(u8, variable);
 		} __packed probe_req;
 		struct {
 			__le64 timestamp;
@@ -1152,7 +1152,7 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params */
-			u8 variable[0];
+			u8 variable[];
 		} __packed probe_resp;
 		struct {
 			u8 category;
@@ -1161,16 +1161,16 @@ struct ieee80211_mgmt {
 					u8 action_code;
 					u8 dialog_token;
 					u8 status_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed wme_action;
 				struct{
 					u8 action_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed chan_switch;
 				struct{
 					u8 action_code;
 					struct ieee80211_ext_chansw_ie data;
-					u8 variable[0];
+					u8 variable[];
 				} __packed ext_chan_switch;
 				struct{
 					u8 action_code;
@@ -1186,7 +1186,7 @@ struct ieee80211_mgmt {
 					__le16 timeout;
 					__le16 start_seq_num;
 					/* followed by BA Extension */
-					u8 variable[0];
+					u8 variable[];
 				} __packed addba_req;
 				struct{
 					u8 action_code;
@@ -1202,11 +1202,11 @@ struct ieee80211_mgmt {
 				} __packed delba;
 				struct {
 					u8 action_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed self_prot;
 				struct{
 					u8 action_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed mesh_action;
 				struct {
 					u8 action;
@@ -1250,7 +1250,7 @@ struct ieee80211_mgmt {
 					u8 toa[6];
 					__le16 tod_error;
 					__le16 toa_error;
-					u8 variable[0];
+					u8 variable[];
 				} __packed ftm;
 			} u;
 		} __packed action;
diff --git a/include/uapi/linux/dlm_device.h b/include/uapi/linux/dlm_device.h
index f880d2831160..e83954c69fff 100644
--- a/include/uapi/linux/dlm_device.h
+++ b/include/uapi/linux/dlm_device.h
@@ -45,13 +45,13 @@ struct dlm_lock_params {
 	void __user *bastaddr;
 	struct dlm_lksb __user *lksb;
 	char lvb[DLM_USER_LVB_LEN];
-	char name[0];
+	char name[];
 };
 
 struct dlm_lspace_params {
 	__u32 flags;
 	__u32 minor;
-	char name[0];
+	char name[];
 };
 
 struct dlm_purge_params {
-- 
2.30.2

