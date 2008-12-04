From: "Sihan Goi" <goister@gmail.com>
Subject: Re: Linux SCSI programming
Date: Thu, 4 Dec 2008 16:40:14 +0800
Message-ID: <b7bb26000812040040p76d0d7fcy3193f236933ea503@mail.gmail.com>
References: <20081202052941.a3c6426c1bfee0652ed014f32bc3b38e.5ef5a46e6d.wbe@email.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:52156 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYLDIkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 03:40:17 -0500
Received: by ti-out-0910.google.com with SMTP id b6so2538406tic.23
        for <linux-scsi@vger.kernel.org>; Thu, 04 Dec 2008 00:40:15 -0800 (PST)
In-Reply-To: <20081202052941.a3c6426c1bfee0652ed014f32bc3b38e.5ef5a46e6d.wbe@email.secureserver.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bburk@extremeprotocol.com
Cc: linux-scsi@vger.kernel.org

Hi,

Thanks for the reply. That made a lot of sense. I think I have the
general idea, however I'm having some problems.

I've managed to use ioctl() to send a vendor specific command using an
ATA_PASS_THROUGH 12 or 16byte CDB to the device, and ioctl() returns
success, and the various status,info flags are all OK too. However,
when I look at CATC traces of the transfer, I notice that the CONTROL
byte is always 0x8. This is regardless of what value I set my CDB's
CONTROL byte field to, and regardless of whether I use the 12 or
16byte CDB. I've read the SCSI architecture model-3 document, and 0x8
isn't even a valid value for the CONTROL byte. It's a reserved bit
that's being set.

Why would the CONTROL byte not be what I set it as? I checked the
value of the byte in my code before and after I do the ioctl() and the
value does not change, so why would it be set as 0x8 instead of what I
set it as in my code?

Thanks.

On Tue, Dec 2, 2008 at 8:29 PM,  <bburk@extremeprotocol.com> wrote:
> http://www.t10.org/cgi-bin/ac.pl?t=f&f=sat-r09.pdf
>
> Go to Section 12 and read up on the passthrough.
>
> The SCSI ioctl that you need to use is SG_IO.  Google that for info on how
> to set up the ioctl.  The command can be sent to either sd or sg devices
> these days.  You'll also need to make sure that libata is loaded as a module
> I think.
>
> Note that not all adapters will support the ATA_PASSTHROUGH scsi commands.
> They should, but they don't.
>
> Brent Burkholder
> ExtremeProtocol.com
>
>
>
>
> -------- Original Message --------
> Subject: Linux SCSI programming
> From: "Sihan Goi" <goister@gmail.com>
> Date: Mon, December 01, 2008 8:50 pm
> To: linux-scsi@vger.kernel.org
>
> Hi,
>
> I'm trying to port a Windows SCSI API over to Linux. The API has
> several functions, most of them using ATA_PASS_THROUGH_EX to send a
> vendor specific command over to the device. I've managed to port 1 of
> the API function that is a modified INQUIRY command. However, I'm very
> confused as to how ATA passthrough is done in Linux. I've looked at
> the sg3_utils source code to get some inspiration but it's too
> complicated for me to understand what's going on.
>
> Does anyone know how to port this?
>
> In Windows a ATA_PASS_THROUGH_EX pointer is declared and memory
> allocated for it. It's fields are then initialized(Length, AtaFlags,
> DataTransferLength, TimeOutValue, DataBufferOffset, CurrentTaskFile[],
> PreviousTaskFile[], etc) and then a DeviceIoControl() is called.
>
> Now I know Linux's version of DeviceIoControl is ioctl() and I've used
> it successfully for the INQUIRY command, but what's Linux's version of
> ATA_PASS_THROUGH_EX?
>
> Any help would be appreciated. Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>



-- 
- Goi Sihan
goister@gmail.com
