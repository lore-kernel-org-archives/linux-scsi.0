From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sdparm: change_mode_page: failed setting page: Caching (SBC)
Date: Sun, 24 Jun 2007 13:22:46 -0400
Message-ID: <467EA866.4070008@torque.net>
References: <467E5798.8030100@msgid.tls.msk.ru>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38436 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXFXRXM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jun 2007 13:23:12 -0400
In-Reply-To: <467E5798.8030100@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Michael Tokarev wrote:
> We've got a bunch of SATA Seagate Barracuda ES drives,
> namely, ST3250620NS -- "enterprize" class.  And now I
> wonder what's wrong with - either those drives, or
> sdparm, or kernel.
> 
> In particular, sdparm can't change WCE bit, like this:
> 
> # sdparm --clear=WCE -v -v /dev/sda
> mp_settings: page,subpage=0x8,0x0  num=1
>   pdt=0 start_byte=0x2 start_bit=2 num_bits=1  val=0  acronym: WCE
>     inquiry cdb: 12 00 00 00 24 00
>     /dev/sda: ATA       ST3250620NS       3.AE
>     mode sense (10) cdb: 5a 00 08 00 00 00 00 00 04 00
>     mode sense (10) cdb: 5a 00 08 00 00 00 00 00 24 00
>     mode select (10) cdb: 55 10 00 00 00 00 00 00 24 00
>     mode select (10) parameter block
>         00 00 00 00 00 00 00 08  00 00 00 00 00 00 02 00
>         08 12 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>         00 00 00 00
> mode select (10):  Fixed format, current;  Sense key: Illegal Request
>  Additional sense: Invalid field in cdb
>  Raw sense data (in hex):
>         70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
>         00 00
> change_mode_page: failed setting page: Caching (SBC)
> # _
> 
> We also have several "desktop" drives similar to the ones above --
> ST3250620AS.  And with those, I can change settings, unlike with
> the NS series:
> 
> # sdparm --clear=WCE /dev/sda
>     /dev/sda: ATA       ST3250620AS       J
> # _
> 
> What I also observed is that `sdparm -a' output is a bit different
> for the two.  For the NS series, it looks like this:
> 
> Caching (SBC) mode page:
>   WCE         1
> ...
> 
> While for the AS series, it is like:
> 
> Caching (SBC) mode page:
>   WCE         1  [cha: y]
> ...
> 
> The difference is that for the AS drives, sdparm displays
> whenever the parameter is changeable, while for the NS
> ("enterprise") disk, it does not.
> 
> So I wonder -- is it the drive which is bad, or something's
> wrong with sdparm?  To me, it should work the opposite way
> (IF there should be any difference at all) -- i.e., I can
> understand when for a "desktop" (consumer) drive I can't
> change some settings, while for "enterprise" class drive
> I have more control.
> 
> Any ideas?  Should I RMA those drives and/or replace them
> with the AS ones? :)

Michael,
My information may be out of date, but last time I
looked libata didn't support MODE SELECT which is
the SCSI command to change mode page settings.
[I have sent patches several times to add support
for this in libata but ...]

So, if /dev/sda is connected directly via libata, and
libata hasn't been fixed (as per the SAT standard)
then exactly the error message you have shown above
will be reported by libata. [BTW the error message
is wrong too ... it should be 20h,0h not 24h,0h ...
sent a patch for that too.]

hdparm should do the trick for you. sdparm (or a very
recent version of hdparm) may be needed if the SATA
disk is behind a SAS (USB or 1394) interconnect that
implements a decent SAT layer somewhere.

Doug Gilbert
