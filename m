From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 2/4] Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation
Date: Thu, 12 Dec 2013 22:25:23 +0100
Message-ID: <201312122225.23604.arnd@arndb.de>
References: <1386833435-30498-1-git-send-email-lho@apm.com> <201312121427.20040.arnd@arndb.de> <CAPw-ZTn4f7w7gxuKoeq6YfHsAfOSaZx_skbo4-MCv2EfS_oHMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPw-ZTn4f7w7gxuKoeq6YfHsAfOSaZx_skbo4-MCv2EfS_oHMQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 12 December 2013, Loc Ho wrote:
> Hi,
> 
> > On Thursday 12 December 2013, Loc Ho wrote:
> >> +- reg                  : First PHY memory resource is the SDS PHY access
> >> +                         resource.
> >> +                         Second PHY memory resoruce is the clock and reset
> >> +                         resources.
> >> +                         Third PHY memory resource is the SDS PHY access
> >> +                         resource outside of the IP if it is type
> >> +                         "apm,xgene-phy-ext".
> >
> > Why do the "clock and reset" resources not use a clock driver and a reset
> > driver?
> >
> > I would expect these to get replaced with
> >
> >         clocks          : Reference to external clock input
> >         resets          : Reference to reset controller input
> [Loc Ho]
> The clock register has bit for the SDS interface, each sata ports,
> CSR, AXI interface, and the PM (power management) interface. The clock
> and CSR for all these are enabled by the host controller driver.
> Unfortunately, during calibration the SATA ports clocks must not be
> enable. This sequence is required by the hardware itself. Unless I
> separate out the two, this requirement is handled by the PHY. If you
> believe this is needed, I can have two separate clocks but it is over
> kill. You can look at function xgene_phy_sata_setup_preclk and
> xgene_phy_sata_setup_postclk.


I'm not looking at this from the driver side but rather from the way the
hardware is built. My understanding is that you have clock and reset
registers in a separate register file that also handles clocks and reset
lines for other devices with the same layout. If this is true, you
should definitely write a clock driver and a reset driver to support
the respective register layouts, and use the clock and reset APIs
in the kernel to call them, rather than poking the raw registers from
an unrelated driver. 

> >> +Optional properties:
> >> +- status             : Shall be "ok" if enabled or "disabled" if disabled.
> >> +                       Default is "ok".
> >> +- apm,tx-eye-tuning  : Manual control to fine tune the capture of the serial
> >> +                       bit lines from the automatic calibrated position.
> >> +                       Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
> >> +                       Range from 0 to 0x7f in unit of one bit period.
> >> +                       Default is 0xa.
> >
> > What does gen1, gen2 and gen3 refer to? Is this PCIe, SATA or serdes generations
> > or all of them?
> [Loc Ho]
> Douglas already commented on this. Gen1 in SATA term is 1.5Gbps, Gen2
> is 3.0Gbps, and Gen3 is 6Gbps.
> 
> >
> > Why are there two sets?
> [Loc Ho]
> Each controller has two SATA ports - one set for each port.

Ok.

> > Will this have to change if you add PCIe support?
> [Loc Ho]
> So far, we don't see a need to use override setting for PCIe

The problem is that with the encoding you have chosen, it becomes a lot harder
to add that if it turns out to be needed later.

> > I would suggest using decimal notation here instead of hexadecimal since you
> > are dealing with numbers couting things. Same for the others.
> [Loc Ho]
> Okay... for future version.
> 
> >
> >> +- apm,tx-eye-direction       : Eye tuning manual control direction. 0 means sample
> >> +                       data earlier than the nominal sampling point. 1 means
> >> +                       sample data later than the nominal sampling point.
> >> +                       Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
> >> +                       Default is 0x0.
> >> +
> >> +- apm,tx-boost-gain  : Frequency boost AC (LSB 3-bit) and DC (2-bit)
> >> +                       gain control. Two set of 3-tuple setting for Gen1,
> >> +                       Gen2, and Gen3. Range is between 0 to 0x1f in unit
> >> +                       of dB. Default is 0x3.
> >> +
> >> +- apm,tx-amplitude   : Amplitude control. Two set of 3-tuple setting for
> >> +                       Gen1, Gen2, and Gen3. Range is between 0 to 0xf in
> >> +                       unit of 13.3mV. Default is 0xf.
> >
> > Units of 13.3mV don't seem to be useful as a generic measurement. I'd
> > recommend using milivolts or microvolts.
> [Loc Ho]
> Each unit is 13.3mV. If I use millivolt, then someone can set fraction
> which will get round up or down. If you still strongly suggest this is
> required, then fine.

The amplitude sounds like something that a lot of PHY drivers would need to
set, and we really want everybody to use the same property definitions for
describing the same things.

> >> +- apm,tx-pre-cursor1 : 1st pre-cursor emphasis taps control. Two set of
> >> +                       3-tuple setting for Gen1, Gen2, and Gen3. Range is
> >> +                       between 0 to 0xf in unit of 18.2mV. Default is 0x0.
> >> +- apm,tx-pre-cursor2 : 2st pre-cursor emphasis taps control. Two set of
> >> +                       3-tuple setting for Gen1, Gen2, and Gen3. Range is
> >> +                       between 0 to 0x7 in unit of 18.2mV. Default is 0x0.
> >> +- apm,tx-post-cursor : Post-cursor emphasis taps control. Two set of
> >> +                       3-tuple setting for Gen1, Gen2, and Gen3. Range is
> >> +                       between 0 to 0x1f in unit of 18.2mV. Default is 0xf.
> >
> > Same here.
> >
> >> +- apm,tx-speed               : Tx operating speed. One set of 3-tuple for
> >> +                       Gen1 (0x1), Gen2 (0x3), and Gen3 (0x7). Default is
> >> +                       0x7.
> >
> > I'm completely confused by this description. Can you rephrase this?
> > It sounds like the only possible values are <1 3 7> for this property.
> [Loc Ho]
> Douglas already comment on this. If you believe this needs to be
> rephrased, then let me know.

I think it's still rather confusing to the casual reader. Let me try to rephrase
what I understand and you can decide whether you want to use that text, or correct
my mistakes.

apm,sata-speed		: Tx operating speed for SATA mode. A 3-tuple for each
			  supported link speed on the host, with a bit mask of
			  compatible device speeds, encoded as
			    0x0001 - SATA-I (1.5gbits/s)
			    0x0002 - SATA-II (3.0gbits/s)
			    0x0004 - SATA-6G (6.0gbits/s)
			Default is <0x1 0x3 0x7>.		

	Arnd
