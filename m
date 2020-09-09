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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7303EC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 330B020936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tE/rZXRZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIICJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:09:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgIICJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0891xvxN146266;
        Wed, 9 Sep 2020 02:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Q3m3hmUdOc7UomT+KaQBpx8Q7cCwiuGT6mKRFYzMJic=;
 b=tE/rZXRZAJ9o2s9wyd1E+vbvyFTodV+5BvyRoWOXdEoPsyq+TPHBZ/KZkKL8CjPmhOyp
 kfLC+axMpDACSmofXh8ry0ivwHECH4fdIb6Epp0j5UgF+p8X8NotgrSF6V14kMFLzne8
 0YxsUhAEtJeFMsUjAzXfCyVIrTgvxFZ1gXZ76KzviaQF+RMTnfKXVYbACV+6zldGPopk
 4QCv6pwmCcNOjNQihTzVYssYqwgyTb0d9t2MHj84AC7EubXw6gWzj5rB5tf0dLFWUcUt
 y8tgBUlfSfLCatlHd3bnC3htyGDFURTmW+RggXeep35MqYPW98Oe7B82ymnV2gBrBzHO XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amxtrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08925SIQ184096;
        Wed, 9 Sep 2020 02:09:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33cmerx7y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:40 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929c6V008051;
        Wed, 9 Sep 2020 02:09:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fdomain_isa: merge branches in fdomain_isa_match()
Date:   Tue,  8 Sep 2020 22:09:17 -0400
Message-Id: <159961731708.5787.1524744143353594403.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <df68e341-5113-4cf2-b64c-dc1ad0b686ac@omprussia.ru>
References: <df68e341-5113-4cf2-b64c-dc1ad0b686ac@omprussia.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 29 Aug 2020 23:19:42 +0300, Sergey Shtylyov wrote:

> The *else* branch of the *if* (base) statement in fdomain_isa_match() is
> immediately followed by the *if* (!base) statement. Simplify the code by
> removing the unneeded *if*...

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: fdomain_isa: Merge branches in fdomain_isa_match()
      https://git.kernel.org/mkp/scsi/c/255937d77390

-- 
Martin K. Petersen	Oracle Linux Engineering
