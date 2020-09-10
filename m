Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB63C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A11206DB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:23:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="pBjqsuB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgIJTWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:22:55 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.67]:44123 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731428AbgIJPvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 11:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1599753059; i=@ts.fujitsu.com;
        bh=To4IJZlpje0+t9jveM15wVsy2heNc2RTr+QZG7J1tJg=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=pBjqsuB5ixio2QAPyi+qDDnUAtdtU9wOZ5+Z0OTtyPbPZJBvHO1x+XI9X3JOSneUe
         qCyVIqIU5YUtOknMb0dsT284rPbr25nAMI4DZqitDYpauVSCoKKxcyWKg3gr2SAnQ5
         Z9LAz7Uchh403Ska35aC5rTq7IU8tD2QcnAOL1p2QCN+gksabRQu3g059cIQzUTXn3
         QDZH+H8LnqSKdFM7ynllsrbPD4/ooZDGdRvX/MxqVM7DOULXLCEY6y06/QUoJ2cM/Q
         n1DpV2KoCaUlvgROgrHEO9N6thTDy3n5utClSFzAeCjb9oIWYcx6wCrGayF7sSsJob
         rimGceWVj9UqQ==
Received: from [100.112.199.154] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-west-1.aws.symcld.net id B9/3B-37769-26B4A5F5; Thu, 10 Sep 2020 15:50:58 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRWlGSWpSXmKPExsViZ8MRqpvkHRV
  vMO++rkX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE14+/dSewF
  n1krZrb+Z21g/MPSxcjFISQwmVHiSfM5KGc6o8SPk4eZuxg5OdgEDCRWTLoPlhARWMMosfLOP
  LAEs4CexLR/69hBbGGBcIk3h7sZuxg5OFgEVCUmTjYCCfMK2Ekc3rGMCcSWEJCX6DgwmWUCI+
  cCRoZVjOZJRZnpGSW5iZk5uoYGBrqGhka6hpaWuoYWeolVukl6qaW65anFJbqGeonlxXrFlbn
  JOSl6eaklmxiBXk8pOC60g/HN6w96hxglOZiURHkFHKPihfiS8lMqMxKLM+KLSnNSiw8xynBw
  KEnwGnsB5QSLUtNTK9Iyc4ABCJOW4OBREuG97gmU5i0uSMwtzkyHSJ1iVJQS57UESQiAJDJK8
  +DaYEF/iVFWSpiXkYGBQYinILUoN7MEVf4VozgHoxJQBch2nsy8Erjpr4AWMwEtbpSPBFlcko
  iQkmpgCq1YxLxw2myh8gfRcuddLt448NR5xbfuLZxbtLd16JfbvOJ+3yp7p0dkvcGsahFuL+W
  jM1Y9NZGe6FFzvWPCXJf5tzpv3Ftfe8vt/eWM6TucX3Jf6L68+NBmw7Mi9nkFq/aaOouobvt7
  OXZLld8sUeVXU1s/fbodw7biWUGVxjKTp3MMd+yZ8V/0/s6nx00XlkUkiJ1Q0+6a/u9xYP+RK
  tupOSl7gmzPnrg3UVy8d+aPiy4NVa+3cTtnfOcs/h9wM3/3sTNfJ3m/956odNdZZGbwp7TLMf
  F762SfLhL7z2n3tvr1v+q7axz3R2TXzWNWiIqVMOU3at6QUxIvd/VAj7eb4f9FAfVLqhSvfft
  nIaLEUpyRaKjFXFScCADh4t249QIAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-30.tower-291.messagelabs.com!1599753058!328515!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.60.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 25978 invoked from network); 10 Sep 2020 15:50:58 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-30.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Sep 2020 15:50:58 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 08AFossf022647;
        Thu, 10 Sep 2020 16:50:54 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id E0727202FA;
        Thu, 10 Sep 2020 17:50:50 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 0/3] target: scsi: tcmu: code rework and speed up of read data handling
Date:   Thu, 10 Sep 2020 17:50:38 +0200
Message-Id: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This small series is made on top of Martin's 5.10/scsi-queue branch.

The patches simplify some code, splits off new helper functions
or implement a cleaner code sequence to prevent double work.
The 3rd patch speeds up buffer preparation for SCSI commands with
long read data.
The series is also base for cleaned up version v3 of my patch
  scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel

Bodo Stroesser (3):
  scsi: target: tcmu: join tcmu_cmd_get_data_length and tcmu_cmd_get_block_cnt
  scsi: target: tcmu: optimize queue_cmd_ring
  scsi: target: tcmu: optimize scatter_data_area

 drivers/target/target_core_user.c | 340 +++++++++++++++++++-------------------
 1 file changed, 170 insertions(+), 170 deletions(-)

-- 
2.12.3

