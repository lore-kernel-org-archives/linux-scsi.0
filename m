From: Douglas Gilbert <dougg@torque.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sun, 22 Jun 2003 15:05:02 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF538FE.3040204@torque.net>
References: <20030621165920.F2811@one-eyed-alien.net> <1056241551.1775.14.camel@mulgrave> <20030621174640.M2811@one-eyed-alien.net> <1056250487.1775.58.camel@mulgrave> <20030621212406.N2811@one-eyed-alien.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:33551 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S265512AbTFVEwB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 00:52:01 -0400
In-Reply-To: <20030621212406.N2811@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>

Matthew Dharm wrote:
> On Sat, Jun 21, 2003 at 09:54:46PM -0500, James Bottomley wrote:
> 
>>@@ -702,7 +692,7 @@
>> 		printk("%s: scsi-1 drive\n", cd->cdi.name);
>> 		return;
>> 	}
>>-	n = buffer[3] + 4;
>>+	n = rc;
>> 	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
>> 	cd->readcd_known = 1;
>> 	cd->readcd_cdda = buffer[n + 5] & 0x01;
> 
> 
> This bit isn't right.  n is supposed to point to the start of the page
> data, not the page header.  The header is a different size if the command
> is 6-byte or 10-byte.
> 
> If you look at my patch, you can see the correct offsets you need.

Matt,
Here is a small function to calculate the mode sense reponse
offset to the first page (borrowed from smartmontools, GPL-ed
code):


/* Offset into mode sense (6 or 10 byte) response that actual mode page
  * starts at (relative to resp[0]). Returns -1 if problem */
int scsiModePageOffset(const UINT8 * resp, int len, int modese_10)
{
     int resp_len, bd_len;
     int offset = -1;
 

     if (resp) {
         if (modese_10) {
             resp_len = (resp[0] << 8) + resp[1] + 2;
             bd_len = (resp[6] << 8) + resp[7];
             offset = bd_len + 8;
         } else {
             resp_len = resp[0] + 1;
             bd_len = resp[3];
             offset = bd_len + 4;
         }
         if ((offset + 2) > len) {
             pout("scsiModePageOffset: page too small, offset=%d "
                  "resp_len=%d bd_len=%d\n", offset, resp_len, bd_len);
             offset = -1;
         } else if ((offset + 2) > resp_len) {
             pout("scsiModePageOffset: response length too short, 
resp_len=%d"
                  " offset=%d bd_len=%d\n", resp_len, offset, bd_len);
             offset = -1;
         }
     }
     return offset;
}


BTW The sanity checks can be useful, Recently, I have been
trying to solve problems with the aacraid which returns
garbage to MODE SENSE commands (and locks up when given
LOG SENSE commands).
My USB mass storage enclosure is quirky as well: when
it gets a MODE_SENSE_10 it swaps the response_length bytes
(bytes 0 and 1) producing an exaggerated length. The mode
page is still readable and valid.

Doug Gilbert

