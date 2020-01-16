Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87ECAC33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB5124671
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GZ1CfkcM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgAPEDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 23:03:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59698 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbgAPEDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 23:03:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3wVZe147170;
        Thu, 16 Jan 2020 04:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ritGAYdlcr1yW4YZVj4cu6XlER7GE4xIl+CF3Nw2WWk=;
 b=GZ1CfkcM19XUKLcPxWsrjHkfjyJy0g4tGmueSsrE8QfalOQD0M6KKcYmqpltx2KFScu/
 ermWZpXIzj2yCwLBMsFOPO1o9+1YhfElns5ZeFlNKzfg3Z070w/uEapt1ccsLP0Ysdhe
 uMgSuEWP4Ftj1R1NFcn2s8PpTSrgCLAomejAmsXkvzvM2bmuIdp1NPTXzGGZQFwi7tkz
 kbKRncD70Q+gxNDdzPtSDSIl30l59YX6gpajQffYscFNE3acSyNVjYlwhwkoc8NWbdOM
 0OByHXDQTqTz/J/BZlj4XmWVVj4iRbgDAlaNr0IrkByRX9JaFtiz0AudRANSiyE1xPa0 +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xf74sg1jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:03:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3xI9c167700;
        Thu, 16 Jan 2020 04:03:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xhy22j86k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:03:11 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G4399q032433;
        Thu, 16 Jan 2020 04:03:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 20:03:08 -0800
To:     longli@linuxonhyperv.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: Re: [Patch v2] scsi: storvsc: Correctly set number of hardware queues for IDE disk
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578960516-108228-1-git-send-email-longli@linuxonhyperv.com>
Date:   Wed, 15 Jan 2020 23:03:05 -0500
In-Reply-To: <1578960516-108228-1-git-send-email-longli@linuxonhyperv.com>
        (longli@linuxonhyperv.com's message of "Mon, 13 Jan 2020 16:08:36
        -0800")
Message-ID: <yq1h80wnj46.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Long,

> Commit 0ed881027690 ("scsi: storvsc: setup 1:1 mapping between
> hardware queue and CPU queue") introduced a regression for disks
> attached to IDE. For these disks the host VSP only offers one VMBUS
> channel. Setting multiple queues can overload the VMBUS channel and
> result in performance drop for high queue depth workload on system
> with large number of CPUs.

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
