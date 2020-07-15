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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE65C433EA
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1BC72067D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JOqO7Ui9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgGOWOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:14:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOWOq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 18:14:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMDfrL130374;
        Wed, 15 Jul 2020 22:14:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=DnBqyE8/pCTV8QRw6jCmfUYbXTq2sDoxMNKNNmn7vp0=;
 b=JOqO7Ui9X2EMSDe6DU9riUaAq9isteC4YSe048IgjkUjFpT4jc7KV3tVj47W4kzel4BW
 V8JlW8AVipK6VcODUKkwcQ9mfwoFRPmLO3JtTg/fUFS2dsSHpUStdZH6y0LNMiTDZOdK
 PeV0bGkL66auzHeMh2vZZKf5hj2oaSeUDU4S5Icgp6LM9iYqLhevqH/uaB3qMag0m+o+
 gS69CCFIolLvE4nOIFheNmNl0uQuKwJ15XRm4iITDDMDhJ8q4PQ2mtk1Wh9tfSoLqlBx
 edIcGFFFNj2PuO+gAaUVgk6a1RhIEBJ7tr+dMkDimFRhOUXJBqGKd7ZesYjETL7WWWaC VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cme19n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:14:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMDdmP086718;
        Wed, 15 Jul 2020 22:14:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32a4cretk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:14:42 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FMEfsA004642;
        Wed, 15 Jul 2020 22:14:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:14:40 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Lee Jones <lee.jones@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/24] Set 3: Fix another set of SCSI related W=1 warnings
Date:   Wed, 15 Jul 2020 18:14:33 -0400
Message-Id: <159484884355.21107.3732344826044180939.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jul 2020 08:59:37 +0100, Lee Jones wrote:

> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> Slowly working through the SCSI related ones.  There are many.
> 
> This brings the total of W=1 SCSI wanings from 1690 in v5.8-rc1 to 1109.
> 
> [...]

Applied to 5.9/scsi-queue. Thanks for cleaning things up!

I do think that in general it makes little sense for low-level drivers
to document internal functions using kerneldoc. As a general approach
I would prefer to just switch drivers to '/*' or to remove stale
comments instead of trying to keep up with the "docrot" warnings.

kerneldoc cleanups are great for functions that actually have more
than one user (core code, libraries, common code used by multiple
drivers, etc.). Whereas for driver internals I would much rather
emphasize function arguments with well-chosen, descriptive names
instead of a kerneldoc "@p: pointer to a foobar" comment that will
inevitably become stale next time an interface changes.

[01/24] scsi: aacraid: Repair two kerneldoc headers
        https://git.kernel.org/mkp/scsi/c/b115958d91f5
[02/24] scsi: aacraid: Fix a few kerneldoc issues
        https://git.kernel.org/mkp/scsi/c/cf93fffac261
[03/24] scsi: aacraid: Fix logical bug when !DBG
        https://git.kernel.org/mkp/scsi/c/2fee77e5b820
[04/24] scsi: aacraid: Remove unused variable 'status'
        https://git.kernel.org/mkp/scsi/c/0123c7c62d6c
[05/24] scsi: aacraid: Demote partially documented function header
        https://git.kernel.org/mkp/scsi/c/71aa4d3e0e78
[06/24] scsi: aic94xx: Document 'lseq' and repair asd_update_port_links() header
        https://git.kernel.org/mkp/scsi/c/966fdadf6fea
[07/24] scsi: aacraid: Fix a bunch of function header issues
        https://git.kernel.org/mkp/scsi/c/f1134f0eb184
[08/24] scsi: aic94xx: Fix a couple of formatting and bitrot issues
        https://git.kernel.org/mkp/scsi/c/d2e510505006
[09/24] scsi: aacraid: Fill in the very parameter descriptions for rx_sync_cmd()
        https://git.kernel.org/mkp/scsi/c/ae272a95133a
[10/24] scsi: pm8001: Provide descriptions for the many undocumented 'attr's
        https://git.kernel.org/mkp/scsi/c/e1c3e0f8a2ae
[11/24] scsi: ipr: Fix a mountain of kerneldoc misdemeanours
        https://git.kernel.org/mkp/scsi/c/a96099e2c164
[12/24] scsi: virtio_scsi: Demote seemingly unintentional kerneldoc header
        https://git.kernel.org/mkp/scsi/c/e31f2661ff41
[13/24] scsi: ipr: Remove a bunch of set but checked variables
        https://git.kernel.org/mkp/scsi/c/4dc833999e37
[14/24] scsi: ipr: Fix struct packed-not-aligned issues
        https://git.kernel.org/mkp/scsi/c/f3bdc59f9b11
[15/24] scsi: myrs: Demote obvious misuse of kerneldoc to standard comment blocks
        https://git.kernel.org/mkp/scsi/c/8a692fdb1d04
[17/24] scsi: be2iscsi: Fix API/documentation slip
        https://git.kernel.org/mkp/scsi/c/abad069ef0da
[18/24] scsi: be2iscsi: Fix misdocumentation of 'pcontext'
        https://git.kernel.org/mkp/scsi/c/dbc019a48f97
[19/24] scsi: be2iscsi: Add missing function parameter description
        https://git.kernel.org/mkp/scsi/c/7405edfdfb96
[20/24] scsi: lpfc: Correct some pretty obvious misdocumentation
        https://git.kernel.org/mkp/scsi/c/09d99705b5d2
[21/24] scsi: aic7xxx: Remove unused variable 'ahd'
        https://git.kernel.org/mkp/scsi/c/91b6e191c4dc
[22/24] scsi: aic7xxx: Remove unused variables 'wait' and 'paused'
        https://git.kernel.org/mkp/scsi/c/532d56c631f1
[23/24] scsi: aic7xxx: Fix 'amount_xferred' set but not used issue
        https://git.kernel.org/mkp/scsi/c/42b840bcfc16

-- 
Martin K. Petersen	Oracle Linux Engineering
