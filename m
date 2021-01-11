Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FC5C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 16:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35BE022AAD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 16:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbhAKQlu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:41:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64670 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732054AbhAKQlu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 11:41:50 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BGXmF3093436;
        Mon, 11 Jan 2021 11:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=1LfRN6ZxXY4AyQUSIbgNrfbiQiArDTe/kJuIKwpPIio=;
 b=kDyORZs78pN7b4TilO+qb7gjRLLAqXdyDReAFiVZi+U1D7880RLbQqgBuDXNm56evbPM
 /4OLewg2p7Ek/LkE1QFr2D5IL1jxw3hSAZoqlcM24hLY8d4ijN6E8X4oZ7SwJfm1M8T5
 GXcoqrLItuLVnD+585cUfQG7C252pBTw2i7aQfPpX+QEBb0qr//iZDzdN5df2Mk7uDVJ
 b003PrK3YnanlrNJ+h79cb8yl29V4AOz/03WsyeQAHSTmGP7fmLGNbtMG+SakppcunfU
 ZO5LhJXqMF0/PLpzc+NF3eCjHxVeUZq++pW3ssB7OAwrf3s+WtI4ezGrz6Ct4cmv5lJJ cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360s3xtxfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 11:40:39 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10BGdZJN120225;
        Mon, 11 Jan 2021 11:40:39 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360s3xtxev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 11:40:39 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BGcRQ6030767;
        Mon, 11 Jan 2021 16:40:38 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 35y448qwt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 16:40:38 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BGeahK26476992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 16:40:36 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D2A47805E;
        Mon, 11 Jan 2021 16:40:36 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 264737805C;
        Mon, 11 Jan 2021 16:40:33 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.180.222])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 16:40:32 +0000 (GMT)
Message-ID: <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
Subject: Re: About scsi device queue depth
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Cc:     chenxiang <chenxiang66@hisilicon.com>
Date:   Mon, 11 Jan 2021 08:40:31 -0800
In-Reply-To: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 clxscore=1031 impostorscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-01-11 at 16:21 +0000, John Garry wrote:
> Hi,
> 
> I was looking at some IOMMU issue on a LSI RAID 3008 card, and
> noticed that performance there is not what I get on other SAS HBAs -
> it's lower.
> 
> After some debugging and fiddling with sdev queue depth in mpt3sas 
> driver, I am finding that performance changes appreciably with sdev 
> queue depth:
> 
> sdev qdepth	fio number jobs* 	1	10	20
> 16					1590	1654	1660
> 32					1545	1646	1654
> 64					1436	1085	1070
> 254 (default)				1436	1070	1050
> 
> fio queue depth is 40, and I'm using 12x SAS SSDs.
> 
> I got comparable disparity in results for fio queue depth = 128 and
> num jobs = 1:
> 
> sdev qdepth	fio number jobs* 	1	
> 16					1640
> 32					1618	
> 64					1577	
> 254 (default)				1437	
> 
> IO sched = none.
> 
> That driver also sets queue depth tracking = 1, but never seems to
> kick in.
> 
> So it seems to me that the block layer is merging more bios per
> request, as averge sg count per request goes up from 1 - > upto 6 or
> more. As I see, when queue depth lowers the only thing that is really
> changing is that we fail more often in getting the budget in 
> scsi_mq_get_budget()->scsi_dev_queue_ready().
> 
> So initial sdev queue depth comes from cmd_per_lun by default or 
> manually setting in the driver via scsi_change_queue_depth(). It
> seems to me that some drivers are not setting this optimally, as
> above.
> 
> Thoughts on guidance for setting sdev queue depth? Could blk-mq
> changed this behavior?

In general, for spinning rust, you want the minimum queue depth
possible for keeping the device active because merging is a very
important performance enhancement and once the drive is fully occupied
simply sending more tags won't improve latency.  We used to recommend a
depth of about 4 for this reason.  A co-operative device can help you
find the optimal by returning QUEUE_FULL when it's fully occupied so we
have a mechanism to track the queue full returns and change the depth
interactively.

For high iops devices, these considerations went out of the window and
it's generally assumed (without varying evidence) the more tags the
better.  SSDs have a peculiar lifetime problem in that when they get
erase block starved they start behaving more like spinning rust in that
they reach a processing limit but only for writes, so lowering the
write queue depth (which we don't even have a knob for) might be a good
solution.  Trying to track the erase block problem has been a constant
bugbear.

I'm assuming you're using spinning rust in the above, so it sounds like
the firmware in the card might be eating the queue full returns.  I
could see this happening in RAID mode, but it shouldn't happen in jbod
mode.

James


