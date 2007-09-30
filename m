From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] SCSI: export sas_hash_addr()
Date: Sun, 30 Sep 2007 13:44:42 -0400
Message-ID: <46FFE08A.4040001@garzik.org>
References: <20070926073557.GA22773@havoc.gtf.org>	 <1190937846.5392.46.camel@localhost.localdomain>	 <46FC5274.10802@garzik.org> <1191171368.4443.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56785 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866AbXI3Roo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 13:44:44 -0400
In-Reply-To: <1191171368.4443.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-09-27 at 21:01 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> On Wed, 2007-09-26 at 03:35 -0400, Jeff Garzik wrote:
>>>> sas_hash_addr() is the spec-defined standard hashing function.  Make it
>>>> available to drivers that need it.
>>> I'm not opposed in principle to exporting this, but I have a hard time
>>> understanding why a driver would need it.
>>>
>>> The hashed address is a property of the constructed SAS frames, which is
>>> done in libsas.  The driver shouldn't really be calculating its own hash
>>> instead of using what libsas provides ... or is this because the hashed
>>> self address isn't calculated by the HBA so it needs to be programmed or
>>> something?
>> It is needed to build the SSP frame header.
>>
>> If there is common code that does that, I will definitely use that, but 
>> do not see any such code.
> 
> The way you're supposed to build the frame header is in
> lldd_execute_task().  Here, if you need the hashed address of the
> destination, you copy it out of the domain_device (dev field of struct
> sas_task).

That's the destination.  I need it for the source.

	Jeff



