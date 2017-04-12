From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Race to power off harming SATA SSDs
Date: Wed, 12 Apr 2017 09:47:12 +0200
Message-ID: <4241332.UzRHA00Li6@merkaba>
References: <20170410232118.GA4816@khazad-dum.debian.net> <3231980.BbEtxjAFS5@merkaba> <20170411143129.GA28632@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170411143129.GA28632@khazad-dum.debian.net>
Sender: linux-ide-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, 11. April 2017, 11:31:29 CEST schrieb Henrique de Moraes 
Holschuh:
> On Tue, 11 Apr 2017, Martin Steigerwald wrote:
> > I do have a Crucial M500 and I do have an increase of that counter:
> > 
> > martin@merkaba:~[…]/Crucial-M500> grep "^174" smartctl-a-201*
> > smartctl-a-2014-03-05.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100  
> > 000 Old_age   Always       -       1
> > smartctl-a-2014-10-11-nach-prüfsummenfehlern.txt:174
> > Unexpect_Power_Loss_Ct
> > 0x0032   100   100   000    Old_age   Always       -       67
> > smartctl-a-2015-05-01.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100  
> > 000 Old_age   Always       -       105
> > smartctl-a-2016-02-06.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100  
> > 000 Old_age   Always       -       148
> > smartctl-a-2016-07-08-unreadable-sector.txt:174 Unexpect_Power_Loss_Ct 
> > 0x0032 100   100   000    Old_age   Always       -       201
> > smartctl-a-2017-04-11.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100  
> > 000 Old_age   Always       -       272
> > 
> > 
> > I mostly didn´t notice anything, except for one time where I indeed had a
> > BTRFS checksum error, luckily within a BTRFS RAID 1 with an Intel SSD
> > (which also has an attribute for unclean shutdown which raises).
> 
> The Crucial M500 has something called "RAIN" which it got unmodified
> from its Micron datacenter siblings of the time, along with a large
> amount of flash overprovisioning.  Too bad it lost the overprovisioned
> supercapacitor bank present on the Microns.

I think I read about this some time ago. I decided for a Crucial M500 cause in 
tests it wasn´t the fastest, but there were hints that it may be one of the 
most reliable mSATA SSDs of that time.

[… RAIN explaination …]

> > The write-up Henrique gave me the idea, that maybe it wasn´t an user
> > triggered unclean shutdown that caused the issue, but an unclean shutdown
> > triggered by the Linux kernel SSD shutdown procedure implementation.
> 
> Maybe.  But that corruption could easily having been caused by something
> else.  There is no shortage of possible culprits.

Yes.

> I expect most damage caused by unclean SSD power-offs to be hidden from
> the user/operating system/filesystem by the extensive recovery
> facilities present on most SSDs.
> 
> Note that the fact that data was transparently (and sucessfully)
> recovered doesn't mean damage did not happen, or that the unit was not
> harmed by it: it likely got some extra flash wear at the very least.

Okay, I understand.

Well my guess back then, I didn´t fully elaborate on it in the initial mail, 
but did so in the blog post, was exactly that I didn´t see any capacitor on 
the mSATA SSD board. But I know the Intel SSD 320 has capacitors. So I 
thought, okay, maybe there really has been a sudden powerloss due to me trying 
to exchange battery during suspend to RAM / standby, without me remembering 
this event. And I thought, okay, without capacitor the SSD then didn´t get a 
chance to write some of the data. But again this also is just a guess.

I can provide to you smart data files in case you want to have a look at them.

> BTW, for the record, Windows 7 also appears to have had (and maybe still
> have) this issue as far as I can tell.  Almost every user report of
> excessive unclean power off alerts (and also of SSD bricking) to be
> found on SSD vendor forums come from Windows users.

Interesting.

Thanks,
-- 
Martin
