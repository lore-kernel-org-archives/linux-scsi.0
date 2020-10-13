Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E78C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E65F121D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qTOzj/Yo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgJMWpP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:45:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgJMWpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:45:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaCZw072213;
        Tue, 13 Oct 2020 22:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oHzB0ScHQDIM4C4XfbPqB9kB+1m+Sa/o+eLjBew+oF0=;
 b=qTOzj/YonOVWV0fsC1OwP01kOFzaVLF7Ms6TE5aYaPIPqlfsFENrkPVsnEBJgKagYBLG
 pFxERO7+RwgMMuoog1av5hhtyQwLHbyJJFY2tV5v9vNDo8qEeE+Ewkv5OYW/Mbd514Rx
 CNbllUuRsWb5bPJpe0iW08I87fjqki+3tVaZmgFYM40/5tk+aaRV0AlZCDc24xPjIBf8
 86nzb/ZOFftjzmWSTVJcmR5vwlr/0OplDiMSte/+14/vk81gB298KCAZe7kNCcdBdK21
 5Yhbk9P0pldcmPnmWBw19R6GuvcXkp8hygUd1cmSnCNaLuG2F9p5uwfnD34qrTjiGGfS GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 343vaeb2hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:45:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaX2g049180;
        Tue, 13 Oct 2020 22:43:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 343pvx1sn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhB9T005704;
        Tue, 13 Oct 2020 22:43:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:10 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/10] scsi: don't export scsi_device_from_queue
Date:   Tue, 13 Oct 2020 18:42:48 -0400
Message-Id: <160262862430.3018.1460317399464810054.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-2-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de> <20201005084130.143273-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 5 Oct 2020 10:41:21 +0200, Christoph Hellwig wrote:

> This function is only used by code built into scsi_mod.ko.

Applied to 5.10/scsi-queue, thanks!

[01/10] scsi: core: Don't export scsi_device_from_queue()
        https://git.kernel.org/mkp/scsi/c/2ba87c43872f
[02/10] scsi: core: Remove scsi_init_cmd_errh
        https://git.kernel.org/mkp/scsi/c/3a8dc5bbc8c0
[03/10] scsi: core: Move command size detection out of the fast path
        https://git.kernel.org/mkp/scsi/c/2ceda20f0a99
[05/10] scsi: core: Use rq_dma_dir in scsi_setup_cmnd()
        https://git.kernel.org/mkp/scsi/c/40b93836a136
[06/10] scsi: core: Rename scsi_prep_state_check() to scsi_device_state_check()
        https://git.kernel.org/mkp/scsi/c/822bd2db798b
[07/10] scsi: core: Rename scsi_mq_prep_fn() to scsi_prepare_cmd()
        https://git.kernel.org/mkp/scsi/c/5843cc3d5acd
[08/10] scsi: core: Clean up allocation and freeing of sgtables
        https://git.kernel.org/mkp/scsi/c/7007e9dd5676
[09/10] scsi: core: Remove scsi_setup_cmnd() and scsi_setup_fs_cmnd()
        https://git.kernel.org/mkp/scsi/c/74e5e6c1b18c
[10/10] scsi: core: Only start the request just before dispatching
        https://git.kernel.org/mkp/scsi/c/ed7fb2d018fd

-- 
Martin K. Petersen	Oracle Linux Engineering
