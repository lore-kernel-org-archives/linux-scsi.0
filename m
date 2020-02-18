Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18EDC34048
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D422620801
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgBRRWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 12:22:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726411AbgBRRWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Feb 2020 12:22:23 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IHJHDR141152;
        Tue, 18 Feb 2020 12:20:34 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6e1hvtp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:20:34 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01IHCKgV002392;
        Tue, 18 Feb 2020 17:20:33 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 2y6896ju1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 17:20:33 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01IHKW0W58917332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 17:20:32 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1547513605D;
        Tue, 18 Feb 2020 17:20:32 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04AD313604F;
        Tue, 18 Feb 2020 17:20:29 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.80.237.10])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Feb 2020 17:20:29 +0000 (GMT)
Message-ID: <1582046428.16681.7.camel@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: sr: get rid of sr global mutex
From:   James Bottomley <jejb@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Merlijn Wajer <merlijn@archive.org>
Cc:     merlijn@wizzup.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Date:   Tue, 18 Feb 2020 09:20:28 -0800
In-Reply-To: <20200218171259.GA6724@infradead.org>
References: <20200218143918.30267-1-merlijn@archive.org>
         <20200218171259.GA6724@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_04:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=818
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-02-18 at 09:12 -0800, Christoph Hellwig wrote:
> On Tue, Feb 18, 2020 at 03:39:17PM +0100, Merlijn Wajer wrote:
> > When replacing the Big Kernel Lock in commit
> > 2a48fc0ab24241755dc93bfd4f01d68efab47f5a ("block: autoconvert
> > trivial BKL users to private mutex"), the lock was replaced with a
> > sr-wide lock.
> > 
> > This causes very poor performance when using multiple sr devices,
> > as the sr driver was not able to execute more than one command to
> > one drive at any given time, even when there were many CD drives
> > available.
> > 
> > Replace the global mutex with per-sr-device mutex.
> 
> Do we actually need the lock at all?  What is protected by it?

We do at least for cdrom_open.  It modifies the cdi structure with no
other protection and concurrent modification would at least screw up
the use counter which is not atomic.  Same reasoning for cdrom_release.

I think the ioctls don't need the mutex (not looked deeply enough) and
certainly the probe only requires it for the idr allocation which has
its own lock, so I don't believe the mutex additions are needed there.

James

