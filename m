Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A87C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AAA061A24
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbhCXSIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:08:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237199AbhCXSIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 14:08:14 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12OI3U7J076527;
        Wed, 24 Mar 2021 14:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yp8ro6AH8l+TW1DAn4/zVKEQERWPYcIFpVc2Y5HyNXI=;
 b=d7ewU9cYBI1TT4PdCJAM+s1lwqjD9TwgNxaQaiUz3+1nh1d/v1dbPtmN35LYFzZQ8g5n
 J/l7cjoXNbThIsuf6WKkp+nlRoy1k+VzvGpIfJ4GwwWp8KnuV4TmQjSyssW/VFDxzwcI
 phEXi1/Xnm8F4BpxXH0oC5xchHxwKYpb2CynvNqBgN5ExvAJmboq4U+RKG3s8KBArqb4
 XstVj2UYwSW7xwOaLcSg+Jep/5SuZPOLSLfRdake5I5bXI1dAC5tbrxof/RmDyoNsNlW
 ze61NSbU+aZaUTwhD6d+0szpwjYXQTl/ckaGe3pDqm2s/j8Ps8YgUDBwbCvmea/FDFKB bg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gaa3g785-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Mar 2021 14:07:45 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12OI3gR2010779;
        Wed, 24 Mar 2021 18:07:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 37d99rckkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Mar 2021 18:07:43 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12OI7fwL26214792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:07:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5BB511C050;
        Wed, 24 Mar 2021 18:07:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D333511C04C;
        Wed, 24 Mar 2021 18:07:40 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.149.73])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 24 Mar 2021 18:07:40 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lP7uu-000DFY-9h; Wed, 24 Mar 2021 19:07:40 +0100
Date:   Wed, 24 Mar 2021 19:07:40 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 7/8] block: refactor the bounce buffering code
Message-ID: <YFt/7BdzecUmdySU@t480-pf1aa2c2.linux.ibm.com>
References: <20210318063923.302738-1-hch@lst.de>
 <20210318063923.302738-8-hch@lst.de>
 <20210318112950.GL3420@casper.infradead.org>
 <20210318125340.GA21262@lst.de>
 <YFt5kPs30x4kPu77@t480-pf1aa2c2.linux.ibm.com>
 <20210324174458.GA13589@lst.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210324174458.GA13589@lst.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_13:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 24, 2021 at 06:44:58PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 24, 2021 at 06:40:32PM +0100, Benjamin Block wrote:
> > Is blk_queue_bounce() called again when mpath submits the request to the
> > lower device? I thought when I looked at this code some time ago
> > bouncing would only be checked the first time a request is created
> > (dm-mpath), and then not again, so when we don't check for whether
> > bouncing is necessary in mpath, we still might screw the LLD - hence why
> > we might inherit this via the limits.
> 
> Every call to blk_mq_submit_bio also calls blk_queue_bounce, 

But map_request() -> multipath_clone_and_map() -> dm_dispatch_clone_request() 
doesn't call blk_mq_submit_bio() for requests that have been queued in a
request based mpath device. The requests gets cloned and then dispatched
on the lower queue. Or am I missing something?

> and
> blk_queue_bounce then checks if it needs to do anything based on the
> bounce limit and max_pfn, and if needed proceeds to check every bvec.
> 
> So for extremely unlikely case thay someone is running multipath over one
> of the few remaining drivers that need block layering bounce buffering
> this inheritance just leads to (harmless) extra work.

Yeah fair enough, I don't know whether anyone would care for those old
drivers; it just crossed my mind.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
