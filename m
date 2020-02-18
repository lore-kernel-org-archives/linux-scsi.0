Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8852FC34049
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A23B24656
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgBRR2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 12:28:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726411AbgBRR2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Feb 2020 12:28:47 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IHRWQu123691;
        Tue, 18 Feb 2020 12:28:40 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6bunre2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:28:39 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01IHSCR2021160;
        Tue, 18 Feb 2020 17:28:38 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 2y6896twjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 17:28:38 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01IHSbYs53018988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 17:28:37 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1F1878063;
        Tue, 18 Feb 2020 17:28:37 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78BCA7805C;
        Tue, 18 Feb 2020 17:28:35 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.80.237.10])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Feb 2020 17:28:35 +0000 (GMT)
Message-ID: <1582046914.16681.11.camel@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: sr: get rid of sr global mutex
From:   James Bottomley <jejb@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Merlijn Wajer <merlijn@archive.org>, merlijn@wizzup.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Date:   Tue, 18 Feb 2020 09:28:34 -0800
In-Reply-To: <20200218172347.GA3020@infradead.org>
References: <20200218143918.30267-1-merlijn@archive.org>
         <20200218171259.GA6724@infradead.org>
         <1582046428.16681.7.camel@linux.ibm.com>
         <20200218172347.GA3020@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_05:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxlogscore=718 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-02-18 at 09:23 -0800, Christoph Hellwig wrote:
> On Tue, Feb 18, 2020 at 09:20:28AM -0800, James Bottomley wrote:
> > > > Replace the global mutex with per-sr-device mutex.
> > > 
> > > Do we actually need the lock at all?  What is protected by it?
> > 
> > We do at least for cdrom_open.  It modifies the cdi structure with
> > no other protection and concurrent modification would at least
> > screw up the use counter which is not atomic.  Same reasoning for
> > cdrom_release.
> 
> Wouldn't the right fix to add locking to cdrom_open/release instead
> of having an undocumented requirement for the callers?

Yes ... but that's somewhat of a bigger patch because you now have to
reason about the callbacks within cdrom.  There's also the question of
whether you can assume ops->generic_packet() has its own concurrency
protections ... it's certainly true for SCSI, but is it for anything
else?  Although I suppose you can just not care and run the internal
lock over it anyway.

James

