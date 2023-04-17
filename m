Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA45BC77B77
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 12:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjDQMsQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 08:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjDQMsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 08:48:15 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C6B7683;
        Mon, 17 Apr 2023 05:47:52 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 4D8DF2B0673E;
        Mon, 17 Apr 2023 08:47:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Apr 2023 08:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1681735669; x=1681736269; bh=Cjs9NDQpI3
        lodejBiOUacfZOZsr5wOLfjoc+sDV3Kd0=; b=SJHK5UL4HREV5gOjeXhMOSZZQi
        pWrT5DvwSFmHcAxWriZHGwlVM88Ue2Uh4kZG7OwyNqtsEtPjhqI6PzVmnnX4JtgS
        GorV97YAdDAB5Ll1x8ZUUIOZMEDbZG3xgM9I6pBa+9vek8EOx7z043bYeLAfV+6d
        uFhy/5JPy0MmcRQReKv1i4nEcdW5dA7Pl7ll2jhreacEwXqipdz47xgn0ELzgpDY
        vc+oMNtkX8/CBHny4FsHElwP5X/rwfPhdXka0iCYZJg5O2hjLbSei0XKZQ/Daxjm
        XwM+D4pretBJkxDXIv/cTErzL30K6ShbUUDktSBSP2kbNY0rPM8WikEhqT9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1681735669; x=1681736269; bh=Cjs
        9NDQpI3lodejBiOUacfZOZsr5wOLfjoc+sDV3Kd0=; b=TXFn8pVSTa2zRLTD3H0
        Od06q2uCVBwb0qNt8GR4r8uj5+6BGx1B4pmG1xQPPw+dWCiRdsFW3GR5K8AdgBv+
        nUeSlqCPjeaJrZy2y8pFSwlfOdwcVGSpJhO7dtil6oy/obWJXIYINThqZoTdhAca
        lUKGbdu9QTeA2UoIay0BuhDJ190IMd42izLYru4ttbvICEblVO+NELzqdOxHwryc
        c/PY/7t5E2pvofFNfi8CpESSRMap/bl8d5t0Y0E6R4InXoG72oiWv5/q0dAQxfcE
        uvNVBuE9awDTF3yKMp691PHmyzNwAdQc/ANiq1nOwF+Fo1GATLwIY0UpVn5fN4bz
        qlA==
X-ME-Sender: <xms:9T89ZGKx4Ya1NqNzCV9PDPENoJYKFbMTQ1Q4SF4ZG-3uQJOawGk7Dg>
    <xme:9T89ZOKuxP1h9j5IGdtJZHaW6vXQ8gVFsPSOuVqsnLnBNBsapDwp4OU2fbH0mCZ6q
    4SY2EpvXOPSTaq8iwI>
X-ME-Received: <xmr:9T89ZGvale0Ju0txRkr_UHJHYJ9KImCQ9-yRTnRzWbLYEqd2cVUl1WlCf2d-mOFRahjOn5He__k0OFGb8h8dnRafkkaB-ci8-MadNbYN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehshhhi
    nhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpefgud
    ekgfefvdffgfefueeigfetlefghfffieekvddvkeetieeltdetieevgfffveenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:9T89ZLaNkTR6ty9fKFktzoPnGKcgBk5v664VZ682l-Ki4yimbGYXtQ>
    <xmx:9T89ZNaeVttSqc07kjfMVkb_K7Uv5P3aapYQ9gWhRWeL92TF_YOp1Q>
    <xmx:9T89ZHCBxLjxiG7TcEOW_r-scisP-I-m6aenHfw7n_qonGf8m_HJKQ>
    <xmx:9T89ZMlwiq6HeFdVEHW9xdtS4EbEk1S3f1INBzyW9XEIk4jPynqZF74KXPZgVego>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:47:48 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 0/9] support built-in scsi_debug
Date:   Mon, 17 Apr 2023 21:47:19 +0900
Message-Id: <20230417124728.458630-1-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.39.2
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

Of note is that still 9 test cases are left to require loadable scsi_debug. 8 of
them can not be run with built-in scsi_debug because the parameters they set are
read-only on sysfs. The other one test case scsi/007 has other failure symptom
now, so I leave it untouched at this moment.

[1] https://lore.kernel.org/linux-block/bc0b2c10-10e6-a1d9-4139-ac93ad3512b2@interlog.com/
[2] https://lore.kernel.org/linux-block/20220601064837.3473709-1-hch@lst.de/
[3] https://lore.kernel.org/linux-block/20220607124739.1259977-1-hch@lst.de/

Shin'ichiro Kawasaki (9):
  common/rc: skip module file check if modules path does not exist
  common/scsi_debug, tests/*: re-define _have_scsi_debug
  common/scsi_debug: factor out _setup_scsi_debug_vars
  common/scsi_debug: introduce _configure_scsi_debug
  scsi/004: allow to run with built-in scsi_debug
  scsi/005: allow to run with built-in scsi_debug
  block/001: allow to run with built-in scsi_debug and sd_mod
  block/002: allow to run with built-in scsi_debug
  block/027: allow to run with built-in scsi_debug

 common/rc         |   1 +
 common/scsi_debug | 139 ++++++++++++++++++++++++++++++++++++++++++----
 tests/block/001   |   4 +-
 tests/block/002   |   5 +-
 tests/block/009   |   3 +-
 tests/block/025   |   2 +-
 tests/block/027   |   6 +-
 tests/block/028   |   2 +-
 tests/block/032   |   3 +-
 tests/loop/004    |   5 +-
 tests/scsi/004    |  15 ++++-
 tests/scsi/005    |   5 +-
 tests/scsi/007    |   2 +-
 tests/zbd/008     |   5 +-
 tests/zbd/009     |   2 +-
 tests/zbd/010     |   2 +-
 16 files changed, 169 insertions(+), 32 deletions(-)

-- 
2.39.2

