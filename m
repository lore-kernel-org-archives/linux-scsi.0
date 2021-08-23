Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52E9C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 10:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C88161373
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 10:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhHWKU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 06:20:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5856 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233399AbhHWKU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 06:20:57 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17NA7LdV139198;
        Mon, 23 Aug 2021 06:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=2khlmwC0UBtryORxTWNt2Lfr5mMjyh5JncOw9A+tlOk=;
 b=Wb32jTSi+CZdSo/nge+nNIT04yvYiDEIJugCOsMt0m/UkaHdZ26erxCmTOhOQ5azcWkw
 T8RE0xQlbf0UannvC/JwHbL88mJrcEJ7TZuSC8/evbYOutGhGYCPHamGH9Lsu3IwGtaK
 +j8MLb/8O5VscRFiT9TEcjPH3DhEk+dBZFboSS/qeWYWCyYRkLL9rHl20AMd1HT6/Y6K
 Z5rtIvVT15oN61wnPfcXMz5OmVFPIek9cIh64KF8NnUhO/EWyIdPdHScN9lfr5WBya/q
 wv023Qd8qdSy+J4/BAu3kts+fXQUZsG1eVf0Jgn5X+9oRk6yzSX6QqZTxWEDG39J1Dzl zw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3akf28k374-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 06:19:56 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17NAHJMO032476;
        Mon, 23 Aug 2021 10:19:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3ajs48jnm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 10:19:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17NAJoh228180910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 10:19:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 676C2AE058;
        Mon, 23 Aug 2021 10:19:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3804AE055;
        Mon, 23 Aug 2021 10:19:47 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.34.43])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 23 Aug 2021 10:19:47 +0000 (GMT)
Date:   Mon, 23 Aug 2021 12:19:44 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?UTF-8?B?TcOka2lzYXJh?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        oliver.sang@intel.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 18/24] scsi_ioctl: move the "block layer" SCSI ioctl
 handling to drivers/scsi
Message-ID: <20210823121944.3403c096.pasic@linux.ibm.com>
In-Reply-To: <20210823064936.GA21806@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
        <20210724072033.1284840-19-hch@lst.de>
        <20210823084316.4bb224e0.pasic@linux.ibm.com>
        <20210823064936.GA21806@lst.de>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W8qgIN0cXdXYRHpTyPcVxS0BChwUL6au
X-Proofpoint-ORIG-GUID: W8qgIN0cXdXYRHpTyPcVxS0BChwUL6au
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_02:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230067
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 Aug 2021 08:49:36 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Aug 23, 2021 at 08:43:16AM +0200, Halil Pasic wrote:
> > I believe there is a small problem with this patch. I think it is
> > easiest to explain with the diff that fixes it. Please see the patch
> > at the end of this email.
> > 
> > Otherwise your patch looks great!
> > 
> > This may or may not be related to the problem reported here:
> > https://lkml.org/lkml/2021/7/29/157
> > Adding Oliver, maybe he can test if this fixes his testcases as well.
> > (It did fix ours.:)
> > 
> > If you like I can respin my fix with an extended patch description.  
> 
> No this looks good, but to make sure Martin picks it up please send it
> as a separate thread.  It would be great it this fixes Olives issue,
> but at least on my Debian systems blkid don't even call into SG_IO.
> But maybe he has a different one or it is a cascading effect on that
> particular setup.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

This patch is directly based on f2542a3be327 ("scsi: scsi_ioctl: Move
the "block layer" SCSI ioctl handling to drivers/scsi") from linux-next, 
and a simple rebase onto the tip of linux-next does not work because the
block of code I'm about to modify got factored out into a function
called scsi_ioctl_sg_io().

I'm not sure about the process of fixes in linux-next, so can please
somebody (Christoph, Martin) tell me against what base should I post the
respin (in a separate thread)?

Thanks in advance!

Halil
