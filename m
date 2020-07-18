Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7AEC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 13:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C32B2074B
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 13:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgGRNYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 09:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgGRNYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 09:24:53 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E41AC0619D2;
        Sat, 18 Jul 2020 06:24:53 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 94017BC07E;
        Sat, 18 Jul 2020 13:24:48 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     don.brace@microsemi.com, corbet@lwn.net,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] scsi: smartpqi: Replace HTTP links with HTTPS ones
Date:   Sat, 18 Jul 2020 15:24:42 +0200
Message-Id: <20200718132442.24208-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 Documentation/scsi/smartpqi.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/scsi/smartpqi.rst b/Documentation/scsi/smartpqi.rst
index a7de27352c6f..38dafc70b4cd 100644
--- a/Documentation/scsi/smartpqi.rst
+++ b/Documentation/scsi/smartpqi.rst
@@ -5,7 +5,7 @@ SMARTPQI - Microsemi Smart PQI Driver
 =====================================
 
 This file describes the smartpqi SCSI driver for Microsemi
-(http://www.microsemi.com) PQI controllers. The smartpqi driver
+(https://www.microsemi.com) PQI controllers. The smartpqi driver
 is the next generation SCSI driver for Microsemi Corp. The smartpqi
 driver is the first SCSI driver to implement the PQI queuing model.
 
@@ -19,8 +19,8 @@ when configuring the kernel.
 
 For more information on the PQI Queuing Interface, please see:
 
-- http://www.t10.org/drafts.htm
-- http://www.t10.org/members/w_pqi2.htm
+- https://www.t10.org/drafts.htm
+- https://www.t10.org/members/w_pqi2.htm
 
 Supported devices
 =================
-- 
2.27.0

