From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sun, 27 Apr 2003 21:52:08 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0304272130340.1366@kai.makisara.local>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
 <20030426151356.A8697@one-eyed-alien.net> <1051397024.4089.86.camel@mulgrave>
 <20030426183428.B8697@one-eyed-alien.net> <1051409717.4089.146.camel@mulgrave>
  <20030427023517.A15212@one-eyed-alien.net> <1051458107.2427.25.camel@fuzzy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:19956 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261362AbTD0Sjz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 14:39:55 -0400
In-Reply-To: <1051458107.2427.25.camel@fuzzy>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Sun, 27 Apr 2003, James Bottomley wrote:

> On Sun, 2003-04-27 at 04:35, Matthew Dharm wrote:
> > I don't see a way to know the byte count without having additional
> > knowledge about the device.  Maybe I'm wrong -- I certainly don't claim to
> > be a SCSI expert.  So explain it to me.
>
> Certainly.  It's documented in the SCSI3 Primary commands (for
> reference, I'm using SPC-3 r12), section 4.3.
>
...
> For each of the non vendor specific groups, called the fixed length
> commands, the location of the transfer count in each command is laid out
> in the standard, too, section 4.3.3 (as well as other things like the
> block location).
>
Quoting from 4.3.1:
---
The fields shown in 4.3.2 and 4.3.3 and described in 4.3.4 are used
consistently by most commands. However, the actual usage of any field
(except OPERATION CODE and CONTROL) is described in the subclause defining
that command.
---

This does not say that _all_ commands behave according to this
description. An example is the READ_6 command for sequential access
devices. The opcode defines a 6 byte command. Transfer length in this
command occupies bytes 2 - 4 (3 bytes instead of 1). This does not
necessarily specify the transfer length in bytes. Bit 0 of byte 1
specifies if the command uses fixed block size or variable block size. If
fixed block size is specified, the transfer length field has to be
multiplied by the block size. This may have been earlier specified using
a MODE SELECT command (in block descriptor). However, the MODE SELECT may
not have been used if the user knows the block size. The mid-level code
should the perform and extra MODE SENSE to get the blocks size. In case
of a very old device, MODE SENSE may not even be supported (optional in
SCSI-1).

I would say the mid-level should not try to determine the transfer
length ;-(

-- 
Kai
