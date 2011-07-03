From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sun, 3 Jul 2011 02:14:30 -0700
Message-ID: <CAA9_cmd7KV_CkvbB+nsc7LHui8gECB-0d4oWt+6cA0x21=crDg@mail.gmail.com>
References: <1309609482.2554.8.camel@mulgrave>
	<Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@hansenpartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 2, 2011 at 10:37 AM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> The second bug, which hit me but apparently not any of you, is that t=
he
> request_queue's elevator gets deallocated while it is still in use.
> That's because __scsi_remove_device() calls scsi_free_queue(), which
> does blk_cleanup_queue(), which calls elevator_exit(), even though th=
e
> device file is still open and more requests will be submitted when th=
e
> file is closed.
>
> I'm not sure of the right fix for this. =A0One possibility is to move=
 the
> scsi_free_queue() call to scsi_device_dev_release_usercontext(). =A0O=
r
> maybe the elevator_exit() call should be moved to blk_release_queue()=
=2E
>
> Also, I have no idea why this shows up with USB drives but not other
> SCSI transports. =A0A fluke of timing?
>

Not sure it's related, but it sounds like the hotplug failures being
seen with libsas hotplug.  Have not had a chance yet to track it down
further with isci, but mvsas developer Xiangliang Yu is reporting:

http://marc.info/?l=3Dlinux-scsi&m=3D130707166512002&w=3D2

He tracked it down to a suspected regression between .39-rc4 and
=2E39-rc5 but did not finalize the bisect.

The isci driver sees this and other signatures all seemingly related
to early device tear down and only when pulling a drive with in-flight
i/o.

--
Dan
