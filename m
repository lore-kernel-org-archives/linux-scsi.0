Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFD8C56202
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E69222EC
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c+GumHq1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1419630AbgJYXDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 19:03:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1419406AbgJYXDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2020 19:03:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PMxmww014852;
        Sun, 25 Oct 2020 23:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=7EeP3tf8AXm8+gH2Mh6ulwKE2rZTOm728vH+cUBDjqc=;
 b=c+GumHq19Fv39eLJsrhW3LugAGUXqa0lVOPJLdhkO2Xh6H5ZuT7mt2ksQZn44lv27MSX
 4m5ca63cfUKaIEX3t8a7YWJ6QEbCBtKJmAOBdrxG43zXX8cfO/L+8ZT+Pir5F/wMd71s
 dpcTWeCgxDyZ7KRuon/pizODitxgq5Ni9BGbH3ncx3s0QqFniGYRjfCWnoDqrF8ucRjC
 bdjTiAENDEkC69GDV72aJ6Fo31KpRjJK6ince9acTOxuTLImwHiBncrsXlR4yQrorN7g
 3Vz9ZMFtnACZiJvQVyPMr4euG5rpPLvhqioIDUbXRzBjnNAEFmhbV83QWYDA8ZFPvDpl AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kjg6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 23:03:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PN0IDu032788;
        Sun, 25 Oct 2020 23:03:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwujrt6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 23:03:25 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09PN3OHN013495;
        Sun, 25 Oct 2020 23:03:24 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 16:03:24 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 0/7] target: fix up locking in IO paths
Date:   Sun, 25 Oct 2020 18:03:11 -0500
Message-Id: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250174
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset removes se_session sess_cmd_lock for every driver but
tcm qla2xxx and moves the se_device execution lock to per CPU so
we can run submissions from multiple CPUs without hammering on
those locks.

With the patches I'm seeing a 25% improvement in IOPs for small
IO tests like:

fio  --filename=/dev/sdXYZ  --direct=1 --rw=randrw --bs=4k \
--iodepth=128  --numjobs=16

I'm sending this as RFC, because the qla2xxx patches are not
tested and I'm hoping we can maybe just remove the session
locking/list from that driver since it's only used to lookup
commands for aborts when a specific model is used.

The following patches are made over Linus's tree. Some of Martin's
branches are missing:

commit 149415586243bd0ea729760fb6dd7b3c50601871
Author: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date:   Wed Sep 16 23:54:31 2020 +0000

    scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case


