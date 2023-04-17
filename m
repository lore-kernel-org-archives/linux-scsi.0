Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F48C77B72
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 12:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjDQMs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 08:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDQMsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 08:48:18 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAAF5584;
        Mon, 17 Apr 2023 05:47:56 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 9F3692B0679E;
        Mon, 17 Apr 2023 08:47:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Apr 2023 08:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1681735675; x=
        1681736275; bh=1+MEVx9jxvmBHXnL2/G+/Ky5rwzrLXN6gGxqfB5sM+I=; b=F
        6SyJBVFWrOWvQ+G2T/yGTkoX9MdJjzQUksooElKaWQPnYl704njTdE96ML8mP27b
        nJu84bxCYnbv2bLa/rFPf4c+umDFn3hl1WeIzIunLZRk0BnIVE6Ywiq7o76Tu4y0
        PDasgJUy8wIIHDlkNXPOdgP+E8Bk7hP6BxZgCsTFvXvpfR3btZUGXu35uAbEIqrz
        tr3dp3rX/KPo/HYyFF6METcDVS0NeaWaLNJfqRIHTOZCRGAA6k8b8oUq6j+2/Uk1
        1qk3la2R9lA+WrHTf4tquKsNzE+F4V+d6uuvdiuA3kH17ziUszIuH8CPJWFFA97J
        C/VHZ4rJUKf3d4Fu188gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1681735675; x=1681736275; bh=1+MEVx9jxvmBHXnL2/G+/Ky5rwzrLXN6gGx
        qfB5sM+I=; b=GZXaMT+JPhv+8bT3OeMQCpQ/0V2R52VqHKE7Rs827RUWe0IMUXh
        NPdx6pTI/YytCXbGii8lHiQK8nNFGLSgL3B3OkNZ8/SziU9cOBK8VNLm6bcZmA0c
        /AdA7T1HmWVs3xxpqw/isjoZ5l1j1l7gTYItToFAYxJPWQh+AVu6lMJEVbwoKI8I
        kYJyLHo4CYYed4QNC8/JZatfpZiPzoS3ISVJCY+05NthcRMRyyhQHsdCXRj11+MP
        +YcmM4GxNI4dtec9Y6pTL01VzWZgYIuyZPWv7VB3yGYuNQD0iV07bcH0uaN3O9oC
        LbNv96R4yGXK6CtKzhZ9ZNF3WHrv++Zj37g==
X-ME-Sender: <xms:-j89ZPEWeSfRoZfiFcEYEERUHM43bACGICEvHvjpqyAK2dlbul0Q6g>
    <xme:-j89ZMVmTQUyrU-ySX78k5rPnSxnheDyNShsk73BQE_Dxb0Q28WxYba5JobngK3NO
    AOWi3tRvkCRfky2XjI>
X-ME-Received: <xmr:-j89ZBIYRldQRTPrWbOBbqJhGNeR8Orn-pFICtD0768a0oEOtHijvPY2deASzTNzGhO9xrRc1ZqA3hSgVWLwcAf_-VeKukFRRgzMec7T>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehs
    hhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpe
    fggfegffejgeefueetgeeukedvhfeludfhhefftdeitdfhteelieefiefhueekgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitg
    hhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:-z89ZNHX8zO21QtDC9uX8PPkjKqNxODyx5RCF8g-lxJ0asfBcUBe-g>
    <xmx:-z89ZFVuqKFcOQRoCPt0SnHsP2n74qrXWSNVz3B4UIDbaiE9i7SJhw>
    <xmx:-z89ZIP0GRV4cpu6RlKjvFQp--KnyklDwr7X753UPmHzokq7ckbXSg>
    <xmx:-z89ZCgRUe2ErMb4yVYaefAMH56ft6W32-QVsgCZX8EFN2MVgwsCqUq3Pnlo1_VY>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:47:53 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 2/9] common/scsi_debug, tests/*: re-define _have_scsi_debug
Date:   Mon, 17 Apr 2023 21:47:21 +0900
Message-Id: <20230417124728.458630-3-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417124728.458630-1-shinichiro@fastmail.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

As a preparation to adapt test cases to built-in scsi_debug module, re-
define the _have_scsi_debug function. It checks that the scsi_debug
module is built as a loadable module. Modify it to check that the
scsi_debug module is available as built-in module or loadable module.

Also replace all _have_scsi_debug calls in test cases with
"_have_module scsi_debug" so that the change of _have_scsi_debug do not
affect the test cases. Following commits will modify them to call
_have_scsi_debug, only for test cases ready to run with built-in
scsi_debug.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 common/scsi_debug | 2 +-
 tests/block/001   | 2 +-
 tests/block/002   | 3 ++-
 tests/block/009   | 3 ++-
 tests/block/025   | 2 +-
 tests/block/027   | 4 +++-
 tests/block/028   | 2 +-
 tests/block/032   | 3 ++-
 tests/loop/004    | 5 ++++-
 tests/scsi/004    | 2 +-
 tests/scsi/005    | 3 ++-
 tests/scsi/007    | 2 +-
 tests/zbd/008     | 5 +++--
 tests/zbd/009     | 2 +-
 tests/zbd/010     | 2 +-
 15 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/common/scsi_debug b/common/scsi_debug
index ae13bb6..5f73354 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -5,7 +5,7 @@
 # scsi_debug helper functions.
 
 _have_scsi_debug() {
-	_have_module scsi_debug
+	_have_driver scsi_debug
 }
 
 _init_scsi_debug() {
diff --git a/tests/block/001 b/tests/block/001
index fb93932..2ea3754 100755
--- a/tests/block/001
+++ b/tests/block/001
@@ -13,7 +13,7 @@ DESCRIPTION="stress device hotplugging"
 TIMED=1
 
 requires() {
-	_have_scsi_debug
+	_have_module scsi_debug
 	_have_driver sd_mod
 	_have_driver sr_mod
 }
diff --git a/tests/block/002 b/tests/block/002
index 05d00d2..a5f3ee5 100755
--- a/tests/block/002
+++ b/tests/block/002
@@ -12,7 +12,8 @@ DESCRIPTION="remove a device while running blktrace"
 QUICK=1
 
 requires() {
-	_have_blktrace && _have_scsi_debug
+	_have_blktrace
+	_have_module scsi_debug
 }
 
 test() {
diff --git a/tests/block/009 b/tests/block/009
index df36edb..d3ea42a 100755
--- a/tests/block/009
+++ b/tests/block/009
@@ -12,7 +12,8 @@
 DESCRIPTION="check page-cache coherency after BLKDISCARD"
 
 requires() {
-	_have_scsi_debug && _have_program xfs_io
+	_have_module scsi_debug
+	_have_program xfs_io
 }
 
 test() {
diff --git a/tests/block/025 b/tests/block/025
index f746c1c..4c48e9f 100755
--- a/tests/block/025
+++ b/tests/block/025
@@ -12,7 +12,7 @@
 DESCRIPTION="do a huge discard with 4k sector size"
 
 requires() {
-	_have_scsi_debug
+	_have_module scsi_debug
 }
 
 test() {
diff --git a/tests/block/027 b/tests/block/027
index b60f62c..ab6369b 100755
--- a/tests/block/027
+++ b/tests/block/027
@@ -19,7 +19,9 @@ QUICK=1
 CAN_BE_ZONED=1
 
 requires() {
-	_have_cgroup2_controller io && _have_scsi_debug && _have_fio
+	_have_cgroup2_controller io
+	_have_module scsi_debug
+	_have_fio
 }
 
 scsi_debug_stress_remove() {
diff --git a/tests/block/028 b/tests/block/028
index 5140d94..13b3278 100755
--- a/tests/block/028
+++ b/tests/block/028
@@ -12,7 +12,7 @@ DESCRIPTION="do I/O on scsi_debug with DIF/DIX enabled"
 DMESG_FILTER="sed -r 's/(guard tag error at sector|ref tag error at location)/blktests failure: \\1/'"
 
 requires() {
-	_have_scsi_debug
+	_have_module scsi_debug
 }
 
 test_pi() {
diff --git a/tests/block/032 b/tests/block/032
index b07b7ab..8975879 100755
--- a/tests/block/032
+++ b/tests/block/032
@@ -13,7 +13,8 @@ DESCRIPTION="remove one mounted device"
 QUICK=1
 
 requires() {
-	_have_xfs && _have_scsi_debug
+	_have_xfs
+	_have_module scsi_debug
 }
 
 test() {
diff --git a/tests/loop/004 b/tests/loop/004
index fab34e8..ca52d80 100755
--- a/tests/loop/004
+++ b/tests/loop/004
@@ -11,7 +11,10 @@ DESCRIPTION="combine loop direct I/O mode and a custom block size"
 QUICK=1
 
 requires() {
-	_have_program xfs_io && _have_scsi_debug && _have_src_program loblksize && _have_loop_set_block_size
+	_have_program xfs_io
+	_have_module scsi_debug
+	_have_src_program loblksize
+	_have_loop_set_block_size
 }
 
 test() {
diff --git a/tests/scsi/004 b/tests/scsi/004
index b5ef2dd..f0845c1 100755
--- a/tests/scsi/004
+++ b/tests/scsi/004
@@ -18,7 +18,7 @@ DESCRIPTION="ensure repeated TASK SET FULL results in EIO on timing out command"
 CAN_BE_ZONED=1
 
 requires() {
-	_have_scsi_debug
+	_have_module scsi_debug
 }
 
 test() {
diff --git a/tests/scsi/005 b/tests/scsi/005
index 22fb495..efd3d82 100755
--- a/tests/scsi/005
+++ b/tests/scsi/005
@@ -11,7 +11,8 @@ DESCRIPTION="test SCSI device blacklisting"
 QUICK=1
 
 requires() {
-	_have_scsi_debug && _have_module_param scsi_debug inq_vendor
+	_have_module scsi_debug
+	_have_module_param scsi_debug inq_vendor
 }
 
 test() {
diff --git a/tests/scsi/007 b/tests/scsi/007
index e7088a1..547a735 100755
--- a/tests/scsi/007
+++ b/tests/scsi/007
@@ -12,7 +12,7 @@ DESCRIPTION="Trigger the SCSI error handler"
 QUICK=1
 
 requires() {
-	_have_scsi_debug
+	_have_module scsi_debug
 }
 
 config_hz() {
diff --git a/tests/zbd/008 b/tests/zbd/008
index c625bad..55b5b6c 100755
--- a/tests/zbd/008
+++ b/tests/zbd/008
@@ -13,8 +13,9 @@ DESCRIPTION="check no stale page cache after BLKZONERESET and data read race"
 TIMED=1
 
 requires() {
-	_have_scsi_debug && _have_module_param scsi_debug zbc &&
-		_have_program xfs_io
+	_have_module scsi_debug
+	_have_module_param scsi_debug zbc
+	_have_program xfs_io
 }
 
 test() {
diff --git a/tests/zbd/009 b/tests/zbd/009
index 483cbf6..c0ce1f2 100755
--- a/tests/zbd/009
+++ b/tests/zbd/009
@@ -36,7 +36,7 @@ requires() {
 	_have_driver btrfs
 	_have_module_param scsi_debug zone_cap_mb
 	_have_program mkfs.btrfs
-	_have_scsi_debug
+	_have_module scsi_debug
 	have_good_mkfs_btrfs
 }
 
diff --git a/tests/zbd/010 b/tests/zbd/010
index 35143b8..c5cb76a 100755
--- a/tests/zbd/010
+++ b/tests/zbd/010
@@ -15,7 +15,7 @@ requires() {
 	_have_module null_blk
 	_have_module_param scsi_debug zone_cap_mb
 	_have_program mkfs.f2fs
-	_have_scsi_debug
+	_have_module scsi_debug
 }
 
 test() {
-- 
2.39.2

