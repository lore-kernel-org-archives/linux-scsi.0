From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Low-level reformat with different sector size: ?
Date: Sat, 30 Jun 2007 15:30:01 +0000 (UTC)
Message-ID: <f65stp$gk4$1@sea.gmane.org>
References: <f638pe$it6$1@sea.gmane.org> <4685B6E5.80204@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58849 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXF3PaO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jun 2007 11:30:14 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1I4etm-00022b-Jb
	for linux-scsi@vger.kernel.org; Sat, 30 Jun 2007 17:30:10 +0200
Received: from smurf.noris.de ([192.109.102.42])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 30 Jun 2007 17:30:10 +0200
Received: from matthias by smurf.noris.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 30 Jun 2007 17:30:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, 29 Jun 2007 21:50:29 -0400, Douglas Gilbert wrote:

> Umm, I hope you don't consider losing all the previous data
> on the disks when a re-format is performed as "screwing up"?

*Giggle* As I just got the disk, have no idea what's on it, and can't read
it in any case (OK, so I could use /dev/sg*...), that would be rather
silly.

No, I consider "reformat it in such a way that the disk now reports 512
bytes instead of 70 GBytes, total" or "brick it" to be screw-ups. Anything
else I can live with. If nothing else, German consumer code happily
gives me 14-day return rights, so if nothing else works I can send the
things back.

Right now, though, it looks like there's something else broken.
*This* does not look normal at all:

# sg_format --format --size=512 --count=-1 --verbose /dev/sg1
    inquiry cdb: 12 00 00 00 24 00 
    inquiry: requested 36 bytes but got 18 bytes
    S330L  !  C0     peripheral_type: disk [0x0]
      PROTECT=1
      << supports 'protection information'>>
    mode sense (10) cdb: 5a 00 01 00 00 00 00 00 fc 00 
    mode sense (10): requested 252 bytes but got 14 bytes
Mode sense (block descriptor) data, prior to changes:
  Number of blocks=2177429504 [0x81c8f000]
  Block size=2615479 [0x27e8b7]
Need to perform MODE SELECT (to change number or blocks or block length)
but (single) block descriptor not found in earlier MODE SENSE
#

This happens on all three disks, so it seems that either the OS or the
controller are screwing things up royally.  :-/

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
Accuracy:
	Exploded concept. Foolish, Platonic notion that we can get our facts
	straight.
		-- Fashionable Dictionary (www.butterfliesandwheels.com)

