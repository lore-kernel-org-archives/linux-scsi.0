Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A6AC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23AE6206EB
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:58:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jvnjhRSl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGYC6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:58:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60500 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYC6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:58:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2wUNB064659;
        Sat, 25 Jul 2020 02:58:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=xj/8F4x/iEzJT9D158eIp0s9RyEpFQjy84gxVqz6rDk=;
 b=jvnjhRSl9vR/LySeDuBkCGMcO+9+sz6f3nqSnq+ld7XfBU5jMFUOFmPG4FkwFwuZcNkq
 C5kioWnOjDiGpkw8Y5DcFxGU007XTeFrWV49+erAsPcCo2tsnDt72oHIrzCzUzBPzsd6
 eTztXatP9fYvJkZ9qCR4Se5tZMBOx8ETMpzZyQeHXWiR/Hn9lcYDkXs5WiRKXOwTBF1o
 RzvQ3GO2+qpZEzsQMTwOkaIvATMC9VYeMzhXuGzZM129dqyhwmKBoP8tw8z20VtLoiM6
 Q2AvieauPKOdT+rwJ7GtggIbQa1eNAxV8LKAcRR6W46TVkE8tO88Ubq9J/21SIKYBZII IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1n1v6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:58:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2rB3W031953;
        Sat, 25 Jul 2020 02:58:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32g9uu7a4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:58:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2wSRt006780;
        Sat, 25 Jul 2020 02:58:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:58:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/40] Set 5: Penultimate set of SCSI related W=1 warnings
Date:   Fri, 24 Jul 2020 22:58:27 -0400
Message-Id: <159564578046.20494.3980136879548068325.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 23 Jul 2020 13:24:06 +0100, Lee Jones wrote:

> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> Hopefully this is the penultimate set.
> 
> Lee Jones (40):
>   scsi: lpfc: lpfc_els: Fix some function parameter descriptions
>   scsi: lpfc: lpfc_hbadisc: Fix kerneldoc parameter
>     formatting/misnaming/missing issues
>   scsi: ufs: ufs-qcom: Demote nonconformant kerneldoc headers
>   scsi: bnx2i: bnx2i_init: Fix parameter misnaming in function header
>   scsi: ufs: ufs-exynos: Make stubs 'static inline'
>   scsi: ufs: ufs-exynos: Demote seemingly unintentional kerneldoc header
>   scsi: bfa: bfa_port: Staticify local functions
>   scsi: bnx2i: bnx2i_sysfs: Add missing descriptions for 'attr'
>     parameter
>   scsi: bfa: bfa_fcpim: Remove set but unused variable 'rp'
>   scsi: bfa: bfa_fcpim: Demote seemingly unintentional kerneldoc header
>   scsi: qedi: qedi_main: Remove 2 set but unused variables
>   scsi: ips: Remove some set but unused variables
>   scsi: ips: Convert strnlen() to memcpy() since result should not be
>     NUL terminated
>   scsi: qla4xxx: ql4_83xx: Remove set but unused variable 'status'
>   scsi: lpfc: lpfc_init: Use __printf() format notation
>   scsi: lpfc: lpfc_init: Add and rename a whole bunch of function
>     parameter descriptions
>   scsi: qla4xxx: ql4_bsg: Rename function parameter descriptions
>   scsi: lpfc: lpfc_mbox: Fix a bunch of kerneldoc misdemeanours
>   scsi: lpfc: lpfc_nportdisc: Add description for lpfc_release_rpi()'s
>     'ndlpl param
>   scsi: bfa: bfa_ioc: Remove a few unused variables 'pgoff' and 't'
>   scsi: csiostor: csio_hw: Mark known unused variable as __always_unused
>   scsi: csiostor: csio_hw_t5: Remove 2 unused variables
>     {mc,edc}_bist_status_rdata_reg
>   scsi: bfa: bfa_ioc: Staticify non-external functions
>   scsi: csiostor: csio_rnode: Add missing description for
>     csio_rnode_fwevt_handler()'s 'fwevt' param
>   scsi: bfa: bfa_ioc_ct: Demote non-compliant kerneldoc headers to
>     standard comments
>   scsi: mvsas: mv_init: Place 'core_nr' inside correct clause
>   scsi: bfa: bfa_fcs_rport: Remove unused variable 'adisc'
>   scsi: bnx2i: bnx2i_hwi: Fix a whole host of kerneldoc issues
>   scsi: bnx2i: bnx2i_iscsi: Add, remove and edit some function parameter
>     descriptions
>   scsi: be2iscsi: be_iscsi: Correct misdocumentation of function param
>     'ep'
>   scsi: qedi: qedi_fw: Remove set but unused variable 'tmp'
>   scsi: esas2r: esas2r: Add braces around the one-line if()
>   scsi: bfa: bfa_ioc: Demote non-kerneldoc headers down to standard
>     comment blocks
>   scsi: bfa: bfa_core: Demote seemingly unintentional kerneldoc header
>   scsi: bfa: bfa_svc: Demote seemingly unintentional kerneldoc header
>   scsi: qedi: qedi_main: Demote seemingly unintentional kerneldoc header
>   scsi: qedi: qedi_iscsi: Staticify non-external function
>     'qedi_get_iscsi_error'
>   scsi: bfa: bfa_ioc: Ensure a blank line precedes next function/header
>   scsi: bnx2i: bnx2i_iscsi: Add parameter description and rename another
>   scsi: esas2r: esas2r_log: Demote a few non-conformant kerneldoc
>     headers
> 
> [...]

Applied to 5.9/scsi-next, thanks!

[01/40] scsi: lpfc: Fix some function parameter descriptions
        https://git.kernel.org/mkp/scsi/c/a0e4a64f8650
[02/40] scsi: lpfc: Fix kerneldoc parameter formatting/misnaming/missing issues
        https://git.kernel.org/mkp/scsi/c/e415f2a2acd9
[03/40] scsi: ufs: ufs-qcom: Demote nonconformant kerneldoc headers
        https://git.kernel.org/mkp/scsi/c/bc5b681614cc
[04/40] scsi: bnx2i: Fix parameter misnaming in function header
        https://git.kernel.org/mkp/scsi/c/b4688a7e01e5
[06/40] scsi: ufs: ufs-exynos: Demote seemingly unintentional kerneldoc header
        https://git.kernel.org/mkp/scsi/c/b44cc4a40bd6
[07/40] scsi: bfa: Staticify local functions
        https://git.kernel.org/mkp/scsi/c/0aaaa04a7a79
[08/40] scsi: bnx2i: Add missing descriptions for 'attr' parameter
        https://git.kernel.org/mkp/scsi/c/2ad6e0c339d2
[09/40] scsi: bfa: Remove set but unused variable 'rp'
        https://git.kernel.org/mkp/scsi/c/70b4de0bb928
[10/40] scsi: bfa: Demote seemingly unintentional kerneldoc header
        https://git.kernel.org/mkp/scsi/c/7106de1d8a75
[11/40] scsi: qedi: Remove 2 set but unused variables
        https://git.kernel.org/mkp/scsi/c/e4020e0835ed
[12/40] scsi: ips: Remove some set but unused variables
        https://git.kernel.org/mkp/scsi/c/ffe1757e45aa
[13/40] scsi: ips: Convert strnlen() to memcpy() since result should not be NUL terminated
        https://git.kernel.org/mkp/scsi/c/00e245655e75
[14/40] scsi: qla4xxx: Remove set but unused variable 'status'
        https://git.kernel.org/mkp/scsi/c/6e3f4f68821b
[15/40] scsi: lpfc: Use __printf() format notation
        https://git.kernel.org/mkp/scsi/c/7fa03c77cd54
[16/40] scsi: lpfc: Add and rename a whole bunch of function parameter descriptions
        https://git.kernel.org/mkp/scsi/c/fe614acd583f
[17/40] scsi: qla4xxx: Rename function parameter descriptions
        https://git.kernel.org/mkp/scsi/c/d10d1df6301d
[18/40] scsi: lpfc: Fix a bunch of kerneldoc misdemeanors
        https://git.kernel.org/mkp/scsi/c/012d019f5a50
[19/40] scsi: lpfc: Add description for lpfc_release_rpi()'s 'ndlpl param
        https://git.kernel.org/mkp/scsi/c/22f8c077411b
[20/40] scsi: bfa: Remove a few unused variables 'pgoff' and 't'
        https://git.kernel.org/mkp/scsi/c/c7ccd038b729
[21/40] scsi: csiostor: Mark known unused variable as __always_unused
        https://git.kernel.org/mkp/scsi/c/085d46fd2202
[22/40] scsi: csiostor: Remove 2 unused variables {mc,edc}_bist_status_rdata_reg
        https://git.kernel.org/mkp/scsi/c/f11106c93fc9
[23/40] scsi: bfa: Staticify non-external functions
        https://git.kernel.org/mkp/scsi/c/00025fc7e676
[24/40] scsi: csiostor: Add missing description for csio_rnode_fwevt_handler()'s 'fwevt' param
        https://git.kernel.org/mkp/scsi/c/f5816509a2f2
[25/40] scsi: bfa: Demote non-compliant kerneldoc headers to standard comments
        https://git.kernel.org/mkp/scsi/c/eaefa33014bf
[27/40] scsi: bfa: Remove unused variable 'adisc'
        https://git.kernel.org/mkp/scsi/c/e95fcb77921c
[28/40] scsi: bnx2i: Fix a whole host of kerneldoc issues
        https://git.kernel.org/mkp/scsi/c/dd3273c9b10f
[29/40] scsi: bnx2i: Add, remove and edit some function parameter descriptions
        https://git.kernel.org/mkp/scsi/c/89c19a8e5ec3
[30/40] scsi: be2iscsi: Correct misdocumentation of function param 'ep'
        https://git.kernel.org/mkp/scsi/c/c4b68559edf5
[31/40] scsi: qedi: Remove set but unused variable 'tmp'
        https://git.kernel.org/mkp/scsi/c/56d244fe89c9
[32/40] scsi: esas2r: Add braces around the one-line if()
        https://git.kernel.org/mkp/scsi/c/e36e0427a46a
[33/40] scsi: bfa: Demote non-kerneldoc headers down to standard comment blocks
        https://git.kernel.org/mkp/scsi/c/b1a187f2615a
[34/40] scsi: bfa: Demote seemingly unintentional kerneldoc header
        https://git.kernel.org/mkp/scsi/c/310531ffc3c8
[35/40] scsi: bfa: Demote seemingly unintentional kerneldoc header
        https://git.kernel.org/mkp/scsi/c/20e73cb1d03c
[36/40] scsi: qedi: Demote seemingly unintentional kerneldoc header
        https://git.kernel.org/mkp/scsi/c/3db05fed8b58
[37/40] scsi: qedi: Staticify non-external function 'qedi_get_iscsi_error'
        https://git.kernel.org/mkp/scsi/c/010f7c2ab4ad
[38/40] scsi: bfa: Ensure a blank line precedes next function/header
        https://git.kernel.org/mkp/scsi/c/64332c13d0d1
[39/40] scsi: bnx2i: Add parameter description and rename another
        https://git.kernel.org/mkp/scsi/c/a8b6d0ee6e9e
[40/40] scsi: esas2r: Demote a few non-conformant kerneldoc headers
        https://git.kernel.org/mkp/scsi/c/e3903d31826f

-- 
Martin K. Petersen	Oracle Linux Engineering
