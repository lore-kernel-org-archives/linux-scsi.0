From: Arne Wiebalck <Arne.Wiebalck@cern.ch>
Subject: AW: SG_IO problem on tape devices
Date: Wed, 4 Jun 2008 18:46:41 +0200
Message-ID: <E7F3663B89B60B478C6997C0A0671F8B0D58A5@cernxchg45.cern.ch>
References: <1212479982.5079.58.camel@pcitfio23.cern.ch> <1212524159.3329.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cernmx11.cern.ch ([137.138.142.198]:21751 "EHLO
	cernmx11.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYFDQqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2008 12:46:43 -0400
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

 
>On Tue, 2008-06-03 at 09:59 +0200, Arne Wiebalck wrote: 
>> Hi all,
>> 
>> I got a problem using the SG_IO ioctl with our tape drives. 
>> In order to examine errors on our drives in more detail, I 
>> would like to make the sense bytes available to the 
>> application using the REQUEST_SENSE command.
>> 
>> However, there's a discrepancy between the kernel output in
>> /var/log/messages and what I see using SG_IO within my 
>> application: while the kernel sees
>> 
>> kernel: st0: Error with sense data: scsi1 : destination target 0, lun 0
>> kernel:         command = Space 01 00 0d d5 00
>> kernel: Info fld=0x1, Current st0: sense key Medium Error
>> kernel: Additional sense: Read retries exhausted
>> kernel: Raw sense data:0xf0 0x00 0x03 0x00 0x00 0x00 0x01 0x12 0x00 0x00
>> 0x00 0x00 0x11 0x01 0x00 0x00 0x00 0x00 0x37 0xf7 0x10 0x01 0x00 0x00
>> 0xf7 0x37
>> 
>> (which is realistic) the ioctl reports something like
>> 
>> 70 00 00 00 00 00 00 12  00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00  10 02
>> 
>> (since the first bit is not set, the sense bytes are not even valid,
>> as far as I understand).
>> 
>> So, could it be that the sense bytes are already cleared when I request
>> them? They cleared/set by the next SCSI cmd, I assume? But shouldn't
>> they be valid even then?
>> 
>> I also tried the sg3-utils to query the drive's sense bytes, and they
>> report (almost) the same sense bytes as SG_IO inside my application
>> does. Sending an INQUIRY cmd using sg3_utils works fine, btw.
>> 
>> Maybe that's all a plain usage error, so please find the code I use
>> below.
>> 
>> Anything obvious I am doing wrong here? All comments appreciated. 
>
> Yes: SCSI automatically requests sense in response to a check condition.
> So, the sense should be attached to the SG_IO command that receives the
> error.  You can't do an additional request sense for it because the
> sense has already been cleared by the automatic request sense the
>mid-layer did.
>
>Does the sense data really not get returned by the SG_IO command that
>actually encounters the check condition return?
>

Thanks for all the quick replies and helpful comments.

I will check what the SCSI command is that sees the error in the first
place, but it is most likely not an SG_IO command. I can't say immediately 
as I'm not the original author of the code, but since the code has been 
written years ago, I have my doubts.

As soon as I have identified the place in the code, I may come back to ask 
for advice on how to access the sense bytes in that specific case ... or 
how to change the code to make that possible at all :)

Since I won't be around for some days, 'coming back' may take some time.

Cheers,
 Arne   

 


