From: Grant Grundler <grundler-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Subject: Re: udev hangs USB-storage (HP r707 camera)
Date: Sat, 19 Jan 2008 19:57:08 -0700
Message-ID: <20080120025708.GH11553@colo.lackof.org>
References: <20080119174556.GE11553@colo.lackof.org> <47929B9F.8080607@s5r6.in-berlin.de> <20080120022829.GG11553@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080120022829.GG11553-lGaJ6EKWmV+kGg0756fqLw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 19, 2008 at 07:28:29PM -0700, Grant Grundler wrote:
...
> Thanks for reminding me...I had collected strace output of udev and all
> it's children a few days ago (probably with 2.6.22-14-generic (Ubuntu
> kernel). I've appended everything for PID 17972 (which is only 12k, full
> output is 559KB). Key bit is this:
> 17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
> 17972 read(3,  <unfinished ...>
> 17972 <... read resumed> 0x804dc80, 512) = -1 EIO (Input/output error)
> 
> given the device reports "60801 512-byte hardware sectors (31 MB)"
> and "31129600/512 == 60800"...it's obvious vol_id is trying to read
> the last sector on the disk (I assume it's to verify the size).
> ISTR "reading the last sector" caused problems else where.
> I'll try to hunt that down.

That was too easy.
http://www.cs.helsinki.fi/linux/linux-kernel/2001-23/0960.html
Is 1K alignment still a problem?

Or I have to add the HP r707 to some list per comments from this patch:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.17-rc2/2.6.17-rc2-mm1/broken-out/git-ieee1394.patch

+ * - fix capacity
+ *   Tell sd_mod to correct the last sector number reported by read_capacity.
+ *   Avoids access beyond actual disk limits on devices with an off-by-one bug.
+ *   Don't use this with devices which don't have this bug.

hunting more...

grant
