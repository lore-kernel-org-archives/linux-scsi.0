From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Race to power off harming SATA SSDs
Date: Tue, 11 Apr 2017 11:31:29 -0300
Message-ID: <20170411143129.GA28632@khazad-dum.debian.net>
References: <20170410232118.GA4816@khazad-dum.debian.net>
 <20170410235206.GA28603@wtj.duckdns.org>
 <3231980.BbEtxjAFS5@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3231980.BbEtxjAFS5@merkaba>
Sender: linux-ide-owner@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 11 Apr 2017, Martin Steigerwald wrote:
> I do have a Crucial M500 and I do have an increase of that counter:
> 
> martin@merkaba:~[…]/Crucial-M500> grep "^174" smartctl-a-201*   
> smartctl-a-2014-03-05.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
> Old_age   Always       -       1
> smartctl-a-2014-10-11-nach-prüfsummenfehlern.txt:174 Unexpect_Power_Loss_Ct  
> 0x0032   100   100   000    Old_age   Always       -       67
> smartctl-a-2015-05-01.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
> Old_age   Always       -       105
> smartctl-a-2016-02-06.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
> Old_age   Always       -       148
> smartctl-a-2016-07-08-unreadable-sector.txt:174 Unexpect_Power_Loss_Ct  0x0032   
> 100   100   000    Old_age   Always       -       201
> smartctl-a-2017-04-11.txt:174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    
> Old_age   Always       -       272
> 
> 
> I mostly didn´t notice anything, except for one time where I indeed had a 
> BTRFS checksum error, luckily within a BTRFS RAID 1 with an Intel SSD (which 
> also has an attribute for unclean shutdown which raises).

The Crucial M500 has something called "RAIN" which it got unmodified
from its Micron datacenter siblings of the time, along with a large
amount of flash overprovisioning.  Too bad it lost the overprovisioned
supercapacitor bank present on the Microns.

RAIN does block-level N+1 RAID5-like parity across the flash chips on
top of the usual block-based ECC, and the SSD has a background scrubber
task that repairs and blocks that fail ECC correction using the RAIN
parity information.

On such an SSD, you really need multi-chip flash corruption beyond what
ECC can fix to even get the operating system/filesystem to notice any
damage, unless you are paying attention to its SMART attributes (it
counts the number of blocks that required RAIN recovery -- which implies
ECC failed to correct that block in the first place), etc.

Unfortunately, I do not have correlation data to know whether there is
an increase on RAIN-corrected or ECC-corrected blocks during the 24h
after an unclean poweroff right after STANDBY IMMEDIATE on a Crucial
M500 SSD.

> The write-up Henrique gave me the idea, that maybe it wasn´t an user triggered 
> unclean shutdown that caused the issue, but an unclean shutdown triggered by 
> the Linux kernel SSD shutdown procedure implementation.

Maybe.  But that corruption could easily having been caused by something
else.  There is no shortage of possible culprits.

I expect most damage caused by unclean SSD power-offs to be hidden from
the user/operating system/filesystem by the extensive recovery
facilities present on most SSDs.

Note that the fact that data was transparently (and sucessfully)
recovered doesn't mean damage did not happen, or that the unit was not
harmed by it: it likely got some extra flash wear at the very least.

BTW, for the record, Windows 7 also appears to have had (and maybe still
have) this issue as far as I can tell.  Almost every user report of
excessive unclean power off alerts (and also of SSD bricking) to be
found on SSD vendor forums come from Windows users.

-- 
  Henrique Holschuh
