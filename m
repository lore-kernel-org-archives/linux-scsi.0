From: "scientica (GMail)" <scientica@gmail.com>
Subject: Re: scsi cmd slab leak? (Was Re: [ck] Anyone been having OOM killer
 problems lately?)
Date: Thu, 19 Jan 2006 18:13:42 +0000
Message-ID: <43CFD6D6.2040700@gmail.com>
References: <200601181951.16708.chase.venters@clientec.com>	<200601190316.05247.chase.venters@clientec.com>	<200601192018.51972.kernel@kolivas.org> <200601190334.25712.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.202]:53939 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751285AbWASRKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 12:10:19 -0500
Received: by uproxy.gmail.com with SMTP id s2so308266uge
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2006 09:10:18 -0800 (PST)
In-Reply-To: <200601190334.25712.chase.venters@clientec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chase Venters wrote:

> On Thursday 19 January 2006 03:18, Con Kolivas wrote:
>
>> On Thursday 19 January 2006 20:15, Chase Venters wrote:
>>
>>> On Thursday 19 January 2006 01:49, Con Kolivas wrote:
>>>
>>>>> Do I have something madly leaking in my kernel?
>>>>
>>>> Yes! post /proc/slabinfo
>>>
>>> (attached). Looks like quite a few scsi commands! Next steps?
>>
>> Inded it does scsi_cmd_cache 1547440 1547440 384 10 1
>> : tunables 54 27 8 : slabdata 154744 154744 0
>>
>> This looks suspiciously large. To be absolutely certain, though,
>> you have to reproduce the problem with a vanilla kernel, and no
>> binary drivers anywhere. My patches don't touch the scsi code
>> directly, but the only way to be certain is to use vanilla.
>
>
> I'll have to try and get around to that soon - I'm currently busy
> with some various work and can't afford the time just yet :/.
>
> Also, I just realized that I copied lkml and scsi without providing
> any useful context. Kernel is 2.6.15-ck1 with the Marvell sk98lin
> patch and (barf) nvidia.ko. I noticed after having the OOM killer
> make its rounds a few times that the slab layer was eating in
> excess of 600MB.
>
> lspci:
>
> 00:00.0 Host bridge: Intel Corporation 915G/P/GV/GL/PL/910GL
> Processor to I/O Controller (rev 04) 00:01.0 PCI bridge: Intel
> Corporation 915G/P/GV/GL/PL/910GL PCI Express Root Port (rev 04)
> 00:1b.0 Class 0403: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) High Definition Audio Controller (rev 03) 00:1c.0 PCI
> bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI
> Express Port 1 (rev 03) 00:1c.1 PCI bridge: Intel Corporation
> 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 2 (rev 03)
> 00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW
> (ICH6 Family) USB UHCI #1 (rev 03) 00:1d.1 USB Controller: Intel
> Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev
> 03) 00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW
> (ICH6 Family) USB UHCI #3 (rev 03) 00:1d.3 USB Controller: Intel
> Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev
> 03) 00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW
> (ICH6 Family) USB2 EHCI Controller (rev 03) 00:1e.0 PCI bridge:
> Intel Corporation 82801 PCI Bridge (rev d3) 00:1f.0 ISA bridge:
> Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC Interface Bridge (rev
> 03) 00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW
> (ICH6 Family) IDE Controller (rev 03) 00:1f.2 Class 0106: Intel
> Corporation 82801FR/FRW (ICH6R/ICH6RW) SATA Controller (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) SMBus Controller (rev 03) 01:03.0 FireWire (IEEE 1394):
> Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link)
> 01:04.0 Mass storage controller: <pci_lookup_name: buffer too
> small> (rev 13) 01:09.0 Multimedia audio controller: Creative Labs
> SB Audigy (rev 04) 01:09.1 Input device controller: Creative Labs
> SB Audigy MIDI/Game port (rev 04) 01:09.2 FireWire (IEEE 1394):
> Creative Labs SB Audigy FireWire Port (rev 04) 01:0a.0 SCSI storage
> controller: Adaptec AHA-7850 (rev 03) 02:00.0 Ethernet controller:
> Marvell Technology Group Ltd. 88E8053 Gigabit Ethernet Controller
> (rev 15) 04:00.0 VGA compatible controller: nVidia Corporation
> Unknown device 0092 (rev a1)
>
> config.gz attached. I'd also like to note that I've been getting
> this in my ring buffer when attempting to burn CD's on a PX-716A:
>
> (scsi0:A:4:0): No or incomplete CDB sent to device. scsi0: Issued
> Channel A Bus Reset. 1 SCBs aborted (scsi0:A:4:0): Unexpected
> busfree while idle SEQADDR == 0x16a (scsi0:A:4:0): No or incomplete
> CDB sent to device. scsi0: Issued Channel A Bus Reset. 1 SCBs
> aborted sr 0:0:4:0: SCSI error: return code = 0x70000
> (scsi0:A:4:0): Unexpected busfree while idle SEQADDR == 0x16a
> (scsi0:A:4:0): No or incomplete CDB sent to device. scsi0: Issued
> Channel A Bus Reset. 1 SCBs aborted (scsi0:A:4:0): Unexpected
> busfree while idle SEQADDR == 0x16a (scsi0:A:4:0): No or incomplete
> CDB sent to device. scsi0: Issued Channel A Bus Reset. 1 SCBs
> aborted sr 0:0:4:0: SCSI error: return code = 0x70000
> (scsi0:A:4:0): Unexpected busfree while idle SEQADDR == 0x16a
> (scsi0:A:4:0): No or incomplete CDB sent to device. scsi0: Issued
> Channel A Bus Reset. 1 SCBs aborted
>
> ...but I don't think this is directly related, because this has
> been happening since at least 2.6.13 iirc. Just being thorough.
>
> Apologies to lkml & scsi for the brief/confusing earlier message.
>
>> Cheers, Con
>
>
> Thanks, Chase
>
>
> ----------------------------------------------------------------------
>
>
> _______________________________________________ ck@vds.kolivas.org
> ck mailing list. If replying to an email please reply-to-all below
> the original message. http://vds.kolivas.org/mailman/listinfo/ck

Just out of curiosity, what's the slab? and what is the expected size
of it? I just checked mine and it seems to eat some 304596 kB
(2.6.14-ck4, soon 68d uptime). The only problems I've had recently is
firefox crashing more than it should (but it could simply be me having
a billion or so windows and tabs open, and it's the
mozilla-firefox-bin-1.5-r2 from portage which is masked ~amd64, so
it's probably just buggy - it dies with a segfault after beeing stuck
at 100% CPU for a while, cant see any OOM-messages anywhere), other
than that I've been able to both emerge stuff (nice'd though),
download stuff and burn backups DVD's with out problems -
simultaneously - and the system was still responsive :)

- --
After all, if you are in school to study computer science, then a
professor saying:
 "use this proprietary software to learn computer science" is the
same as English professor handing you a copy of Shakespeare
and saying:
 "use this book to learn Shakespeare without opening the book itself."
  -- Bradley Kuhn
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDz9bVRbO4Br+gO6YRAoi+AJ474kaoue3QRausPgKKdYJtj1vmrwCdHcoE
hqxwpAq5Hr2HUlIYmc5fXu0=
=TgZJ
-----END PGP SIGNATURE-----

