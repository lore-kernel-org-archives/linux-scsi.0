Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3B4C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ADD2208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TiQ2abXE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgJGDsS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36170 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGDsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973hvto044770;
        Wed, 7 Oct 2020 03:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TZ22GLt8v2noU7mYvYvl5wxvRnyWf+PM35LhXeJoB74=;
 b=TiQ2abXESfbv5OIHN2ZiH/rvpYOzLFYI32qerjmoP20sj6wTnP4RydwZ1VYzWYySHDV7
 +DysOeAI8oHpiM+25OJyl0m4ht3JPhIDCV+ReI4JrOMdJiqX/YVIHu5KuC0mnawLWwGn
 qXY75iWYh+/7bscKNra6nh0rlcVRukGf0Yuak+GfebZThbDQGxYiHSZc5NvYCgIK2YBU
 XjRWRBsSnt7da4FJDAPW8srhQ6fTBHqn2uuOZqtg+bi0QqRhvwo1Gx+FDTu0+kdsuizf
 lxH7TXbomTPmUgEvkX41Myo/3sLcbuR1iSsqpqbrNEYlZ1EH3USfL6ms9p0VH/AtMpna Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34mjxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ip95194643;
        Wed, 7 Oct 2020 03:48:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3410jy2s0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0973m9M2002396;
        Wed, 7 Oct 2020 03:48:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:08 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        kernel-janitors@vger.kernel.org,
        Jayamohan Kallickal 
        <jayamohank@HDRedirect-LB5-1afb6e2973825a56.elb.us-east-1.amazonaws.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()
Date:   Tue,  6 Oct 2020 23:47:48 -0400
Message-Id: <160204240578.16940.13402401013800356061.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200928091300.GD377727@mwanda>
References: <20200928091300.GD377727@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=928 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=938 clxscore=1011 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Sep 2020 12:13:00 +0300, Dan Carpenter wrote:

> The be_fill_queue() function can only fail when "eq_vaddress" is NULL
> and since it's non-NULL here that means the function call can't fail.
> But imagine if it could, then in that situation we would want to store
> the "paddr" so that dma memory can be released.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()
      https://git.kernel.org/mkp/scsi/c/38b2db564d9a

-- 
Martin K. Petersen	Oracle Linux Engineering
