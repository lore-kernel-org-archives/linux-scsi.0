Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFB9C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 11:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiGOLEI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 07:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbiGOLEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 07:04:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1019914D2B
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 04:04:04 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w7so2940437ply.12
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 04:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Valzg4MdQM0s6Xay0/0OhLA2dJ21OLQUFF2eZQYgXgA=;
        b=m3pDjO4Mg+N5AN7bxsMHxeVwbcfVtID/FmTJdKEfO1F/VozkzhJH2LCAT/bvz69gxY
         Fk91SyHAClxBFvpCg6KkirrHFB1ErGIXoCJ1Jb9SLim/Sl2nHSv+U5Z37bsfM9I0s2DE
         YiWRmLLPO/pI/PaQaYPv/lDWLnukIFkFFq6PE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Valzg4MdQM0s6Xay0/0OhLA2dJ21OLQUFF2eZQYgXgA=;
        b=IjL41t6LILqtwflN1VmJD/Ts89EIJgk+gwKx7ihDXWaxklwIdefYN0KSU/UFJ7aAGI
         sj+Z0kXwUDIicRZTYNEFBA++tGiYBAj1EirJvKYU216te+ovsok3Ko1J4Am908laeE4e
         Yew1s6n8MoKTUyJLYXO6+L2UeEJgxBxKgo0Bant6ZbtWsLyWBIqEMWTAvRgnZ3n3boq1
         GQXrtyLpeBVjyTnzoNWoRJt+fJGtWige4petjXYEo7tr/o52dVrbA4UmNegMFZXB5xkg
         K6xtNoYTNUd7dBQapjJevE4lnKH7fwo981Kt4LFxIok0vbLcFkTyMRHSu0KSAE1wdBN9
         ZAZw==
X-Gm-Message-State: AJIora9NrRe3hQw1Ix5eJMIOoM4ypOm982PLsCuegWGZ4tjZBwyUh84k
        Oie8KDYC7M0U6IwR/YUGi2o4FQ==
X-Google-Smtp-Source: AGRyM1t2BRN1BkfsijEq10BldIanrGiPn4J9cS4WzJBqn+aEFxDX88MHtIyvymVk/Ix5V1K697sLLg==
X-Received: by 2002:a17:902:e749:b0:16c:3d6f:aba3 with SMTP id p9-20020a170902e74900b0016c3d6faba3mr12764452plf.135.1657883043108;
        Fri, 15 Jul 2022 04:04:03 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id d64-20020a623643000000b0052b2e8d0894sm2126836pfa.16.2022.07.15.04.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 04:04:02 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufshcd: Read device property for ref clock
Date:   Fri, 15 Jul 2022 21:03:53 +1000
Message-Id: <20220715210230.1.I365d113d275117dee8fd055ce4fc7e6aebd0bce9@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS storage devices require bRefClkFreq attribute to be set to operate
correctly at high speed mode. The necessary value is determined by what the
SoC / board supports. The standard doesn't specify a method to query the
value, so the information needs to be fed in separately.

DT information feeds into setting up the clock framework, so platforms
using DT can get the UFS reference clock frequency from the clock
framework. A special node "ref_clk" from the clock array for the UFS
controller node is used as the source for the information.

On the platforms that do not use DT (e.g. Intel), the alternative mechanism
to feed the intended reference clock frequency is necessary. Specifying the
necessary information in DSD of the UFS controller ACPI node is an
alternative mechanism proposed in this patch. Those can be accessed via
firmware property facility in the kernel and in many ways simillar to
querying properties defined in DT.

This patch introduces a small helper function to query a predetermined ACPI
supplied property of the UFS controller, and uses it to attempt retrieving
reference clock value, unless that was already done by the clock
infrastructure.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

 Documentation/scsi/ufs.rst | 15 +++++++++++++++
 drivers/ufs/core/ufshcd.c  | 16 ++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/scsi/ufs.rst b/Documentation/scsi/ufs.rst
index fbac745b783ce..885b1a736e3f3 100644
--- a/Documentation/scsi/ufs.rst
+++ b/Documentation/scsi/ufs.rst
@@ -17,6 +17,8 @@ Universal Flash Storage
      3.2 UTP Transfer requests
      3.3 UFS error handling
      3.4 SCSI Error handling
+   4. BSG Support
+   5. UFS Reference Clock Frequency configuration
 
 
 1. Overview
@@ -193,3 +195,16 @@ UFS specifications can be found at:
 
 - UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
 - UFSHCI - http://www.jedec.org/sites/default/files/docs/JESD223.pdf
+
+5. UFS Reference Clock Frequency configuration
+==============================================
+
+Devicetree can define a clock named "ref_clk" under the UFS controller node
+to specify the intended reference clock frequency for the UFS storage
+parts. ACPI-based system can specify the frequency using ACPI
+Device-Specific Data property named "ref-clk-freq". In both ways the value
+is interpreted as frequency in Hz and must match one of the values given in
+the UFS specification. UFS subsystem will attempt to read the value when
+executing common controller initialization. If the value is available, UFS
+subsytem will ensure the bRefClkFreq attribute of the UFS storage device is
+set accordingly and will modify it if there is a mismatch.
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ce86d1b790c05..78242f189f636 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8536,6 +8536,19 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 	return ret;
 }
 
+static enum ufs_ref_clk_freq ufshcd_parse_ref_clk_property(struct ufs_hba *hba)
+{
+	u32 freq;
+	int ret = device_property_read_u32(hba->dev, "ref-clk-freq", &freq);
+
+	if (ret) {
+		dev_dbg(hba->dev, "Cannnot query 'ref-clk-freq' property = %d", ret);
+		return REF_CLK_FREQ_INVAL;
+	}
+
+	return ufs_get_bref_clk_from_hz(freq);
+}
+
 static int ufshcd_init_clocks(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -8629,6 +8642,9 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_hba_vreg;
 
+	if (hba->dev_ref_clk_freq == REF_CLK_FREQ_INVAL)
+		hba->dev_ref_clk_freq = ufshcd_parse_ref_clk_property(hba);
+
 	err = ufshcd_setup_clocks(hba, true);
 	if (err)
 		goto out_disable_hba_vreg;
-- 
2.31.0

