From: Kjetil Torgrim Homme <kjetil.homme@redpill-linpro.com>
Subject: Re: [hpsa] regression, does not recognise tape robot changer
Date: Mon, 02 Mar 2015 16:34:23 +0100
Message-ID: <1rbnkbct1c.fsf@feh.ms.redpill-linpro.com>
References: <54E618D8.9090406@redpill-linpro.com> <54E66C28.1030401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54347 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbbCBPkF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2015 10:40:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1YSSRv-0007Lj-QG
	for linux-scsi@vger.kernel.org; Mon, 02 Mar 2015 16:40:03 +0100
Received: from feh.ms.redpill-linpro.com ([87.238.42.167])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2015 16:40:03 +0100
Received: from kjetil.homme by feh.ms.redpill-linpro.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2015 16:40:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Don Brace <brace77070@gmail.com>

Don Brace <brace77070@gmail.com> writes:
> On 02/19/2015 11:09 AM, Kjetil Torgrim Homme wrote:
>> this regression is getting old, but it's still present in the newest
>> Linus kernels.
>>
>> I have a HP server with a P411 card with a MSL G3 48 slot tape changer
>> attached.  the tape changer has two LTO5 and one LTO6 tape drives
>> installed.  one of the cables is an "octopus", well "quadpus", but
>> changing what's connected with a "proper" cable and two of the quadpus
>> doesn't seem to make any difference.  there is no other equipment (e.g.,
>> disks) attached to this card.
>>
>> on Linux 3.14 this works fine, but on anything newer one of the tape
>> drives and the changer itself goes missing.  see attachments of boot
>> messages from each case.
>
> I'll look into this. I should have all that I need.

Ok, I tried Linus' 4.0rc1, and it didn't manage to start properly
(although it looked like a udev problem, not a kernel problem), but the
changer is back:

  hpsa 0000:0d:00.0: RAID              device c2b3t0l0 added.
  hpsa 0000:0d:00.0: Sequential-Access device c2b2t0l0 added.
  hpsa 0000:0d:00.0: Sequential-Access device c2b2t1l0 added.
  hpsa 0000:0d:00.0: Medium Changer    device c2b2t1l1 added.
  hpsa 0000:0d:00.0: Sequential-Access device c2b2t2l0 added.
  scsi 2:3:0:0: RAID              HP    P411             6.60 PQ: 0 ANSI: 5
  scsi 2:2:0:0: Sequential-Access HP    Ultrium 6-SCSI   32AW PQ: 0 ANSI: 6
  scsi 2:2:1:0: Sequential-Access HP    Ultrium 5-SCSI   Z58W PQ: 0 ANSI: 6
  scsi 2:2:1:1: Medium Changer    HP    MSL G3 Series    8.10 PQ: 0 ANSI: 5
  scsi 2:2:2:0: Sequential-Access HP    Ultrium 5-SCSI   Z58W PQ: 0 ANSI: 6

I guess I need to try to either figure out what's up with 3.19 or what's
up with udev.

thanks for looking!

-- 
Kjetil T. Homme
Redpill Linpro AS - Changing the game

