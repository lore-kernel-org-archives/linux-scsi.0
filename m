From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v8 2/5] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Mon, 19 Feb 2018 10:57:30 +0100
Message-ID: <CAK8P3a2b3rLHyM+vMppCkAR3VYbhw-b0LpuWfLCqjs7z9n+hyw@mail.gmail.com>
References: <20180213101412.5717-1-liwei213@huawei.com>
 <20180213101412.5717-3-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180213101412.5717-3-liwei213@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Li Wei <liwei213@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Eric Anholt <eric@anholt.net>, Krzysztof Kozlowski <krzk@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Kevin Hilman <khilman@baylibre.com>, zangleigang@hisilicon.com, Wei Xu <xuwei5@hisilicon.com>, Zhangfei Gao <zhangfei.gao@linaro.org>, Thierry Reding <treding@nvidia.com>, DTML <devicetree@vger.kernel.org>, "Fengbaopeng (kevin,
 Kirin Solution Dept)" <fengbaopeng@hisilicon.com>, Rob Herring <robh+dt@kernel.org>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, Guodong Xu <guodong.xu@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 13, 2018 at 11:14 AM, Li Wei <liwei213@huawei.com> wrote:
> add ufs node document for Hisilicon.
>
> Signed-off-by: Li Wei <liwei213@huawei.com>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt


I'm pretty sure we've discussed it before, but can you make this so that
the generic properties are part of the ufshcd binding, and you refer to it
from here, only describing in what ways the hisi ufs binding differs from
the standard?

> diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> new file mode 100644
> index 000000000000..0d21b57496cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> @@ -0,0 +1,37 @@
> +* Hisilicon Universal Flash Storage (UFS) Host Controller
> +
> +UFS nodes are defined to describe on-chip UFS hardware macro.
> +Each UFS Host Controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains one of the following -
> +                                       "hisilicon,hi3660-ufs", "jedec,ufs-1.1" for hisi ufs
> +                                       host controller present on Hi36xx chipset.
> +- reg               : should contain UFS register address space & UFS SYS CTRL register address,
> +- interrupt-parent  : interrupt device
> +- interrupts        : interrupt number
> +- clocks               : List of phandle and clock specifier pairs
> +- clock-names       : List of clock input name strings sorted in the same
> +                                       order as the clocks property. "ref_clk", "phy_clk" is optional

The clock names sound generic enough, should we have both in the
generic binding?

> +- resets            : reset node register, one reset the clk and the other reset the controller
> +- reset-names       : describe reset node register

This looks incomplete. What is the name of the reset line supposed to be?
I'd also suggest you document it in the ufshcd binding instead.

      Arnd
