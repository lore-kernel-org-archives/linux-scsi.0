From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/3] Call scsi_initialize_rq() also for filesystem
 requests
Date: Wed, 30 Aug 2017 17:14:53 -0500
Message-ID: <0df3b3b3-94f7-22bf-deb1-9c8b53d65ec5@linux.vnet.ibm.com>
References: <20170830000742.29653-1-bart.vanassche@wdc.com>
 <20170830000742.29653-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50481 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750980AbdH3WO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 18:14:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7UMETrl135499
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2017 18:14:57 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cp5y8g2nq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2017 18:14:57 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 30 Aug 2017 16:14:56 -0600
In-Reply-To: <20170830000742.29653-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/29/2017 07:07 PM, Bart Van Assche wrote:
> If a pass-through request is submitted then blk_get_request()
> initializes that request by calling scsi_initialize_rq(). Also
> call this function for filesystem requests. Introduce
> CMD_INITIALIZED to keep track of whether or not a request has
> already been initialized.

Bart,

I applied these patches and was able to then re-apply your now reverted patch:

270065e92 - scsi-mq: Always unprepare before requeuing a request

With this combination, I was still able to boot successfully on
a Power system with ipr.

Tested-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
