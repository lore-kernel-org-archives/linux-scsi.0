Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FC6C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 02:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 816DF208B3
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 02:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rqkC4UCa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgFQCgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 22:36:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgFQCgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 22:36:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05H2Qpea164602;
        Wed, 17 Jun 2020 02:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=qvgZnLOIIfJf/ujxLoAp3CI8oYpCJxkhQIhjpeCqggY=;
 b=rqkC4UCaHQsCrL17aAfWVUhKGjEhhkeuEZBr6OGmRA9x0eqMKnyaMSpQFhHbr2cT9Lun
 BbeAkVeUcyXXnfSFC5N879/COopxmwFJpkqGamCb08iTE655BsVdxIJVy5B/TkEyPUBE
 6rQ/qEizSgx0LZMbVOv6trUwHr6nRPqL8BrwhE5lPaWdyaiNz1WUalX9FhB9p1rXgnTq
 /DX6im6iM/9T3jtuRWfhE0UrMy1dvwPcha91lgkvo3QQYC/09i2QH6OCTkgdfREnArpI
 /FBrQTdMQFl6X7Lk4YmZvfBSXJtz3k0W3W4mcW3QZaZ6OnwqMbBkHFzCoUKhMEfy2Lm4 gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31q65jrphw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jun 2020 02:35:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05H2X59R126602;
        Wed, 17 Jun 2020 02:35:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31q66mew15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 02:35:36 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05H2ZLF9004679;
        Wed, 17 Jun 2020 02:35:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 19:35:21 -0700
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Chris Boot <bootc@bootc.net>, linuxppc-dev@lists.ozlabs.org,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18sgml9ds.fsf@ca-mkp.ca.oracle.com>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
        <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
Date:   Tue, 16 Jun 2020 22:35:18 -0400
In-Reply-To: <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet> (Finn
        Thain's message of "Sun, 14 Jun 2020 10:03:31 +1000 (AEST)")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 cotscore=-2147483648 suspectscore=1
 bulkscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006170018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Finn,

> I haven't used this driver for a long time, but I still own PowerMacs
> with firewire, and I know I'm not the only one.

I also have old 1394 hardware kicking around in the basement. But having
worked with FireWire shared storage targets in the past, I have zero
desire to ever touch any of that again.

I could understand an objection if we were to entertain removing
sbp2. But really, how many people are setting up FireWire targets?

-- 
Martin K. Petersen	Oracle Linux Engineering
