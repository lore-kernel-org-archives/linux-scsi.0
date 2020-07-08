Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0B6C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79073207BB
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NFQeAqZp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgGHGHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:07:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35312 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgGHGHL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:07:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06866ZSO097312;
        Wed, 8 Jul 2020 06:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=qsTfspgmK3uYWJMx+zh46mUUfcGIdDlcr5ePN9k1dSE=;
 b=NFQeAqZpF7LBzOUqm2QFrmLBHmkUielW7Xqiye7cjcjR79tLEOgjGQh1XB9YVIiiHBrr
 +Zq7OtPSoo+UpeFC9DchW1p0+cEbeOC3QrsK+Lsluj+vtaHp46386AZIJbub7UenniYc
 kuRdh9sP3S7GzxudLWJmRYM4JAE1PC3f2TaZbJfJf9rVzaLVtUy0psMN+MkzkdBsBSHZ
 q4VlmT++sNdy+6A67roS3elHLyNQnAvTOevkYHfPqUN3iDBpk8JCVMkSPhjRB88NEz+j
 R3aUM3uioHLSAq2EcelQZ17FZkZNPWN82B5xF7DOkm2i2KwgIFX4sgqwUhx1XAPOxAa5 Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 323sxxvqkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:07:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685x91p145284;
        Wed, 8 Jul 2020 06:07:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 324n4se4nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 068675Sh011512;
        Wed, 8 Jul 2020 06:07:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:05 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] lpfc: Fix less-than-zero comparison of unsigned value
Date:   Wed,  8 Jul 2020 02:06:50 -0400
Message-Id: <159418828150.5152.9681609115401557543.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706204246.130416-1-jsmart2021@gmail.com>
References: <20200706204246.130416-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=911 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=920
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jul 2020 13:42:46 -0700, James Smart wrote:

> The expressions start_idx - dbg_cnt is evaluated using unsigned int
> arthithmetic (since these variables are unsigned ints) and hence can
> never be less than zero, so the less than comparison is never true.
> Re-write the expression to check for start_idx being less than dbg_cnt.
> 
> After the logic was corrected, temp_idx wasn't working correct. So fix it
> was fixed as well.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix less-than-zero comparison of unsigned value
      https://git.kernel.org/mkp/scsi/c/77dd7d7b3442

-- 
Martin K. Petersen	Oracle Linux Engineering
