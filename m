From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Tue, 27 Mar 2012 08:30:43 +0900 (JST)
Message-ID: <224002.28941.qm@web100019.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1203261007290.1384-100000@iolanthe.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1203261007290.1384-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Executive summary:
It is probably sd_mod which is too aggressive in failing reads, and which needs the same fix that libata and linux-ide received a few years ago.  Now adding the linux-scsi mailing list and quoting my original (faulty) report at the bottom of this message.

Matthew Dharm corrected me:
> Actually, ehci_hcd has nothing to do with this.  The problem in likely in sd_mod or the scsi core.  Those are the modules that translate your userspace request for a single block into a scsi request, which is then processed by usb-storage and passed to the usb core

OK.  Since libata and linux-ide had been fixed some years ago, and I saw ehci_hcd assigned to the interface I was using yesterday, I blamed the wrong victim.  I understand it's likely to be sd_mod or usb-storage.

> So, the problem is that sd_mod is turning your request for a single block into a request for several blocks.

That's part of the problem.  Readahead is not a bad thing to do.  The problem is that sd_mod or whoever is too aggressive.  Instead of marking buffers for nearby blocks as not having valid data available, it further refuses to supply valid data for the good block and errors out a call that should have succeeded.  libata and linux-ide used to have the same defect before they were fixed.

> As for needing unplug and replug, likely the firmware in your device is crashing when it encounters a bad block. So there is nothing which can be done to recover aside from resetting the device with an unplug/replug cycle.

The disk's firmware correctly reports a read error when reading the bad block and correctly proceeds to obey later commands to read good blocks if so ordered.  This is the same drive that I mounted on a motherboard's IDE connector a few years ago when testing linux-ide and libata.  However, if you blame the usb-to-ide bridge's firmware, I'll try to find a way to test it.

Alan Stern also corrected me:
> It is the block layer which insists on reading an entire page at a time.

Understood.

> This has nothing at all to do with ehci-hcd.  You can prove this (assuming your computer has a UHCI or OHCI controller) by unloading ehci-hcd and running the test again.

I understand that ehci-hcd can be unloaded and reloaded (well, sometimes I can't rmmod some other drivers, but I understand how to try).  I don't see how that would prove anything though.

> ehci_hcd does not try to reassign anything.  Rather, it is usb-storage which resets the non-working device.

OK.  I have a feeling that usb-storage is overly aggressive in resetting a device and trying to assign a new address.  The drive does not need resetting; I mentioned above that it correctly reports a bad block and correctly continues operating.  Though if the USB-to-IDE bridge is to blame, I'll try to find a way to test it.

> If the device were working properly, unplugging and replugging it wouldn't be necessary.  The failure is entirely the device's fault.

I do not believe that.  The drive's report of failure to read a bad block is correct operation by the drive.  Mishandling of a correct error report is the fault of the driver that mishandles the report.

I originally wrote (blaming the wrong component):
>> dd if=/dev/sdb of=/dev/zero bs=512 count=1 skip=551563
>> should succeed because block 551563 has no problem.  But it fails because ehci_hcd insists on reading blocks 551560 through 551567, and block 551562 does have a problem.
>>
>> Some years ago similar problems in linux-ide and libata were fixed.  ehci_hcd would also benefit from fixing.
>>
>> ehci_hcd has further problems.  After failing to read block 551562, it tries to reassign device addresses on the USB bus, fails repeatedly, and gives up.  Unplugging and replugging the USB cable fixes this, so that block numbers far enough away from bad blocks can be read again.  I think that unplugging should not be necessary.
>>
>> (Of course I should have been outputting to /dev/null instead of /dev/zero but that should not matter.)
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
