Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5B9C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C112076D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QBuiYDE1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgHRDMv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:12:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgHRDMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:12:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38VXd134891;
        Tue, 18 Aug 2020 03:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=wCqyRWl7cdexhYSpNKpa3YbPzn0RoUVnLQhaZ7Ev7UM=;
 b=QBuiYDE1Q0TMSIeSODYdl5bLfE/+gSv+XpRzBejELKkD9YKHLyyInn1KOgNjhoD+5H61
 Vv8kf4EF5EETnBCIE9/TCq7sJkRDXAiDgTi4UlzPI0IhJ30SHCzg17iE7jIDkL/CxiPv
 g4a+XBsjRYy0UUGag6GrRdEh/8ksg85eVDaIiI0HExSlOUqoNKjqGE3IWxNFZGDAGZhg
 cpiROPL8PBkPNtxSIItI+7ujdaKqp2WM2IOlohi7RJq09uXNpYcJElNc2e67Vj3IQQU1
 LphEtU9IA2iOC+Fobam3rtC9hpOn/ErfuAN/2LUx1BHk2M3O3HLKZxisWc3RemQxpyYX jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74r27ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:12:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I387id131387;
        Tue, 18 Aug 2020 03:12:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32xs9mf4es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07I3CjX6021365;
        Tue, 18 Aug 2020 03:12:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:45 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/11] qla2xxx driver bug fixes
Date:   Mon, 17 Aug 2020 23:12:30 -0400
Message-Id: <159772029327.19587.8489472284800239905.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200806111014.28434-1-njavali@marvell.com>
References: <20200806111014.28434-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 6 Aug 2020 04:10:03 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the attached miscellaneous qla2xxx bug fixes to the
> scsi tree at your earliest convenience.
> 
> v1->v2:
> Add patch, "qla2xxx: Revert: Disable T10-DIF feature with FC-NVMe
> during probe", within the patchset.
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[01/11] scsi: qla2xxx: Flush all sessions on zone disable
        https://git.kernel.org/mkp/scsi/c/10ae30ba6648
[02/11] scsi: qla2xxx: Flush I/O on zone disable
        https://git.kernel.org/mkp/scsi/c/a117579d0205
[03/11] scsi: qla2xxx: Indicate correct supported speeds for Mezz card
        https://git.kernel.org/mkp/scsi/c/4709272f6327
[04/11] scsi: qla2xxx: Fix login timeout
        https://git.kernel.org/mkp/scsi/c/abb31aeaa9b2
[05/11] scsi: qla2xxx: Reduce noisy debug message
        https://git.kernel.org/mkp/scsi/c/81b9d1e19d62
[06/11] scsi: qla2xxx: Allow ql2xextended_error_logging special value 1 to be set anytime
        https://git.kernel.org/mkp/scsi/c/49030003a38a
[07/11] scsi: qla2xxx: Fix WARN_ON in qla_nvme_register_hba
        https://git.kernel.org/mkp/scsi/c/897d68eb816b
[08/11] scsi: qla2xxx: Check if FW supports MQ before enabling
        https://git.kernel.org/mkp/scsi/c/dffa11453313
[09/11] scsi: qla2xxx: Fix null pointer access during disconnect from subsystem
        https://git.kernel.org/mkp/scsi/c/83949613fac6
[10/11] Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"
        https://git.kernel.org/mkp/scsi/c/de7e6194301a
[11/11] Revert "scsi: qla2xxx: Disable T10-DIF feature with FC-NVMe during probe"
        https://git.kernel.org/mkp/scsi/c/dca93232b361

-- 
Martin K. Petersen	Oracle Linux Engineering
