From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v7 3/4] PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
Date: Wed, 15 Jan 2014 12:11:09 -0800
Message-ID: <CAPw-ZTn_fhyY2keqRXa4uab2U+NKi6nvpfz+yaNX+h_FQFOLuw@mail.gmail.com>
References: <1389769840-15469-1-git-send-email-lho@apm.com>
	<1389769840-15469-2-git-send-email-lho@apm.com>
	<1389769840-15469-3-git-send-email-lho@apm.com>
	<1389769840-15469-4-git-send-email-lho@apm.com>
	<20140115120946.GD25824@e106331-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140115120946.GD25824@e106331-lin.cambridge.arm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "olof@lixom.net" <olof@lixom.net>, "tj@kernel.org" <tj@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

> [...]
>
>> + * The APM X-Gene PHY consists of two PLL clock macro's (CMU) and lanes.
>> + * The first PLL clock macro is used for internal reference clock. The second
>> + * PLL clock macro is used to generate the clock for the PHY. This driver
>> + * configures the first PLL CMU, the second PLL CMU, and programs the PHY to
>> + * operate according to the mode of operation. The first PLL CMU is only
>> + * required if internal clock is enabled.
>> + *
>> + * Logical Layer Out Of HW module units:
>> + *
>> + * -----------------
>> + * | Internal      |    |------|
>> + * | Ref PLL CMU   |----|      |     -------------    ---------
>> + * ------------ ----    | MUX  |-----|PHY PLL CMU|----| Serdes|
>> + *                      |      |     |           |    ---------
>> + * External Clock ------|      |     -------------
>> + *                      |------|
>> + *
>> + * The Ref PLL CMU CSR (Configureation System Registers) is accessed
>> + * indirectly from the SDS offset at 0x2000. It is only required for
>> + * internal reference clock.
>> + * The PHY PLL CMU CSR is accessed indirectly from the SDS offset at 0x0000.
>> + * The Serdes CSR is accessed indirectly from the SDS offset at 0x0400.
>> + *
>> + * The Ref PLL CMU can be located within the same PHY IP or outside the PHY IP
>> + * due to shared Ref PLL CMU. For PHY with Ref PLL CMU shared with another IP,
>> + * it is located outside the PHY IP. This is the case for the PHY located
>> + * at 0x1f23a000 (SATA Port 4/5). For such PHY, another resource is required
>> + * to located the SDS/Ref PLL CMU module and its clock for that IP enabled.
>> + *
>> + * Currently, this driver only supports SATA mode with external clock.
>> + */
>
> Having looked at this and the binding, I'm confused as to why we need an
> additional reg entry when we're using the external clock.
>
> Surely the second resource (the external CMU base) is a property of the
> shared ref PLL clock, rather than the PHY itself. How do you handle two
> units trying to use the shared PLL?

You have an good point here. For the time being, let me rip out the
external CMU support as we don't support internal clock just yet. It
will be deal with later on.

>
> I think makes sense to model the ref PLL CMU as a separate clock, and
> use clock-names to differentiate between the two inputs to the mux:
>
> external: external_clock {
>         compatible = "fixed-clock";
>         clock-frequency = < ... >;
>         #clock-cells = <0>;
> };
>
> ref_pll: reference_clock {
>         compatible = "apm,xgene-ref-pll";
>         reg = < .... >;
>         #clock-cells = <0>;
> };
>
> phy {
>         compatible = "apm,xgene-phy";
>         reg = < ... >;
>         clocks = <&ref_pll>, <&external>;
>         clock-names = "ref-pll", "external";
>         ...
> };
>
>
> That also means the phy only needs a single compatible string -- you can
> figure out what to do by probing the set of clocks.
>
> Does that make sense? Is there something I'm missing?

Okay... As mentioned, let me rip the ref CMU out and address this at a
later time - going with your suggested approach in the future.

-Loc
