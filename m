Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E50C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F29F020786
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YRsYTmZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgGHGJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:09:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgGHGJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:09:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06866XVq097296;
        Wed, 8 Jul 2020 06:09:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=z1G2f0b66VHoL5BRHaMkeOPuTvsvV9boGDlv2nknlAs=;
 b=YRsYTmZa1U+rwBM5oBiSlVTOlTfPwHWzhAb955ksDqP32mJhz5MOu98dLmP8q7YsW09Z
 pYvHs1bHJXuJcVTt4EgbMJS0+VBI8AZlaG1kAxcaYJvufgeVQEYpTcfTyyNrzp/gs1Ai
 Q3aSbZLghSErNQuRTZCU4QZafojSJ3h2Hq6SMc1MUi21czNq3sZ16LP4onY3Hx/Rvw6U
 vIyFYOcA3VIq2nLdF/vDIxNell02PgeUrKyQgHoYLet3l4N+5iZlXDcqM5Uiva5riWOZ
 KDsp3vrbvc3tzX6Xh5nlcLDV3IYVALFGJZ0JF6Li5alP/Kg70Z6b8yZDz2Ae+os1qT1l 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 323sxxvr0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:09:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685xBCG063834;
        Wed, 8 Jul 2020 06:07:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3233p4k2h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:03 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06866wZk030638;
        Wed, 8 Jul 2020 06:06:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:06:58 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-doc@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        George Spelvin <lkml@sdf.org>
Subject: Re: [PATCH 0/7] zfcp: cleanups and small changes for 5.9
Date:   Wed,  8 Jul 2020 02:06:45 -0400
Message-Id: <159418828149.5152.2055440250302680177.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593780621.git.bblock@linux.ibm.com>
References: <cover.1593780621.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Jul 2020 15:19:56 +0200, Benjamin Block wrote:

> here are some cleanups and small changes for zfcp I'd like to include in
> 5.9 if possible.
> 
> One of the changes touches documentation in `Documentation/scsi/`, so I
> put Jonathan on To, hope that was correct. I hope you can still pull
> this all in one go to minimize work. IBM did retire some old URLs and
> content from our public website, so we have to clean that up in the
> documentation so there are not dead links. I changed these in the hopes
> we can minimize documentation churn going forward, just to replace URLs.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/7] scsi: zfcp: Use prandom_u32_max() for backoff
      https://git.kernel.org/mkp/scsi/c/0cd0e57ec858
[2/7] scsi: zfcp: Fix an outdated comment for zfcp_qdio_send()
      https://git.kernel.org/mkp/scsi/c/459ad085d87b
[3/7] scsi: docs: Update outdated link to IBM developerworks
      https://git.kernel.org/mkp/scsi/c/b9789bfbfe9d
[4/7] scsi: docs: Remove invalid link and update text for zfcp kernel config
      https://git.kernel.org/mkp/scsi/c/c06de6e28c9e
[5/7] scsi: zfcp: Clean up zfcp_erp_action_ready()
      https://git.kernel.org/mkp/scsi/c/b43cdb5ac856
[6/7] scsi: zfcp: Replace open-coded list move
      https://git.kernel.org/mkp/scsi/c/6bcb7c171a0c
[7/7] scsi: zfcp: Avoid benign overflow of the Request Queue's free-level
      https://git.kernel.org/mkp/scsi/c/c3bfffa5ec69

-- 
Martin K. Petersen	Oracle Linux Engineering
