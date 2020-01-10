Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD289C33C99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806D12077B
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rNyXKrot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgAJG01 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 01:26:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731455AbgAJG00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 01:26:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A6Nd1V084855;
        Fri, 10 Jan 2020 06:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=fHCtMN49MZxpNEoKDqSfeTXdEv7IK57B7vU6roH9E7M=;
 b=rNyXKrotsPCGOg+YSglg6R9Elv3YirCaoGus42dIEVOf+Zem4oTEr7uQTIW+BLHsUuja
 BVoP1Y4yCsJ1l6hLFsHRw0jbvIbh4O7YBDVTC6FRQYtjF6V61IGS+iA2iDxaETnbFZ1j
 mREuB+wC6T8w82iCIZ4YcsHLz2mDhIMonfGWVG0vd0tLK1RBgvS5tDSOOuq70wT+psVb
 FUJTLe+cm3UXy2+zpJDuheZdD36fu1YXyRiMEcHUNXO7kuib3dqucB4PrzF9XIN7Ma+O
 LSkUlFSaLiCCdtBFO6aZhUQxLwGUYqjAJ93MPf6hHEPielV4aRLqVUa1FnnZGHJTdRp2 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xakbr7vys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:26:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A6NlRI045957;
        Fri, 10 Jan 2020 06:26:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xdrxfcbd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:26:10 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00A6Q8is012392;
        Fri, 10 Jan 2020 06:26:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 22:26:07 -0800
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: lpfc: Make lpfc_defer_acc_rsp static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200107014956.41748-1-yuehaibing@huawei.com>
Date:   Fri, 10 Jan 2020 01:26:03 -0500
In-Reply-To: <20200107014956.41748-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Tue, 7 Jan 2020 09:49:56 +0800")
Message-ID: <yq1y2ufvnd0.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=956
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100053
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> Fix sparse warning:
>
> drivers/scsi/lpfc/lpfc_nportdisc.c:344:1: warning:
>  symbol 'lpfc_defer_acc_rsp' was not declared. Should it be static?

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
