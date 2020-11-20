Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9043C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 792E522267
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DDgYD3oQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgKTD3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:29:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKTD3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:29:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3QOHf097173;
        Fri, 20 Nov 2020 03:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0+yob98xl2umr83QJJGmPf5tXWJBSCpkS0f5XLnCPAw=;
 b=DDgYD3oQ2CXF/z225Hf893Te6S5S7eMRzoZZ8w00lBSbYxvS1cg5vReBuUQLrMiU7kui
 ngCQW6dqbY+zf3UYfJU5LPpN4SqVKS/h3REhuDZdHrCsvOJoJPSecijWc6aUUxslOwvI
 sxjXxH0h06f1LB7txD1BHcWhELbcfQ/z1zCgFwVdXlhkhNK19p6gFScdNyie/St153QH
 oJq9L6dp3Jl6evmVnsaALrW+2TSvkkaEEK8QxJW2CwTkpdTnxb9pTFjQ02YbGTrkswgc
 bhkneSWXopMCWKUkCL5JKtwfsAadFFYnTMlYe8n0wckzh+wqroEHHkASpVK6y1Iuqkf9 Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76m8qu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:29:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3Pc8U096491;
        Fri, 20 Nov 2020 03:29:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ts0uq2jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:29:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AK3Tm7m029083;
        Fri, 20 Nov 2020 03:29:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:29:48 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/17] lpfc: Update lpfc to revision 12.8.0.6
Date:   Thu, 19 Nov 2020 22:29:35 -0500
Message-Id: <160584262852.7157.12650015994189438837.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=862 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=871
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 15 Nov 2020 11:26:29 -0800, James Smart wrote:

> Update lpfc to revision 12.8.0.6
> 
> This patch set contains several sets of recoding and refactoring.
> 
> A close look was taken at the driver to identify what was causing
> continual small state machine errors as well other repeatitive issues.
> Code review showed several things and this is the first set of changes
> to address the deficiencies.
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[01/17] scsi: lpfc: Rework remote port ref counting and node freeing
        https://git.kernel.org/mkp/scsi/c/307e338097dc
[02/17] scsi: lpfc: Rework locations of ndlp reference taking
        https://git.kernel.org/mkp/scsi/c/4430f7fd09ec
[03/17] scsi: lpfc: Fix removal of SCSI transport device get and put on dev structure
        https://git.kernel.org/mkp/scsi/c/95f0ef8a8368
[04/17] scsi: lpfc: Fix refcounting around SCSI and NVMe transport APIs
        https://git.kernel.org/mkp/scsi/c/e9b1108316b9
[05/17] scsi: lpfc: Rework remote port lock handling
        https://git.kernel.org/mkp/scsi/c/c6adba150191
[06/17] scsi: lpfc: Remove ndlp when a PLOGI/ADISC/PRLI/REG_RPI ultimately fails
        https://git.kernel.org/mkp/scsi/c/52edb2caf675
[07/17] scsi: lpfc: Unsolicited ELS leaves node in incorrect state while dropping it
        https://git.kernel.org/mkp/scsi/c/9d76d4675159
[08/17] scsi: lpfc: Fix NPIV discovery and Fabric Node detection
        https://git.kernel.org/mkp/scsi/c/b3f2e67cc2dd
[09/17] scsi: lpfc: Fix NPIV Fabric Node reference counting
        https://git.kernel.org/mkp/scsi/c/a70e63eee1c1
[10/17] scsi: lpfc: Refactor WQE structure definitions for common use
        https://git.kernel.org/mkp/scsi/c/b101eb27fde0
[11/17] scsi: lpfc: Enable common wqe_template support for both SCSI and NVMe
        https://git.kernel.org/mkp/scsi/c/840a470181c7
[12/17] scsi: lpfc: Enable common send_io interface for SCSI and NVMe
        https://git.kernel.org/mkp/scsi/c/47ff4c510f02
[13/17] scsi: lpfc: Convert SCSI path to use common I/O submission path
        https://git.kernel.org/mkp/scsi/c/da255e2e7cc8
[14/17] scsi: lpfc: Convert SCSI I/O completions to SLI-3 and SLI-4 handlers
        https://git.kernel.org/mkp/scsi/c/96e209be6ecb
[15/17] scsi: lpfc: Convert abort handling to SLI-3 and SLI-4 handlers
        https://git.kernel.org/mkp/scsi/c/db7531d2b377
[16/17] scsi: lpfc: Update lpfc version to 12.8.0.6
        https://git.kernel.org/mkp/scsi/c/ab4dfa4dd5a1
[17/17] scsi: lpfc: Update changed file copyrights for 2020
        https://git.kernel.org/mkp/scsi/c/983f761cd5c5

-- 
Martin K. Petersen	Oracle Linux Engineering
