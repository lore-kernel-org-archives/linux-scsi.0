From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Race to power off harming SATA SSDs
Date: Tue, 11 Apr 2017 12:37:43 +0200
Message-ID: <3231980.BbEtxjAFS5@merkaba>
References: <20170410232118.GA4816@khazad-dum.debian.net> <20170410235206.GA28603@wtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48511 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754497AbdDKKqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 06:46:51 -0400
In-Reply-To: <20170410235206.GA28603@wtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Am Dienstag, 11. April 2017, 08:52:06 CEST schrieb Tejun Heo:
> > Evidently, how often the SSD will lose the race depends on a platform
> > and SSD combination, and also on how often the system is powered off.
> > A sluggish firmware that takes its time to cut power can save the day...
> > 
> > 
> > Observing the effects:
> > 
> > An unclean SSD power-off will be signaled by the SSD device through an
> > increase on a specific S.M.A.R.T attribute.  These SMART attributes can
> > be read using the smartmontools package from www.smartmontools.org,
> > which should be available in just about every Linux distro.
> > 
> > smartctl -A /dev/sd#
> > 
> > The SMART attribute related to unclean power-off is vendor-specific, so
> > one might have to track down the SSD datasheet to know which attribute a
> > particular SSD uses.  The naming of the attribute also varies.
> > 
> > For a Crucial M500 SSD with up-to-date firmware, this would be attribute
> > 174 "Unexpect_Power_Loss_Ct", for example.
> > 
> > NOTE: unclean SSD power-offs are dangerous and may brick the device in
> > the worst case, or otherwise harm it (reduce longevity, damage flash
> > blocks).  It is also not impossible to get data corruption.
> 
> I get that the incrementing counters might not be pretty but I'm a bit
> skeptical about this being an actual issue.  Because if that were
> true, the device would be bricking itself from any sort of power
> losses be that an actual power loss, battery rundown or hard power off
> after crash.

The write-up by Henrique has been a very informative and interesting read for 
me. I wondered about the same question tough.

I do have a Crucial M500 and I do have an increase of that counter:

martin@merkaba:~[…]/Crucial-M500> grep "^174" smartctl-a-201*   
smartctl-a-2014-03-05.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
Old_age   Always       -       1
smartctl-a-2014-10-11-nach-prüfsummenfehlern.txt:174 Unexpect_Power_Loss_Ct  
0x0032   100   100   000    Old_age   Always       -       67
smartctl-a-2015-05-01.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
Old_age   Always       -       105
smartctl-a-2016-02-06.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
Old_age   Always       -       148
smartctl-a-2016-07-08-unreadable-sector.txt:174 Unexpect_Power_Loss_Ct  0x0032   
100   100   000    Old_age   Always       -       201
smartctl-a-2017-04-11.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
Old_age   Always       -       272


I mostly didn´t notice anything, except for one time where I indeed had a 
BTRFS checksum error, luckily within a BTRFS RAID 1 with an Intel SSD (which 
also has an attribute for unclean shutdown which raises).

I blogged about this in german language quite some time ago:

https://blog.teamix.de/2015/01/19/btrfs-raid-1-selbstheilung-in-aktion/

(I think its easy enough to get the point of the blog post even when not 
understanding german)

Result of scrub:

   scrub started at Thu Oct  9 15:52:00 2014 and finished after 564 seconds
        total bytes scrubbed: 268.36GiB with 60 errors
        error details: csum=60
        corrected errors: 60, uncorrectable errors: 0, unverified errors: 0

Device errors were on:

merkaba:~> btrfs device stats /home
[/dev/mapper/msata-home].write_io_errs   0
[/dev/mapper/msata-home].read_io_errs    0
[/dev/mapper/msata-home].flush_io_errs   0
[/dev/mapper/msata-home].corruption_errs 60
[/dev/mapper/msata-home].generation_errs 0
[…]

(thats the Crucial m500)


I didn´t have any explaination of this, but I suspected some unclean shutdown, 
even tough I remembered no unclean shutdown. I take good care to always has a 
battery in this ThinkPad T520, due to unclean shutdown issues with Intel SSD 
320 (bricked device which reports 8 MiB as capacity, probably fixed by the 
firmware update I applied back then).

The write-up Henrique gave me the idea, that maybe it wasn´t an user triggered 
unclean shutdown that caused the issue, but an unclean shutdown triggered by 
the Linux kernel SSD shutdown procedure implementation.

Of course, I don´t know whether this is the case and I think there is no way 
to proof or falsify it years after this happened. I never had this happen 
again.

Thanks,
-- 
Martin
