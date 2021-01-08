Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A58C432C3
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5822B2075A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbhAHEUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49072 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbhAHEUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10848rOc041264;
        Fri, 8 Jan 2021 04:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=H2NP67Vi8JOmj1ylLUkv1/MHg4MARLtdao26hCgGlHU=;
 b=MDWjw8yn3PJ9CrUtV+VPaU7C2RbH7fuQlRejFiCjiqkN3okCU4DZkyOzxUdDBXRfaMBF
 17dyna89seVxStMbu08jrUbJ3UBG9dZBA0ek7nvgC4ckAVG3K15HXMr3fW2I9Kq6WVTj
 ivOV5BqqCqU8UZyGUo7VEvFqmOIMTkbdHptzWEdg79/CXLLJoDbYzx9lNtuf5MgTGd97
 ENZVM2e3YH1yz2lKUWzfQxBso/LSQgGF66xZ2efbfwEsa+H/q+kvl2miSbwv7VbpD8Fk
 JfMMwvgV/iJUMRYHpP679oAVhtAHPmgTwSxTy7LU1D/TlrPVqn1Wi91wubBiWOAWrOG9 Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35wcuxysa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084AuSM079392;
        Fri, 8 Jan 2021 04:19:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1fc2x7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1084JnUB018020;
        Fri, 8 Jan 2021 04:19:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 20:19:49 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, bvanassche@acm.org, cang@codeaurora.org,
        avri.altman@wdc.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v5 0/2] Two UFS fixes
Date:   Thu,  7 Jan 2021 23:19:35 -0500
Message-Id: <161007949340.9892.1668899238099620205.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107185316.788815-1-jaegeuk@kernel.org>
References: <20210107185316.788815-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=833 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=844 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 Jan 2021 10:53:14 -0800, Jaegeuk Kim wrote:

> Change log from v4:
>  - remove RESERVE tag for tm command
>  - remove waiting IOs and let full reset handle it
>  - avoid verbose error log which causes cpu lock up

Applied to 5.11/scsi-fixes, thanks!

[1/2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
      https://git.kernel.org/mkp/scsi/c/4ee7ee530bc2
[2/2] scsi: ufs: fix tm request correctly when non-fatal error happens
      https://git.kernel.org/mkp/scsi/c/eeb1b55b6e25

-- 
Martin K. Petersen	Oracle Linux Engineering
