From: tmhikaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem readonly
Date: Mon, 23 Nov 2009 18:42:34 -0500
Message-ID: <20091123234234.GA22126@roll>
References: <20091123200605.GA19446@roll> <Pine.LNX.4.44L0.0911231533071.2958-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911231533071.2958-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: tmhikaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2009 at 03:33:56PM -0500, Alan Stern wrote:
> On Mon, 23 Nov 2009 tmhikaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> 
> > Uhh, this could be a problem. CONFIG_USB_MON=y is set in my .config BUT,
> > although I followed the directions and debugfs is mounted,
> > 
> > root@roll:/home/tm# mount
> > /dev/root on / type ext4 (rw,relatime,barrier=1,data=ordered,data_err=abort)
> > proc on /proc type proc (rw)
> > sysfs on /sys type sysfs (rw)
> > usbfs on /proc/bus/usb type usbfs (rw)
> > none_debugs on /sys/kernel/debug type debugfs (rw)
> > 
> > I receive this message when I test if usbmon's directory exists:
> > 
> > root@roll:/home/tm# ls /sys/kernel/debug/usbmon
> > ls: cannot access /sys/kernel/debug/usbmon: No such file or directory
> > 
> > According to the kernel documentation usbmon should be loaded already. Help?
> 
> The documentation is slightly out of date.  The usbmon directory has 
> been moved down a level, to /sys/kernel/debug/usb/usbmon.
> 
> Alan Stern

Thank you. I've gotten output of it screwing up, but it's a 62MB file. I
don't think I'm allowed to send attachments here, nor do I know what I'm
supposed to be looking for in this output. So, instead I'm putting the
(compressed) file up on my home computer. If you've got suggestions for what
I should use instead, let me know.

http://hikaru.no-ip.info:3000/1.mon.out.xz

Although I don't think you'll need it, I've included the dmesg output of
what happened when I ran my backup script, just in case it helps at all.

Thanks for the help so far,
Tim McGrath


usb 1-6: new high speed USB device using ehci_hcd and address 2
usb 1-6: New USB device found, idVendor=0471, idProduct=0332
usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=0
usb 1-6: Product: Philips SPC 1000NC Webcam
usb 1-6: Manufacturer: Philips CE
usb 1-6: configuration #1 chosen from 1 choice
2:3:1: cannot get freq at ep 0x84
usbcore: registered new interface driver snd-usb-audio
usb 1-3: new high speed USB device using ehci_hcd and address 3
usb 1-3: New USB device found, idVendor=067b, idProduct=2506
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: Mass Storage Device
usb 1-3: Manufacturer: Prolific Technology Inc.
usb 1-3: SerialNumber: 0
usb 1-3: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
scsi 0:0:0:0: Direct-Access     ST325082 3A               3.06 PQ: 0 ANSI: 0
usb-storage: device scan complete
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
usb 1-6: USB disconnect, address 2
EXT4-fs (sda1): barriers enabled
kjournald2 starting: pid 9416, dev sda1:8, commit interval 5 seconds
EXT4-fs (sda1): internal journal on sda1:8
EXT4-fs (sda1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sda1): mounted filesystem with ordered data mode
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 44783
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 51823
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
