Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A268FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8229F20786
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sQjtXaNQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgGHGHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:07:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgGHGHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:07:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068628jt187743;
        Wed, 8 Jul 2020 06:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jdmNeZNrmZGmYqPbEanKtcpNUV44YUbacv2zQBbxr2o=;
 b=sQjtXaNQwaN3K7uAQ3y7Ebsq24CofKH6hh9qPBXon1yAA3yp0jo8K0LlAgf/zeOHTui7
 kpJxSE3EXvAsljHlISMnZ++tvEZ5T/DehINN57D2eX69USfIkv1wxxetqa0kOJ8QMKcz
 Jx3nyQ3sQwF6Kne7UQoD6gnCaexRgNEhGWD5/wlobHQ8xfdq/Tp274I/hUdttWDjIh6E
 iLuW8nzjCSoXzzZxnGOvt4WksdtzBbObKkfbSVUhB2dd5+OguZKAYToAKxDCYnYQbfjv
 783ehUtJbboVys9eeiBsOMKoOIiR5b85VvV1xbNOxbmb6C3SUtmaXB8QxO5cK0j6isAz yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 323wacm8rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:07:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685xDeE105116;
        Wed, 8 Jul 2020 06:07:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3233bqb3s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:09 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06867833030662;
        Wed, 8 Jul 2020 06:07:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:08 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bstroesser@ts.fujitsu.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] target: misc fixes for 5.9
Date:   Wed,  8 Jul 2020 02:06:53 -0400
Message-Id: <159418828148.5152.15776013269977713869.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 cotscore=-2147483648
 suspectscore=0 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 1 Jul 2020 20:43:16 -0500, Mike Christie wrote:

> The following patches were made over Martin's 5.9 queue branch. They fix
> some bugs that intersect with the sysfs/configfs patchset I've been
> posting
> 
> These patches are not critical so are best for 5.9 or later. They fix
> the SPEC_I_PT handling and how we report the iscsi inititor transport id
> which seems to have always been broken and I do not think anyone uses.
> There is also a fix for a leak during target_core_mod rmmod which is
> rare.

Applied to 5.9/scsi-queue, thanks!

[1/7] scsi: target: Check enforce_pr_isids during registration
      https://git.kernel.org/mkp/scsi/c/63c9ffe473d3
[2/7] scsi: target: Fix xcopy sess release leak
      https://git.kernel.org/mkp/scsi/c/3c006c7d23aa
[3/7] scsi: target: Fix crash during SPEC_I_PT handling
      https://git.kernel.org/mkp/scsi/c/f32ba612ef0f
[4/7] scsi: target: Fix iscsi transport id parsing
      https://git.kernel.org/mkp/scsi/c/169622eee437
[5/7] scsi: target: Fix iscsi transport id buffer setup
      https://git.kernel.org/mkp/scsi/c/a6f9b6cee3f2
[6/7] scsi: target: Fix iscsi transport id buf len calculation
      https://git.kernel.org/mkp/scsi/c/bd7f65d95200
[7/7] scsi: target: Handle short iSIDs
      https://git.kernel.org/mkp/scsi/c/639341bf8836

-- 
Martin K. Petersen	Oracle Linux Engineering
