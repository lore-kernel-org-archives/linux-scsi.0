From: Arnd Bergmann <arnd@arndb.de>
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiDnrZTlpI06IFtQQVRDSCB2OCAyLzVdIGR0LWJpbmRpbg==?=
        =?UTF-8?B?Z3M6IHNjc2k6IHVmczogYWRkIGRvY3VtZW50IGZvciBoaXNpLXVmcw==?=
Date: Wed, 28 Mar 2018 14:49:46 +0200
Message-ID: <CAK8P3a2BRXWbNzEcd9+Fi1zEkSA8aGB5ObxYrbVnaA7MKzU--w@mail.gmail.com>
References: <20180213101412.5717-1-liwei213@huawei.com> <20180213101412.5717-3-liwei213@huawei.com>
 <CAK8P3a2b3rLHyM+vMppCkAR3VYbhw-b0LpuWfLCqjs7z9n+hyw@mail.gmail.com>
 <1699CE87DE933F49876AD744B5DC140FA584ED@DGGEMM506-MBS.china.huawei.com>
 <CAK8P3a3NdHLDf2vOMyZ1qcWNW1Jg5T47qR0qWhWEeDn+90S4ug@mail.gmail.com>
 <1699CE87DE933F49876AD744B5DC140FA58798@DGGEMM506-MBS.china.huawei.com>
 <CAK8P3a29sDaEj=iTkru-3mc9NpjNvZos3Z+h5UsT1cAeULoGHw@mail.gmail.com> <1699CE87DE933F49876AD744B5DC140FA588AD@DGGEMM506-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1699CE87DE933F49876AD744B5DC140FA588AD@DGGEMM506-MBS.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "liwei (CM)" <liwei213@huawei.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "xuwei (O)" <xuwei5@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kevin Hilman <khilman@baylibre.com>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Riku Voipio <riku.voipio@linaro.org>, Thierry Reding <treding@nvidia.com>, Krzysztof Kozlowski <krzk@kernel.org>, Eric Anholt <eric@anholt.net>, DTML <devicetree@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 27, 2018 at 8:15 AM, liwei (CM) <liwei213@huawei.com> wrote:
> Hi, Arnd
>
> At present our ufs module mainly has four clocks from the outside:
> hclk_ufs:     main clock of ufs controller ,freq is 207.5MHz
> cfg_phy_clk:  configuration clock of MPHY, freq is 51.875MHz
> ref_phy_clk:  reference clock of MPHY from PMU, freq is 19.2MHz
> ref_io_clk:    reference clock for the external interface to the device, freq is 19.2MHz
>
> We control two clocks "ref_io_clk" and "cfg_phy_clk" in the driver because the other
> two are controlled by main clock module and pmu.

I'm not completely sure what you mean with "control" here. Do you mean
setting the
rate and disabling them during runtime power management? What does it mean for
the clock to be controlled by teh "main clock module and pmu"?

> for this patch, cfg_phy_clk corresponds to "phy_clk", ref_io_clk corresponds to "ref_clk".

I'm not sure I understand the difference between ref_phy_clk and
ref_io_clk, but it sounds
like we should give both of those names in the ufs-platform binding.

Your hclk_ufs would appear to correspond to what qualcomm calls core_clk, so
maybe use that name as well.

cfg_phy_clk seems to be something that qcom would not have, but it's
also generic
enough to list it in the common binding.

> So the clks in the patch you give appear to be unsuitable for describing this .And the following clks of qcom are internal clock?
> We didn't describe or pay attention to the clock inside the ufs module.
>
> PHY to controller symbol synchronization clocks:
>         "rx_lane0_sync_clk" - RX Lane 0
>         "rx_lane1_sync_clk" - RX Lane 1
>         "tx_lane0_sync_clk" - TX Lane 0
>         "tx_lane1_sync_clk" - TX Lane 1

Right, let's leave those for the qcom private binding.

      Arnd
