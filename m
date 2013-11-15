From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
Date: Fri, 15 Nov 2013 20:26:07 +0100
Message-ID: <201311152026.07433.arnd@arndb.de>
References: <1384457519-21335-1-git-send-email-lho@apm.com> <201311151335.09577.arnd@arndb.de> <CAPw-ZT=x3eTd_vgVgyu0HR7j2wmSfQkkSeCMJSJ_i3MTPwiM-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPw-ZT=x3eTd_vgVgyu0HR7j2wmSfQkkSeCMJSJ_i3MTPwiM-g@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 15 November 2013, Loc Ho wrote:
> >> +- CTLE0                        : PHY override parameters for channel 0 register REG1
> >> +                         field CTLE_EQ. First value for Gen1, second value
> >> +                         for Gen2, and third value for Gen3. Default is 0x2.
> >> +- CTLE1                        : PHY override parameters for channel 1 register REG1
> >> +                         field CTLE_EQ. First value for Gen1, second value
> >> +                         for Gen2, and third value for Gen3. Default is 0x2.
> >> +- PQ0                  : PHY override parameters for channel 0 register REG125
> >> +                         field PQ_REG. First value for Gen1, second value
> >> +                         for Gen2, and third value for Gen3. Default is 0xA.
> >> +- PQ1                  : PHY override parameters for channel 1 register REG125
> >> +                         field PQ_REG. First value for Gen1, second value
> >> +                         for Gen2, and third value for Gen3. Default is 0xA.
> >
> > As mentioned before, I don't think putting register-level information into the binding
> > is the right approach here.
> >
> [Loc Ho]
> I don't want to change the driver for every possible customer or APM
> boards out there. In general, if the board designer follows the board
> design guideline, this isn't necessary. Unfortunately, I can not
> control what customer do. If these setting is NOT driven by DTS, then
> I or others may have to change the driver every time there is an new
> board. Another option is pass them as module parameters.

Module parameters are certainly not a solution for this, that would make the
problem worse.

Would it be possible to read out the values that were set by the firmware
at startup and reuse those during run-time? I assume that the devices are
already brought up when the kernel starts.

If that s not possible, change the properties to be named after what the
setting does and make the values be units that are sensible to a board
designer, e.g. (specifics are totally made up here)

 - polarity:	If present, override the polarity of the signal line.
		zero for negative polarity, one for positive polarity.
		If absent, use the firmware default.
 - signal-clock-frequency: If present, override the signal clock frequency.
		This value is defined in HZ
 - x-y-time:	If present, override the timing setting for the X/Y signal
		time, in nanoseconds.

This way, you can reuse the properties for an updated version of the device
that has similar settings but a different register layout.

	Arnd
