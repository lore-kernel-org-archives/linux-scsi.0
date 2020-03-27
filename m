Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92781C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 06:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F8120716
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 06:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZY+zkvHD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgC0GCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 02:02:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28938 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgC0GCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 02:02:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R60ffO020368
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 23:02:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=Pt4iescZ97GPEFL8hGnDACS8l5y1YXrgDag6FfjQyhM=;
 b=ZY+zkvHD6hxKQimEYKA6qDKtjmlj5WE4Jp5WezVkzg+sbtMD1KcLpttPLv1y1YgwLqSl
 qlqgoeLWIukPmUO6887jv7/+216/MPl2ZDrMonE7uszc+JDR1pwjvnWbYOTmVUuybPMy
 qF+bb5jz0HrZj/n7EgjgkdExhsUV881Ht4Xn/J++G0Q1wO7JHs/FyiyM48w9gFBkLCeY
 zkrESFjYziyefQ4hszEVUy73kJbVqDUmWDyqPQXBZR5RVPNqxkrePib+IHaOWEGgw4ii
 OFq3FCI7KybwDY7TUgoaa0iXuBa7ODR+rPt3VGTeQmOQ1p5TYViNf4ECW1wmeIPq+mzF eg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p1f12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 23:02:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 23:02:09 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 23:02:09 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 23:02:08 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C1B323F7040;
        Thu, 26 Mar 2020 23:02:08 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02R628AX017139;
        Thu, 26 Mar 2020 23:02:08 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02R628gI017138;
        Thu, 26 Mar 2020 23:02:08 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>
Subject: [PATCH 0/2] libfc: Move to PLOGI state on RJT and retry exhaustion. 
Date:   Thu, 26 Mar 2020 23:02:06 -0700
Message-ID: <20200327060208.17104-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Kindly apply this series to scsi tree at your earliest convenience.

Thanks,
~Saurav

Javed Hasan (2):
  libfc: If PRLI rejected, move rport to PLOGI state.
  libfc: rport state move to PLOGI if all PRLI retry exhausted.

 drivers/scsi/libfc/fc_rport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
1.8.3.1

