From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 24 Mar 2003 10:43:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048524232.3435.47.camel@mulgrave>
References: <Pine.LNX.4.44.0303240827030.3010-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0303240827030.3010-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 2003-03-24 at 10:29, Linus Torvalds wrote:
> Really? The code was _supposed_ to always start off with READ/WRITE_10's,
> and then fall back to the old READ/WRITE_6 if it gets errors from that. Do 
> we really have some broken random-number generator semantic still in teh 
> SCSI layer? That sounds like a piece of crock.

Well, OK, the whole story is that sd does size the command according to
the request, as I said before.  However, if the six byte command fails
with an illegal request sense then we'll retry it at ten bytes and lock
the device to accept only ten byte commands using the ten flag in the
struct scsi_device.

We never do sixteen byte commands unless a region of the device >2Tb is
accessed (in which case the device must support sixteen byte commands).

I think this behaviour is reasonably optimal.  I suspect more ancient
SCSI-1 devices would have issues with READ/WRITE_10 than modern devices
that don't do READ_6 but also are unable to return the correct error
code.

James


