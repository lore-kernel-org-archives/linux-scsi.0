From: Douglas Gilbert <dougg@torque.net>
Subject: bidirectional, long commands + OSD
Date: Thu, 29 Jan 2004 23:07:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40190591.5060409@torque.net>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com>	<1075136727.2290.48.camel@mulgrave>  <401625CA.1070404@torque.net> <1075316397.1739.15.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:50190 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S266252AbUA2NKQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 08:10:16 -0500
In-Reply-To: <1075316397.1739.15.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote in thread:
   [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update

> On Tue, 2004-01-27 at 02:48, Douglas Gilbert wrote:
> 
>>So the sg (or SG_IO/SCSI_IOCTL_SEND_COMMAND ioctl) user controls
>>the data direction and they are free to get it wrong:-)
> 
> 
> Since we do have a mid layer library for this, perhaps we should set it
> in sg if the user leaves it apparently unset.

It is valid for vendor specific commands to have command lengths
other than those dictated by the top 3 bits of the opcode. The
variable length opcode (0x7f) breaks that convention as well.
The pass-through philosophy is (within reason) "you asked for
it ....".

>>** The Object Storage Device (OSD) commands use bidirectional
>>data transfers so perhaps we should think about catering for
>>that.
> 
> 
> Actually, a much more fundamental problem for OSD is going to be >16
> byte CDBs.  The mid and block layers today are coded with an internal 16
> byte array for the CDB.  That's not very scaleable to the hundreds of
> bytes that OSD needs.

Just did a check on recent drafts and SPC-3 doesn't have any
commands with lengths > 16 bytes but SBC-2 has:
    XDREAD(32)
    XDWRITE(32)
    XDWRITEREAD(32)
    XPWRITE(32)

> As far as bidirectional goes, we should be able to support that today
> providing there's just a *single* data buffer, which the OSD spec
> implies is the easiest way to support this (although I suspect most SCSI
> processor coding won't be expecting to see both a data in and a data out
> from a single command).

... and XDWRITEREAD (both 10 and 32 byte variants) is bidirectional.

> As I see it, OSD seems to require a different interface from the current
> bio layer, so there would be some type of object layer glue between the
> fs and the mid-layer, with the block layer relegated simply to queueing
> specials for the mid-layer, but since no-one's actually come forward
> with an implementation, that's just a guess.

Both Jens and Linus jumped on me when I suggested
similar heresy :-)

For anyone interested, an overview of the proposed Object
Storage Device (OSD) architecture can be found at:
http://www.t10.org/ftp/t10/drafts/osd/osd-r08.pdf
in section 4.2 .

Doug Gilbert


