From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] megaraid driver fix for 2.5.70
Date: 05 Jun 2003 10:07:24 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1054822044.1792.48.camel@mulgrave>
References: <1054650567.13617.12.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1054650567.13617.12.camel@markh1.pdx.osdl.net>
To: Mark Haverkamp <markh@osdl.org>, atulm@lsil.com
Cc: Linus Torvalds <torvalds@transmeta.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2003-06-03 at 10:29, Mark Haverkamp wrote:
> A recent change to the megaraid driver to fix some memset calls resulted
> in overflowing the arrays being cleared and causing a system panic. 
> This patch fixes the problem by making sure that the arrays being
> cleared are dimensioned to the correct size.  The patch has been tested
> on osdl's stp machines that have megaraid controllers.

This patch doesn't quite look like a fix to me:  The megaraid mailboxes
are always >16 bytes *but* none of the setting commands is supposed to
touch any of the status parts (which begin at byte 15), so I don't see
how your patch would prevent a panic.

It also looks like the first fifteen (not sixteen) bytes are user data
and the remaining 51 are for data from the card.

It thus looks like this memcpy in both issue_scb() and issue_scb_block()
may be wrong

	memcpy((char *)mbox, (char *)scb->raw_mbox, 16);

because it's overwriting the mbox->busy return.

Logically, it looks like the mbox_t should be split up into an mbox_out
(which is what all the routines want to set values in) and an mbox_in
which is where the status is returned.

James
