Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70F6C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B14E520792
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fB78a84/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGVEfn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 00:35:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgGVEfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 00:35:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4WJ2F047597;
        Wed, 22 Jul 2020 04:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ctbS8eOAREb4+bvdGv4FdSz/I4Ywj1q0as43nAJVEAU=;
 b=fB78a84/B8i20N8Qwp5WQxHjRiScnqguzib5tZQT34FLS3IHlr6EDuWOAm+juFa4cBJa
 EoOcObZdN7rnv7WByxV4zL5hU5lRI98TOaxDICK4Lmemf4ksuz3KL7Kr7ukvuL1IPucF
 cjPxItgRX/LJHIa4hpgUqFoeUEmTyU4OGBGdYSY/fI1zE+aK1hi/iFu0395g4Q8vHS5M
 Wl6uYFgEhuAx4a1S2DoEoDB7RhS+MaBaqnjYnDFYvvf0rrocV93F/+lItgxiHyj5KAnA
 LRfPsDnop4msx8y0Y5RXZmpAiyxVEt2HkJEkVORZN28CS+ciNCjYbAT5dGzpGb/5uqnv VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6ksn2ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 04:35:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4S21f028505;
        Wed, 22 Jul 2020 04:33:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32eberxcyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 04:33:36 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06M4SZdS026749;
        Wed, 22 Jul 2020 04:28:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 21:28:35 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com
Subject: Re: [PATCH V2] megaraid_sas: clear affinity hint
Date:   Wed, 22 Jul 2020 00:28:31 -0400
Message-Id: <159539205428.31352.10645150006432482019.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709133144.8363-1-thenzl@redhat.com>
References: <20200709133144.8363-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=869 mlxscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=893 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Jul 2020 15:31:44 +0200, Tomas Henzl wrote:

> To avoid a warning in free_irq, clear the affinity hint.
> 
> Fixes: f0b9e7bdc309e8cc63a640009715626376e047c6 ("scsi: megaraid_sas: Set affinity for high IOPS reply queues")

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: megaraid_sas: Clear affinity hint
      https://git.kernel.org/mkp/scsi/c/925230b8723f

-- 
Martin K. Petersen	Oracle Linux Engineering
