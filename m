Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178C8C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E65A2206D8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MDIRBbP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEOBKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 21:10:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgEOBKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 21:10:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F12Xx7003794;
        Fri, 15 May 2020 01:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=s/3nVpAgnqTW+EhLLpuvw8VYRFUjFBPNAhhN20Zki84=;
 b=MDIRBbP6ZDbkKaay+rY+nNRmItayVfk9S02H0xnc8kn0uk12UpSAbOY3EHpI4Ra8ZHTU
 CzGERM8X8Lv1zQuvCsE+xJ4k5UkAiwciXlPcB+1dYvJS/JKVZn3sh2JVfGZ6rNQFPyLR
 L8y1nxoYcZ3OyRhfrO0tyfVPxPPbjOIjdEdiVGulRhwg5gh524GuEXItdEWqEfcTZ9pH
 rq+Rv4t/s1/rdnuqrHMCtN+H79AytehBYEnFqd8Rmi2B6Dy/mCJCk8oNykL/wMdV66nm
 IzOWv0hB7f8RaB0w57myzJvl1SSIgyyIZqBYhrBEnT1NYyX0EfoQmyp1Y0sDDMOCThBs HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3100yg6pw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 01:10:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F148Fm015065;
        Fri, 15 May 2020 01:10:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3100yds33h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 01:10:36 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04F1AY0k006139;
        Fri, 15 May 2020 01:10:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 18:10:34 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zou Wei <zou_wei@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: Fix an Oops in error handling
Date:   Thu, 14 May 2020 21:10:28 -0400
Message-Id: <158950485294.8169.9682857771113228452.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513093703.GB347693@mwanda>
References: <20200513093703.GB347693@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=928 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=970 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 May 2020 12:37:03 +0300, Dan Carpenter wrote:

> If the memdup_user() function fails then it results in an Oops in the
> error handling code when we try to kfree() and error pointer.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: aacraid: Fix an oops in error handling
      https://git.kernel.org/mkp/scsi/c/25c21d20bcfd

-- 
Martin K. Petersen	Oracle Linux Engineering
