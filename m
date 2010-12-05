From: Audio Haven <audiohaven@gmail.com>
Subject: Re: mvsas errors in 2.6.36
Date: Sun, 5 Dec 2010 11:45:01 +0100
Message-ID: <AANLkTinVK8FAApP2zP8gqmPhgPo4ZeUMRRJ4cD+O1iza@mail.gmail.com>
References: <201010290650.32892.thomas@fjellstrom.ca>
	<4CE3912E.6060904@tomt.net>
	<201012012329.54944.thomas@fjellstrom.ca>
	<201012020249.00367.thomas@fjellstrom.ca>
	<4CF79C60.9030107@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35985 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab0LEKpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Dec 2010 05:45:03 -0500
Received: by wyb28 with SMTP id 28so11033576wyb.19
        for <linux-scsi@vger.kernel.org>; Sun, 05 Dec 2010 02:45:02 -0800 (PST)
In-Reply-To: <4CF79C60.9030107@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Cc: thomas@fjellstrom.ca, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Dec 2, 2010 at 2:17 PM, Spelic <spelic@shiftmail.org> wrote:
> It's already applied only in 2.6.37-rc1..rc4

After one year of mvsas troubles, I can finally say that 2.6.37-rc4
fixed all of my mvsas issues. I have been stress testing 2 machines
for days and can't trigger the usual mvsas issues (nexus errors and
unplug notices) anymore.

In the past, on one system all 8 1TB drives of 2 different brands
(Hitachi & Samsung) on a Supermicro AOC-SASLP-MV8 gave me random
errors, such as unplug notices. Large file copies over samba stalled
or were aborted. This could easily be triggered by doing 1 hour of
large IO.

On a second system, newer 1.5 TB drives gave me almost no issues. I
had to stress much longer before something appeared in the log. Both
machines have identical motherboards and same kernel versions. So my
suspicion some of the older 1 TB drives were bad is now confirmed.

With 2.6.37-rc4, only the real faulty drives are now reported in dmesg
instead of ALL drives after waiting long enough. I found one drive had
12 uncorrectable sectors according to smart, while another drive
always reported DriveStatusError under heavy load. These two drives
were always slowing down the array. After removong them from the RAID6
software raid, speed is now stable.

On the second system with all good drives, the nexus errors and unplug
notices are completely gone.

Thanks to everyone who helped making mvsas stable as it finally works!

Best regards,

Audio Haven (Frederic Vanden Poel)
