From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Wed, 29 Mar 2006 08:15:24 -0600
Message-ID: <442A967C.8070805@us.ibm.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com> <20060329091104.GB7940@infradead.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060329091104.GB7940@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jgarzik@pobox.com, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Mar 28, 2006 at 04:17:18PM -0600, Brian King wrote:
>> Add a max_cmd_len field to the scsi_device struct
>> to allow for per device limits of allowable command
>> lengths. This will be used by libata, which is currently
>> using the max_cmd_len field in the scsi_host struct,
>> which doesn't work for attaching libata controlled
>> SATA devices to SAS HBAs.
> 
> this sounds wrong to me.  cdb length is a limitation of the host (driver).
> A target will reject unknown commands, no matter what length they have.

In that case, this patch can probably be dropped. Currently libata has
some code that looks at all the devices attached to a port and sets
the scsi_host's max_cmd_len to the max of these values. I was assuming
this was due to some misbehaving ATA/ATAPI devices out there.

Jeff, care to comment on this one?


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
