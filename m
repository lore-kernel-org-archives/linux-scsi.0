Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A760FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 06:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B63622CA2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 06:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbhALGhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 01:37:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729223AbhALGhF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 01:37:05 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10C6XpON107042;
        Tue, 12 Jan 2021 01:35:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=7ICjcjyZoP36IcIqAtmsWOjw8Be2kuyorFnzhFljoHU=;
 b=TxDSP2nKH9h/7nEwIsELkW4NCaoGs4Qxlas2oN2Iz5FIHX3yCaCx+aflGqSWfqL/Aidc
 T9C1rBMu13/3PAzO2wtI8iknErkZkLccrwR2IgRK7Mj+4ML3UMQ6HNCUAz5A6GhZkVnm
 nvTqpZbKA+a/j8DsQP0USKLncnvEfYaEe+AoDqqQOMLoN1CSpjqVokvpVL8CNjjnZsq0
 muLP8pdbpM447NpHaaYets/bqGIG1Y6jEWkqE2lQhmXkii98ryNoBKXhytu0t9/+oHPa
 EEgv+dnILB6bNW14nvazcYGiFdpb5rDJaHG14Wq+Xls+UFP2EGG8nXsVB+C6Cf3w/VUj xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3616c58af9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 01:35:47 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10C6YBgW108844;
        Tue, 12 Jan 2021 01:35:47 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3616c58af2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 01:35:46 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10C6WAR0026671;
        Tue, 12 Jan 2021 06:35:45 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 35y44914gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 06:35:45 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10C6Zic18323786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 06:35:44 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 120F678060;
        Tue, 12 Jan 2021 06:35:44 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4BBE7805C;
        Tue, 12 Jan 2021 06:35:41 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.180.222])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 06:35:41 +0000 (GMT)
Message-ID: <62b562eae9830830d87ea9f92dcc0018a1935583.camel@linux.ibm.com>
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
Date:   Mon, 11 Jan 2021 22:35:40 -0800
In-Reply-To: <b51fc658-b28a-d627-a2a3-b2835132ab13@huawei.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
         <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
         <b51fc658-b28a-d627-a2a3-b2835132ab13@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1031
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-01-11 at 17:11 +0000, John Garry wrote:
> On 11/01/2021 16:40, James Bottomley wrote:
> > > So initial sdev queue depth comes from cmd_per_lun by default or
> > > manually setting in the driver via scsi_change_queue_depth(). It
> > > seems to me that some drivers are not setting this optimally, as
> > > above.
> > > 
> > > Thoughts on guidance for setting sdev queue depth? Could blk-mq
> > > changed this behavior?
> 
> Hi James,
> 
> > In general, for spinning rust, you want the minimum queue depth
> > possible for keeping the device active because merging is a very
> > important performance enhancement and once the drive is fully
> > occupied simply sending more tags won't improve latency.  We used
> > to recommend a depth of about 4 for this reason.  A co-operative
> > device can help you find the optimal by returning QUEUE_FULL when
> > it's fully occupied so we have a mechanism to track the queue full
> > returns and change the depth interactively.
> > 
> > For high iops devices, these considerations went out of the window
> > and it's generally assumed (without varying evidence) the more tags
> > the better. 
> 
> For this case, it seems the opposite - less is more. And I seem to
> be hitting closer to the sweet spot there, with more merges.

I think cheaper SSDs have a write latency problem due to erase block
issues.  I suspect all SSDs have a channel problem in that there's a
certain number of parallel channels and once you go over that number
they can't actually work on any more operations even if they can queue
them.  For cheaper (as in fewer channels, and less spare erased block
capacity) SSDs there will be a benefit to reducing the depth to some
multiplier of the channels (I'd guess 2-4 as the multiplier).  When
SSDs become write throttled, there may be less benefit to us queueing
in the block layer (merging produces bigger packets with lower
overhead, but the erase block consumption will remain the same).

For the record, the internet thinks that cheap SSDs have 2-4 channels,
so that would argue a tag depth somewhere from 4-16

> > SSDs have a peculiar lifetime problem in that when they get
> > erase block starved they start behaving more like spinning rust in
> > that they reach a processing limit but only for writes, so lowering
> > the write queue depth (which we don't even have a knob for) might
> > be a good solution.  Trying to track the erase block problem has
> > been a constant bugbear.
> 
> I am only doing read performance test here, and the disks are SAS3.0 
> SSDs HUSMM1640ASS204, so not exactly slow.

Possibly ... the stats on most manufacturer SSDs don't give you
information about the channels or spare erase blocks.

> > I'm assuming you're using spinning rust in the above, so it sounds
> > like the firmware in the card might be eating the queue full
> > returns.  Icould see this happening in RAID mode, but it shouldn't
> > happen in jbod mode.
> 
> Not sure on that, but I didn't check too much. I did try to increase
> fio queue depth and sdev queue depth to be very large to clobber the
> disks, but still nothing.

If it's an SSD it's likely not giving the queue full you'd need to get
the mid-layer to throttle automatically.

James


