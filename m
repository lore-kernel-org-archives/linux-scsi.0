Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071D2C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF0CB22482
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:08:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="V9hE3DXe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgGTSI4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 14:08:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49852 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729029AbgGTSIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 14:08:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHuAVl024321;
        Mon, 20 Jul 2020 11:08:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=mn9ObnyjAHSe76pzAfu6gLa78PSQPQm8EO4sGZA7vGw=;
 b=V9hE3DXeoS8r5n4firW07BN3FGtquowq9VNPgFZVL0DUaFiyDe2o1qvFyL4oHeySXKHZ
 Tu5NYyrgN+x/c1dgSOoPO19h4ssQb1sLFw/8yS/AU3rV6TJfnPVWtSQzLgcEETug6M8G
 cMHjXzCIO1NzZXYYdXxAgk57aablbF7mqkOQPZyKTNunuXe6798SIOtZlQ1CqvbGXaif
 snwEbxPsDKG6BI1vaJVNYXRqZ031ucPPjeb4nL7ESoPod6NzqeBQENpdXutAGZqStVpW
 0XO+1lI3PIzlr5dnygOeTrYKhVEDw/1Q7bJl7FVbJ0i0ADuEj7iGr08r+y5+2Z0rbkwH cw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:08:48 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:08:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:08:46 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 918EC3F7040;
        Mon, 20 Jul 2020 11:08:42 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 00/16] qed, qede: add support for new operating modes
Date:   Mon, 20 Jul 2020 21:07:59 +0300
Message-ID: <20200720180815.107-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series covers the support for the following:
 - new port modes;
 - loopback modes, previously missing;
 - new speed/link modes;
 - several FEC modes;
 - multi-rate transceivers;

and also cleans up and optimizes several related parts of code.

v3 (from [2]):
 - dropped custom link mode declaration; qed, qede and qedf switched to
   Ethtool link modes and definitions (#0001, #0002, per Andrew Lunn's
   suggestion);
 - exchange more .text size to .initconst and .ro_after_init in qede
   (#0003).

v2 (from [1]):
 - added a patch (#0010) that drops discussed dead struct member;
 - addressed checkpatch complaints on #0014 (former #0013);
 - rebased on top of latest net-next;
 - no other changes.

[1] https://lore.kernel.org/netdev/20200716115446.994-1-alobakin@marvell.com/
[2] https://lore.kernel.org/netdev/20200719201453.3648-1-alobakin@marvell.com/

Alexander Lobakin (16):
  linkmode: introduce linkmode_intersects()
  qed, qede, qedf: convert link mode from u32 to ETHTOOL_LINK_MODE
  qede: populate supported link modes maps on module init
  qed: reformat public_port::transceiver_data a bit
  qed: add support for multi-rate transceivers
  qed: use transceiver data to fill link partner's advertising speeds
  qed: reformat several structures a bit
  qed: add support for Forward Error Correction
  qede: format qede{,_vf}_ethtool_ops
  qede: introduce support for FEC control
  qed: reformat several structures a bit
  qed: remove unused qed_hw_info::port_mode and QED_PORT_MODE
  qed: add support for new port modes
  qed: add missing loopback modes
  qed: populate supported link modes maps on module init
  qed: add support for the extended speed and FEC modes

 drivers/net/ethernet/qlogic/qed/qed.h         | 125 ++-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 172 +++-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 786 ++++++++++--------
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 765 +++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 126 ++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     | 146 ++--
 drivers/net/ethernet/qlogic/qede/qede.h       |   2 +
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 497 +++++------
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   2 +
 drivers/scsi/qedf/qedf_main.c                 |  78 +-
 include/linux/linkmode.h                      |   6 +
 include/linux/qed/qed_if.h                    | 128 ++-
 12 files changed, 1829 insertions(+), 1004 deletions(-)

--

Netdev maintainers, patch #0001 affects qedf under scsi tree, but could
you take it through yours after all necessary acks? It will break
incremental buildability and bisecting otherwise. Thanks.

-- 
2.25.1

