From: david@lang.hm
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 13:55:07 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net>
 <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net>
 <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu>
 <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm> <20071016195432.GA31306@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:40267
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXJPUvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 16:51:46 -0400
In-Reply-To: <20071016195432.GA31306@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tue, 16 Oct 2007, Matthew Wilcox wrote:

> On Tue, Oct 16, 2007 at 12:54:58PM -0700, david@lang.hm wrote:
>> On Tue, 16 Oct 2007, Alan Cox wrote:
>>> I wouldn't try dividing those by pata v sata. You'll cause all sorts of
>>> problems in the process because of PATA-SATA and SATA-PATA bridges.
>>
>> if you use a PATA-SATA bridge (IDE drive SATA controller), it would look
>> to the system like a SATA drive and be addressed and enumerated as SATA.
>
> But you don't know where the bridge is.  It might be on the drive's
> board, it might be an explicit enclosure, or it might be on the
> motherboard.  Each of those scenarios is going to have a different user
> expectation.

the only one of these that I would find unexpected would be the one on the 
motherboard.

why is this any different from the external enclosures? they have always 
appeared as the type of device that connects them to the motherboard, (and 
even with SCSI, there are some controllers that don't generate sdX 
devices)

the driver for the controller is what has historicly determined what the 
device appears as to the system. an example of this is the 3ware driver 
that is a SCSI drive but the drives attached to the card are IDE drives. 
another example is the I2O drivers (which give you access to the Raid 
array and to the individual drives, in different namespaces). while I may 
disagree with some of the selections that have been made (the 3ware has 
always seemed odd to me for example) it's pretty simple to figure out.

but in any case, historicly IDE (PATA) and SATA drives have been handled 
differently, IDE drives have had fixed device names based on how they are 
connected, SATA devices have had 'order found' device names from the SCSI 
heritige. mixing the two types into one namespace requires changing one or 
the other. while I would love to see SATA gain hardware path dependant 
names I'm not holding my breath, but I hate to loose the predictable 
nameing (even if the names change) for the IDE drives.

David Lang

