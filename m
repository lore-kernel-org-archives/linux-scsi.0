From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Tue, 04 Apr 2006 05:25:07 -0400
Message-ID: <44323B73.9070903@pobox.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com> <20060329091104.GB7940@infradead.org> <442B15F4.30506@pobox.com> <442C09A8.50200@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39367 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932407AbWDDJZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2006 05:25:29 -0400
In-Reply-To: <442C09A8.50200@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Brian King wrote:
> Jeff Garzik wrote:
>> James Bottomley wrote:
>>> This really doesn't look correct.  What you want is a sata transport
>>> class with a max command length in the host device.
>> Christoph Hellwig wrote:
>>> this sounds wrong to me.  cdb length is a limitation of the host (driver).
>>> A target will reject unknown commands, no matter what length they have.
>>
>> In practice, CDB length may be limited by both the host and the device. 
>>   This applies to ATAPI, and some USB storage too IIRC.  For ATAPI, you 
>> read the CDB length from the device's IDENTIFY PACKET DEVICE info page.
> 
> So the question remains, do we need to police the CDB length on a per device
> basis, or is a per host basis ok? Will we have ATAPI devices falling on the
> floor if they get sent too large of a cdb?

It _must_ be limited by both device and host.  If you have a device that 
supports 16-byte CDBs and a host controller which only supports 12-byte 
CDBs, clearly the limit is 12, due to host.  However, a reversed 
situation (limited by device) is equally plausible/possible.

	Jeff



