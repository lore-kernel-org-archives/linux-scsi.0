From: Michael Tokarev <mjt@tls.msk.ru>
Subject: sdparm: change_mode_page: failed setting page: Caching (SBC)
Date: Sun, 24 Jun 2007 15:38:00 +0400
Message-ID: <467E5798.8030100@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:21188 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbXFXLiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jun 2007 07:38:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

We've got a bunch of SATA Seagate Barracuda ES drives,
namely, ST3250620NS -- "enterprize" class.  And now I
wonder what's wrong with - either those drives, or
sdparm, or kernel.

In particular, sdparm can't change WCE bit, like this:

# sdparm --clear=WCE -v -v /dev/sda
mp_settings: page,subpage=0x8,0x0  num=1
  pdt=0 start_byte=0x2 start_bit=2 num_bits=1  val=0  acronym: WCE
    inquiry cdb: 12 00 00 00 24 00
    /dev/sda: ATA       ST3250620NS       3.AE
    mode sense (10) cdb: 5a 00 08 00 00 00 00 00 04 00
    mode sense (10) cdb: 5a 00 08 00 00 00 00 00 24 00
    mode select (10) cdb: 55 10 00 00 00 00 00 00 24 00
    mode select (10) parameter block
        00 00 00 00 00 00 00 08  00 00 00 00 00 00 02 00
        08 12 00 00 00 00 00 00  00 00 00 00 00 00 00 00
        00 00 00 00
mode select (10):  Fixed format, current;  Sense key: Illegal Request
 Additional sense: Invalid field in cdb
 Raw sense data (in hex):
        70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
        00 00
change_mode_page: failed setting page: Caching (SBC)
# _

We also have several "desktop" drives similar to the ones above --
ST3250620AS.  And with those, I can change settings, unlike with
the NS series:

# sdparm --clear=WCE /dev/sda
    /dev/sda: ATA       ST3250620AS       J
# _

What I also observed is that `sdparm -a' output is a bit different
for the two.  For the NS series, it looks like this:

Caching (SBC) mode page:
  WCE         1
...

While for the AS series, it is like:

Caching (SBC) mode page:
  WCE         1  [cha: y]
...

The difference is that for the AS drives, sdparm displays
whenever the parameter is changeable, while for the NS
("enterprise") disk, it does not.

So I wonder -- is it the drive which is bad, or something's
wrong with sdparm?  To me, it should work the opposite way
(IF there should be any difference at all) -- i.e., I can
understand when for a "desktop" (consumer) drive I can't
change some settings, while for "enterprise" class drive
I have more control.

Any ideas?  Should I RMA those drives and/or replace them
with the AS ones? :)

Thanks.

/mjt
