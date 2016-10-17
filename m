From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Mon, 17 Oct 2016 13:30:27 -0400
Message-ID: <86feb34c-bee8-a158-1bbb-ac37c71a9bfc@redhat.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
 <d9e79049-b4ce-588f-263d-dad015b3368d@suse.de>
 <9e5fbcef-bd72-71be-76f6-f41e26b5cb3c@redhat.com>
 <1476721205.2734.12.camel@linux.vnet.ibm.com>
 <14aa9905-b7fc-9695-dd19-1cc31cbee330@redhat.com>
 <1476724793.2734.21.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933945AbcJQRaa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 13:30:30 -0400
In-Reply-To: <1476724793.2734.21.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, kashyap.desai@broadcom.com, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Gris Ge <fge@redhat.com>, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>

On 10/17/2016 01:19 PM, James Bottomley wrote:
>>> That's not what I get from the change log.  What it says to me is
>>> > >that the caches are currently firmware managed.  Barring firmware
>>> > >bugs, that means that we currently don't have any integrity issues.
>> >
>> >Your understanding (or the change log) is incorrect.
> There's no current way in English of construing "as firmware takes care
> of flushing cache" to mean its inverse, so the changelog needs updating
> to explain that firmware does*not*  take care of cache flushing, so
> effectively nothing does and we'll need a cc to stable if the problem
> is that nothing takes care of flushing the drive caches.
>
> James
>
>
I agree that the changelog should be fixed, but the code itself is clearly 
broken in how is discards synchronize_cache commands. I assume Sumit will update 
that for use.

The specific situation is this:

* when using devices in RAID mode, the firmware does handle cache flushes (I 
assume it disables the back end disk write caches and handles its HBA write 
cache as you would expect).

* when using devices in non-RAID mode or pass through mode where the backend 
disks have write cache enabled, dropping the "SYNCHRONIZE_CACHE" commands in the 
driver is *never* correct for any disk with a volatile write cache

* there is no standard way to distinguish devices that have WCE set and have 
non-volatile write caches, so we have to assume the worst.

Regards,

Ric


