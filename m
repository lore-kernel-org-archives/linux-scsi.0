From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 13:54:32 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0301061343210.1054-100000@ida.rowland.org>
References: <3E19B24D.1080500@splentec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E19B24D.1080500@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Andries.Brouwer@cwi.nl, mdharm-kernel@one-eyed-alien.net, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Mon, 6 Jan 2003, Luben Tuikov wrote:

> In this most recent case reported, this looks very similar to
> overflow residual, but not quite the same. I.e. *more* data is
> actually immediately available (in the buffer) than *we requested* or can
> find out by other means (i.e. checking the ADDITIONAL LENGTH field).

In the case reported, the problem was not that there was additional data
immediately available.  In fact, there was not any additional data.  The
problem was that the firmware returned a value in the ADDITIONAL LENGTH
field indicating that additional data existed when in fact it did not.
(The host requested 36 bytes, the device returned 36 bytes and indicated
that one more byte was available, the host then requested 37 bytes, and
the device returned a short reply of 36 bytes.)

> But if we requested 36 and the transport provided 36 then the
> residual should be 0 (set by the transport).

As indeed it would be.

> Had we requested 5 and the
> transport provided 36 then the residual should be 31, but there's no way
> of reporting this residual, since it is an *overflow* residual, and from
> the comments therein, cmd->resid is *only underflow* residual.

No.  This can't happen at all with USB; the protocol does not allow the
device to return more data than the host requested.

Alan Stern

