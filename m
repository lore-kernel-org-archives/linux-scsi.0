From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v5 2/5] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Fri, 20 Oct 2017 11:15:55 +0200
Message-ID: <CAK8P3a0z_q-GNc-vSPbovu8yrEQyCGDccoDe16rycW+uOwO4Dw@mail.gmail.com>
References: <20171020085259.8093-1-liwei213@huawei.com> <20171020085259.8093-3-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020085259.8093-3-liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Wei Xu <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, DTML <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 20, 2017 at 10:52 AM, Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> @@ -0,0 +1,46 @@
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

I think I've asked about this before, but I think this should be done more
consistently with the other UFS bindings.

In particular, I wonder if what you describe as the "UFS SYS CTRL"
area corresponds to what Qualcomm have described as their PHY
implementation. It certainly seems to driver some of the properties
that would normally be associated with a PHY.

For the "clock-names" property, you specify "clk_ref", which I
assume is the same as what Qualcomm call "ref_clk". I'd
suggest you use the existing name and add that as the
default name in the ufshcd-pltfrm.txt binding document.

The "clk_phy" property appears to be related to the PHY, so
it might be better to have a separate phy node with either just
the clk, or with the clk plus the "UFS SYS CTRL" register area,
whichever matches your hardware better, and then use teh
"phys/phy-names" property to refer to that.

The reset handling you describe here (both resets and reset-gpios)
appears to be completely generic, so I'd suggest adding those to
ufshcd-pltfrm.txt instead of your own binding, to ensure that future
drivers use the same identifiers.


      Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
