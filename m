Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07265C2BA1A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 17:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D332082F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 17:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgDHRgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 13:36:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728262AbgDHRgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 13:36:12 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038HXugP010174;
        Wed, 8 Apr 2020 13:36:07 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3091yaaarp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Apr 2020 13:36:07 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 038HZbMb032509;
        Wed, 8 Apr 2020 17:36:06 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3091mdxtqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Apr 2020 17:36:06 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 038Ha6IA47186320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 17:36:06 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ADA8B2065;
        Wed,  8 Apr 2020 17:36:06 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E395BB205F;
        Wed,  8 Apr 2020 17:36:04 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.187.1])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 17:36:04 +0000 (GMT)
Message-ID: <1586367363.7606.34.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Rate limit "rejecting I/O" messages
From:   James Bottomley <jejb@linux.ibm.com>
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Wed, 08 Apr 2020 10:36:03 -0700
In-Reply-To: <20200408171012.76890-1-dwagner@suse.de>
References: <20200408171012.76890-1-dwagner@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 clxscore=1011 adultscore=0
 mlxlogscore=869 suspectscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080129
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-04-08 at 19:10 +0200, Daniel Wagner wrote: 
> +#define sdev_printk_ratelimited(l, sdev, fmt, a...)			
> \
> +({									
> \
> +	static DEFINE_RATELIMIT_STATE(_rs,				
> \
> +				      DEFAULT_RATELIMIT_INTERVAL,	
> \
> +				      DEFAULT_RATELIMIT_BURST);	
> 	\
> +									
> \
> +	if (__ratelimit(&_rs))					
> 	\
> +		sdev_prefix_printk(l, sdev, NULL, fmt, ##a);	

If we do go with a ratelimit architecture for sdev_printk, I would
think the limit has to be per sdev, because we wouldn't want a burst of
messages on one sdev to suppress messages on another.

For this particular issue, I suppose one target can have many sdevs, so
you'd prefer to rate limit by target?

James

