From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 11:05:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B464AAEC-F526-11D8-BFA2-00039398BB5E@ieee.org>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patli
	 nux.iomegacorp.com> <20040823154648.GB2301@suse.de> <412A15EC.8040903@pobo
	x.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:58335 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265978AbUHWRFz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 13:05:55 -0400
In-Reply-To: <412A15EC.8040903@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

> Speaking of which...  (WARNING: change of topic; or perhaps, getting 
> back on topic :))

Part of my initial ambiguity is now clear to me.  I said max 
"bytes/CDB" to mean "max data bytes per CDB", which is more often in 
dispute than "max bytes of CDB", which was nonetheless what some of us 
thought I meant.

>> Ok, makes more sense to me now. The reason why I get confused is that 
>> I
>> don't consider the cdb more than the actual 10-16 bytes of command 
>> data
>> bytes, not the full structure of it.

That English doesn't yet make sense to me.  I don't know what "the full 
structure" is.

I agree CDB and data and status and auto sense all form part of the 
bits copied between device and host in each transaction.  For the 
rendezvous itself I have no clearly appropriate and unambiguous English 
term.

I see the word "command" can mean the whole transaction or just the CDB.

I suppose CDB stands for "command data bytes".  That expansion doesn't 
help, does it?  That phrase uses the word "data" in a pointless 
redundancy I think - in that context, there are no "bytes" which are 
not "data".

> like to see support for CDBs larger than 16 bytes in struct request.

Often xC (12), not even x10 (16), is the CDROM_PACKET_SIZE limit of 
struct cdrom_generic_command of include/linux/cdrom.h

My survey at sourceforge.net iomrrdtools rrd iomscsi xscsi.h is:

/* Recommend a limit for the length in bytes of the CDB.
  *
  * Consider the limits:
  *
  *      xC      // common max of SCSI over IDE
  *      xC      // common max of SCSI over 1394 i.e. xC = (x20 - x14)
  *      xC      // seen as max of Linux ioctl CDROM_SEND_PACKET
  *      x10     // max SCSI over IDE
  *      x10     // max SCSI over USB
  *      x10     // max declared SCSI thru Dos Aspi or Win32 Ioctl
  *      x10     // max SCSI-3 for standard op xXX other than x7F
  *      xFF     // common max of SCSI pass thru
  *      x104    // max SCSI-3 permits for op x 7F XX XX = 8 + xFC
  *      x107    // max SCSI-3 expresses for op x 7F XX XX = 8 + xFF
  *      x3E8    // max SCSI over 1394 = ((xFF * 4) - x14)
  *
  * Arguably 2001-07 SPC-2 r20: "4.3.3" "The variable length CDB 
formats" says
  * SK ASC = x 5 24 "ILLEGAL REQUEST" "INVALID FIELD IN CDB" may mean 
CDB too
  * long to copy out, rather than implying recover by flipping CDB bits.
  */

#define MAX_CDB 0xFF

Pat LaVarre

