Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12497C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5017610E6
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhHTDam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:30:42 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4894 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238314AbhHTDak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:30:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629430201; x=1660966201;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wA3eYLnvD1ULZz32DK2g05B7K9RC1NxvhVZsSfjWeLs=;
  b=kIJ1dNSerESKsFg6CwXQO7kGuyGH1mTcShPPmJz4g5utlDch4Vas2XF+
   4KQ6n/RYWFSJlSs+eprAhOvAg4i2L2gAhAlXtHQiztGvLZuY42QUcZx+/
   i0Oy3QGKbp/9HF/InIXalst6UG38VoVXbelTSYEPu4F7ENdud53592ens
   enL/gF0So2PzaOVyfa6KBpaYSQhLPooMp4FgZQgStpY/Wvp4xx/nDw4ol
   rGRBUqJnj0KrNgGYwIM7v0ub9TCAxdmhUs8J/3Z0y8QfBdIQKIjZxEYC9
   8aPeZtEJU31aQKa4dPW+lwMqXESWrThLBU04+Ux97/nYiZiosXP6/7hXX
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="182646443"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 11:30:01 +0800
IronPort-SDR: oq5WCJYzsTZEZgrEf3ezJpx7XUnHV8D0U5LKUrj6CQMmBU8EOHOfQ9vSEESn3ZORz9wYkaAvbJ
 2A85Dkyi2gxQnWACAy8cdJyECv5+pQCiC2rZPKZ2htGRwfxwgLp1jiLtaNarJt+jYx/qugHWv6
 1Ohf60iwWrE3/MHX1BrfV1CKOA/tMtRgO/ma7+C7Sg9Z4ZqXSiLAH4npYXSFtzXTvV0z+DDsy3
 p31SFPwKQ3z5G3SJ3zs9JqMv6FbXOOtbazfHd9UipmKTT4t+SkS3OxmgrsqoB7Nds38T8rDQW2
 UTodGp/k70BWbufN3QpZvl7W
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 20:05:22 -0700
IronPort-SDR: 99JjtYxIOoUYjH8ctme2DndJHCbpA3/szxfOHACYuo7/goGebOhhuTe8/IhT9CsDtXDlWzgo1Z
 WX9/hH7DlASYTLG+z+IOUPDgRAJ/hc1bh69x0LLSgAxlq/DYQ69eMiGWRbOGy/QQBOdyJtSSFu
 LABAxA+Uvq2KN8BNTbrQuFvOXLbKmVvhg8t97ySJKo2kK7K7Zh6TYLtFFNeN9ITI+2a7Jm9aac
 b2y2ADibbrCVQBFv+yPTvqO5DMDg8SVrrtv484BPg+UdhxJ8AlOtt2D6+jt2t5BJhGdyX2cHkZ
 CoI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Aug 2021 20:30:01 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 0/2] Fixes for scsi_mode_sense/select()
Date:   Fri, 20 Aug 2021 12:28:11 +0900
Message-Id: <20210820032813.575032-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch in this series is v2 of the patch titled
"scsi: fix scsi_mode_sense()". Patch 2 is new and added to fix similar
buffer length handling problems found in scsi_mode_select().

Changes from v1:
* Patch 1:
  - Added check on the buffer length not being larger than 65535 bytes
    for the MODE SENSE 10 case.
  - Automatically try MODE SENSE 10 for large requests even if the
    device does not have use_10_for_ms set
* Added patch 2

Damien Le Moal (2):
  scsi: fix scsi_mode_sense() buffer length handling
  scsi: fix scsi_mode_select() buffer length handling

 drivers/scsi/scsi_lib.c | 46 +++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

-- 
2.31.1

