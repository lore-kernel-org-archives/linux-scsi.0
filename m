Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CF0C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 03:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EE04206C2
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 03:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AKxnj44k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKVDAR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 22:00:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKVDAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 22:00:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM2x0oB177011;
        Fri, 22 Nov 2019 03:00:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=eG2j5S+DBx6HL1zztLwv8V+KrPOcofjy7WnRUP8OGeY=;
 b=AKxnj44kwNcxMv32Xw/RDBejQhk5Z6OXWuN+EoBQqzCdPu5VnkMD8lOObo37cGg3xLcG
 i2nd7Lxx2Ia5WUGT/tH/PK5hid+K6rm5lO8f+gp0iT5hNb5pKP7MGPn2GHvygKuK8xZc
 y0egD3gI1AGp5o1W+tIxPmOPmo+/NC/FGQpYsBVZECWpEY3hl5RCxZFaHvDKD68x531P
 7tHrWDYv0zZ9w5VPX8rs1YCDuF8bXIbIfO1KjeF1TxUIBVHEpHSoy4j0GFg1vGbhmRMB
 IUQmrIVvLIqNWrVil/Tc/aQiEkt0rN6d0vZDko8cv/jn8epOva87yFzLJJaO1wii0gjZ cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8hu82j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 03:00:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM2wPbG020369;
        Fri, 22 Nov 2019 03:00:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wd47y2tx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 03:00:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAM2xvXw004602;
        Fri, 22 Nov 2019 02:59:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 18:59:57 -0800
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191118103117.978-1-ming.lei@redhat.com>
        <20191118103117.978-5-ming.lei@redhat.com>
        <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
        <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
        <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
        <20191121010730.GD24548@ming.t460p>
Date:   Thu, 21 Nov 2019 21:59:53 -0500
In-Reply-To: <20191121010730.GD24548@ming.t460p> (Ming Lei's message of "Thu,
        21 Nov 2019 09:07:30 +0800")
Message-ID: <yq1pnhkbopi.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=840
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=910 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> I don't understand the motivation of ramp-up/ramp-down, maybe it is just
> for fairness among LUNs.

Congestion control. Devices have actual, physical limitations that are
different from the tag context limitations on the HBA. You don't have
that problem on NVMe because (at least for PCIe) the storage device and
the controller are one and the same.

If you submit 100000 concurrent requests to a SCSI drive that does 100
IOPS, some requests will time out before they get serviced.
Consequently we have the ability to raise and lower the queue depth to
constrain the amount of requests in flight to a given device at any
point in time.

Also, devices use BUSY/QUEUE_FULL/TASK_SET_FULL to cause the OS to back
off. We frequently see issues where the host can submit burst I/O much
faster than the device can de-stage from cache. In that scenario the
device reports BUSY/QF/TSF and we will back off so the device gets a
chance to recover. If we just let the application submit new I/O without
bounds, the system would never actually recover.

Note that the actual, physical limitations for how many commands a
target can handle are typically much, much lower than the number of tags
the HBA can manage. SATA devices can only express 32 concurrent
commands. SAS devices typically 128 concurrent commands per
port. Arrays differ.

If we ignore the RAID controller use case where the controller
internally queues and arbitrates commands between many devices, how is
submitting 1000 concurrent requests to a device which only has 128
command slots going to work?

Some HBAs have special sauce to manage BUSY/QF/TSF, some don't. If we
blindly stop restricting the number of I/Os in flight in the ML, we may
exceed either the capabilities of what the transport protocol can
express or internal device resources.

-- 
Martin K. Petersen	Oracle Linux Engineering
