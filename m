From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas: User mode app failed to send ioctl commands to
 SATA drive.
Date: Fri, 16 Jan 2009 09:33:19 -0500
Message-ID: <49709AAF.7010606@garzik.org>
References: <496B1B31.4050606@marvell.com>	 <1231774426.3256.2.camel@localhost.localdomain> <49707B7A.90100@garzik.org> <1232115665.3224.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47138 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399AbZAPOdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 09:33:25 -0500
In-Reply-To: <1232115665.3224.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: kewei@marvell.com, linux-scsi@vger.kernel.org, djwong@us.ibm.com, Jason Chu <jasonchu@marvell.com>, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>

James Bottomley wrote:
> On Fri, 2009-01-16 at 07:20 -0500, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> On Mon, 2009-01-12 at 18:28 +0800, Ke Wei wrote:
>>>> The context of scsi_host's hostdata points to a sas ha structure with libsas
>>>> module, but the libata casts this pointer to a ata_port structure when ioctl
>>>> sends HDIO_GET_IDENTITY.
>>> This is a good find thanks.  I think there's a small problem in the way
>>> the layering is done.
>>>
>>> I think ata_scsi_ioctl needs to be expanded to pass the port in all the
>>> time.   That way other implementors don't have to remember to special
>>> case HDIO_GET_IDENTITY.
>>>
>>> When you redo this, ipr will need altering as well (rather than also
>>> having the identity exception added).
>> The attached appears to be what is needed.  We cannot change 
>> ata_scsi_ioctl() because every libata driver uses that function directly 
>> in its SCSI template as the driver's ioctl hook.
>>
>> Ack, and I'll apply?
> 
> That's about precisely what I was thinking ... except I'd call the API
> ata_sas_scsi_ioctl() ... since the ata_sas prefix is what we use for all
> the SAS inputs to libata (and __ usually implies hidden or unlocked).

That's fine with me.  I was on the fence, tossing between __ and 
ata_sas_ in my head.

	Jeff



