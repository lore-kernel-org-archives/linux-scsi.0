From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 4/6] libata: Add ata_host_flags
Date: Mon, 26 Jun 2006 13:56:21 -0500
Message-ID: <44A02DD5.1030405@us.ibm.com>
References: <200606071625.k57GPrit014721@d01av01.pok.ibm.com> <448CDEF3.1000703@pobox.com> <448DB360.8010504@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <448DB360.8010504@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> Jeff Garzik wrote:
>> Brian King wrote:
>>> Since SATA devices attached to SAS HBAs will not have
>>> a host_set, add a helper function to retrieve the host_set
>>> flags which can check for the existence of a host_set.
>>>
>>> Signed-off-by: Brian King <brking@us.ibm.com>
>>> ---
>>>
>>>  libata-dev-bjking1/drivers/scsi/libata-core.c |    7 +++----
>>>  libata-dev-bjking1/include/linux/libata.h     |    7 +++++++
>>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff -puN drivers/scsi/libata-core.c~libata_sas_no_simplex drivers/scsi/libata-core.c
>>> --- libata-dev/drivers/scsi/libata-core.c~libata_sas_no_simplex	2006-06-06 08:55:43.000000000 -0500
>>> +++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-06 08:55:43.000000000 -0500
>>> @@ -2161,7 +2161,7 @@ int ata_set_mode(struct ata_port *ap, st
>>>  	/* Record simplex status. If we selected DMA then the other
>>>  	 * host channels are not permitted to do so.
>>>  	 */
>>> -	if (used_dma && (ap->host_set->flags & ATA_HOST_SIMPLEX))
>>> +	if (used_dma && (ata_host_flags(ap) & ATA_HOST_SIMPLEX))
>> I'm not sure I like this one.  Will have to think a bit more on this -- 
>> there might be a need for ipr to carry some cross-port libata state.
> 
> I can't think of any need at this point. Would it be reasonable to go ahead
> with this change and add in the support for a cross-port libata state
> if and when such a need comes along? 

Jeff, any further thoughts about this? I had been trying to avoid having
any host_set type of data for the SAS usage of libata in part due to
not seeing a need and also due to a comment Bartlomiej made a while back:

http://marc.theaimsgroup.com/?l=linux-ide&m=112842136431977&w=2


Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
