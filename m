From: Peter Wu <lekensteyn@gmail.com>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using xhci_hcd"
Date: Fri, 02 Aug 2013 12:32:44 +0200
Message-ID: <2872274.yGHX7ixWqU@al>
References: <51F44125.2040803@ntlworld.com> <Pine.LNX.4.44L0.1307281505410.18237-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1307281505410.18237-100000@netrider.rowland.org>
Sender: stable-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stuart Foster <smf.linux@ntlworld.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday 28 July 2013 15:28:52 Alan Stern wrote:
> On Sat, 27 Jul 2013, Stuart Foster wrote:
> > On 07/27/13 20:34, Alan Stern wrote:
> > > On Sat, 27 Jul 2013, Stuart Foster wrote:
> > >> On 07/27/13 15:58, Alan Stern wrote:
> > >>> On Sat, 27 Jul 2013, Stuart Foster wrote:
> > >>>> Hi,
> > >>>> 
> > >>>> I have started having problems with an external USB 3 diskdrive, the
> > >>>> problems started when I moved from the 3.10.2 kernel to 3.10.3.
> > >>>> The machine is a ASUS M5A97 PRO, BIOS 1604.
> > >>> 
> > >>> On Sat, 27 Jul 2013, Ed Tomlinson wrote:
> > >>>> Hi
> > >>>> 
> > >>>> Same problem here with 3.10.3.  Dmesg filtered with 'hci'.
> > >>> 
> > >>> Each of you, please post a usbmon trace showing what happens when the
> > >>> drive is plugged in.
> > >>> 
> > >>> Alan Stern
> > >> 
> > >> Hi Alan
> > >> 
> > >> Herewith the log you requested.
> > > 
> > > The trace shows that something is sending an invalid INQUIRY command
> > > (one with a 512-byte transfer length) to the drive.  Normally such
> > > things are done by user programs, but in this case it looks more like
> > > the command came from somewhere in the kernel.  I have no idea where.
> > > 
> > > Did you change anything besides the kernel when going from 3.10.2 to
> > > 3.10.3?
> > > 
> > > If you boot now into a 3.10.2 kernel, does the drive work?
> > > 
> > > What happens if you plug the drive into a USB-2 port?  (I expect it
> > > will make no difference at all.)
> > > 
> > > Alan Stern
> > 
> > Hi Alan,
> > 
> > The config between 3.10.2 and 3.10.3 did not change.
> > 
> > The drive works correctly on 3.10.2 (I usually keep the previous kernel
> > available just in case).
> > 
> > On 3.10.3 the drive fails in a similar manner when plugged into a USB-2
> > port.
> > 
> > For interest I have tried the USB-3 drive in the USB-2 ports on an IBM
> > thinkpad R51 laptop that is also running 3.10.3 and that fails also.
> > 
> > Conversely I have tried a USB-2 drive on both the IBM and my ASUS
> > machine and that works fine on 3.10.3 in all available USB ports.
> 
> Thank you.  I was able to duplicate the problem on my own machine and
> track down the bug.
> 
> It was introduced by commit 98dcc2946adb (SCSI: sd: Update WRITE SAME
> heuristics).  This commit adds a call to scsi_get_vpd_page() in
> sd_read_write_same() without first checking sd_try_extended_inquiry().
> As noted in the latter routine, VPD inquiries will crash some devices.
> 
> Martin, this bug needs to be fixed in 3.11.  As far as the stable
> kernels are concerned, the best thing for now may simply be to revert
> it.
> 
> Alan Stern

Hi,

I am also affected by this bug, this one is broken:
scsi 7:0:0:0: Direct-Access     Kingston DataTraveler 2.0 1.00 PQ: 0 ANSI: 4
sd 7:0:0:0: Attached scsi generic sg2 type 0
sd 7:0:0:0: [sdb] 15138816 512-byte logical blocks: (7.75 GB/7.21 GiB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 2f 00 00 00
sd 7:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
** USB device removed here after ten seconds **
usb 2-1.2: USB disconnect, device number 7
sd 7:0:0:0: [sdb] Attached SCSI removable disk

This device is still working on the same kernel:
scsi 14:0:0:0: Direct-Access     SanDisk  Cruzer Blade     8.02 PQ: 0 ANSI: 0 CCS
sd 14:0:0:0: Attached scsi generic sg2 type 0
sd 14:0:0:0: [sdb] 15695871 512-byte logical blocks: (8.03 GB/7.48 GiB)
sd 14:0:0:0: [sdb] Write Protect is off
sd 14:0:0:0: [sdb] Mode Sense: 45 00 00 08
sd 14:0:0:0: [sdb] No Caching mode page present
sd 14:0:0:0: [sdb] Assuming drive cache: write through
sd 14:0:0:0: [sdb] No Caching mode page present
sd 14:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 14:0:0:0: [sdb] No Caching mode page present
sd 14:0:0:0: [sdb] Assuming drive cache: write through
sd 14:0:0:0: [sdb] Attached SCSI removable disk

Reverting 98dcc2946adb on top of v3.11-rc3-207-g64ccccf works for me (tested
through QEMU with USB passthrough). I noticed this issue since 3.11-rc2
(previous kernel was 3.10.0).

I've two affected USB 2.0 sticks (in a USB 2.0 port) and one that is still working:
- "1516:1213 CompUSA" - broken
- "0951:1665 Kingston Technology" - broken
- "0781:5567 SanDisk Corp. Cruzer Blade" - working

If it helps, this is when the affected USB stick is plugged in:
# cat /proc/$(pidof usb-storage)/stack
[<ffffffffa0566f21>] usb_stor_msg_common+0xf1/0x170 [usb_storage]
[<ffffffffa0567349>] usb_stor_bulk_transfer_buf+0x59/0xa0 [usb_storage]
[<ffffffffa056763c>] usb_stor_Bulk_transport+0x15c/0x330 [usb_storage]
[<ffffffffa0567e18>] usb_stor_invoke_transport+0x38/0x550 [usb_storage]
[<ffffffffa0566b4e>] usb_stor_transparent_scsi_command+0xe/0x10 [usb_storage]
[<ffffffffa0568c63>] usb_stor_control_thread+0x173/0x290 [usb_storage]
[<ffffffff8106ef1a>] kthread+0xea/0xf0
[<ffffffff815b5fdc>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

Let me know if I should provide further details like usbmon or test something.

Regards,
Peter
