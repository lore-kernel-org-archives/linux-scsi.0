From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Question about LS120 floppies
Date: Sun, 02 Aug 2009 20:42:43 -0600
Message-ID: <4A764EA3.5050708@gmail.com>
References: <4A4BC762.3090104@lwfinger.net>	<4A4C441B.6050808@gmail.com>	<4A4CBD9E.4070404@lwfinger.net> <20090702181240.747e4063@lxorguk.ukuu.org.uk> <4A4D48A6.2060204@gmail.com> <4A761EED.4030606@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A761EED.4030606@lwfinger.net>
Sender: linux-ide-owner@vger.kernel.org
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, Roland Hughes <roland@logikalsolutions.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/02/2009 05:19 PM, Larry Finger wrote:
> Robert Hancock wrote:
>> Yes, definitely a lot of uninformed speculation on that thread. The
>> floppy driver has nothing to do with any IDE/ATA drive like this, and if
>> OpenSUSE is using libata drivers then attempting to load the IDE floppy
>> driver is also useless.
>>
>> It would be useful if the reporter could verify that the drive is at all
>> functional with that media under any OS. That "Cannot read medium -
>> unknown format" is being reported by the drive itself in response to a
>> "read capacity" request, not the driver. So unless there's some magic
>> that the driver needs to do to get the drive to recognize the disc, it
>> seems like a hardware problem.
>
> Since the last posting on this thread, I have acquired the hardware
> from Roland Hughes. He reports that it worked with Ubuntu Hardy,
> FreeDOS and Windows XP. I am assuming that the hardware is OK, but it
> certainly is strange. I don't know the details for all commands, but
> the command to get the capacity is 0x23 rather than the standard 0x25.
>
> Will it be possible to make such strange hardware work under libata?
> Is there a document that shows how to implement quirky devices? I
> found the scsi_static_device_list[] entries, but also saw the
> admonition not to add to that list.

Well, it looks like there is some specific code for this drive in 
drivers/ide/ide-floppy.c that uses READ FORMAT CAPACITIES, which "allows 
the Host to request a list of the possible format capacities
for an installed writable media" instead of READ CAPACITY. The code in 
the sd driver (which gets used under libata) doesn't do that. However 
from my reading of the MMC spec (which is where READ FORMAT CAPACITIES 
is defined), it seems like READ CAPACITY should still work. (But then I 
wouldn't be surprised if the manufacturer used the SCSI/MMC standards as 
toilet paper..)

Supposedly LS-120 disks are pre-formatted, so the "cannot read medium - 
unknown format" error is rather bizarre. It would definitely be useful 
to verify that this drive is at all functional under an older distro 
using the IDE drivers, or WinXP before spending too much time on it..
