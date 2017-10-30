From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIHY1IDIvNV0gZHQtYmluZGluZ3M6IHNjc2k6IHVmczogYQ==?=
        =?UTF-8?B?ZGQgZG9jdW1lbnQgZm9yIGhpc2ktdWZz?=
Date: Mon, 30 Oct 2017 16:21:55 +0100
Message-ID: <CAK8P3a37yYDQZpZxmunCdSO83qkqywTME5Xo0k56nWEs2k+=dg@mail.gmail.com>
References: <20171020085259.8093-1-liwei213@huawei.com> <20171020085259.8093-3-liwei213@huawei.com>
 <CAK8P3a0z_q-GNc-vSPbovu8yrEQyCGDccoDe16rycW+uOwO4Dw@mail.gmail.com> <1699CE87DE933F49876AD744B5DC140FA321D1@DGGEMM506-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1699CE87DE933F49876AD744B5DC140FA321D1-0LhPdUyVHB9548jd+VSckwK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "liwei (CM)" <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "xuwei (O)" <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, DTML <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TaqPxH82wqD4g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 24, 2017 at 11:06 AM, liwei (CM) <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> what's your opinion about my explanation and revision method?
> I am looking forward to your reply, thanks!

Sorry for the delay, I was travelling last week.
> =E5=8F=91=E4=BB=B6=E4=BA=BA: arndbergmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:arndbergmann@=
gmail.com] =E4=BB=A3=E8=A1=A8 Arnd Bergmann
> On Fri, Oct 20, 2017 at 10:52 AM, Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
>> @@ -0,0 +1,46 @@
>> +* Hisilicon Universal Flash Storage (UFS) Host Controller
>> +
>> +UFS nodes are defined to describe on-chip UFS hardware macro.
>> +Each UFS Host Controller should have its own node.
>> +
>> +Required properties:
>> +- compatible        : compatible list, contains one of the following -
>> +                       "hisilicon,hi3660-ufs" for hisi ufs host control=
ler
>> +                        present on Hi3660 chipset.

One more thing I just noticed: you don't describe the device as compatible =
with
the ufshcd spec as defined in the generic binding. Shouldn't we have
both compatible
strings listed here?

> In particular, I wonder if what you describe as the "UFS SYS CTRL"
> area corresponds to what Qualcomm have described as their PHY implementat=
ion. It certainly seems to driver some of the properties that would normall=
y be associated with a PHY.
>
> Liwei:Yes, a part of "UFS SYS CTRL" is associated with a PHY, but from ou=
r chip colleague that we assure "UFS SYS CTRL" is associated with clk/reset=
/power on/power off and so on.
> In fact, in addition to the controller itself, the controller related per=
iphery are all in this area. So it's not appropriate to put this into a sep=
arate phy node.

I'm not sure I understand here. Do you mean the reset handle is for
resetting the PHY rather than the UFS HCD?

> > For the "clock-names" property, you specify "clk_ref", which I assume i=
s the same as what Qualcomm call "ref_clk". I'd suggest you use the existin=
g name and add that as the default name in the ufshcd-pltfrm.txt binding do=
cument.
>
> Liwei:" ref_clk " is already in the ufshcd-pltfrm.txt binding document, a=
nd parse in ufshcd.c, so we will replace "clk_ref" with "ref_clk". I will f=
ix it in patch v6;

ok

> > The "clk_phy" property appears to be related to the PHY, so it might be=
 better to have a separate phy node with either just the clk, or with the c=
lk plus the "UFS SYS CTRL" register area, whichever matches your hardware b=
etter, and then use teh "phys/phy-names" property to refer to that.
>
> Liwei: OK, I will add a separate phy node and fix it in patch v6;

Thanks.

>> The reset handling you describe here (both resets and reset-gpios) appea=
rs to be completely generic, so I'd suggest adding those to ufshcd-pltfrm.t=
xt instead of your own binding, to ensure that future drivers use the same =
identifiers.
>
> Liwei: From our soc chip colleague, reset include "rst", "assert" is not =
generic and related with our soc
> implementation, you can see ufs_hisi_soc_init() in drivers/scsi/ufs/ufs-h=
isi.c, the position of rst and assert
> is very special, it's hard to put it in a generic process;

It seems odd that the ability to reset a device is specific to your
implementation. What I meant is
that other implementations may also require a reset, so describing the
way you refer to this
into the generic binding would be helpful, to prevent others from
adding another incompatible
way to do the same thing.

A lot of generic bindings have a reference to a reset controller that
if present needs to
be used before first accessing the device itself.

> reset-gpios is used to solve a defect of the SOC chip reset function and =
it is not generic , but our chip has been updated, so this is no longer nee=
ded, and I will remove it in the patch v6;

Ok.

      Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
