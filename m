From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/5] dt-bindings: scsi: ufs: add document for hi3660-ufs
Date: Thu, 22 Jun 2017 13:51:28 +0200
Message-ID: <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw@mail.gmail.com>
References: <20170616065119.10704-1-butao@hisilicon.com> <20170616065119.10704-3-butao@hisilicon.com>
 <CAK8P3a2aPorzpUzwL=dkUkYNCGkhQMDPOkKRW1-=Hf=yCdvTsQ@mail.gmail.com> <0f79aeea-53e3-6bea-ffa6-0e057f2ff83b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0f79aeea-53e3-6bea-ffa6-0e057f2ff83b@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bu Tao <butao@huawei.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Wei Xu <xuwei5@hisilicon.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kevin Hilman <khilman@baylibre.com>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Riku Voipio <riku.voipio@linaro.org>, Thierry Reding <treding@nvidia.com>, Krzysztof Kozlowski <krzk@kernel.org>, Eric Anholt <eric@anholt.net>, devicetree@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>Linux
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 22, 2017 at 1:44 PM, Bu Tao <butao@huawei.com> wrote:
> =E5=9C=A8 2017/6/17 5:51, Arnd Bergmann =E5=86=99=E9=81=93:
>> On Fri, Jun 16, 2017 at 8:51 AM, Bu Tao <butao@hisilicon.com> wrote:
>>> +Optional properties for board device:
>>> +- ufs-hi3660-use-rate-B                : specifies UFS rate-B
>>> +- ufs-hi3660-broken-fastauto   : specifies no fastauto
>>> +- ufs-hi3660-use-HS-GEAR3      : specifies UFS HS-GEAR3
>>> +- ufs-hi3660-use-HS-GEAR2      : specifies UFS HS-GEAR2
>>> +- ufs-hi3660-use-HS-GEAR1      : specifies UFS HS-GEAR1
>>> +- ufs-hi3660-broken-clk-gate-bypass    : specifies no clk-gate
>>> +- ufs-hi3660-use-one-line      : specifies UFS use one line work
>>> +- reset-gpio                   : specifies to reset devices
>>
>>
>> Some of these sound rather generic and might apply to UFS implementation=
s
>> other than hi3660, so I'd suggest adding them to the base ufs binding wi=
th
>> a generic name instead.
>>
>> Any DT properties that might be useful across multiple implementations
>> should be parsed in generic code that gets called by the individual
>> drivers,
>> and then the properties that are specific to the integration work done b=
y
>> hisilicon should be prefixed with "hisilicon,", but not normally with th=
e
>> SoC name: it is quite possible that another SoC will be derived from thi=
s
>> chip and it should reuse the properties.
>
>
> I do not know wheher other SoC need to use the optional properties as
> abover. So here the name of the optional properties has "hi3660".

They should not have "hi3660" in their names either way, independent
of where they are used.

>> (note: this is different from the value of the "compatible" property tha=
t
>> is meant to be as specific as possible".
>>
>> Also, please clarify how your binding relates to the ufshcd binding
>> in Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt: does
>> hi3660 implement any registers that are shared with ufshcd, or does
>> it use the same physical interface with a different register set?
>
> No, only show how to use the dt-binding for hi3660 SoC

My question was about the hardware: does hi3660 implement ufshcd
or not?

      Arnd
