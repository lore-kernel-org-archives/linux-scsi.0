From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: do not requeue requests unaligned with device
 sector size
Date: Wed, 21 Dec 2016 21:11:09 -0200
Message-ID: <c7a174fc-aec4-e8bb-b7ad-8c53a87046de@linux.vnet.ibm.com>
References: <1482199347-9128-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <yq1fulh1ivs.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1fulh1ivs.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, gpiccoli@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 12/21/2016 05:50 AM, Christoph Hellwig wrote:
 > How do you even get an unaligned residual count?  Except for SES
 > processor devices (which will only issue BLOCK_PC commands) this is
 > not allowed by SPC:
 >
 > "The residual count shall be reported in bytes if the peripheral device
 >  type in the destination target descriptor is 03h (i.e., processor 
device),
 >  and in destination device blocks for all other device type codes.

On 12/21/2016 06:09 AM, Hannes Reinecke wrote:
 > Which actually would be pretty much my objection, too.
 >
 > This would only be applicable for 512e drives, where we _might_ end up
 > with a residual smaller than the physical sector size.
 > But that should be handled by firmware; after all, that's what the 'e'
 > implies, right?

On 12/21/2016 12:01 PM, Martin K. Petersen wrote:
> I agree with Christoph and Hannes. Some of this falls into the gray area
> that's outside of the T10 spec (HBA programming interface guarantees)
> but it seems like a deficiency in the HBA to report a byte count that's
> not a multiple of the logical block size. A block can't be partially
> written. Either it made it or it didn't. Regardless of how the I/O is
> being broken up into frames at the transport level and at which offset
> the transfer was interrupted.

Christoph, Hannes, Martin,

Thank you all for your comments and pointers to the documentation/spec.
I'll carry it on with the HBA and storage folks.

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
