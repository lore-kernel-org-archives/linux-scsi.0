From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [DOC PATCH]  T10/04-262r8
Date: Thu, 10 Nov 2005 10:58:39 -0500
Message-ID: <1131638319.3336.9.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>
	 <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>
		 <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>
		 <43721C3C.1010103@pobox.com> <1131553363.3271.1.camel@mulgrave>
	  <4372E66F.5070802@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:4490 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751069AbVKJP6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 10:58:51 -0500
In-Reply-To: <4372E66F.5070802@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: t.schorpp@gmx.de
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Thu, 2005-11-10 at 07:19 +0100, thomas schorpp wrote:
> how about full definitions of the pasthru cdb's in kernel structs and approbiate ioctls?

Why would we want to do that?  The whole point about pass through is
that it is designed to use the existing SCSI infrastructure
transparently (hence use SG_IO to send an ATA command to a bridge that
understands it---but the key point here is that the device so addressed
must understand the opcodes).

> the passthru cdb is also not clear enough to me:
> according to sat-r06 spec byte 0-2 is scsi, 3-9 are ata, 11 is scsi, yes?

Actually, no; byte 0 is the opcode, so you could call that SCSI and byte
11 (or 15) is the control as defined by SAM; the rest all contain SAT
specific fields.

James


