From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take
 2
Date: Tue, 07 Sep 2004 14:12:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413E2440.8080509@cs.wisc.edu>
References: <20040907210520.0251476C56@isis.visi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:64152 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S268671AbUIGVWM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 17:22:12 -0400
In-Reply-To: <20040907210520.0251476C56@isis.visi.com>
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <mikenc@us.ibm.com>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Scott M. Ferris wrote:
> James Bottomley wrote:
> 
>>On Tue, 2004-09-07 at 15:19, Scott M. Ferris wrote:
>>
>>
>>>That's not a very helpful analogy, since only SPI and FC-AL resemble a
>>>bus, and all of the newer SCSI transports are switched fabrics.
>>
>>Well, I'm at a bit of a loss to make it plainer ... a host is somewhere
>>you plug your bus  this is an obvious concept even for switched
>>fabrics.
> 
> 
> So a host is where you plug your (non-existent) bus?  I think it would
> be clearer to use terminology from SAM.
> 
> 
>>>>In iSCSI that's really the other end point.  Using abstractions
>>>>incorrectly (like a single host for the entire iSCSI system) is
>>>>bound to end up with problems due to the concept mismatch.
>>>
>>>I have trouble understanding your viewpoint.  Your answers to the
>>>following questions will hopefully clear things up.
>>
>>I doubt it, but I'll try.
> 
> 
> Thanks.
> 
> 
>>>Do you think Linux hosts should be used in a similar way by all
>>>switched SCSI transports (e.g. FC-SW, iSCSI, SAS)?  If not, why not?
>>
>>Yes.
> 
> 
> I'm glad we agree on that.
> 
> 
>>>Do you think switched SCSI transports should allocate one Linux host
>>>for each I_T nexus?
>>
>>No.
> 
> 
> This is exactly why I ask these questions.  The iSCSI driver
> developers just implemented this, because they thought this is what
> you and Christoph were asking for.  Apparently it's not what you
> wanted.

Thank you for clarifying this. So we should go back to a single linux host,
right? The iscsi session is an I_T nexus, so the only way to store the
session state in the host is to allocate a session per host.

> 
>>>Do you think switched SCSI transports should allocate one Linux host
>>>for each (SAM-2 or SAM-3) SCSI initiator port?
>>
>>Yes.
> 
> 
> Thank you.  This is a much clear statement of your intent.
> 
> 
>>>Do you think switched SCSI transports should allocate one Linux host
>>>for each (SAM-2 or SAM-3) SCSI initiator device?
>>
>>No.
> 
> 
> Should all drivers that currently use one host for each SCSI initiator
> device, and a channel for each initiator port on each device, be
> modified to use a host for each initiator port?
> 
> Documentation/scsi/scsi_mid_low_api.txt says that a host corresponds
> to a SCSI initiator device.  Could someone change that to say SCSI
> initiator port instead, since that seems to be the new goal?
> 

