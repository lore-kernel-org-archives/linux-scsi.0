From: Arne Wiebalck <arne.wiebalck@cern.ch>
Subject: Re: SG_IO problem on tape devices
Date: Mon, 30 Jun 2008 10:43:25 +0200
Message-ID: <1214815405.5058.20.camel@pcitfio23.cern.ch>
References: <1212479982.5079.58.camel@pcitfio23.cern.ch>
	 <1212524159.3329.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cernmx11.cern.ch ([137.138.142.198]:50172 "EHLO
	cernmx11.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYF3In1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 04:43:27 -0400
In-Reply-To: <1212524159.3329.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: arne.wiebalck@cern.ch

On Tue, 2008-06-03 at 15:15 -0500, James Bottomley wrote:
> On Tue, 2008-06-03 at 09:59 +0200, Arne Wiebalck wrote: 
> > Hi all,
> > 
> > I got a problem using the SG_IO ioctl with our tape drives. 
> > In order to examine errors on our drives in more detail, I 
> > would like to make the sense bytes available to the 
> > application using the REQUEST_SENSE command.
> > 
> > However, there's a discrepancy between the kernel output in
> > /var/log/messages and what I see using SG_IO within my 
> > application: while the kernel sees
> > 
> > kernel: st0: Error with sense data: scsi1 : destination target 0, lun 0
> > kernel:         command = Space 01 00 0d d5 00
> > kernel: Info fld=0x1, Current st0: sense key Medium Error
> > kernel: Additional sense: Read retries exhausted
> > kernel: Raw sense data:0xf0 0x00 0x03 0x00 0x00 0x00 0x01 0x12 0x00 0x00
> > 0x00 0x00 0x11 0x01 0x00 0x00 0x00 0x00 0x37 0xf7 0x10 0x01 0x00 0x00
> > 0xf7 0x37
> > 
> > (which is realistic) the ioctl reports something like
> > 
> > 70 00 00 00 00 00 00 12  00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00 00 00  10 02
> > 
> > (since the first bit is not set, the sense bytes are not even valid,
> > as far as I understand).
> > 
> > So, could it be that the sense bytes are already cleared when I request
> > them? They cleared/set by the next SCSI cmd, I assume? But shouldn't
> > they be valid even then?
> > 
> > I also tried the sg3-utils to query the drive's sense bytes, and they
> > report (almost) the same sense bytes as SG_IO inside my application
> > does. Sending an INQUIRY cmd using sg3_utils works fine, btw.
> > 
> > Maybe that's all a plain usage error, so please find the code I use
> > below.
> > 
> > Anything obvious I am doing wrong here? All comments appreciated. 
> 
> Yes: SCSI automatically requests sense in response to a check condition.
> So, the sense should be attached to the SG_IO command that receives the
> error.  You can't do an additional request sense for it because the
> sense has already been cleared by the automatic request sense the
> mid-layer did.
> 
> Does the sense data really not get returned by the SG_IO command that
> actually encounters the check condition return?

The code does not use SG_IO interface until now. The command that
encounters the error is a read or a write. Is there a way to get the 
sense bytes in such a case (except for replacing all read/write calls
with the corresponding SG_IO commands)?

TIA,
 Arne  


