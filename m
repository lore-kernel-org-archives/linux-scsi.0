Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356D9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C0AA206DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="biUv6dks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGCEEF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:04:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGCEEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:04:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633wvwI096861;
        Fri, 3 Jul 2020 04:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=L1u2fFDuKIWsO31WN0vUswf3Y8+lDWU8GKw7EIyCEJw=;
 b=biUv6dksOzySz2iLGbz94Sk0l0j467gV2YWoDaWAkN7hTdlXOvxNkRsrkCSx2dUEwaQA
 BxLJ8+q66vnhtiSFsJg5NfeFeg8l9dIF2pkL2ByjMQcM/AXqlY0iHZuvj/a5SGuNj1ot
 FQBmyAMN4Q0FJsopVXzNnS7HEHpNsom0B74KGG9aFs1+IQJV1foGxo4QqmRgeN9Ecq1i
 LqRgMnqRE5eJv8nSH5+wbmQDjNmj2YZuPlH/2EXEdHbUodEgOBHk1rq5NsYsJq/a5Dxm
 JGU8PxjL4V58x2vdgYmyXxE+P6jms8Xln7fbgmIeO2vg0ZROioumKGXllGwTH2+KYJeO qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrnkp4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 04:04:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633whqV161967;
        Fri, 3 Jul 2020 04:04:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvwnc9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 04:04:02 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 063442qm003299;
        Fri, 3 Jul 2020 04:04:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:04:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/14] lpfc: Update lpfc to revision 12.8.0.2
Date:   Fri,  3 Jul 2020 00:03:55 -0400
Message-Id: <159374899164.14731.8353105103067375009.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Jun 2020 14:49:47 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.2
> 
> Patch set contains fixes as a couple of small additions, and two larger
> additions - blk_io_poll support and a different log message facility.
> 
> The patches were cut against Martin's 5.9/scsi-queue tree
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[01/14] scsi: lpfc: Fix unused assignment in lpfc_sli4_bsg_link_diag_test
        https://git.kernel.org/mkp/scsi/c/e5fcb81d40d4
[02/14] scsi: lpfc: Fix missing MDS functionality
        https://git.kernel.org/mkp/scsi/c/c93764a65b4b
[04/14] scsi: lpfc: Fix NVMe rport deregister and registration during ADISC
        https://git.kernel.org/mkp/scsi/c/9806c984d43a
[05/14] scsi: lpfc: Fix oops due to overrun when reading SLI3 data
        https://git.kernel.org/mkp/scsi/c/d91e3abb682b
[06/14] scsi: lpfc: Fix stack trace seen while setting rrq active
        https://git.kernel.org/mkp/scsi/c/9dace1fa91ca
[07/14] scsi: lpfc: Fix shost refcount mismatch when deleting vport
        https://git.kernel.org/mkp/scsi/c/03dbfe0668e6
[08/14] scsi: lpfc: Fix kdump hang on PPC
        https://git.kernel.org/mkp/scsi/c/86ee57a97a17
[09/14] scsi: lpfc: Fix language in 0373 message to reflect non-error message
        https://git.kernel.org/mkp/scsi/c/28ed7374401b
[10/14] scsi: lpfc: Allow applications to issue Common Set Features mailbox command
        https://git.kernel.org/mkp/scsi/c/45bc44270f0c
[11/14] scsi: lpfc: Add support to display if adapter dumps are available
        https://git.kernel.org/mkp/scsi/c/f0020e428af7
[12/14] scsi: lpfc: Add blk_io_poll support for latency improvment
        https://git.kernel.org/mkp/scsi/c/317aeb83c92b
[13/14] scsi: lpfc: Add an internal trace log buffer
        https://git.kernel.org/mkp/scsi/c/372c187b8a70
[14/14] scsi: lpfc: Update lpfc version to 12.8.0.2
        https://git.kernel.org/mkp/scsi/c/3fed58b94e3d

-- 
Martin K. Petersen	Oracle Linux Engineering
