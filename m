Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49F0CA9ECF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85FEB208E3
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HpdaODPV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfKBA3q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 20:29:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKBA3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 20:29:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA20TTQH194721;
        Sat, 2 Nov 2019 00:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=SaeO2ZMwQiftYInzU4i7VWexA0Rcs+VMYR81gTfei1o=;
 b=HpdaODPV1Ghf1ZGlXF2EhHaTtNq25JhDB9chqoxQPC0WPAoOI5uEtXNL/0qT/n6JioKN
 MbweIC/RiV/jWG/netFJ4Viw7Mu2+cK/dYsyh9QQfjn0ZlaW4LH0IzfnylJmVAGfa34B
 /Jysr3pS0au37C+wm3qmRY15YucVDksZIUIUs33quFfC2ALpI+ZXMEJjtKv8gpTOq9+s
 S6RfuWNveALsRZ147C+2dnr1LJAvCOLUAFz+BesHEdEThUbjTewotms+dCxb7iYmf38l
 6hTrJoyby1pTHBQBtR+F7FnkCeaqh3YjI+WPhmc8GuNQOpvuRjc5y8ZhFfzFzERSJme3 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vxwhg4hbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:29:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA20S7WD170393;
        Sat, 2 Nov 2019 00:29:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w0rusf8h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:29:28 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA20TQn4004375;
        Sat, 2 Nov 2019 00:29:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 17:29:26 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] scsi/trace: Use get_unaligned_be*()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191101211447.187151-1-bvanassche@acm.org>
Date:   Fri, 01 Nov 2019 20:29:15 -0400
In-Reply-To: <20191101211447.187151-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 1 Nov 2019 14:14:47 -0700")
Message-ID: <yq1o8xv5des.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=877
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911020000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911020000
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch fixes an unintended sign extension on left shifts. From
> Colin King: "Shifting a u8 left will cause the value to be promoted to
> an integer. If the top bit of the u8 is set then the following
> conversion to an u64 will sign extend the value causing the upper 32
> bits to be set in the result."
>
> Fix this by using get_unaligned_be*() instead.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
