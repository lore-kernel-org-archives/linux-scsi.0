From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 2/5] dt-bindings: scsi: ufs: add document for hi3660-ufs
Date: Fri, 16 Jun 2017 23:51:29 +0200
Message-ID: <CAK8P3a2aPorzpUzwL=dkUkYNCGkhQMDPOkKRW1-=Hf=yCdvTsQ@mail.gmail.com>
References: <20170616065119.10704-1-butao@hisilicon.com> <20170616065119.10704-3-butao@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616065119.10704-3-butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Wei Xu <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 16, 2017 at 8:51 AM, Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org> wrote:
> add ufs node document for hi3660
>
> Signed-off-by: Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> ---
>  .../devicetree/bindings/ufs/hi3660-ufs.txt         | 58 ++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/hi3660-ufs.txt
>
> diff --git a/Documentation/devicetree/bindings/ufs/hi3660-ufs.txt b/Documentation/devicetree/bindings/ufs/hi3660-ufs.txt
> new file mode 100644
> index 000000000000..461afc8ef017
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/hi3660-ufs.txt
> @@ -0,0 +1,58 @@
> +* Hisilicon Universal Flash Storage (UFS) Host Controller
> +
> +UFS nodes are defined to describe on-chip UFS hardware macro.
> +Each UFS Host Controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains one of the following -
> +                       "hisilicon,hi3660-ufs" for hisi ufs host controller
> +                        present on Hi3660 chipset.
> +- reg               : should contain UFS register address space & UFS SYS CTRL register address,
> +- interrupt-parent  : interrupt device
> +- interrupts        : interrupt number
> +- clocks               : List of phandle and clock specifier pairs
> +- clock-names       : List of clock input name strings sorted in the same
> +                     order as the clocks property. "clk_ref", "clk_phy" is optional
> +- resets            : reset node register, one reset the clk and the other reset the controller
> +- reset-names       : describe reset node register
> +
> +Optional properties for board device:
> +- ufs-hi3660-use-rate-B                : specifies UFS rate-B
> +- ufs-hi3660-broken-fastauto   : specifies no fastauto
> +- ufs-hi3660-use-HS-GEAR3      : specifies UFS HS-GEAR3
> +- ufs-hi3660-use-HS-GEAR2      : specifies UFS HS-GEAR2
> +- ufs-hi3660-use-HS-GEAR1      : specifies UFS HS-GEAR1
> +- ufs-hi3660-broken-clk-gate-bypass    : specifies no clk-gate
> +- ufs-hi3660-use-one-line      : specifies UFS use one line work
> +- reset-gpio                   : specifies to reset devices

Some of these sound rather generic and might apply to UFS implementations
other than hi3660, so I'd suggest adding them to the base ufs binding with
a generic name instead.

Any DT properties that might be useful across multiple implementations
should be parsed in generic code that gets called by the individual drivers,
and then the properties that are specific to the integration work done by
hisilicon should be prefixed with "hisilicon,", but not normally with the
SoC name: it is quite possible that another SoC will be derived from this
chip and it should reuse the properties.

(note: this is different from the value of the "compatible" property that
is meant to be as specific as possible".

Also, please clarify how your binding relates to the ufshcd binding
in Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt: does
hi3660 implement any registers that are shared with ufshcd, or does
it use the same physical interface with a different register set?

       Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
