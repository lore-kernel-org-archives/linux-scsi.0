Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A64C00143
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3197A60E98
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345100AbhIAMko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 08:40:44 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63892 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343761AbhIAMiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 08:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630499839; x=1662035839;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wu7IeLEdZDNNGywR65jKMi2ZL76+lV8AJClR21YY6KM=;
  b=n1qeWZ1IkmTFWCzAszx2o1vQrJUquz+C40YkH2YesetCB+Rh1HBwDaad
   Em5P2Wk2EleYWOk4x6KLL5cHoqZ5ZUrq6B/pQ2UlicNHKHYGt7PIyG5O3
   I7hqYRcaAi9Qn+Ws4Om5PP8LMWeA3Oi6JSHx3wRzXTtw1i8se/8bfHg+F
   GX7sSDOROya0gkqnLYCGq7mp+Io3J5o0bfr+rja4ynYOF2xt+mmLRTr3H
   8HXH5RVT0Uxxencf4d9R9MdBZSzNjJMsibHl6hCObqSjJn1ufuWL5uKNz
   kzphi2Nb1lrbFKgf4Z0qmFlRLGRG1GgMPGns7u5Hb5d3t42q2iFn2ZLVf
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,369,1620662400"; 
   d="scan'208";a="290548565"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2021 20:37:19 +0800
IronPort-SDR: hskPRIrCkjduReIsqaTPqM5wv3z6xNrRsqyX+W2mxUKbuhXjoCbECfp5shmkFmMTW4gjidRSG1
 sqBDiWPFJ0k7kv3t+MhxnetkdqzHf19y3BpCJ8ppQPZq21bVbg5ZhPn1ex97Eibq2b5UfYh5ja
 JmjNHP6/Oi1UtdmXCOLaeAVPJMu5LiR9mv4bnJahtjw0Fuabn43ecmQq5xKjbLPQ7kvzAwk/i1
 MfTYlytf21vH+oxo/N4NnYYrlDBSBSzpntQOvKK9EKddaEj3qPI8UIni3pSMI0S75L/lAKMk4V
 xm8tLmc8GJhkR6VpKuwPo0UU
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 05:12:24 -0700
IronPort-SDR: 9Ee4cJBdnkhR1pgWywv96zGQ0YJvqmUZcycuSnOujUZFVK1HzgSZ3gwV4ezyNeiFodW5qOqslN
 h6u5o66WEgGw/XW+z/jCO8EKt1Wr4UQ1bIllenViC26HxXgjCyFqPkoXqPw8LjWtHE1R5aX6/N
 KiA4rcDd1fpPH7dR78d/1Usw4NDX+t4PwqaLRTUDp5DBHly4wtpkVx7tTntchziKg6rVSYZH5N
 dW7dGi0umDndt8O4e+8vqUOUsLPVhXB345VJJid1Du0RoRvQfTBkaaaWpwjHaD1+Ar2AUAzzve
 BGM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Sep 2021 05:37:17 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/3] Add temperature notification support
Date:   Wed,  1 Sep 2021 15:37:04 +0300
Message-Id: <20210901123707.5014-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS3.0 allows using the ufs device as a temperature sensor. The purpose
of this optional feature is to provide notification to the host of the
UFS device case temperature. It allows reading of a rough estimate
(+-10 degrees centigrade) of the current case temperature, and setting a
lower and upper temperature bounds, in which the device will trigger an
applicable exception event.

A previous attempt [1] tried a comprehensive approach.  Still, it was
unsuccessful. Here is a more modest approach that introduces just the
bare minimum to support temperature notification.

Thanks,
Avri

[1] https://lore.kernel.org/lkml/1582450522-13256-1-git-send-email-avi.shchislowski@wdc.com/


Avri Altman (3):
  scsi: ufs: Probe for temperature notification support
  scsi: ufs: Add temperature notification exception handling
  scsi: ufs-sysfs: Add sysfs entries for temperature notification

 Documentation/ABI/testing/sysfs-driver-ufs | 38 +++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 63 +++++++++++++++++++++-
 drivers/scsi/ufs/ufs.h                     | 12 +++++
 drivers/scsi/ufs/ufshcd.c                  | 28 ++++++++++
 drivers/scsi/ufs/ufshcd.h                  | 29 ++++++++++
 5 files changed, 169 insertions(+), 1 deletion(-)

-- 
2.17.1

