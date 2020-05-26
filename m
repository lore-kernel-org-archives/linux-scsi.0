Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0ADC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 19:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C429720776
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 19:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391419AbgEZT3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 15:29:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390433AbgEZT3C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 15:29:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QJ1nCm162716;
        Tue, 26 May 2020 15:28:24 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 316vrvuexj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 15:28:23 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QJOoW8014583;
        Tue, 26 May 2020 19:28:23 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 316ufa8vvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 19:28:23 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QJSMQI60621108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 19:28:22 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2327F7805F;
        Tue, 26 May 2020 19:28:22 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E62F57805C;
        Tue, 26 May 2020 19:28:20 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.161.209])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 19:28:20 +0000 (GMT)
Message-ID: <1590521299.11810.45.camel@linux.vnet.ibm.com>
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
From:   James Bottomley <jejb@linux.vnet.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.de>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Date:   Tue, 26 May 2020 12:28:19 -0700
In-Reply-To: <20200526183920.GI17206@bombadil.infradead.org>
References: <20200524155814.5895-1-dgilbert@interlog.com>
         <20200524155814.5895-2-dgilbert@interlog.com>
         <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
         <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
         <20200525174052.GD17206@bombadil.infradead.org>
         <825bece5-e209-a4da-ddb1-809c48e4e9b3@suse.de>
         <20200526142727.GH17206@bombadil.infradead.org>
         <b14bdfa1-1cb9-6e3f-c025-fccdfa034024@suse.de>
         <20200526183920.GI17206@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_02:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 cotscore=-2147483648 spamscore=0 malwarescore=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=416 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260143
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-05-26 at 11:39 -0700, Matthew Wilcox wrote:
> On Tue, May 26, 2020 at 07:53:35PM +0200, Hannes Reinecke wrote:
> > On 5/26/20 4:27 PM, Matthew Wilcox wrote:
> > > Ah, OK.  I think for these arrays you'd be better off accepting
> > > the cost of an extra 4 bytes in the struct scsi_device rather
> > > than the cost of storing the scsi_device at the LUN.
> > > 
> > > Let's just work an example where you have a 64-bit LUN with 4
> > > ranges, each of 64 entries (this is almost a best-case scenario
> > > for the XArray). [0,63], 2^62+[0,63], 2^63+[0,63],
> > > 2^63+2^62+[0,63].
> > > 
> > > If we store them sequentially in an allocating XArray, we take up
> > > 256 * 4 bytes = 1kB extra space in the scsi_device.  The XArray
> > > will allocate four nodes plus one node to hold the four nodes,
> > > which is 5 * 576 bytes (2780 bytes) for a total of 3804 bytes.
> > > 
> > > Storing them in at their LUN will allocate a top level node which
> > > covers bits 60-66, then four nodes, each covering bits of 54-59,
> > > another four nodes covering bits 48-53, four nodes for 42-47,
> > > ...  I make it 41 nodes, coming to 23616 bytes.  And the pointer
> > > chase to get to each LUN is ten deep.  It'll mostly be cached,
> > > but still ...
> > > 
> > 
> > Which is my worry, too.
> > In the end we're having a massively large array space (128bit if we
> > take the numbers as they stand today), of which only a _tiny_
> > fraction is actually allocated.
> 
> In your scheme, yes.  Do you ever need to look up scsi_device from
> a scsi_host with only the C:T:L as a key (and it's a situation where
> speed matters)?  Everything I've seen so far is about iterating every
> sdev in an shost, but maybe this is a "when you have a hammer"
> situation.

I don't believe we ever do.  We've arranged pretty much everything so
the SCSI device is immediately obtainable from the enclosing structure
(sysfs, rw, ioctl, interrupt from device etc).  The only time we do a
direct lookup by H:C:T:L is the very old scsi proc API, which we're
trying to deprecate.

James
