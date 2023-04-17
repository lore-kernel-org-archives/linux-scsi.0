Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B8BC77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 13:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjDQNE1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 09:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjDQND7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 09:03:59 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B0012017;
        Mon, 17 Apr 2023 06:01:00 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 8EDE62B066B3;
        Mon, 17 Apr 2023 08:59:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 17 Apr 2023 08:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1681736359; x=1681736959; bh=TBaT+4cr6v
        Wz/Vz1IbQN7kXEDEkzvZRMD990nt4ep2M=; b=NCp8K1lPQIB2ax2JeBaHR3G58J
        rxPI2+uyLoOFip4qX0Ah8MisLZG/uYNYYr4eVFJfYH/+0ZF1argZ5wGlLOWjM44h
        HO4jTtOvu9t5X+X315bOfWLNdYbA/1p/Ol0nD+nDFzQmmYY5RTLNS1Var/Kl3SEF
        XujD1CsTFztZY8d9C6LLTk7yxcqVMUrnNVnyDBolHrq9xLW3UMXumM6+mp5doAwL
        4tC7PSWUnX8LMU2v78HXvLfpw6QQxLzhZijJRUZElkmE1Jbe21/XC+OTixLcHhXe
        w+pHTpqB3OwzLpBHzMxvPysVMzFCtmQ7pEVDuJ8AlZDO2FXlrSFxiWwA9vJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1681736359; x=1681736959; bh=TBa
        T+4cr6vWz/Vz1IbQN7kXEDEkzvZRMD990nt4ep2M=; b=HM61VvHZFpPY/Qev1Ar
        PCPVjc7Np+mFUM9OQ7HZspnvd1yXQFWyGZ9qIGU5e5KGBnmQ6ydGbc/7lVGNG70i
        wfdwilDBglYGgi85VV6/t/aV0yiuMMot+Z2DWSLSwkkfxgWhf0aaGMjLUqqZTlNP
        oHGPJzTQyv6DjjDjNrPYIZaoZyc8l0V9jg0i+CukuIXCdUvMxtonJcGsUCLIh88q
        El5NH5Qn5dHUauEZtKFWHLZpBFO3ESuN8Tmqkdggv9D6QiZE6gMvqak3Zfrm3apk
        gGtWeItCuOrBjNbtmyG2gfIQ3VtdzsWIRYpoZCBKr7qMRa9zva8kGfR1SZ2dA75i
        ZKw==
X-ME-Sender: <xms:pkI9ZIynyjAhkjtF5kl9vAdvlMqKBKUQAYfCRaqNkC7lqgC976aAWQ>
    <xme:pkI9ZMQ61_2hI5ZRVp-XTPm5-LJ5JJVos2qDDZC-U8mqy0fByFeT34sZKxR4jLURY
    M1jjfqf27aVzQb3lZ4>
X-ME-Received: <xmr:pkI9ZKV1gI-Fdsoe8Y7SDE-Z9RCfcPMtkJgAQWi1wqVEg3cZPtFTPKLHlK-Dir1gzROHlTvBYcyBxyN7YPF_p547UxL17RLnFNMK9XHX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehshhhi
    nhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpefhke
    dtteeggeegleeltdfgffehleekhfduvdegveduffetudejveetieejiefghfenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitghhih
    hrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:pkI9ZGjBY1KOLpkNTXsif2Ca7-csyoojmmqv3SdzEt0XWu7zywZoAg>
    <xmx:pkI9ZKCNYGwYPVi0W9EAQO40U27xL-EVTfthrWdFdCt7E4zujaNQzg>
    <xmx:pkI9ZHKpwLRI1qGLV1K3yhnUBgB8gP1hFvneJJEM8LWNZywB7wwO3A>
    <xmx:p0I9ZNOuU4U47VEAWaKdY0PaiVdesMtdv8ej6IaSf7HN-mm6vHXFrCMYa9LaXIzW>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:59:17 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 5/9] scsi/004: allow to run with built-in scsi_debug
Date:   Mon, 17 Apr 2023 21:59:09 +0900
Message-Id: <20230417125913.458726-1-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

To allow the test case run with build-in scsi_debug, replace
'_have_module scsi_debug' with _have_scsi_debug, and replace
_init_scsi_debug with _configure_scsi_debug.

Also, save and restore the values of scsi_debug parameters 'opts' and
'ndelay'. The test case modifies the parameters and do not restore their
original values. It is fine when scsi_debug is loadable since scsi_debug
is unloaded after the test case run. However, when scsi_debug is built-
in, the modified parameters may affect following test cases. To avoid
potential impact on following test cases, save original values of the
parameters and restore them at the end of the test case.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 tests/scsi/004 | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tests/scsi/004 b/tests/scsi/004
index f0845c1..110b5f4 100755
--- a/tests/scsi/004
+++ b/tests/scsi/004
@@ -18,15 +18,22 @@ DESCRIPTION="ensure repeated TASK SET FULL results in EIO on timing out command"
 CAN_BE_ZONED=1
 
 requires() {
-	_have_module scsi_debug
+	_have_scsi_debug
 }
 
 test() {
+	local opts ndelay
+
 	echo "Running ${TEST_NAME}"
 
-	if ! _init_scsi_debug add_host=1 max_luns=1 statistics=1 every_nth=1; then
+	if ! _configure_scsi_debug max_luns=1 statistics=1 every_nth=1; then
 	    return 1
 	fi
+
+	# save scsi_debug parameters
+	opts=$(</sys/bus/pseudo/drivers/scsi_debug/opts)
+	ndelay=$(</sys/bus/pseudo/drivers/scsi_debug/ndelay)
+
 	echo 5 > "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/timeout"
 	# every_nth RW with full queue gets SAM_STAT_TASK_SET_FULL
 	echo 0x800 > /sys/bus/pseudo/drivers/scsi_debug/opts
@@ -42,7 +49,11 @@ test() {
 	while grep -q -F "in_use_bm BUSY:" "/proc/scsi/scsi_debug/${SCSI_DEBUG_HOSTS[0]}"; do
 		sleep 1
 	done
-	echo 1 > /sys/bus/pseudo/drivers/scsi_debug/ndelay
+
+	# restore scsi_debug parameters
+	echo "$opts" > /sys/bus/pseudo/drivers/scsi_debug/opts
+	echo "$ndelay" > /sys/bus/pseudo/drivers/scsi_debug/ndelay
+
 	_exit_scsi_debug
 
 	echo "Test complete"
-- 
2.39.2

