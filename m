From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: sysfs group not found for kobject on mvsas drive removal
Date: Tue, 12 May 2015 13:30:31 -0700
Message-ID: <CAPcyv4gpiAT7x6FAmSKxf4fh0q=fSpubQMOOht3_bvhLyxBZ8Q@mail.gmail.com>
References: <c952e6a1dc4b4badb3b4a55272bfbc48@EX01.lg.local>
	<16adc53b67b247f49bc46ff20a9d55d4@EX01.lg.local>
	<CAPcyv4gm7Ss5Bim--=9i_G2J-OmbxmKuMU_zcAJ9pJ8_0Khqjg@mail.gmail.com>
	<CAPcyv4iyaCDchXt93aw0cjqcvL_RPZDU-LendmdhS7G8_AUxMA@mail.gmail.com>
	<05ebfba955294f0580856f5a23329d7d@EX01.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35218 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbbELUad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 16:30:33 -0400
Received: by wgnd10 with SMTP id d10so20268215wgn.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 13:30:31 -0700 (PDT)
In-Reply-To: <05ebfba955294f0580856f5a23329d7d@EX01.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: "James Bottomley (James.Bottomley@HansenPartnership.com)" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, May 12, 2015 at 1:20 PM, Praveen Murali <pmurali@logicube.com> wrote:
>> > -----Original Message-----
>> > From: Dan Williams [mailto:dan.j.williams@intel.com]
>> > Sent: Monday, May 11, 2015 3:44 PM
>> > To: Praveen Murali
>> > Cc: James Bottomley (James.Bottomley@HansenPartnership.com); linux-
>> > scsi@vger.kernel.org
>> > Subject: Re: sysfs group not found for kobject on mvsas drive removal
>> >
>> > So I wonder if this is a new warning, because as far as I can tell
>> > we've always been double deleting the devices below sas_port.  It
>> > seems we should delete all the devices from rphy down before deleting
>> > the parent port.  Something like this (excuse the whitespace
>> > mangling).  Only compile tested as I don't have a SAS setup handy.
>> >
> I tested that patch on my setup with the Marvell SAS HBA and it seems to be working well; all the warnings are gone.

Cool, hmm, makes me nervous when untested patches work right the first
time :-).  I wonder if we are still managing the reference counts
correctly and not leaking devices.  Previously we would get 2 calls to
put_device() on the sas_port device.  Now I think we only get one.
Can you confirm that sas_port_release() is still being called.

/me also wonders why the scsi_transport_class has "port->dev.parent =
get_device(parent);" all over the place.  Parents should be pinned as
long as children are registered.  James, do you recall why these
extra/explicit references are taken?
