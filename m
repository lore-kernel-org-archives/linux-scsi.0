From: Matthew Wilcox <matthew@wil.cx>
Subject: Alternative TRIM proposal
Date: Thu, 2 Oct 2008 09:24:47 -0600
Message-ID: <20081002152446.GM13822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34250 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYJBPZE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 11:25:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Knight, Frederick" <Frederick.Knight@netapp.com>
Cc: t10@t10.org, linux-scsi@vger.kernel.org, dougg@torque.net, Martin Petersen <mkp@mkp.net>


There's a meeting tomorrow to discuss the T10 TRIM command.  The current
proposal can be seen at http://t10.org/ftp/t10/document.08/08-149r2.pdf
A related document (discussing READ after TRIM) can be found at
http://t10.org/ftp/t10/document.08/08-347r1.pdf

I'm not keen on the 'pass a list of blocks to be trimmed' model.  I would
prefer TRIM to be a real command like READ or WRITE.  To that end, here
are my notes on creating such commands, followed by an actual proposal.
I would welcome feedback on this, and it'd be most useful if such feedback
occurred within the next 24 hours so I can refine the proposal before
the meeting.

Notes
=====

SBC-3 specifies 6, 10, 12, 16 and 32 byte commands for each of READ and
WRITE as well as 10, 12, 16 and 32 byte commands for VERIFY.  While it
is tempting to only define a 32-byte TRIM command, that would prevent
older controllers from supporting TRIM, as well as being wasteful in the
on-wire encoding.  All drivers in Linux support at least 12-byte commands,
so I think we can avoid defining 6 and 10 byte variants of TRIM in order
to conserve the number of operation codes required for this proposal.

The 12-byte commands allow 32 bits for LBA and 32 bits for transfer length
(remember these are specified in sectors (normally 512 bytes), so support
drives up to 2TB in size).  The 16-byte commands expand the LBA size
to 64-bit, supporting drive sizes over 9000 Exabytes (8192 exbibytes,
I suppose).  The 32-byte commands add support for application tags.

The commands also include various fields which may or may not make sense
for TRIM.  Here's a list:

WRPROTECT	| The application may want the device to check protection
RDPROTECT	| information before allowing the TRIM to succeed.  This is
VRPROTECT	| the same case as VERIFY with BYTCHK=0.  See table 67 in
		| SAM 3 r14.

DPO		| Disable Page Out is not relevant to TRIM since the blocks
		| are being discarded.  Checking application tags may require
		| the blocks to be accessed, but they can always be discarded
		| immediately.  Recommend this bit be reserved.

FUA		| I don't see a reason to force unit access, recommend these
FUA_NV		| bits be reserved.

BYTCHK		| There might be a case to be made for allowing the device
		| to discard only if the data is still what it used to be,
		| but this would add additional complexity and I don't know
		| if it's worth it.  Reserve this bit.

GROUP NUMBER	| I can see it being useful to account TRIMs to different
		| groups and produce statistics about them, so recommend that
		| GROUP NUMBER be specified as it is for other commands.

CONTROL		| All commands shall contain the CONTROL byte as specified by
		| SAM 4.


Proposal
========

Define three new commands, TRIM (12), TRIM (16) and TRIM (32):

TRIM (12)
byte 0		OPERATION CODE (to be assigned)
byte 1		bits 7-5: VRPROTECT, bits 4-0: Reserved
byte 2-5	LOGICAL BLOCK ADDRESS
byte 6-9	TRANSFER LENGTH
byte 10		bits 7-5: Reserved, bits 4-0: GROUP NUMBER
byte 11		CONTROL

TRIM (16)
byte 0		OPERATION CODE (to be assigned)
byte 1		bits 7-5: VRPROTECT, bits 4-0: Reserved
byte 2-9	LOGICAL BLOCK ADDRESS
byte 10-13	TRANSFER LENGTH
byte 14		bits 7-5: Reserved, bits 4-0: GROUP NUMBER
byte 15		CONTROL

TRIM (32)
byte 0		OPERATION CODE (7Fh)
byte 1		CONTROL
byte 2-5	Reserved
byte 6		bits 7-5: Reserved, bits 4-0: GROUP NUMBER
byte 7		ADDITIONAL CDB LENGTH (18h)
byte 8-9	SERVICE ACTION (to be assigned)
byte 10		bits 7-5: VRPROTECT, bits 4-0: Reserved
byte 11		Reserved
byte 12-19	LOGICAL BLOCK ADDRESS
byte 20-23	EXPECTED INITIAL LOGICAL BLOCK REFERENCE TAG
byte 24-25	EXPECTED LOGICAL BLOCK APPLICATION TAG
byte 26-27	LOGICAL BLOCK APPLICATION TAG MASK
byte 28-31	TRANSFER LENGTH


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
