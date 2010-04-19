From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: SYNCHRONIZE_CACHE from sd_preppare_flush does not have retries.!
Date: Mon, 19 Apr 2010 11:20:43 -0500
Message-ID: <4BCC82DB.1070402@cs.wisc.edu>
References: <1C9608B8A4CD534FB19C7C7543CBB249021C7718FA@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40693 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0DSQUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2010 12:20:31 -0400
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB249021C7718FA@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

On 04/19/2010 06:32 AM, Desai, Kashyap wrote:
> I am facing one issue with scsi stack.
> Here is a background of my test.
>
> Mount ext3 file system with journaling support with barrier=1, commit=5
> Now, with this setup file system will do submit_bh with  WRITE_BARRIER flag set for interval of 5 seconds. (This is a part of journaling.)
> Eventually it will call queue_flush() which will generate SCSI command of CDB: SYNCHRONIZE_CAHCE and insert it into the request queue.
> I observed that creation of SYNCHRONIZE_CACHE is a part of sd_prepare_flush(). Here we have timeout set to SD_TIMEOUT but retries are not set.
> Because of retries of the request is not set, there is no retries allowed for SYNCHRONIZE_CACHE at mid layer.
>
> Because of zero retries for SYNCHRONIZE_CACHE command at mid-layer, it is creating trouble for file system.
> In current situation, Even though LLD send back commands with DID_RESET, SYNCHRONIZE_CACHE will fail immediately without going for any retries, when HBA is in recovery state. Eventually this information goes to File system and it sees SYNCHRONIZE_CAHCE is failed and file system goes to Read only mode.
>
> My question is "Can we add in sd_prepare_flush(), rq->retries = X" some reasonable retries value ?
>

I am not sure where we want it, but I think we want to be able to set 
both the retries and timeout. I have seen where a sync cache can take 
longer than the default 30 secs.

Do you think we want to the block layer to manage retries/timeouts for 
all block device flushes or is this more device specific? I was thinking 
that we may want to create a sysfs interface under the block dirs and 
have blk-sysfs.c and blk-barrier.c handle this. queue_flush could set 
the timeout and retries that is set by some new files under 
/sys/block/sdX/queue/ ?
