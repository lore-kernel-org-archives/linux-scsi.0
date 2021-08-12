Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C99FC4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 14:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AA8C610A4
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 14:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbhHLOSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:18:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231547AbhHLOSf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Aug 2021 10:18:35 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CEGJnZ045815;
        Thu, 12 Aug 2021 10:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WpwNez1EYtY4fiOuV32GJxS7fXSgheIsQzSCXrQEqoA=;
 b=gByg492G4cjxRynUgjE/HbzZ5PXKx628QWaZlMLLg1yXgIupxseMHa5kz7WazJez5QIz
 9ffii0AhFC7/QI+L8/tnDvMM26SRti4inglvsB5x12GYUb+m7ZXJoNvW07Gdo0A0TL8Q
 sODoNbWIDFGsS0J/Q/CBCXI6PaYOtsFyZ5vKNtLdBzI+3+ZAUfecMGiFu74XjUrWhdAT
 ADk6r7q18mWlJBElhNIw+dMb5xTp/JmTuubvabtVRQkeUFZf7ZakW5KwUbLuESGCHGRW
 Qc35/r4xE+yND+0KZL0eT+Q34X7XrYoVtiPwNm9CJJsIIWHm8Evu0VGCfuymJsuM67nk jA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ad4hxhh0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 10:17:40 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17CE8PlT014290;
        Thu, 12 Aug 2021 14:17:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3abs263uv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 14:17:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17CEHab755247180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 14:17:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11CF652080;
        Thu, 12 Aug 2021 14:17:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.92.71])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A05C15207F;
        Thu, 12 Aug 2021 14:17:35 +0000 (GMT)
Subject: Re: [PATCH 6/8] block: remove the minors argument to
 __alloc_disk_node
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210812074642.18592-1-hch@lst.de>
 <20210812074642.18592-7-hch@lst.de>
From:   Stefan Haberland <sth@linux.ibm.com>
Message-ID: <c0fd949f-45be-679d-6909-3d7df8a29748@linux.ibm.com>
Date:   Thu, 12 Aug 2021 16:17:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812074642.18592-7-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XRkQKgieg7AXfxt8m4MZFVqyfgInQ54G
X-Proofpoint-GUID: XRkQKgieg7AXfxt8m4MZFVqyfgInQ54G
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_05:2021-08-12,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 12.08.21 um 09:46 schrieb Christoph Hellwig:
> This was a leftover from the legacy alloc_disk interface.  Switch
> the scsi ULPs and dasd to set ->minors directly like all other
> drivers and remove the argument.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c                  | 2 +-
>  block/genhd.c                   | 6 ++----
>  drivers/s390/block/dasd_genhd.c | 4 ++--

for the DASD part:

Looks good.

Reviewed-by: Stefan Haberland <sth@linux.ibm.com>

