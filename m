Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFF7C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C25C221E7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uiGNM7mr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgGNE7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:59:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgGNE7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:59:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vDrj135825;
        Tue, 14 Jul 2020 04:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=JdgDMF59wpVnVy2Cr8T/w66WwAVdhNNEMAkHpUr/M7E=;
 b=uiGNM7mrX8xt4jCqpRkGnUh9co5Qclh9Jl3uYc96Qe0ATTkrebGmgdbdiO6XQ2ak62r+
 efoO5IRlVikaw3V3KD+6yQ6w8fgiPAA+4c63h2Ol5dDhHXQpC1TsXM++G37LUL90Fi1u
 bBNem4KkbQX3VAu0mL6KuGFcU/bV97agkw4gfbmVfWcHt9PKiCbAHQ6ChxxNoK3d1FJ3
 xX6RbmsjB/vY3R/lqGh7TR2Zx1uCDuv68evZHEB7lJyFWX/A/8G96QKsRpgh1bEv+oLl
 gZk9fqXeeGlIxfM44hSQm3FdEvB0oYXHeBB6yfjyn7caJH32z8kednaeaBj7bo6je+SD hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32762natk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 04:58:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vYoC185803;
        Tue, 14 Jul 2020 04:58:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0nc9jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:58:54 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E4wrTx022057;
        Tue, 14 Jul 2020 04:58:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:53 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hare@suse.com,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        dgilbert@interlog.com, ming.lei@redhat.com
Subject: Re: [PATCH v2 0/2] scsi: scsi_debug: Support hostwide tags and a fix
Date:   Tue, 14 Jul 2020 00:58:43 -0400
Message-Id: <159470266468.11195.3600852323660522464.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1594297400-24756-1-git-send-email-john.garry@huawei.com>
References: <1594297400-24756-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Jul 2020 20:23:18 +0800, John Garry wrote:

> This series includes hostwide tags support, so we can mimic some SCSI HBAs,
> like megaraid sas or hisi_sas.
> 
> There is also a fix for an out-of-range module param.
> 
> Differences to v1:
> - add Doug's Ack for patch 1/2
> - sort params alphabetically
> - fix max queue at host max queue (when non-zero)
> - drop host max queue file write permission
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: scsi_debug: Add check for sdebug_max_queue during module init
      https://git.kernel.org/mkp/scsi/c/c87bf24cfb60
[2/2] scsi: scsi_debug: Support hostwide tags
      https://git.kernel.org/mkp/scsi/c/c10fa55f5e7a

-- 
Martin K. Petersen	Oracle Linux Engineering
