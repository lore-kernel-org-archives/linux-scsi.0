Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114B0C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C338020936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K0vMnnAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIICJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:09:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIICJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08920oci087237;
        Wed, 9 Sep 2020 02:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=UgHj7e7fBJzMAXVqioijstJEBoTHtkVOui/VbE5yruc=;
 b=K0vMnnAPmoWlaB6B0TBXQLcPqvQJY1Ucyom6SE8UKbZM6S4OvtMz301Q84hImvlBiYxy
 sifo79gKlA0X8+2W0hzbNjNPFyZPnWL9NrClaFAioqbPwdf0mpekW8PikhDy1R1V8oj9
 cRKgtR8qb537vtF5p1/xdnrdqSjUoKYDULZOdiGiN3KjYrHkvVXM02bd8qZaUZu4KNqu
 lwTkEPh64CyT2KweVYRuQPf6EjPdvolTKF6y9pUFtCvYibY98T6Jug7biEqGRnHAfugT
 C0X3JbsZHZIzlZsZeIlNqIcT23NMMbhKjyX3pNa3LbbKm8G6FUyfIZtW5YVb7nMwnLwR 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mkxvma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089252P4095393;
        Wed, 9 Sep 2020 02:09:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33cmk53eag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929Qiu008002;
        Wed, 9 Sep 2020 02:09:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:25 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kernel-team@android.com, asutoshd@codeaurora.org,
        hongwus@codeaurora.org, Can Guo <cang@codeaurora.org>,
        rnayak@codeaurora.org, salyzyn@google.com, saravanak@google.com,
        linux-scsi@vger.kernel.org, nguyenb@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH v1 0/2] Add UFS LINERESET handling
Date:   Tue,  8 Sep 2020 22:09:08 -0400
Message-Id: <159961731707.5787.9889340819985366604.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
References: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=730 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=737
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 24 Aug 2020 19:07:04 -0700, Can Guo wrote:

> PA Layer issues a LINERESET to the PHY at the recovery step in the Power
> Mode change operation. If it happens during auto or mannual hibern8 enter,
> even if hibern8 enter succeeds, UFS power mode shall be set to PWM-G1 mode
> and kept in that mode after exit from hibern8, leading to bad performance.
> Handle the LINERESET in the eh_work by restoring power mode to HS mode
> after all pending reqs and tasks are cleared from doorbell.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/2] scsi: ufs: Abort tasks before clearing them from doorbell
      https://git.kernel.org/mkp/scsi/c/307348f6ab14
[2/2] scsi: ufs: Handle LINERESET indication in err handler
      https://git.kernel.org/mkp/scsi/c/2355b66ed20c

-- 
Martin K. Petersen	Oracle Linux Engineering
