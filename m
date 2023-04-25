Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B95C77B76
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 11:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjDYLsU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 07:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbjDYLsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 07:48:17 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90956C166;
        Tue, 25 Apr 2023 04:48:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 2379B2B06432;
        Tue, 25 Apr 2023 07:48:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 25 Apr 2023 07:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1682423279; x=1682423879; bh=fRrycwJ7NX
        o9snGHazdOKIpHE7KywMsIWdwYq+cbjFk=; b=Yvhc2zdO929XTWkwFqzdC2zULK
        e7vG2CXLi6w0QCrDRuHszotfm2LeH9jsY11FkitBxLgvDeJmSCwLuhaKUG7X8CRF
        Hec9EY+Y4q1JHNEEuyVEwXyCjwtOxPzc1qHMJGibC4+YmrkkjiJhhq0V1mcrDDLf
        EfzYPpO/X1nwH3zlpzgWhq8HNvhz0iVXJ0qVnzVTYXlh45Xin3/1LdQTnW3TgAS2
        +903m3/ZEbJpcoiWJiuoTcJZjmwpyaghmhOI6pcnUp3os+5HZfo/bIXNEpK+2On/
        5JZhMYPnC7B2c++rCY06z+g+mZhMCVs8J7f8l1SiUhZhMb1bf4wucHRdG7hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1682423279; x=1682423879; bh=fRr
        ycwJ7NXo9snGHazdOKIpHE7KywMsIWdwYq+cbjFk=; b=i8uW1os7GuAKRJ9xbQh
        trABq3yvoQrsOm1KpfoQkAYS+zXCEjRLYS83YRarcHP4ZBs/GfsiJFI9oS3ZTsZ8
        thVUjoNGJoJN5Nm/pRmrYLysuaYf2o1ZxW7MhozIAkz45ncnWnIOoHOTWmBmTEGP
        jkwGskd1CfQSxTHAIeDFHFW19LkoP7iQ0iFnJCKQXlmhdiEscr+OmBQT9hhiaPr+
        PLZCzRXUNPNMESdbTWsfxlaFbKfolczqORzGHqS9wor9sMOnubNp/v+owCzqQdaU
        OLSU/hGJ8EmkN8TBlHt8wTEikXh8gk5+UChDNh7da/87cM3vo+fO0OFRgPit7QM3
        YsQ==
X-ME-Sender: <xms:771HZLzYCIZdnpB2M2hmG1Fj71BcdriiGX49kDZ34cpY3InVjbILlg>
    <xme:771HZDRMwyH9JlaDDgtwFXla7okIwuyo3HRq8g5oqltYTtQtEn03J5qZlwo1jaw6O
    BNfRZ_q9jjtdKCMtTc>
X-ME-Received: <xmr:771HZFWC7iUREW2tc2mZ-AXiOReEzcOC54rPn2GrOC7CqY--9riF0pXX_uf14tkP7_qcRYgENVG2JpiMi8WpmdIxWG3yPQFFSL_xJy8c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepufhhihhnkdhi
    tghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrghilh
    drtghomheqnecuggftrfgrthhtvghrnhepgfdukefgfedvfffgfeeuiefgteelgffhffei
    kedvvdekteeiledtteeivefgffevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhi
    tghhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:771HZFhI5ZAtr4E1MfB6W2hHDUFhRpsyLcApg0HEpJpdvAM5vcYjwg>
    <xmx:771HZNChAu7YkVszkMavJDJLi3g7iT1vmIq1ldRpM3gDeL-R0PiTGw>
    <xmx:771HZOJhJsHeJ6LCdW2ZWwdhcBCe8X70koS8DRkNlw0DR5WT9QwUcw>
    <xmx:771HZMNhECZYhW8_J9aDwzNd1aS7azJMeQFb8d5N_DMIKsB08v_sqAWcJQftg-UT>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 07:47:57 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v2 0/6] support built-in scsi_debug
Date:   Tue, 25 Apr 2023 20:47:39 +0900
Message-Id: <20230425114745.376322-1-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

In the past, there was an issue related to scsi_debug module unload [1]. At that
time, it was suggested to modify blktests not to rely on module load and unload.
Based on that discussion, blktests was modified not to load or unload null_blk
driver [2][3]. As of today, a number of test cases with null_blk can be run with
built-in null_blk.

This series introduces similar support for built-in scsi_debug. This patch adds
a new helper function _configure_scsi_debug which can set up scsi_debug device
without module load and unload. Also it enables 5 test cases to run with built-
in scsi_debug.

The first patch in this series fixes a minor issue found during this work. Next
two patches modify common/scsi_debug functions as preparation. The 4th patch
introduces the new function _configure_scsi_debug. Following 5 patches modify
the 5 test cases so that they can run with built-in scsi debug.

Of note is that still srp test group and 9 test cases in other test groups are
left to require loadable scsi_debug. The srp test group and 8 of the 9 test
cases can not be run with built-in scsi_debug because the parameters they set
are read-only on sysfs. The other one test case scsi/007 has other failure
symptom now, so I leave it untouched at this moment.

[1] https://lore.kernel.org/linux-block/bc0b2c10-10e6-a1d9-4139-ac93ad3512b2@interlog.com/
[2] https://lore.kernel.org/linux-block/20220601064837.3473709-1-hch@lst.de/
[3] https://lore.kernel.org/linux-block/20220607124739.1259977-1-hch@lst.de/

Changes from v1:
* 4th patch: improved to restore scsi_debug parameters modified during test
* Squashed last 5 patches into 2 patches as suggested
* Added Reviewed-by tags
* Noted srp test group in the last paragraph of the cover letter

Shin'ichiro Kawasaki (6):
  common/rc: skip module file check if modules path does not exist
  common/scsi_debug, tests/*: re-define _have_scsi_debug
  common/scsi_debug: factor out _setup_scsi_debug_vars
  common/scsi_debug: introduce _configure_scsi_debug
  scsi/{004,005}: allow to run with built-in scsi_debug
  block/{001,002,027}: allow to run with built-in scsi_debug and sd_mod

 common/rc         |   1 +
 common/scsi_debug | 138 ++++++++++++++++++++++++++++++++++++++++++----
 tests/block/001   |   4 +-
 tests/block/002   |   5 +-
 tests/block/009   |   3 +-
 tests/block/025   |   2 +-
 tests/block/027   |   6 +-
 tests/block/028   |   2 +-
 tests/block/032   |   3 +-
 tests/loop/004    |   5 +-
 tests/scsi/004    |   2 +-
 tests/scsi/005    |   5 +-
 tests/scsi/007    |   2 +-
 tests/zbd/008     |   5 +-
 tests/zbd/009     |   2 +-
 tests/zbd/010     |   2 +-
 16 files changed, 156 insertions(+), 31 deletions(-)

-- 
2.40.0

