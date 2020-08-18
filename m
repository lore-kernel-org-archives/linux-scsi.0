Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2974AC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04384206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xQZBmaym"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgHRDNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:13:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgHRDNG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:13:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38CdA134845;
        Tue, 18 Aug 2020 03:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=bw3vjhVE8POnsxYphN8maqx8YY19m/Dn1NGPELw5mIA=;
 b=xQZBmaym4/99pdi5976wdTLp/3Av3qK0N2xr+YPPWrEHPVAfBMLuMVdNhZlvVQG0uHyh
 MAuNbSCgj9b2o1pgHmNS6acs5b4K9OvBSFx79iBh/aB0LKKQcyHi1GimfFyEsannPUwy
 9F67N2hGVwzweVJFVVBHTV11SDOtXDJV2+K0gTMVZrbnMXxGkzZt9wU6VZv93UYC8Cng
 ofW4eg9gy4lYMsxMzMCuUBxiqy+E27Bd+gjwVWKJFmGkbSU3kARlejI6s7LMRLvApIUc
 KW5PKTpQCfdDk1X7qlM5ss9p84u2skgYSbxiFO7r0lL4KzkP6AycQJWHgQd6a78mSJQb kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74r27dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:12:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I387qw131344;
        Tue, 18 Aug 2020 03:12:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32xs9mf4dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07I3CfpU020686;
        Tue, 18 Aug 2020 03:12:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org, avri.altman@wdc.com,
        asutoshd@codeaurora.org, Bean Huo <huobean@gmail.com>,
        jejb@linux.ibm.com, beanhuo@micron.com, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: ufs: two fixups of ufshcd_abort()
Date:   Mon, 17 Aug 2020 23:12:26 -0400
Message-Id: <159772029326.19587.13319744810377565226.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200811141859.27399-1-huobean@gmail.com>
References: <20200811141859.27399-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=729 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=723
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 11 Aug 2020 16:18:57 +0200, Bean Huo wrote:

> Changelog:
> 
> v1 - v2:
>     1. add patch [1/2], which is from Stanley Chu <stanley.chu@mediatek.com>
>     2. change goto command in patch [2/2], let it goto cleanup flow
> 
> Bean Huo (1):
>   scsi: ufs: no need to send one Abort Task TM in case the task in DB
>     was cleared
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/2] scsi: ufs: Clean up completed request without interrupt notification
      https://git.kernel.org/mkp/scsi/c/b10178ee7fa8
[2/2] scsi: ufs: No need to send Abort Task if the task in DB was cleared
      https://git.kernel.org/mkp/scsi/c/d87a1f6d021f

-- 
Martin K. Petersen	Oracle Linux Engineering
