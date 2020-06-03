Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA6CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEB55206E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MWw5V8RB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgFCCcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:32:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbgFCCcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 22:32:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532S5Yg185677;
        Wed, 3 Jun 2020 02:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Zl0+nJeXbVl6u+zbUzG7Al+pOb28DJU1KHOuBGmYr1Q=;
 b=MWw5V8RBlTaTao1dWycuNKyPvd4EyatPGmd13VGjmcyLOq+unQc9w0pBq7gyFlzzPs6T
 C3ZbBsCRiaNPL00dnf+fLCYWDSMYzPS+Sso2rQEBq9H+g6JvYUlGlomOYFZkMuYiq30A
 2TWTfAnoMUgRWsW3tk8A1/WLCJyXDMRGfTiMLL2UkLlFyvRjWi4xFd8NNz+BljmuLAy2
 HwIR5tk/CJmAeHy5nLE5lASp83Od1VBYnRToPjQpcn1hbtAGkqGy9RbrU0J4qTPKceuj
 KFajytKGbbT48Y9u+p1EN73/zKTn+F6NgvSWbsFyyC6RPMOvodeTMGKbaRZCLu0b7Krf CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31dkrukvre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 02:31:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532RvoP063125;
        Wed, 3 Jun 2020 02:31:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25qpmf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 02:31:46 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0532VisS032607;
        Wed, 3 Jun 2020 02:31:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 19:31:44 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hongwus@codeaurora.org, saravanak@google.com,
        rnayak@codeaurora.org, kernel-team@android.com,
        linux-scsi@vger.kernel.org, nguyenb@codeaurora.org,
        asutoshd@codeaurora.org, salyzyn@google.com,
        Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v1 1/1] scsi: ufs: Don't update urgent bkops level when toggle auto bkops
Date:   Tue,  2 Jun 2020 22:31:34 -0400
Message-Id: <159114947916.26776.2254304120169408842.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1590632686-17866-1-git-send-email-cang@codeaurora.org>
References: <1590632686-17866-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 27 May 2020 19:24:42 -0700, Can Guo wrote:

> Urgent bkops level is used to compare against actual bkops status read
> from UFS device. Urgent bkops level is set during initialization and might
> be updated in exception event handler during runtime, but it should not be
> updated to the actual bkops status every time when auto bkops is toggled.
> Otherwise, if urgent bkops level is updated to 0, auto bkops shall always
> be kept enabled.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: ufs: Don't update urgent bkops level when toggling auto bkops
      https://git.kernel.org/mkp/scsi/c/be32acff4380

-- 
Martin K. Petersen	Oracle Linux Engineering
