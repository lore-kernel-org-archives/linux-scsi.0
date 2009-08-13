From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Thu, 13 Aug 2009 16:58:58 +0300
Message-ID: <4A841C22.4070908@panasas.com>
References: <Pine.LNX.4.44L0.0908111212010.2562-100000@iolanthe.rowland.org> <1250007887.4301.53.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:30141
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752680AbZHMN7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2009 09:59:04 -0400
In-Reply-To: <1250007887.4301.53.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/11/2009 07:24 PM, James Bottomley wrote:
> On Tue, 2009-08-11 at 12:14 -0400, Alan Stern wrote:
>> On Tue, 11 Aug 2009, James Bottomley wrote:
>>
>>> Sort of, but it's not really doing it properly.  Lets do it like this.
>>> This should also fix the > 255 length problem older devices might have.
>>
>> Do you mind including also the residue check?
> 
> But there's no point to it ... it's a Byzantine check.  The standard
> says shall return as many bytes as will fit in the allocation length
> (what it does with allocation length beyond data to return is
> undefined).
> 
> For the USB case where a full residue and no error indicates there was
> actually an error, we already have a translation.
> 
> If devices just return random data lengths and then stop, your proposed
> residue check doesn't catch them anyway.  However, I'd much rather
> assume a device performs to spec until proven otherwise.
> 

OK so this is also the case for devices that did not error, did not return
resid, and yet did not return the page in question. Please remove that
!= page check then. ("until proven otherwise")

> James
> 
> 

Boaz
