Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FD4C82C80
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 22:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D54620661
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 22:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JwCNM8AW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD0WuA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 18:50:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgD0Wt7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 18:49:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RMnGKi011609;
        Mon, 27 Apr 2020 22:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=1c+Qb0P6m8Bjmtsg/rPwqyaKG/hriJn7/NsqFOKcOsU=;
 b=JwCNM8AW/dbJuvz0+/3HtR9BfLbskNfRUpOW3+MYz982eaQxZ65kNms8PG+FoHaXUhkt
 0WduaFWvcrVOJHLwVy/YX+9vXC4mykDD+C9KimRWTpBdcnqKYTUn7pcAbuUtvlNXYsfa
 bd92cgXg6/YDYoT06k7tzCiSojS2EI0MU1DSAUwOVEhZWGgaUHrIwN7x/sqEb0n2Xp9u
 XBGEwqhcEaRJA0KeECvMtNIeAbc1rL+HtcsT9PcNAffTms5BwnuR5YRXSc1vEQLi59e4
 Cdz4NFnSBhzUSYZNqJ+aMu5EPsl7E7ySLFCY1Dv1lOuaAPdZe009Xfr2y8EREOyhzsiK 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01nk10y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:49:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RMbOC2126457;
        Mon, 27 Apr 2020 22:49:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30my0avchp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:49:54 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RMnrjU022306;
        Mon, 27 Apr 2020 22:49:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 15:49:53 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, aacraid@microsemi.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: Fix some error handling paths in 'aac_probe_one()'
Date:   Mon, 27 Apr 2020 18:49:49 -0400
Message-Id: <158802757520.27023.14035276109176874290.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200412094039.8822-1-christophe.jaillet@wanadoo.fr>
References: <20200412094039.8822-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=819 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=875 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270185
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 12 Apr 2020 11:40:39 +0200, Christophe JAILLET wrote:

> If 'scsi_host_alloc()' or 'kcalloc()' fail, 'error' is known to be 0. Set
> it explicitly to -ENOMEM instead before branching to the error handling
> path.
> 
> While at it, axe 2 useless assignments to 'error'. These values are
> overwridden a few lines later.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: aacraid: Fix error handling paths in aac_probe_one()
      https://git.kernel.org/mkp/scsi/c/f7854c382240

-- 
Martin K. Petersen	Oracle Linux Engineering
