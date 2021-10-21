Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA447C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59FA60ED3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhJUDqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53900 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231264AbhJUDp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:29 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L23hqG019155;
        Thu, 21 Oct 2021 03:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=SfIAroasqOKG7ABdu84goldKo7kiEdrIQonwbcPMIAM=;
 b=ln218AhYyBLuLuc5PYDsszGGIa6CXk6BZgS6h7zCAROQGlpvaBE3QyOJRDEJcPHuyzYU
 aNwjJEzdBCKerydpXbhVAweXaAp3R9HOEegf5gJ2d2qKFqkuUEk16uaOsI0ATQyIw9hT
 M/CMK7HFp9iX7VzwdBreOA2iIC0kbJYxLtBn2cLoGebrAd7pDGQYAKNTTpM29salkOAd
 eemdvM8lUk3aEu5bxg1Q1veXwXmfXklnOkRNmNQgA+6+oggEHKivN3jxz86HNEqA3Yei
 KdfIEqCz1m24SZ+5itNOH/LA4dT6sXTi2gFemfUtNlBmy9v1tplApJBSv0yk3rMWq+EG Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypjhud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3eshO078026;
        Thu, 21 Oct 2021 03:43:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:08 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8B082116;
        Thu, 21 Oct 2021 03:43:08 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-14;
        Thu, 21 Oct 2021 03:43:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        james.bottomley@hansenpartnership.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] target: fixes and perf improvements
Date:   Wed, 20 Oct 2021 23:42:45 -0400
Message-Id: <163478764104.7011.4720961002832674677.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210930020422.92578-1-michael.christie@oracle.com>
References: <20210930020422.92578-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: W7RTagJkmwCPh6SLope9oF63ZI_6SelH
X-Proofpoint-GUID: W7RTagJkmwCPh6SLope9oF63ZI_6SelH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Sep 2021 21:04:17 -0500, Mike Christie wrote:

> The following patches apply to Martin's staging tree or Linus's tree.
> The patches main goal is to take the locks out of the main IO path but
> for the case of ordered cmds they also fix a handfull of bugs.
> 
> For the locks we currently have:
> 
> 1. lun_tg_pt_gp_lock
> 2. delayed_cmd_lock
> 3. dev_reservation_lock
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/5] target: fix ordered CMD_T_SENT handling
      https://git.kernel.org/mkp/scsi/c/945a160794a9
[2/5] target: fix ordered tag handling
      https://git.kernel.org/mkp/scsi/c/ed1227e08099
[3/5] target: fix alua_tg_pt_gps_count tracking
      https://git.kernel.org/mkp/scsi/c/1283c0d1a32b
[4/5] target: replace lun_tg_pt_gp_lock with rcu in IO path
      https://git.kernel.org/mkp/scsi/c/7324f47d4293
[5/5] target: perform alua group changes in one step
      https://git.kernel.org/mkp/scsi/c/f9793d649c29

-- 
Martin K. Petersen	Oracle Linux Engineering
