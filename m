From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 27 Apr 2003 10:41:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051458107.2427.25.camel@fuzzy>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
	<20030426151356.A8697@one-eyed-alien.net>
	<1051397024.4089.86.camel@mulgrave>
	<20030426183428.B8697@one-eyed-alien.net>
	<1051409717.4089.146.camel@mulgrave>
	<20030427023517.A15212@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:42500 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263138AbTD0P3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 11:29:52 -0400
In-Reply-To: <20030427023517.A15212@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Sun, 2003-04-27 at 04:35, Matthew Dharm wrote:
> I don't see a way to know the byte count without having additional
> knowledge about the device.  Maybe I'm wrong -- I certainly don't claim to
> be a SCSI expert.  So explain it to me.

Certainly.  It's documented in the SCSI3 Primary commands (for
reference, I'm using SPC-3 r12), section 4.3.

The SCSI opcode is divided into a group code (bits 7-5) and a Command
Code (bits 4-0), see section 4.3.4.1.

The group code identifies the command length:

Group		Length
0		6 byte
1		10 byte
2		10 byte
3		reserved (except for 0x7f, the variable length commands)
4		16 byte
5		12 byte
6		vendor specific
7		vendor specific

Thus, when you | 0x40 into MODE_SENSE, you change it from group0 to
group2 and it becomes a ten byte command.

For each of the non vendor specific groups, called the fixed length
commands, the location of the transfer count in each command is laid out
in the standard, too, section 4.3.3 (as well as other things like the
block location).

They are

Command	Size	transfer offset		transfer size
6 byte		byte 4			1 byte
10 byte		byte 7			2 bytes
12 byte		byte 6			4 bytes
16 byte		byte 10			4 bytes
32 byte(*)	byte 28			2 bytes

* The 32 byte commands are variable length commands (opcode 0x7f) with
Additional CDB length set to 0x18.  The actual command is specified in
the service action field (two bytes).

So the algorithm is quite simple: you get the command length from the
group (using a table with one exception for the 32 byte commands), and
then extract the transfer length from the command

For the other reserved or vendor specific commands, you just return -1
or some other indicator that we have to believe the buffer length to be
the command length.

James


