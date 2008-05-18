From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Sun, 18 May 2008 19:27:29 +0300
Message-ID: <483058F1.4020601@panasas.com>
References: <Pine.LNX.4.44L0.0805170933530.22979-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0805170933530.22979-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Maciej Rutecki <maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> Summary: 2.6.26-rc2 doesn't detect a USB drive's write-protect setting 
> correctly.
> 
> On Sat, 17 May 2008, Maciej Rutecki wrote:
> 
>> 2.6.25.4 (works fine):
>> http://unixy.pl/maciek/download/kernel/2.6.25.4/syslog_debug.txt
>> http://unixy.pl/maciek/download/kernel/2.6.25.4/usbmon.txt
>>
>> 2.6.26-rc2 ("write protect is on" problem; can't mount device):
>> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/syslog_debug.txt
>> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/usbmon.txt
> 
> I'm not sure exactly what changed to cause this regression, but the 
> problem lies in the SCSI layer, not the USB layer.
> 
> The logs show that in response to the 192-byte MODE SENSE command (used
> to read the write-protect status), the device sends back no data, good
> status, and Residue = 192.  The SCSI core ignores the Residue and
> thinks that the old left-over data in the buffer (in this case left
> over from the READ CAPACITY command) actually indicates the
> write-protect status -- which it obviously doesn't.
> 
> Boaz, is scsi_mode_sense() the right place to check for this sort of 
> thing?  It probably should be treated the same as an Illegal Request 
> error.
> 
> Alan Stern
> 

Do you mean this diff below:

@@ -796,133 +789,133 @@ kernel: usb-storage: *** thread awakened
 kernel: usb-storage: Command MODE_SENSE (6 bytes)
 kernel: usb-storage:  1a 00 3f 00 c0 00
 kernel: usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
 kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
 kernel: usb-storage: Status code 0; transferred 31/31
 kernel: usb-storage: -- transfer complete
 kernel: usb-storage: Bulk command transfer result=0
 kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
 kernel: usb-storage: Status code -32; transferred 0/192
 kernel: usb-storage: clearing endpoint halt for pipe 0xc0008480
 kernel: usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
 kernel: usb-storage: usb_stor_clear_halt: result = 0
 kernel: usb-storage: Bulk data transfer result 0x2
 kernel: usb-storage: Attempting to get CSW...
 kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
 kernel: usb-storage: Status code 0; transferred 13/13
 kernel: usb-storage: -- transfer complete
 kernel: usb-storage: Bulk status result = 0
 kernel: usb-storage: Bulk Status S 0x53425355 T 0x4 R 192 Stat 0x0
 kernel: usb-storage: scsi cmd done, result=0x0
 kernel: usb-storage: *** thread sleeping.
-kernel: sd 2:0:0:0: [sda] Write Protect is off
-kernel: sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
+kernel: sd 2:0:0:0: [sda] Write Protect is on
+kernel: sd 2:0:0:0: [sda] Mode Sense: 09 50 f8 af
 kernel: sd 2:0:0:0: [sda] Assuming drive cache: write through
 kernel: usb-storage: queuecommand called

("+" is the new kernel and "-" the older one)

It looks like it used to be the same exact return and everything only that at
old kernel the 4 bytes used to be zero and now they are not.

So It looks to me that it never used to work (Data was never actually read
from device) but by luck, the garbage data used to be a better default 
"Write Protect is off"

I do not think it is legal in scsi to return "Nothing was read" with no
error condition. You are probably right that we do not at all check resid
if status is 0, even though short reads are allowed with out error status
in some cases, as per command. But this is not the case here here nothing
was read at all, status must be returned. Or even worse if this command 
is mandatory by scsi but not supported by some USB devices then it will
have to be emulated by usb_storage.

My $0.017
Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
