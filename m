From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Sun, 28 Jul 2002 13:22:40 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207281300320.942-100000@kai.makisara.local>
References: <20020727195503.C3121@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020727195503.C3121@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

On Sat, 27 Jul 2002, Matthew Dharm wrote:

> ARGH!!
>
...
> Emulated SCSI busses _need_ to know how much data to move.  usb-storage has
> a large table to try to figure it out, but it only gets the correct answer
> in _most_ cases, not all cases.  Only the originator of the command truly
> knows how much data is going to be moved, so the only mechanism that makes
> sense is to make the originator of the command indicate that number via
> some mechanism.
>
Note that even the originator does not always know how much data will be
transferred. One example is reading a tape block in variable block mode.
The originator specifies the maximum length but the target returns less if
the block is shorter.

The current interface is a little messy. The function scsi_do_req has the
following signature:

void scsi_do_req(Scsi_Request * SRpnt, const void *cmnd,
              void *buffer, unsigned bufflen, void (*done) (Scsi_Cmnd *),
                 int timeout, int retries)

Here bufflen is defined "size of data buffer". In order to see what is
really desired to be done, one must additionally look at some fields in
the Scsi_Request: if SRpnt->sr_use_sg is non-zero, buffer points to a
scatter/gather list. Otherwise it points to the continguous buffer.

A common interpretation seems to be that bufflen is the buffer length only
when scatter/gather is used. Otherwise the buffer length is computed from
the scatter/gather elements and bufflen is a parameter with no meaning.

Another interpretation (which I have used) is that the bufflen parameter
is always the length of the buffer _used in this transfer_. Whether the
buffer is contiguous or defined using scatter/gather list is determined by
SRpnt->sr_use_sg. (The lower level drivers don't have to know the actual
length of the buffer as long as it is long enough.)

The second interpretation has the transfer length in exactly one place. In
the first interpretation a complicated logic (or a new structure member)
is needed to get the transfer length. Do we need this or should we just
enforce the second interpretation (maybe change the name bufflen to
maxtransfer or something like that)?

(If the new structure member dxfer_len is useful to lower level drivers, I
don't oppose adding it to Scsi_Request as long as it is set in
scsi_do_req. What I am opposing is to make the callers responsible for
redundant specifications.)

	Kai




