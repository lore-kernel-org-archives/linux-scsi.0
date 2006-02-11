From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 11 Feb 2006 10:50:23 +0100
Message-ID: <43EDB35F.40709@s5r6.in-berlin.de>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52662 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751347AbWBKJvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2006 04:51:02 -0500
In-Reply-To: <20060208235415.GL27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Al Viro wrote on 2006-02-09:
> On Thu, Feb 09, 2006 at 12:39:20AM +0100, Stefan Richter wrote:
>>Could the fact that Linux reboots (if sbp2 does not mangle the SCSI 
>>commands) mean that the SBP-2 target is overwriting memory outside of a 
>>data buffer? Or does the SCSI stack perform reckless things like jumps 
>>based on pointer tables, using unchecked data? Or...?
> 
> Interesting...  What's the last command sent before reboot?  Note that
> original driver would remap 6byte commands to 10byte ones, but new one
> should not _get_ those commands.  At all.  What happens if you take old
> driver, put
>         sdev->use_10_for_rw = 1;
>         sdev->use_10_for_ms = 1;
> into sbp2scsi_slave_configure() and leave remapping code alone?  Then
> see if remapper is ever triggered - if it does, we have a problem in
> midlayer.  If not...  I'd love to see the last commands.

Yes, I will do so as soon I got spare time.
MODE_SENSE_10 seemed to be the trigger, as mentioned in 
http://marc.theaimsgroup.com/?l=linux-scsi&m=112128914912105 . Also note 
that this device reports to implement Direct-Access, unlike most other 
SBP-2 HDDs which pose as Direct-Access-RBC.

I have one other bridge which reports type Direct-Access. It is based on 
the first generation fon TI StorageLynx. This does not work under Linux 
either because it requires the 36 byte inquiry workaround. Sbp2's 
version has become ineffective in recent kernels and I have not yet 
figured out how to enable the SCSI layer's version of this workaround. 
(But that's another issue.)

> BTW, I've seen PL3507-based enclosure <spit> with the following lovely
> bug: if it _ever_ got INQUIRY (any INQUIRY) other than immediately in
> the beginning of session, it got 8 bytes stuck in FIFO.  All subsequeunt
> reads got shifted by 8 bytes, no matter what.  With old driver, new driver...
> Just scsiinfo -i would be enough to screw it.  With massive fs corruption,
> obviously...

Interesting. Many PL3507 come with buggy firmware which is noticed under 
other OSs too. Newer hardware revisions can be reprogrammed but I don't 
know where the latest firmware is available and whether it fixes this 
INQUIRY related bug.

Do you think a workaround (like perhaps "reject all INQUIRY commands 
except the first one after login") would be justified?
-- 
Stefan Richter
-=====-=-==- --=- -=-==
http://arcgraph.de/sr/
