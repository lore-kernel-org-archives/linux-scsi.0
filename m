Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E023CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA69E2076E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ciGF3E4E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgG2EKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:10:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgG2EKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:10:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42p9w073233;
        Wed, 29 Jul 2020 04:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=mFgPZLBhbrr08eGSo1D38FwIFNHtP7ViGpu1FsdLV/Q=;
 b=ciGF3E4EE8FCNZY/9akgurJT/ccUh9Wt3FYh2kCQaoissoIDntC48pNshnZSf5I8TGuw
 GE8xhMT6/EksF085bO/wmccjw6kMcc5+8XkjNLlEzUmpnjS0lTWXCVsl0ovL+5GX//LK
 gEZWuMYxXfx7SLMV9FfADZNoZNZyk/8+iqAugmKhztBEI2dtlwXKmCZyw4VmFIy634P9
 rGGBdVxP1u1CQ5Ouq7P/3xXYGK1YkHV/pX3GXPyqcP2r7vcMRLjDKmx9+7iD4lFpbQmf
 IWg0qEGaBRRCMwO++0QmFLVfLWEXyZm7Azs+FSqY7qlpks4MZmrq+dqtHs+S3Fc4lhUW Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32hu1jb6de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:10:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42aSH023674;
        Wed, 29 Jul 2020 04:10:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32hu5u1pve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06T4AeXo018612;
        Wed, 29 Jul 2020 04:10:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:40 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Date:   Wed, 29 Jul 2020 00:10:32 -0400
Message-Id: <159599579268.11289.16855842795289437175.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 26 Jul 2020 17:35:02 +0200, Bodo Stroesser wrote:

> This patch series is made on top of Martin's for-next branch.
> 
> ChangeLog:
> 
> v2: in patch "scsi: target: tcmu: Implement tmr_notify callback"
>     changed new comment's style from "// ..." to "/* ... */"
>     and correctly use "/** " for function doc.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/8] scsi: target: Modify core_tmr_abort_task()
      https://git.kernel.org/mkp/scsi/c/f5e2714ad1a6
[2/8] scsi: target: Add tmr_notify backend function
      https://git.kernel.org/mkp/scsi/c/2e45a1a9c75d
[3/8] scsi: target: tcmu: Use priv pointer in se_cmd
      https://git.kernel.org/mkp/scsi/c/a35129024e88
[4/8] scsi: target: tcmu: Do not queue aborted commands
      https://git.kernel.org/mkp/scsi/c/c96849276211
[5/8] scsi: target: tcmu: Factor out new helper ring_insert_padding
      https://git.kernel.org/mkp/scsi/c/3d3f9d56a570
[6/8] scsi: target: tcmu: Fix and simplify timeout handling
      https://git.kernel.org/mkp/scsi/c/ed212ca87897
[7/8] scsi: target: tcmu: Implement tmr_notify callback
      https://git.kernel.org/mkp/scsi/c/bc2d214af5db
[8/8] scsi: target: tcmu: Make TMR notification optional
      https://git.kernel.org/mkp/scsi/c/59526d7a187f

-- 
Martin K. Petersen	Oracle Linux Engineering
