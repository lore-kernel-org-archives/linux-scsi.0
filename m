From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 17:23:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106222322.GC29126@redhat.com>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030106112259.B13916@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, luben@splentec.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Mon, Jan 06, 2003 at 11:22:59AM -0800, Matthew Dharm wrote:
> 
> The first case:  If the additional length indicates < 36 bytes, we should
> never issue the second request (which is where this device choked).  This
> should be a sanity check in scsi_scan.c, and it works for reasons I've
> previously outlined.

No, this should be fixed in usb code.  It's a hack, I know, but it's a 
hack to work around the fact that usb devices are broken by and large much 
more so than non-usb scsi devices.  Basically, the usb code has the 
ability to tell that 36 bytes were actually transferred, so the usb code 
should set the length byte in the return to max(actual_transfer - 5, 
current_length_byte);  In actuality, other scsi HBAs that know how many 
bytes were transferred by devices could do this as well, but they don't 
need to because their SCSI devices aren't so braindead....

> The second case:  This is a bad device.  A classic off-by-one error.  But
> what can usb-storage do?  We don't know that the device is bad.  But,
> focusing on this case, what happens?  Short data is returned... if the
> resid field is set to indicate this, then scsi_scan.c should be able to do
> something sane here.

Yep, as my previous email, scsi_scan.c should simply ignore the extra byte 
because we don't care about it in the least.

> Perhaps the "best" fix here is to simply make scsi_scan.c only send 36 byte
> inquiry requests if the bus is 'emulated'.  That would solve a world of
> problems....

Except that if a device *does* transfer 36 bytes and then lies and says it 
only transferred 5 then we are missing information that might actually be 
usefull, hence the reason to set the transfer length up to the real amount 
transferred (and BTW, I would only do this for INQUIRY responses, for 
anything else the device is simply too buggy to live if it lies about the 
transfer length).


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
