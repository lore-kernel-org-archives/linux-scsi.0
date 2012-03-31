From: "Norman Diamond" <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Sat, 31 Mar 2012 12:36:50 +0900
Message-ID: <BA1D046C8A454166BF330A4A89630D1F@diamond1720>
References: <Pine.LNX.4.44L0.1203301011050.1280-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Fri, 30 Mar 2012, Norman Diamond wrote:
[Attribution lost:]
>>> It is a separate value from the product ID. It appears in the output 
>>> from "lsusb -v" or in /sys/kernel/debug/usb/devices (where it is 
>>> labelled "Rev=").
>>
>> bcdDevice is 1.00
>
> That's the same as a bridge that was reported non-working.  Which means 
> the OS has no way to tell them apart.

There's still something wrong here.  When the bridge is connected to Windows 
XP, Windows accesses the correct number of blocks.  We need to find someone 
who has a non-working but indistinguishable bridge, ask them to connect it 
to Windows XP, and see if Windows XP gets a number of blocks that is too 
large by 1.

>>>> It is hard to imagine a USB bridge adding 1 to the number of blocks. 
>>>> Did that really happen?
>>>
>>> No. What happened was that the bridge reported the number of blocks, but 
>>> SCSI's READ CAPACITY command requires the device to report the highest 
>>> available block number (which is one smaller since blocks are numbered 
>>> starting from 0).
>>
>> I guess you mean that some USB bridges screw up the result of the READ 
>> CAPACITY command, so you have to subtract 1 in those cases.  This 
>> particular bridge isn't one of them, and the subtraction of 1 was wrong 
>> in this case.
>
> True, but the computer has no way to know.  However you can tell 
> usb-storage not to manipulate the capacity of your drive by specifying a 
> module parameter:
> modprobe usb-storage quirks=067b:2507:

I have to find the appropriate file to modify under /etc/modsomething.d. 
It's been a while but I'll find it again.

>> hdparm reports the bugged capacity after the incorrect subtraction of 1. 
>> HDIO_GETGEO_BIG also gets the bugged capacity.  I don't see an option to 
>> sdparm to get the device capacity (real SCSI devices probably have it in 
>> a VPD page but this USB bridge doesn't provide any VPD pages).
>
> I don't know if the information would be in a VPD page or not.  There's 
> not much point in putting it there, since it's already available via READ 
> CAPACITY.

OK.  Anyway VPD pages seem to be irrelevant to discussions of USB-to-ATA 
bridges.

>> sg_dd with correct parameters successfully read the actual last block! 
>> That must be because sg_dd accessed /dev/sgsomething instead of 
>> /dev/sdmumble.
>>
>> My program doesn't know if a USB bridge is defective and/or if a driver 
>> defectively manipulated a block count.  So I have to open a 
>> /dev/sgsomething, try to read 1 sector past the last sector that we think 
>> is valid.  If it fails then I have to find out if the error was due to 
>> nonexistence or other reason.  If it succeeds then I have to execute more 
>> painful hacks that I have to add.
>
> It's not as simple as that.  With many bridges, if you test to see whether 
> the block count is too small by trying to read "the block beyond the end", 
> you will hang the bridge -- requiring an unplug to fix.

Hey, just like my bridge hanged when reading an existing but defective block 
(for which the drive reported its own error).  Actually in yesterday's test, 
I also tried to read 1 sector past the actual last block and got the error 
that I was expecting for that.  I forgot to check if the bridge hanged at 
that point.  I'll have to test that again.

> There is no good solution to this problem.

Agreed.  But in my case I think I need to disable that quirk entirely for 
all USB bridges, so that my uses of Linux will always believe what the USB 
bridge reports.  At least then my program will work correctly when working 
bridges are attached.  Then if a user complains, we can tell them to use a 
different bridge. 

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
