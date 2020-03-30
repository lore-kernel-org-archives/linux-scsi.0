Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654ABC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 03:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E7782078B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 03:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgC3DGj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Mar 2020 23:06:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728202AbgC3DGj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Mar 2020 23:06:39 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U340dP112506;
        Sun, 29 Mar 2020 23:06:32 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30227um7gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:06:31 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02U34qXb032530;
        Mon, 30 Mar 2020 03:06:30 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 301x765ndk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 03:06:30 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02U36TuK45154620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 03:06:29 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEA6CC6061;
        Mon, 30 Mar 2020 03:06:29 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C58C605B;
        Mon, 30 Mar 2020 03:06:28 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.166.38])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 03:06:28 +0000 (GMT)
Message-ID: <1585537587.4510.6.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH] sr: Fix a recently introduced W=1 compiler warning
From:   James Bottomley <jejb@linux.vnet.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 29 Mar 2020 20:06:27 -0700
In-Reply-To: <20200330025304.10743-1-bvanassche@acm.org>
References: <20200330025304.10743-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_10:2020-03-27,2020-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003300027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-03-29 at 19:53 -0700, Bart Van Assche wrote: 
>  static unsigned int sr_block_check_events(struct gendisk *disk,
>  					  unsigned int clearing)
> @@ -685,8 +685,9 @@ static const struct block_device_operations
> sr_bdops =
>  	.owner		= THIS_MODULE,
>  	.open		= sr_block_open,
>  	.release	= sr_block_release,
> +#ifndef CONFIG_COMPAT
>  	.ioctl		= sr_block_ioctl,
> -#ifdef CONFIG_COMPAT
> +#else
>  	.ioctl		= sr_block_compat_ioctl,

Well, this is obviously incorrect: we need the compat ioctl for 32 on
64 bit and the real for native 64 bit, so both have to be defined. 
What you propose would work if we were only ever 32 on 64.  I think
what you want to do is change the second .ioctl to .compat_ioctl.

James

