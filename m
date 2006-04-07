From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Fri, 07 Apr 2006 08:36:44 -0500
Message-ID: <44366AEC.4070504@us.ibm.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com> <20060329091104.GB7940@infradead.org> <442B15F4.30506@pobox.com> <442C09A8.50200@us.ibm.com> <44323B73.9070903@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <44323B73.9070903@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brian King wrote:
>> Jeff Garzik wrote:
>>> James Bottomley wrote:
>>>> This really doesn't look correct.  What you want is a sata transport
>>>> class with a max command length in the host device.
>>> Christoph Hellwig wrote:
>>>> this sounds wrong to me.  cdb length is a limitation of the host (driver).
>>>> A target will reject unknown commands, no matter what length they have.
>>> In practice, CDB length may be limited by both the host and the device. 
>>>   This applies to ATAPI, and some USB storage too IIRC.  For ATAPI, you 
>>> read the CDB length from the device's IDENTIFY PACKET DEVICE info page.
>> So the question remains, do we need to police the CDB length on a per device
>> basis, or is a per host basis ok? Will we have ATAPI devices falling on the
>> floor if they get sent too large of a cdb?
> 
> It _must_ be limited by both device and host.  If you have a device that 
> supports 16-byte CDBs and a host controller which only supports 12-byte 
> CDBs, clearly the limit is 12, due to host.  However, a reversed 
> situation (limited by device) is equally plausible/possible.

Ok. That is what I was assuming, which was the reason I submitted this
patch in the first place.

James, given this information, are you ok with the patch, or do you
still have an objection?

Thanks,

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
