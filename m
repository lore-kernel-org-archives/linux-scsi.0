From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock
Date: Fri, 25 Apr 2003 10:00:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EA93F64.3020205@rogers.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030425111212.A28577@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:25353
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263165AbTDYNsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2003 09:48:06 -0400
In-Reply-To: <20030425111212.A28577@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>-		spin_lock_irqsave(&d->list_lock, flags);
>>+		spin_lock_irqsave(&d->sdev_lock, flags);
>> 		list_for_each_entry(cmd, &d->cmd_list, list) {
>> 			if(cmd->serial_number == 0){
> 
> 
> <snip>
> 
>>-	spin_lock_irqsave(&sdev->list_lock, flags);
>>+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>> 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
> 
> 
> 
> Oh, please, please use the lock consistantly.  Yes, I know that the
> two are the same currently, but it might not be obvious to every reader
> and queue_lock might change to something else in the future.

I concur.

-- 
Luben

P.S. This same thing was discussed before at the intro of starved
devs's code, seems it didn't get through then, maybe it will now...


