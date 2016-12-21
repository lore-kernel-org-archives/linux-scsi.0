From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: do not requeue requests unaligned with device
 sector size
Date: Wed, 21 Dec 2016 09:09:22 +0100
Message-ID: <1f44fb00-78c6-fb5c-9169-6aeeaf4c06ef@suse.de>
References: <1482199347-9128-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20161221075003.GA22860@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161221075003.GA22860@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, gpiccoli@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 12/21/2016 08:50 AM, Christoph Hellwig wrote:
> On Tue, Dec 20, 2016 at 12:02:27AM -0200, Mauricio Faria de Oliveira wrote:
>> When a SCSI command (e.g., read operation) is partially completed
>> with good status and residual bytes (i.e., not all the bytes from
>> the specified transfer length were transferred) the SCSI midlayer
>> will update the request/bios with the completed bytes and requeue
>> the request in order to complete the remainder/pending bytes.
>>
>> However, when the device sector size is greater than the 512-byte
>> default/kernel sector size, alignment restrictions and validation
>> apply (both to the starting logical block address, and the number
>> of logical blocks to transfer) -- values must be multiples of the
>> device sector size, otherwise the kernel fails the request in the
>> preparation stage (e.g., sd_setup_read_write_cmnd() at sd.c file):
> 
> How do you even get an unaligned residual count?  Except for SES
> processor devices (which will only issue BLOCK_PC commands) this is
> not allowed by SPC:
> 
> "The residual count shall be reported in bytes if the peripheral device
>  type in the destination target descriptor is 03h (i.e., processor device),
>  and in destination device blocks for all other device type codes."

Which actually would be pretty much my objection, too.

This would only be applicable for 512e drives, where we _might_ end up
with a residual smaller than the physical sector size.
But that should be handled by firmware; after all, that's what the 'e'
implies, right?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
