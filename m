Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E01AC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC6123A5B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rCPthy/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgIVD7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:59:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42576 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgIVD7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:59:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nSF0149212;
        Tue, 22 Sep 2020 03:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jXS0BhXEXcUXKw/flIqFt5Jc5tLUcUcCbsrIV4rFncU=;
 b=rCPthy/UhhGLTz5o722CNXEvk0HZbIOyMjoqxffuEyMTiV2XP+7c0US/H/3eLzDV0f/i
 i1BpBWCCsIRtraCqIMPABhh/MRe7LpvZaVyAaVPQIsqPan8z1Ij0iRhL1bqq/sHoKBMg
 twI4eiV+Go1RxQU2RPRAhZ8Re6i9xEDjoda02IHMFEsoqUjZYrtSVDkMJ1+esMovm1tv
 LzF81C/5iN6hL2eqfKWCa+JgusiabdfSGnCEdiVCnJVjPDzMWd+QpP9ORa96PK2Etmpm
 uIJsr53EhDFZ6EpVRaWWZLRl5o+zuOKmkL3VWb3Ogjzd9tLJY1p+c1LPKFz7ki2tzkrI 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33n7gad5y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:59:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tLWW020837;
        Tue, 22 Sep 2020 03:57:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nuwxk71m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:14 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vDkh009418;
        Tue, 22 Sep 2020 03:57:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:13 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 0/2] zfcp: small changes for 5.10
Date:   Mon, 21 Sep 2020 23:56:45 -0400
Message-Id: <160074695008.411.13328105917017372358.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1599765652.git.bblock@linux.ibm.com>
References: <cover.1599765652.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Sep 2020 21:49:14 +0200, Benjamin Block wrote:

> here are some small changes for zfcp I'd like to include in 5.10 if
> possible. They apply cleanly on Martin's `scsi-queue`, and James' `misc`
> branches.
> 
> Both patches make the driver a bit cleaner, and hopefully easier to
> maintain.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/2] scsi: zfcp: Use list_first_entry_or_null() in zfcp_erp_thread()
      https://git.kernel.org/mkp/scsi/c/addf13729615
[2/2] scsi: zfcp: Clarify access to erp_action in zfcp_fsf_req_complete()
      https://git.kernel.org/mkp/scsi/c/d251193d1732

-- 
Martin K. Petersen	Oracle Linux Engineering
