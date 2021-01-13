Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3D6C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A17723120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbhAMFv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:51:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35696 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbhAMFv6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:51:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5ne9t170789;
        Wed, 13 Jan 2021 05:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Fa53x9KCB45aZToeaa6imRFJDCfKeEZyIw4w0UELXYU=;
 b=qNX1fy3863Uc+9Cdm1risWemmIyLPaAvwCb15uuQu8JI6ajp/MZfa6QiroaWVLyFnsF4
 RSfD8hzMdcojJMI9x2VUp7Iu5qP+w/YC4esGXGgzHdOAXI5d5fbDfMOWkQZwNT96w36M
 XN//udxOhHgtw2QPuiU0Wop7ojgQzp/o88Tb10JTAnHZY9FA+T9lHgWj5BCD+DP7MME5
 L81GehSrUiyQ4J5jE6N+tpusvXRl42xWN7cjzDIh22SclAvnqyDQq8Y4pTobPLBfO2Q4
 vOI4qz03OiGXwSae8VqkBaaq8+VwbK19JeY3iowxkO6dIAOPlUXYPFRhF1WzH1HOdxEU TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 360kg1sp04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:50:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5dcoH158982;
        Wed, 13 Jan 2021 05:48:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 360ke7rkjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:39 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10D5mWOQ023651;
        Wed, 13 Jan 2021 05:48:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:31 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, beanhuo@micron.com, jejb@linux.ibm.com,
        Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        rostedt@goodmis.org, bvanassche@acm.org, tomas.winkler@intel.com,
        asutoshd@codeaurora.org, avri.altman@wdc.com, cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/6] Several changes for the UPIU trace
Date:   Wed, 13 Jan 2021 00:48:22 -0500
Message-Id: <161050726819.14224.15923940659426155067.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105113446.16027-1-huobean@gmail.com>
References: <20210105113446.16027-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 Jan 2021 12:34:40 +0100, Bean Huo wrote:

> Changelog:
> 
> V3--v4:
>  1. Rebase patch onto 5.12/scsi-queue
>  2. Incorporate Avri's suggestion in patch 2/6
> 
> V2--V3:
>   1. Fix a typo in patch 1/6 (Reported-by: Joe Perches <joe@perches.com>)
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/6] scsi: ufs: Remove stringize operator '#' restriction
      https://git.kernel.org/mkp/scsi/c/c7c730ac6a88
[2/6] scsi: ufs: Use __print_symbolic() for UFS trace string print
      https://git.kernel.org/mkp/scsi/c/28fa68fc557a
[3/6] scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is disabled
      https://git.kernel.org/mkp/scsi/c/9d5095e74c83
[4/6] scsi: ufs: Distinguish between query REQ and query RSP in query trace
      https://git.kernel.org/mkp/scsi/c/be20b51cfd85
[5/6] scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM UPIU trace
      https://git.kernel.org/mkp/scsi/c/0ed083e91662
[6/6] scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
      https://git.kernel.org/mkp/scsi/c/867fdc2d6e34

-- 
Martin K. Petersen	Oracle Linux Engineering
