Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C3DC3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20820208C2
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kSGOFUNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfH2VyN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:54:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfH2VyN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 17:54:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLrmNb195158;
        Thu, 29 Aug 2019 21:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=DoDotwQCm8A/eCKdq9o1ZHvkhzi+Ht7puHnU4k/TCps=;
 b=kSGOFUNWHkaPHOoVkI0FoJN6+oaglGCGAaViIsyqaXJaBcu7WyCsYkOiCtI+PxNLHwKp
 RelNsHdyaK1AZV5rabRVDrT81tGX3Zc+TE4As0SkUr6u3uWfDSkPFsiC3W6xVhythbwS
 +OJC6wG9+7pcOKCOszMzeJvfJesMOP1MF+O33Jcl6zBYr4wboN/9Ity4tfizWQ4t4kJe
 G5GvQLKsKVy0XjyTCwNcel6+oPdTyR9eZk9ZmatJ3qWVTvTXwF+WbpVwxfyS7IReGcT4
 /yD86O3w0UHGkuU8s+EV7oZ767tprEnHByUzJc/GGajk6c79pC4pWmZmRtONYIMZtX/d 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uppr9r2ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:54:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLnDjk160627;
        Thu, 29 Aug 2019 21:52:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uphaubkj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:52:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLq6Il010100;
        Thu, 29 Aug 2019 21:52:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:52:05 -0700
To:     Konstantin Khorenko <khorenko@virtuozzo.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sagar Biradar <sagar.biradar@microchip.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: Re: [PATCH v3 0/1] aacraid: Host adapter Adaptec 6405 constantly resets under high io load
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <yq15zo86nvk.fsf@oracle.com>
        <20190819163546.915-1-khorenko@virtuozzo.com>
Date:   Thu, 29 Aug 2019 17:52:03 -0400
In-Reply-To: <20190819163546.915-1-khorenko@virtuozzo.com> (Konstantin
        Khorenko's message of "Mon, 19 Aug 2019 19:35:45 +0300")
Message-ID: <yq136hjskqk.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290217
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=981 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290218
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Problem description:
> ====================
> A node with Adaptec 6405 controller, latest BIOS V5.3-0[19204] A lot
> of disks attached to the controller.  Simple test: running mkfs.ext4
> on many disks on the same controller in parallel (mkfs is not
> important here, any serious io load triggers controller aborts)

Microchip folks: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
