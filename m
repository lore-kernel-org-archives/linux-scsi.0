Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABD9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D501C2065F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tCmmAhkx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgGOWOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:14:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41548 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgGOWOq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 18:14:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMBvoF090395;
        Wed, 15 Jul 2020 22:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=pr1P/I9L+5gzWuD7JenbHVssGm+AxNla7ODU/7+mdDc=;
 b=tCmmAhkxmhm1/jaufggXk9M5ahMOT4bvSr2fXfwn0wh3CEOSbv0zFUYPPXbKULdULNh5
 uWaF+xh+ol2Esse8AXdwP2tBahZUPghqL+vthOAep6rGs1OiU2uVszflEfLGQA2lOH/k
 6wZCMqCDhIh9PheEO6MQqZ7bWacF5C5D0UBCg76F+r5HbwcW+y+zb7W4L4ptSt2NOoXa
 H791VGy9Pi8slbKYht9Vf1/RVVoUfJKPYBUlklXzEeAuhKy2xJkejq+imq84BTaefRHK
 Go7SW1KJnwyxyWcg+f9BhiB7VW0eQgZbRqf9dsjnvajd7ec8zQkArVA9iiMsDPjZxZgL zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 327s65maba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:14:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMDevu035125;
        Wed, 15 Jul 2020 22:14:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb91d9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:14:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FMEgCk001029;
        Wed, 15 Jul 2020 22:14:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:14:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Lee Jones <lee.jones@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/29] Fix a bunch more SCSI related W=1 warnings
Date:   Wed, 15 Jul 2020 18:14:34 -0400
Message-Id: <159484884353.21107.4318943401829525429.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jul 2020 08:46:16 +0100, Lee Jones wrote:

> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> Slowly working through the SCSI related ones.  There are many.
> 
> Change-log:
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[01/29] scsi: libfc: Supply some missing kerneldoc struct/function attributes/params
        https://git.kernel.org/mkp/scsi/c/74341d35b901
[02/29] scsi: scsi_transport_fc: Match HBA Attribute Length with HBAAPI V2.0 definitions
        https://git.kernel.org/mkp/scsi/c/e721eb0616f6
[03/29] scsi: libfc: trivial: Fix spelling mistake of 'discovery'
        https://git.kernel.org/mkp/scsi/c/ee9ec5c9af94
[04/29] scsi: fcoe: Fix various kernel-doc infringements
        https://git.kernel.org/mkp/scsi/c/54888649bec7
[05/29] scsi: fcoe: Fix a myriad of documentation issues
        https://git.kernel.org/mkp/scsi/c/3052652326dc
[06/29] scsi: fcoe: Correct some kernel-doc issues
        https://git.kernel.org/mkp/scsi/c/f2db5efefa89
[07/29] scsi: bnx2fc: Repair a range of kerneldoc issues
        https://git.kernel.org/mkp/scsi/c/ca63d8e2e9ef
[08/29] scsi: qedf: Demote obvious misuse of kerneldoc to standard comment blocks
        https://git.kernel.org/mkp/scsi/c/a9d4aece2255
[09/29] scsi: qedf: Remove set but not checked variable 'tmp'
        https://git.kernel.org/mkp/scsi/c/c6e2f4bd794a
[10/29] scsi: libfc: Repair function parameter documentation
        https://git.kernel.org/mkp/scsi/c/9865a04d528c
[11/29] scsi: libfc: Fix a couple of misdocumented function parameters
        https://git.kernel.org/mkp/scsi/c/f636acae8d0d
[12/29] scsi: libfc: Provide missing and repair existing function documentation
        https://git.kernel.org/mkp/scsi/c/ebb40ab68118
[13/29] scsi: bnx2fc: Fix a couple of bitrotted function documentation headers
        https://git.kernel.org/mkp/scsi/c/4db2ac3e0392
[14/29] scsi: arcmsr: Remove some set but unused variables
        https://git.kernel.org/mkp/scsi/c/18bc435e0a1d
[16/29] scsi: qedf: Remove a whole host of unused variables
        https://git.kernel.org/mkp/scsi/c/50efc51cb9ff
[17/29] scsi: bnx2fc: Demote obvious misuse of kerneldoc to standard comment blocks
        https://git.kernel.org/mkp/scsi/c/2bd92b33643e
[18/29] scsi: aic7xxx: Remove unused variable 'tinfo'
        https://git.kernel.org/mkp/scsi/c/e3f58eeedb55
[19/29] scsi: aic7xxx: Remove unused variable 'ahc'
        https://git.kernel.org/mkp/scsi/c/614fc2f9883e
[20/29] scsi: aic7xxx: Remove unused variable 'targ'
        https://git.kernel.org/mkp/scsi/c/7097a517446f
[21/29] scsi: aic7xxx: Fix 'amount_xferred' set but not used issue
        https://git.kernel.org/mkp/scsi/c/aa89d74e040a
[22/29] scsi: qedf: Demote obvious misuse of kerneldoc to standard comment blocks
        https://git.kernel.org/mkp/scsi/c/ce7e0a84e5d7
[23/29] scsi: aacraid: Provide suggested curly braces around empty body of if()
        https://git.kernel.org/mkp/scsi/c/8558d5a4f38c
[24/29] scsi: aacraid: Fix a couple of small kerneldoc issues
        https://git.kernel.org/mkp/scsi/c/00a72e8cd267
[25/29] scsi: aic94xx: Demote seemingly unintentional kerneldoc header
        https://git.kernel.org/mkp/scsi/c/2862a3a26c2d
[26/29] scsi: pm8001: Demote obvious misuse of kerneldoc and update others
        https://git.kernel.org/mkp/scsi/c/e802fc43ba36
[27/29] scsi: aic94xx: Repair kerneldoc formatting error and remove extra param
        https://git.kernel.org/mkp/scsi/c/bb458974e063
[28/29] scsi: aacraid: Fix a bunch of function doc formatting errors
        https://git.kernel.org/mkp/scsi/c/e7eb414c653d
[29/29] scsi: qla4xxx: Provide a missing function param description and fix formatting
        https://git.kernel.org/mkp/scsi/c/7ec772d0c3e6

-- 
Martin K. Petersen	Oracle Linux Engineering
