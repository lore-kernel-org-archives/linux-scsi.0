Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4176EC77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 11:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjDYLsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 07:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbjDYLsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 07:48:25 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D3659CD;
        Tue, 25 Apr 2023 04:48:18 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id ECF172B066FC;
        Tue, 25 Apr 2023 07:48:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 25 Apr 2023 07:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1682423294; x=
        1682423894; bh=mj3LqWfjihVWv+zbTeME8/Bh8GDHTxC6knqcFWrBxrk=; b=O
        BrQQtArUh8bcWroB35Hb/hN7xXBjc46Ym6YALi5Gt2G4X5u32B5q3f4v51JSw9go
        Rz/eRpa6EGvVdrQ0eEPme3cMvPswC9pNz+DVXAGwQ4gRsCAVFZ5q91nSZSZTG1VT
        4c92T92PidnpoaPNfIA6g8tFip7w7tbNuXMiAhPGXxAAme+phe518UyCCF+LEDdm
        ItUZoBrwConzfvRljUiBEkd6hmdgVlfXeubOzxhWzxbZn4JyfJquJnO7SH/8kO8f
        2E8w+YLSv9JbhxmK3CtqAp1CtydXkHyZt4CXC/32/2/W0WU6struYZC2+6K/fQRt
        ZBPf3qsv/t9dgO/d27qeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1682423294; x=1682423894; bh=mj3LqWfjihVWv+zbTeME8/Bh8GDHTxC6knq
        cFWrBxrk=; b=alYLqy36Bkk8GFp/B6jHO8K5IhclpVkO14NLYLEV8QnXGLCJENc
        z3tPf1xFZc6sK8ZcVZbKNJ4rh86HRk/v+hh23o/fEf3JbuaiPAJwpgdwzmLXDsn6
        Sr1Wdv4B6mhjPUUvtTDQXrU7fkKAnOb5VLiM3Nuc2EPgqwPAG5kqWzq1owCFj00W
        93q3V6x0k/dmW/beHjh3uGwKhfu0wSN1b9Zf/1x3pOdU2YZcfOkL3rsiSQ/9HLhO
        JuiEe3LrerRNINgu8e4NklvF+6zoeKXxVcQheUh/mLv9c2RtH/JE92z7VX0UyeBI
        tCyjJHRLY4IX3QXKYQ5/hk+lskyC+6rB1YQ==
X-ME-Sender: <xms:_r1HZLkAEvu-eTyOuUTmwhIE-RTObLTDo62Lc8XRm5KqLxPqPc391A>
    <xme:_r1HZO2g0nO9V1-Bp_Ax0SJsk93M945J0kjY4SNw1OpYPipxX6_4_wIhNR_J28E15
    2nlVL-dOIz8nrcT1QM>
X-ME-Received: <xmr:_r1HZBrLH2X0kd1pf9o_LzGK3Twosb0cU_eoIQEfcsWzJ5FSyJgzoq3Cac4xO5_qPDDvH0fyJTud_WnZClp79WyDzAUyfl5EO1oAikAq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepgffggeffjeegfeeuteegueekvdfhledu
    hfehffdtiedthfetleeifeeihfeukeegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:_r1HZDlC3qvBVkxYEyCrkFTfP9XNaGNIvwmfExdS54CduvtqPkZqGg>
    <xmx:_r1HZJ0s8ZO0M5xEMafznKiDObzyMTQ3HW_LpsrbiDYdLT-mOXIqmw>
    <xmx:_r1HZCupZ3PzzbCOOjUuLsQf0YjcYykZlCa2SNzIcxG3rL2BHFH86A>
    <xmx:_r1HZCzpTVCeigBcdmlySlnvplY0rN-TEUkSHYW5R2svXCr0vwZ0K3_9WBO-cH1E>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 07:48:12 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v2 5/6] scsi/{004,005}: allow to run with built-in scsi_debug
Date:   Tue, 25 Apr 2023 20:47:44 +0900
Message-Id: <20230425114745.376322-6-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425114745.376322-1-shinichiro@fastmail.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

To allow the test case run with build-in scsi_debug, replace
'_have_module scsi_debug' with _have_scsi_debug, and replace
_init_scsi_debug with _configure_scsi_debug.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 tests/scsi/004 | 4 ++--
 tests/scsi/005 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/scsi/004 b/tests/scsi/004
index f0845c1..7d0af54 100755
--- a/tests/scsi/004
+++ b/tests/scsi/004
@@ -18,13 +18,13 @@ DESCRIPTION="ensure repeated TASK SET FULL results in EIO on timing out command"
 CAN_BE_ZONED=1
 
 requires() {
-	_have_module scsi_debug
+	_have_scsi_debug
 }
 
 test() {
 	echo "Running ${TEST_NAME}"
 
-	if ! _init_scsi_debug add_host=1 max_luns=1 statistics=1 every_nth=1; then
+	if ! _configure_scsi_debug max_luns=1 statistics=1 every_nth=1; then
 	    return 1
 	fi
 	echo 5 > "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/timeout"
diff --git a/tests/scsi/005 b/tests/scsi/005
index efd3d82..bfa1014 100755
--- a/tests/scsi/005
+++ b/tests/scsi/005
@@ -11,7 +11,7 @@ DESCRIPTION="test SCSI device blacklisting"
 QUICK=1
 
 requires() {
-	_have_module scsi_debug
+	_have_scsi_debug
 	_have_module_param scsi_debug inq_vendor
 }
 
@@ -33,7 +33,7 @@ test() {
 	for inq in "${inqs[@]}"; do
 		vendor="${inq:0:8}"
 		model="${inq:8:16}"
-		if ! _init_scsi_debug inq_vendor="$vendor" inq_product="$model"; then
+		if ! _configure_scsi_debug inq_vendor="$vendor" inq_product="$model"; then
 			continue
 		fi
 		vendor="$(cat "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/vendor")"
-- 
2.40.0

