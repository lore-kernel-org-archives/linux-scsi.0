Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECA3C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00E3C2168B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NkZefb0p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgKKC67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgKKC6w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2rwDZ158233;
        Wed, 11 Nov 2020 02:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kMf5UIoxWvrsqEKORwqSO1TUvpHk/yao3ePcAJmIksg=;
 b=NkZefb0pTUX9tdtzsXi7R9u0+1zRz58Vnyt3+uOqt/4LxOX03D6GaT6T3GkH9w4EDnzk
 vORiJZQdexWwZvYM5GaOWa2U3LEE8fT9lxFCCk1aevPGAHdm3qGT2CS73jV4Ql+djnl4
 tm94hXNG0/U/b/CXZfGNZEm/HCwasAfF5TOHpXGlBeBwFuPK7WnLonexQsMGdsjpfoiw
 KCwzTPiD1MKWYF0R4rPKb0h6zaPdL0vUC4+JT88eKPCtg4SBHsEkGnTzw5mnbpBmE9HV
 pGOqvJQ67LDh2NmoxyR2yxFuC4wV72IU2JTCbPR+2GBiBwpc2VZdE+MVGQ1hvtCdmXiC jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34nkhkxwq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2srnc153461;
        Wed, 11 Nov 2020 02:58:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5g15jf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:41 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB2wcIQ023878;
        Wed, 11 Nov 2020 02:58:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:38 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Viswas G <Viswas.G@microchip.com.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        akshatzen@google.com, Viswas.G@microchip.com,
        vishakhavc@google.com, jinpu.wang@cloud.ionos.com,
        yuuzheng@google.com, Ruksar.devadi@microchip.com,
        Vasanthalakshmi.Tharmarajan@microchip.com, radha@google.com
Subject: Re: [PATCH V3 0/4] pm80xx updates
Date:   Tue, 10 Nov 2020 21:58:27 -0500
Message-Id: <160506295514.14063.6073783995829466265.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102165528.26510-1-Viswas.G@microchip.com.com>
References: <20201102165528.26510-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=985 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2 Nov 2020 22:25:24 +0530, Viswas G wrote:

> This patch set include some bug fixes for pm80xx driver.
> 
> Changes from v2:
> 	- Corrected commit message for make pm8001_mpi_get_nvmd_resp
> 	  free of race condition.patch.
> 
> Changes from v1:
>         - Improved commit message for "make mpi_build_cmd locking
>           consistent.patch"
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/4] scsi: pm80xx: Make mpi_build_cmd locking consistent
      https://git.kernel.org/mkp/scsi/c/7640e1eb8c5d
[2/4] scsi: pm80xx: Make running_req atomic
      https://git.kernel.org/mkp/scsi/c/4a2efd4b89fc
[3/4] scsi: pm80xx: Avoid busywait in FW ready check
      https://git.kernel.org/mkp/scsi/c/48cd6b38eb4f
[4/4] scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp() race condition
      https://git.kernel.org/mkp/scsi/c/1f889b58716a

-- 
Martin K. Petersen	Oracle Linux Engineering
