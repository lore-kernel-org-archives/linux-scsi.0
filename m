Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43DAC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C232082F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zHJz7DAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgFPEA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:00:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38816 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgFPEAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 00:00:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3wH1F014041;
        Tue, 16 Jun 2020 04:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=+4Xj92iIInRkeTVInVgDIeuxZMR/l0BHDBXSpNW/QzI=;
 b=zHJz7DAT4vwOkj8MepNLOJ1eCefAhmwcYf0yoD98gpOpmHYET+XnERyDlEfTw0TW0GMq
 SxZNEa5CbvzlsSrmjNXjJItP29CYPQH/OgUzzOfBkoftl86S7lQ+z76WAWGe20uwAMhf
 jwkM4iEYVsxTaZRCD7aajt5TJ1RtB/Ih833dCoYIk+Tn63Kzi8c1nV08fHcLH7aSgC7k
 KfXq7mcF9vJn8AqZLRTHATjRiOJFsyLJESrmehYBiMmpj/uysbXl7zMjug3/DO3u+BZM
 7t+pc/mFlErzdZkcvU2EJRn4oCDNPFDqIjok2KZJ26hNIwhDNm2CUin1ix2hutr8lI28 vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31p6s24aap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:00:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3xOI8131282;
        Tue, 16 Jun 2020 04:00:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31p6dcaddw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05G405mj023186;
        Tue, 16 Jun 2020 04:00:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:04 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     beanhuo@micron.com, stanley.chu@mediatek.com, jejb@linux.ibm.com,
        cang@codeaurora.org, bvanassche@acm.org, asutoshd@codeaurora.org,
        avri.altman@wdc.com, tomas.winkler@intel.com,
        Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, beanhuo@outlook.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RESENT PATCH v5 0/5] scsi: ufs: cleanup ufs initialization
Date:   Mon, 15 Jun 2020 23:59:54 -0400
Message-Id: <159227986421.24883.16863663810252939595.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200603091959.27618-1-huobean@gmail.com>
References: <20200603091959.27618-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 cotscore=-2147483648 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 3 Jun 2020 11:19:54 +0200, Bean Huo wrote:

> Resent this patchset since linux-scsi@vger.kernel.org and
> linux-kernel@vger.kernel.org rejected my email
> 
> 
> Cleanup UFS descriptor length initialization, and delete some unnecessary code.
> 
> Changelog:
> v4 - v5:
>     1. Rebased patch
>     2. In the patch 3/5, change "param_size > buff_len" to
>        "(param_offset + param_size) > buff_len"
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/5] scsi: ufs: Remove max_t in ufs_get_device_desc
      https://git.kernel.org/mkp/scsi/c/458a45f5262b
[2/5] scsi: ufs: Delete ufshcd_read_desc()
      https://git.kernel.org/mkp/scsi/c/c4607a09450d
[3/5] scsi: ufs: Fix potential NULL pointer access during memcpy
      https://git.kernel.org/mkp/scsi/c/cbe193f6f093
[4/5] scsi: ufs: Clean up ufs initialization path
      https://git.kernel.org/mkp/scsi/c/7a0bf85b5e18
[5/5] scsi: ufs: Add compatibility with 3.1 UFS unit descriptor length
      https://git.kernel.org/mkp/scsi/c/72fb690eece1

-- 
Martin K. Petersen	Oracle Linux Engineering
