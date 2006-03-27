From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Mon, 27 Mar 2006 09:40:01 -0600
Message-ID: <1143474001.3334.11.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
	 <20060326200522.GA3486@parisc-linux.org>
	 <Pine.LNX.4.58.0603271158360.3209@be1.lrz>
	 <20060327152026.GG3486@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751102AbWC0PkO@vger.kernel.org>
In-Reply-To: <20060327152026.GG3486@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-03-27 at 08:20 -0700, Matthew Wilcox wrote:
> So we don't currently save the scsi_lun anywhere.  We, er, translate it
> into a 32-bit int, and carry that around.  Obviously this is going to
> have to change for things like iSCSI, but this is totally offtopic for
> your patch.  So I agree with you, whoever adds the 64-bit LUN support
> gets to patch the ioctl struct too.

Actually, this is precisely the argument for why we don't want such an
ioctl at all.  This area is one of the ones there should be significant
changes in for the forseeable future.  32->64 bit LUNs are probably only
the start; then there'll be elimination of the target ID (or replacing
it with a string).  If we have this ioctl, every time this area changes,
so now does the user ABI.

Finally, I really don't think we want to encourage anybody in userspace
to rely on a string of internally generated numbers ... that's what
sysfs paths are for, but at least they're simply strings opaque, so we
can change them.

James
