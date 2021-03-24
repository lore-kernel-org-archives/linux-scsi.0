Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0428AC433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA2C561A20
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbhCXRlf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:41:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237166AbhCXRlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 13:41:04 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12OHWX73036488;
        Wed, 24 Mar 2021 13:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=sM2Zpv+QbiAr2QX5diIifb9tShx8b9JrKzHNWZQvc10=;
 b=amRu3HtDtJ21978sB2g8ruYDc5i+gpF5P/8ASUX5iXTz+Iw0oJ4pq0hQIX3H3/GWfppj
 uECSoNrpSbTJ2h1t6Rq6ceuT4iSARRyRveqOPpisx6bGL5pR6PeEWaYOvqkhu/JkyG4P
 VBZSTHz1JLC0+EX8RSLwG/evUPI8yo3Z82EJrF/FRHQ3tEB9cE6gss/bmnA/lMVDws9C
 8n5Lu07JMkAgpMqsPqmzKRYq4qtdmXZ5fAKgHejn/7WHkkI8ocCXLWV8ENnrBS0+EESj
 KX665h2rDt5PiC2eXtOwayGwzrHXVeB/4LVv6/78nvJd84kTNSiB6Lnq1jWDo/RsKiSE JQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37g8t0j7dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Mar 2021 13:40:36 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12OHRXL6022442;
        Wed, 24 Mar 2021 17:40:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 37d99xjdhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Mar 2021 17:40:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12OHeWll30802416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 17:40:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B810452054;
        Wed, 24 Mar 2021 17:40:32 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.149.73])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id A4A2052052;
        Wed, 24 Mar 2021 17:40:32 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lP7Ue-000CZr-4J; Wed, 24 Mar 2021 18:40:32 +0100
Date:   Wed, 24 Mar 2021 18:40:32 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 7/8] block: refactor the bounce buffering code
Message-ID: <YFt5kPs30x4kPu77@t480-pf1aa2c2.linux.ibm.com>
References: <20210318063923.302738-1-hch@lst.de>
 <20210318063923.302738-8-hch@lst.de>
 <20210318112950.GL3420@casper.infradead.org>
 <20210318125340.GA21262@lst.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210318125340.GA21262@lst.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_13:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 impostorscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=972 adultscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103240127
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 18, 2021 at 01:53:40PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 18, 2021 at 11:29:50AM +0000, Matthew Wilcox wrote:
> > On Thu, Mar 18, 2021 at 07:39:22AM +0100, Christoph Hellwig wrote:
> > > @@ -536,7 +518,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
> > >  					b->max_write_zeroes_sectors);
> > >  	t->max_zone_append_sectors = min(t->max_zone_append_sectors,
> > >  					b->max_zone_append_sectors);
> > > -	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
> > > +	t->bounce = min_not_zero(t->bounce, b->bounce);
> > 
> > I see how min_not_zero() made sense when it was a pfn.  Does it still
> > make sense now it's an enum?  I would have thought it'd now be 'max()',
> > given the definitions later on.
> 
> Actually, blk_stack_limits should not look at ->bounce_pfn / ->bounce
> at all.  blk_queue_bounce is only called my blk_mq_submit_bio, and
> the only stacked blk-mq driver (dm-mpath) does not need bouncing.
> 
> I'll add a patch to fix this up to the front of the series.

Is blk_queue_bounce() called again when mpath submits the request to the
lower device? I thought when I looked at this code some time ago
bouncing would only be checked the first time a request is created
(dm-mpath), and then not again, so when we don't check for whether
bouncing is necessary in mpath, we still might screw the LLD - hence why
we might inherit this via the limits.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
