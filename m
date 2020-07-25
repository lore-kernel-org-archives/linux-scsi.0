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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E429BC433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C32FF20737
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d/WjhKYh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGYCvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGYCvA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2m6DT043209;
        Sat, 25 Jul 2020 02:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=2LEmVzP0v4CwHYaFbrCprZ1/Tu1tf4ykG9L6AB5ahF8=;
 b=d/WjhKYhYSxCg0L9wHHC7+sL33vCWwEBbemqv11TbSRigrrbLAcBIxBAwD9pr6oXnXuk
 CTU2ap/5KdxKn5MVEvDcMhNir+VdVbwj7vayNS7bG3n+wW4oVqvfNVZI4dz03BP/XLfY
 kHI3eUnI1uFzKDPDGB5oi0f9wHOGHQZtXiER63NG/12Nv3bPmIBeooiG+tbZCLFucjx+
 HhIz3l5fOrrJbvr9a7gTY/A/EGAon1mtD83rksZxPFTGmRzXY6QeLgijs5wNGijXrzuc
 o+nb/DEa3yPQXDvqvvxdZVsCGAEZUqefdYMuNEpO500Em7Qtgpv1JLfMx9iKtXR/0c90 uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32bs1n1ur0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:50:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mVb1092367;
        Sat, 25 Jul 2020 02:50:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32gaseas1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:50:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P2onfK010052;
        Sat, 25 Jul 2020 02:50:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:50:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Colin King <colin.king@canonical.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: remove redundant assignment to variable res
Date:   Fri, 24 Jul 2020 22:50:34 -0400
Message-Id: <159564519422.31464.3717823298731100505.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722154404.959267-1-colin.king@canonical.com>
References: <20200722154404.959267-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Jul 2020 16:44:04 +0100, Colin King wrote:

> The variable res is being initialized with a value that is
> never read and it is being updated later with a new value. The
> initialization is redundant and can be removed.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: libsas: Remove redundant assignment to variable res
      https://git.kernel.org/mkp/scsi/c/55eb809f5e1c

-- 
Martin K. Petersen	Oracle Linux Engineering
