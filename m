From: Charles Hannum <root@ihack.net>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone
 (one line)
Date: Thu, 12 May 2011 18:41:32 -0400
Message-ID: <BANLkTinYvgcT8OqD9Fc7e_w1FPEchRkGLQ@mail.gmail.com>
References: <Pine.LNX.4.44L0.1105121711100.1917-100000@iolanthe.rowland.org>
	<1305236616.2575.95.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305236616.2575.95.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 12, 2011 at 17:43, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> It depends what the drive is caching and what's removable. =A0If it's=
 some
> type of hybrid, and the cache isn't mapped to the media for instance.

Except that the SCSI spec says the cache affected by SYNCHRONIZE CACHE
is related to the medium.

> The point really is that if the cache is in the housing, setting it t=
o
> write through when it's not is not a correct reflection of reality.

Since this pretty clearly violates the intent of the spec, I have to
ask whether you are aware of any such device.  I've never seen one.

Also, the only actual behavioral difference between my proposed patch
and your proposed one is to print out a message; you still weren't
calling sd_sync_cache() if the medium was not present.  I'm not
beholden to a specific patch=97but printing out an extra message, which
seems to imply that something is wrong, is decidely uncool in the
original case I referenced (my Android phone, after =93Turn on USB
storage=94 and then =93/usr/bin/eject=94), where nothing is wrong other=
 than
the driver trying to SYNCHRONIZE CACHE to a medium that it already
knows is not present.

> or actually, just checking the value when it looks at the return code=
=2E

That was what I did first, but then I realized two things:

1) The pre-use (before clicking =93Turn on USB storage=94) state has
WCE=3D=3D0 because the mode page code hasn't been called at that point.
There is no good reason the pre-use and post-eject behavior should be
different, given that the device itself is in *exactly* the same state
at these points.

2) I definitely do not want a spurious message that could be
interpreted as an error, since this is perfectly normal and acceptable
use.
