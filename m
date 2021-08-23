Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D268EC432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 06:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6E546103D
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 06:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhHWGo3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 02:44:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231779AbhHWGo3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 02:44:29 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17N6Y58c087043;
        Mon, 23 Aug 2021 02:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=P9fw4VLP/J/ALHiiFAin6o7BcfNci/tdgswv/X+Hwt0=;
 b=Ar3pjw3xFYBiFkz4VNuD4fQ0yNb631OF7LReid0vrKq9gpVH/kQbWPUg1U/wZHnr1mjg
 sCZkdU1cqDL1M8b9aRsXyhEbLzE3FaicTZOkNundva9ihHZmb7W+Q3N3kusoEfEYiHR9
 zlXtIfW+Er1jwVArLYhNLdqv9ep4/HC67PNYQBnv1SjhYr9zMcHLT1NkQ/iuocCdXcOl
 emSEIdBieYrj/n/qer1d912OZUHR/B0OfttNygf5C5sXuOP0sBUzk2GV1CH9TOy7Nlww
 gm10nTHSQscbO09g4whn57lnzBC5l1fBWSo/zFTobWcPK9jEouZPHL9cyngIpuVFqn6H 4A== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3akejapcen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 02:43:27 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17N6gpWt024691;
        Mon, 23 Aug 2021 06:43:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ajs48ac6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 06:43:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17N6di8E58655066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 06:39:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03AAF4C052;
        Mon, 23 Aug 2021 06:43:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 224FD4C044;
        Mon, 23 Aug 2021 06:43:20 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.34.43])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 23 Aug 2021 06:43:19 +0000 (GMT)
Date:   Mon, 23 Aug 2021 08:43:16 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?UTF-8?B?TcOka2lzYXJh?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>, oliver.sang@intel.com
Subject: Re: [PATCH 18/24] scsi_ioctl: move the "block layer" SCSI ioctl
 handling to drivers/scsi
Message-ID: <20210823084316.4bb224e0.pasic@linux.ibm.com>
In-Reply-To: <20210724072033.1284840-19-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
        <20210724072033.1284840-19-hch@lst.de>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b7z-rbOCxBf46qRXly_rqVnwyFAm9nJz
X-Proofpoint-ORIG-GUID: b7z-rbOCxBf46qRXly_rqVnwyFAm9nJz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_02:2021-08-20,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 clxscore=1011 mlxlogscore=999 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230043
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 24 Jul 2021 09:20:27 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Merge the ioctl handling in block/scsi_ioctl.c into its only caller in
> drivers/scsi/scsi_ioctl.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Hi Christoph!

I believe there is a small problem with this patch. I think it is
easiest to explain with the diff that fixes it. Please see the patch
at the end of this email.

Otherwise your patch looks great!

This may or may not be related to the problem reported here:
https://lkml.org/lkml/2021/7/29/157
Adding Oliver, maybe he can test if this fixes his testcases as well.
(It did fix ours.:)

If you like I can respin my fix with an extended patch description.

-----------------------8<-------------------------------------------
From: Halil Pasic <pasic@linux.ibm.com>
Date: Mon, 23 Aug 2021 08:11:53 +0200
Subject: [PATCH] scsi: scsi_ioctl: fix error code propagation in SG_IO

Fixes: f2542a3be327 ("scsi: scsi_ioctl: Move the "block layer" SCSI
ioctl handling to drivers/scsi")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/scsi/scsi_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 2c4cdd0fc26e..dbb24a3720ac 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -952,7 +952,7 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,

                if (put_sg_io_hdr(&hdr, arg))
                        return -EFAULT;
-               return 0;
+               return error;
        }
        case SCSI_IOCTL_SEND_COMMAND:
                return sg_scsi_ioctl(q, disk, mode, arg);
-- 
2.31.1
