Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7663C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B53752186A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n+qkT5Ir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbfHHB0W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:26:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbfHHB0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:26:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781OLCZ121507;
        Thu, 8 Aug 2019 01:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=FT1UwY4JMIp7e/cK6tp4YcPLYO/ePVBemIr7GTR1nwE=;
 b=n+qkT5IrBc5Xe48jALyS7klrgPTIBLEJTtLLMDLk/ZW32DibI3vzIorY8mRIBSxWXhUp
 L555tTzDRjuC1tFpO75L1lK45UbvyKYqEySY4mPYMmkGeEjsjWU99hE7inHftqkTrVQs
 p19kqx2Ikq8dqpt+//D7m4vPa1PoitNQCpsG7imwnR1cn270KvFvV10V1fheOW3vq3dP
 X5ct9JrcjBFbCSSfH3qNpDDyOlOo9K3DjKI7NNls0okUPsfPkRoGiahfNEkIZJFtbm7O
 i+Ay4zKLAEoY6vvcStzmCNteGGIQjPXkIJ2EY57xToiwnn9pARiuJ9O31iAioCT51L8i Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u527pyes7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:26:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781Mqw6012087;
        Thu, 8 Aug 2019 01:26:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u7578fyam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:26:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x781QIWt006606;
        Thu, 8 Aug 2019 01:26:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 18:26:17 -0700
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, anand.lodnoor@broadcom.com
Subject: Re: [PATCH] megaraid_sas: change sdev queue depth max vs optimal
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190726073214.23820-1-chandrakanth.patil@broadcom.com>
Date:   Wed, 07 Aug 2019 21:26:15 -0400
In-Reply-To: <20190726073214.23820-1-chandrakanth.patil@broadcom.com>
        (Chandrakanth Patil's message of "Fri, 26 Jul 2019 13:02:14 +0530")
Message-ID: <yq1zhkke9c8.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=930
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=987 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080010
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chandrakanth,

> This patch provides the module parameter and sysfs interface to switch
> between the firmware provided (optimal) queue depth and controller
> queue depth (can_queue).

This smells a bit like a don't-be-broken flag.

Why isn't the firmware-provided value optimal?

-- 
Martin K. Petersen	Oracle Linux Engineering
