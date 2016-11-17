From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/14] cxlflash: Set sg_tablesize to 1 instead of SG_NONE
Date: Thu, 17 Nov 2016 13:20:13 -0600
Message-ID: <E29324C2-3F4A-4046-86E8-F30EA11F3112@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1479251617-22707-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752272AbcKQTUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 14:20:20 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAHJIxH3040809
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 14:20:20 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26sfvpgkb5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 14:20:20 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 17 Nov 2016 12:20:19 -0700
In-Reply-To: <1479251617-22707-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Nov 15, 2016, at 5:13 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> The following Oops is encountered when blk_mq is enabled with the
> cxlflash driver:
> 
> [ 2960.817172] Oops: Kernel access of bad area, sig: 11 [#5]
> [ 2960.817309] NIP  __blk_mq_run_hw_queue+0x278/0x4c0
> [ 2960.817313] LR __blk_mq_run_hw_queue+0x2bc/0x4c0
> [ 2960.817314] Call Trace:
> [ 2960.817320] __blk_mq_run_hw_queue+0x2bc/0x4c0 (unreliable)
> [ 2960.817324] blk_mq_run_hw_queue+0xd8/0x100
> [ 2960.817329] blk_mq_insert_requests+0x14c/0x1f0
> [ 2960.817333] blk_mq_flush_plug_list+0x150/0x190
> [ 2960.817338] blk_flush_plug_list+0x11c/0x2b0
> [ 2960.817344] blk_finish_plug+0x58/0x80
> [ 2960.817348] __do_page_cache_readahead+0x1c0/0x2e0
> [ 2960.817352] force_page_cache_readahead+0x68/0xd0
> [ 2960.817356] generic_file_read_iter+0x43c/0x6a0
> [ 2960.817359] blkdev_read_iter+0x68/0xa0
> [ 2960.817361] __vfs_read+0x11c/0x180
> [ 2960.817364] vfs_read+0xa4/0x1c0
> [ 2960.817366] SyS_read+0x6c/0x110
> [ 2960.817369] system_call+0x38/0xb4
> 
> The SCSI blk_mq stack assumes that sg_tablesize is always a non-zero
> value with scsi_mq_setup_tags() allocating tags using sg_tablesize.
> The cxlflash driver currently uses SG_NONE (0) for the sg_tablesize
> as the devices it supports are not capable of scatter gather. This
> mismatch of values results in the Oops above.
> 
> To resolve this issue, sg_tablesize for cxlflash can simply be set
> to 1, a value which satisfies the constraints in cxlflash and the
> lack of support of SG_NONE in SCSI blk_mq.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

