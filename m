From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: Fri, 28 Jan 2005 03:10:46 -0500
Message-ID: <41F9F386.7070501@pobox.com>
References: <200501272242.j0RMgoP5016154@falcon30.maxeymade.com> <41F97299.2070909@pobox.com> <20050128065358.GA4800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:28875 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261169AbVA1ILD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2005 03:11:03 -0500
In-Reply-To: <20050128065358.GA4800@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Doug Maxey <dwm@maxeymade.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Jan 27 2005, Jeff Garzik wrote:
> 
>>Doug Maxey wrote:
>>
>>>On Thu, 27 Jan 2005 13:02:48 +0100, Jens Axboe wrote:
>>>
>>>
>>>>Hi,
>>>>
>>>>For the longest time, only the old PATA drivers supported barrier writes
>>>>with journalled file systems. This patch adds support for the same type
>>>>of cache flushing barriers that PATA uses for SCSI, to be utilized with
>>>>libata. 
>>>
>>>
>>>What, if any mechanism supports changing the underlying write cache?  
>>>
>>>That is, assuming this is common across PATA and SCSI drives, and it is 
>>>possible to turn the cache off on the IDE drives, would switching the 
>>>cache underneath require completing the inflight IO?
>>
>>[ignoring your question, but it made me think...]
>>
>>
>>I am thinking the barrier support should know if the write cache is 
>>disabled (some datacenters do this), and avoid flushing if so?
> 
> 
> Ehm it does, read the code :)


I did.  I see nowhere that handles the case where the user uses a util 
(hdparm or blktool) to switch off write cache after sd.c has probed the 
disk.  sd only sets its WCE bit at probe time, and doesn't appear to 
notice state changes.

Since nobody snoops the MODE SELECT on the caching page, nobody knows 
past probe the state of write caching.

Thus my comment...   I think barrier support should know about that sort 
of thing :)

	Jeff


