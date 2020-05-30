Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9510C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 16:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86BF12077D
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 16:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgE3Qlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 12:41:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728927AbgE3Qlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 May 2020 12:41:39 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04UGWeVn136775;
        Sat, 30 May 2020 12:41:16 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31bkc0rfew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 May 2020 12:41:16 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04UGep2i029839;
        Sat, 30 May 2020 16:41:15 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 31bf48atuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 May 2020 16:41:15 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04UGfEwU52363664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 May 2020 16:41:14 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B5327805C;
        Sat, 30 May 2020 16:41:14 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE8A17805E;
        Sat, 30 May 2020 16:41:12 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.147.245])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 30 May 2020 16:41:12 +0000 (GMT)
Message-ID: <1590856871.8207.6.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2] scsi: sr: Fix sr_probe() missing mutex_destroy
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        Simon Arlott <simon@octiron.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Sat, 30 May 2020 09:41:11 -0700
In-Reply-To: <48ed3e8c-6aed-c7bc-6330-18f2f64f8803@acm.org>
References: <0cb16d6f-098a-a8c3-09c3-273d02067ada@0882a8b5-c6c3-11e9-b005-00805fc181fe>
         <48ed3e8c-6aed-c7bc-6330-18f2f64f8803@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-30_10:2020-05-28,2020-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 cotscore=-2147483648 suspectscore=2 spamscore=0 bulkscore=0 phishscore=0
 clxscore=1011 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005300127
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-05-30 at 09:24 -0700, Bart Van Assche wrote:
> On 2020-05-30 02:32, Simon Arlott wrote:
> > If the device minor cannot be allocated or the cdrom fails to be
> > registered then the mutex should be destroyed.
> 
> Please add Fixes: and Cc: stable tags.

This isn't really a bug, is it?  mutex_destroy is a nop unless lock
debugging is enabled in which case it checks the lock is unlocked and
marks it as unusable to detect a use after destroy.  Since the
structure containing the mutex is kfree'd in the next statement, kasan
would also detect any use after free.  That's not to say we shouldn't
do this to be fully correct ... just that it has no potential ever to
have user visible impact so there doesn't seem to be much point
cluttering up the stable process with it.

James



