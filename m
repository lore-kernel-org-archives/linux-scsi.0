Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADAFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 16:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25842064C
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 16:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgGGQgr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 12:36:47 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2436 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728029AbgGGQgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 12:36:47 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id A6218A7227013FDD4E58;
        Tue,  7 Jul 2020 17:36:45 +0100 (IST)
Received: from [127.0.0.1] (10.47.9.47) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 7 Jul 2020
 17:36:44 +0100
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Support hostwide tags
To:     "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>
References: <1594128751-212234-1-git-send-email-john.garry@huawei.com>
 <1594128751-212234-3-git-send-email-john.garry@huawei.com>
 <86cad960-9563-af80-d15e-6fd5845e681a@interlog.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4f0c7329-e2e9-68ea-7937-bb629133d759@huawei.com>
Date:   Tue, 7 Jul 2020 17:35:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <86cad960-9563-af80-d15e-6fd5845e681a@interlog.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.9.47]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/07/2020 17:28, Douglas Gilbert wrote:


>> +	if (sdebug_host_max_queue)
>> +		sd_dp->hc_idx = get_tag(cmnd);
>> +
>>    	if (ndelay > 0 && ndelay < INCLUSIVE_TIMING_MAX_NS)
>>    		ns_from_boot = ktime_get_boottime_ns();
>>    
>> @@ -5585,6 +5604,8 @@ module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
>>    module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
>>    module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
>>    module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
>> +module_param_named(host_max_queue, sdebug_host_max_queue, int,
>> +		   S_IRUGO | S_IWUSR);
> I can't see a "_store" method to match that S_IWUSR. If you don't want that
> parameter to be run-time changeable, then please drop the S_IWUSR.

Right, my intention was for RO, so I can drop S_IWUSR

> 
>>    module_param_named(medium_error_count, sdebug_medium_error_count, int,
>>    		   S_IRUGO | S_IWUSR);
>>    module_param_named(medium_error_start, sdebug_medium_error_start, int,
>> @@ -5654,6 +5675,7 @@ MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (de
>>    MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
>>    MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
>>    MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
>> +MODULE_PARM_DESC(host_max_queue, "max number of queued commands per host (0 to max(def))");
>>    MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
>>    MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
>>    MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
>> @@ -6141,7 +6163,8 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
>>    	struct sdebug_queue *sqp;
>>    

[...]

>>    
>> @@ -7272,9 +7317,13 @@ static int sdebug_driver_probe(struct device *dev)
>>    			my_name, submit_queues, nr_cpu_ids);
>>    		submit_queues = nr_cpu_ids;
>>    	}
>> -	/* Decide whether to tell scsi subsystem that we want mq */
>> -	/* Following should give the same answer for each host */
>> -	hpnt->nr_hw_queues = submit_queues;
>> +	/*
>> +	 * Decide whether to tell scsi subsystem that we want mq. The
>> +	 * following should give the same answer for each host. If the host
>> +	 * has a limit of hostwide max commands, then do not set.
>> +	 */
>> +	if (!sdebug_host_max_queue)
>> +		hpnt->nr_hw_queues = submit_queues;
>>    
>>    	sdbg_host->shost = hpnt;
>>    	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
>>
> John,
> Looks good apart from the issue above. Another minor point: in a year's
> time (when this patch isn't (near) top of mind) then the output from
> 'modinfo scsi_debug' can be bewildering: so many parameter options, how
> to find the one(s) I need. That is why I try to put them in alphabetical
> order (namely the module_param_named() and MODULE_PARM_DESC() entries).
> Maybe the "DESC" could be expanded to hint at the relationship with
> max_queue.

ok, I'll fix that up as requested.

Thanks for checking,
John
