Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1D0C4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB6C221EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:52:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ukJcrQpe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIWAwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 20:52:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgIWAwC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 20:52:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N0jAKR001202;
        Wed, 23 Sep 2020 00:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4cVhTdG3zorw6QjJt5z3I67vupn2zO/nb+w7JYhBzXg=;
 b=ukJcrQpekHFv4oE5hSit3fg34zsWtgSCx/Mq6ybknXfv03Wk+xA3fYv8HoO+FY+OVvsT
 XexA8MeU63be1KWtom5lGM+rgWYjpBVOlRWGt5GoaBh7HIayIkA7lJ6LqSTcp7k5FN+5
 1PzBO+fRBTmnxYe4atV+dyA3qb1pqvkX7iR7orZ1+oQrMlQDMHceQvjsr3XDgKaYixZH
 ZEYu3GCBp0l8q1cDTjTdxVheFGPrYfKhjItGBdM5MJD7Cy/weq3vJMM/s80SdKTLTAIT
 tJgbdhGpaHWzJ/HtpPNAwi6w3lnk4hTR/IkPYlfsRZMj+u+umX+co1e7AYApYfxqTpdt Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rge482-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 00:52:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N0iO9D055860;
        Wed, 23 Sep 2020 00:51:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nurtssxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 00:51:59 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08N0px2R004345;
        Wed, 23 Sep 2020 00:51:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 17:51:58 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        ssudhakarp@gmail.com
Subject: Re: [PATCH] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
Date:   Tue, 22 Sep 2020 20:51:57 -0400
Message-Id: <160082230400.6366.234985652157623643.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=932 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1011 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=960 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Sep 2020 23:54:31 +0000, Sudhakar Panneerselvam wrote:

> transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd
> for the lookup. Hence, update this field directly for the
> TARGET_SCF_LOOKUP_LUN_FROM_TAG case.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case
      https://git.kernel.org/mkp/scsi/c/149415586243

-- 
Martin K. Petersen	Oracle Linux Engineering
