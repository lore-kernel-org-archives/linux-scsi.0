From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] check non-scsi part of status in scsi_status_is_good
Date: Thu, 30 Oct 2003 06:25:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8CBEA170-0ADC-11D8-9A0E-000393A22C62@ieee.org>
Mime-Version: 1.0 (Apple Message framework v552)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rly-ip03.mx.aol.com ([64.12.138.7]:19365 "EHLO
	rly-ip03.mx.aol.com") by vger.kernel.org with ESMTP id S262458AbTJ3N35
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 08:29:57 -0500
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, stern@rowland.harvard.edu, james.bottomley@steeleye.com, p.lavarre@ieee.org

 > patch should be applied, since we are
 > otherwise ignoring non scsi errors in multiple
 > places ... Before, we ignored the failed MODE
 > SENSE and used whatever data was returned, and
 > later the TEST UNIT READY failed.

Clear, thank you.

 > Ugh. It is behaving worse than before.

Aye.

 > Any suggestions?

We want ANY suggestions?

Here following I rephrase the suggestion we've seen pieces of before 
from me:

 > With the patch, ...
 > we try a MODE SENSE page 0 len 4 and it hangs ..
 > If the first MODE SENSE were 10 bytes
 > your device would probably work OK,
 > but per comments in sd.c, we should not increase this
 > ...
 > 2.4 code used only a 255 byte MODE SENSE request.

I contest that flat "should not".

I'm guessing we mean the comments that say asking for the header alone 
makes 2.6 more polite than 2.4 asking for more bytes than ever exist?  
I agree, as far as that comment goes, but I'm guessing that's not the 
whole story.  I'm guessing we can lose less often by talking more like 
Windows: ask for the header plus block descriptor plus all of page x08 
(not page x3F).  The op x5A MODE_SENSE_10 total is x1C = 8 + 8 + xC.  
The op x1A MODE_SENSE total is x14 = 4 + 8 + xC.

 > If we can't workaround this by modifying the
 > code (increasing the length,

Yes, increase the length.  Our 2.4 history of pain tells us max chokes. 
  Here we are learning min chokes.  How about next we try a guess less 
extreme than either of those choices.

 > If we can't workaround this by modifying the
 > code (increasing the length, or somehow
 > workaround this in SCSI or USB code), we are
 > back to black listing or command filtering.

Aye, ugh.

 > Alan or USB gurus -
 > is the following what we expect on a timeout?

I'm too new to just know ... but for comparison, via gccscsi etc., I 
imagine I can easily trace some timeouts caused by SG_IO e.g. via op 
x2F Verify of xFFFF blocks.  Want me to bother?

 > > Oct 29 10:10:32 ronald kernel: usb-storage: Soft reset failed: -32
 > > Oct 29 10:10:32 ronald kernel: usb-storage: bus_reset called
 >
 > It would be nice if it came back :-(

Would be nice if timeout & reset & retry worked more often than not, 
aye.  I remember usb bbb resets in particular needing to be timed out 
and retried themselves, proving the host design rule that all device 
i/o is perceptibly unreliable.

Pat LaVarre

