From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Mon, 27 Mar 2006 08:20:26 -0700
Message-ID: <20060327152026.GG3486@parisc-linux.org>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz> <20060326200522.GA3486@parisc-linux.org> <Pine.LNX.4.58.0603271158360.3209@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751083AbWC0PUa@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0603271158360.3209@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 27, 2006 at 12:11:14PM +0200, Bodo Eggert wrote:
> > > +			__put_user(0, &idp->unused[0]);
> > > +			__put_user(0, &idp->unused[1]);
> > 
> > Is it time to repurpose the unused bytes for the 64-bit LUN?
> 
> ACK, but I didn't find out how to fill it, and having ints instead of
> __uXX made the struct look ugly. Therefore I postponed it to a later patch.

So we don't currently save the scsi_lun anywhere.  We, er, translate it
into a 32-bit int, and carry that around.  Obviously this is going to
have to change for things like iSCSI, but this is totally offtopic for
your patch.  So I agree with you, whoever adds the 64-bit LUN support
gets to patch the ioctl struct too.
