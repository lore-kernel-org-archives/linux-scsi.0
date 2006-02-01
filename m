From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: ServeRAID Seeing DADSI Devices
Date: Wed, 1 Feb 2006 11:00:46 -0500
Message-ID: <A121ABA5B472B74EB59076B8E3C8F01901DD64A2@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:56249 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1422652AbWBAQAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 11:00:47 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com


I believe this is a bad solution. If exposing an element of a RAID array
( at any level ), now or ever in the future, allows anyone or anything
the ability to touch the physical DASDI device, it has violated the most
sacred rule of a RAID subsystem because it has jeopardized the data's
integrity. Nothing should ever have the ability to touch a drive's data
( attached to a RAID adapter ) except the adapter's firmware.

That being said ( and soapbox dismounted ), I will create a patch that
sets the no_uld_attach flag - if that's the implementation the community
thinks is appropriate.

Jack

 

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, February 01, 2006 5:25 AM
To: Hammer, Jack
Cc: linux-scsi@vger.kernel.org; James.Bottomley@steeleye.com
Subject: Re: ServeRAID Seeing DADSI Devices

On Tue, Jan 31, 2006 at 01:17:55PM -0500, Jack Hammer wrote:
> A critical thing the ServeRAID driver MUST do is hide the physical 
> DASDI devices from the OS. It does this by intercepting the INQUIRY
commands.

No, it must not.  What itu should do instead is to set the no_uld_attach
flag.


