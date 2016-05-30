From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Mon, 30 May 2016 15:43:43 +0800
Message-ID: <574BEF2F.9070707@huawei.com>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
 <20160529065452.GA21677@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:23855 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbcE3Ho5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2016 03:44:57 -0400
In-Reply-To: <20160529065452.GA21677@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hi, Christoph,

On 2016/5/29 14:54, Christoph Hellwig wrote:
> On Sat, May 28, 2016 at 11:51:11AM +0800, Wei Fang wrote:
>> async_sas_ata_eh(), which will call scsi_eh_finish_cmd() in some case,
>> would be performed simultaneously in sas_ata_strategy_handler(). In this
>> case, ->host_failed may be decreased simultaneously in
>> scsi_eh_finish_cmd() on different CPUs, and become abnormal.
>>
>> It will lead to permanently inequal between ->host_failed and
>>  ->host_busy. Then SCSI error handler thread won't become running,
>> SCSI errors after that won't be handled forever.
>>
>> Use atomic type for ->host_failed to fix this race.
> 
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But please also update Documentation/scsi/scsi_eh.txt for this
> change.

Thanks for reviewing the patch.
I looked around the file, and didn't find the part should be updated.
Would you point me out?

Thanks,
Wei

> 
> .
> 

