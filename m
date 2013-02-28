From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] drivers/scsi/cxgbi: correcting the include path, so can
 pass compiling.
Date: Thu, 28 Feb 2013 14:07:57 +0800
Message-ID: <512EF43D.1070805@asianux.com>
References: <50F15A35.4000400@asianux.com> <50FB9A33.2090204@asianux.com> <51077BB3.2010809@asianux.com> <512ECDDC.2020607@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <512ECDDC.2020607@asianux.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, David Miller <davem@davemloft.net>, kxie@chelsio.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


  I find another more suitable way to fix this issue.
    using ccflags-y instead of EXTRA_FLAGS.
    according to the file ./script/checkpatch.pl:

1755                 if (($realfile =3D~ /Makefile.*/ || $realfile =3D~=
 /Kbuild.*/) &&
1756                     ($line =3D~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
1757                         my $flag =3D $1;
1758                         my $replacement =3D {
1759                                 'EXTRA_AFLAGS' =3D>   'asflags-y',
1760                                 'EXTRA_CFLAGS' =3D>   'ccflags-y',
1761                                 'EXTRA_CPPFLAGS' =3D> 'cppflags-y'=
,
1762                                 'EXTRA_LDFLAGS' =3D>  'ldflags-y',
1763                         };
1764                   =20
1765                         WARN("DEPRECATED_VARIABLE",
1766                              "Use of $flag is deprecated, please u=
se \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement  -=
>{$flag});


  I need send new patch for it.

  welcome any members to provide additional suggestions or completions.

  thanks.

  :-)

gchen.


=D3=DA 2013=C4=EA02=D4=C228=C8=D5 11:24, Chen Gang =D0=B4=B5=C0:
> Hello relative Maintainers:
>=20
>   could any one help checking this patch ?
>=20
>     this patch fixes the compiling issue.
>     the make command in my x86_64 laptop is: "make V=3D1 allmodconfig=
"
>     the patch was sent in Jan-12-2013, and get non-reply now.
>=20
>   could you please give a glance when you have time.
>=20
>   thanks.
>=20
>   :-)
>=20
> gchen.
>=20
>=20
> =D3=DA 2013=C4=EA01=D4=C229=C8=D5 15:35, Chen Gang =D0=B4=B5=C0:
>> Hello JBottomley@parallels.com
>>
>>   have you already fixed it by another patches ?
>>
>>   if so:
>>     better to let me know about it, so I should not bother you, agai=
n.
>>   else
>>     please give a glance to this patch, when you have time
>>      (since compiling errors are always belong to critical errors)
>>
>>   thanks.
>>
>>
>> by the way:
>>    I get the sending mail address from ./script/get_maintainer.pl.
>>    if I sent to an incorrect member, please tell me.
>>
>>   thanks.
>>
>> gchen.
>>
>>
>> =D3=DA 2013=C4=EA01=D4=C220=C8=D5 15:18, Chen Gang =D0=B4=B5=C0:
>>> Hello JBottomley@parallels.com
>>>
>>>   when you have free time, could you give a glance for this patch ?
>>>
>>>   thanks.
>>>
>>> gchen.
>>>
>>>
>>> =D3=DA 2013=C4=EA01=D4=C212=C8=D5 20:42, Chen Gang =D0=B4=B5=C0:
>>>>
>>>>   correct the include path,
>>>>   or the compiler will report can not find "common.h"...
>>>>
>>>>   both cxgb3/ and cxgb4/ sub directly have l2t.h (they are differe=
nt).
>>>>   so it is not suitable to '-I' sub-directy, directly.
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>  drivers/scsi/cxgbi/Makefile        |    4 ++++
>>>>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   14 +++++++-------
>>>>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   10 +++++-----
>>>>  3 files changed, 16 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Make=
file
>>>> index 86007e3..aff2998 100644
>>>> --- a/drivers/scsi/cxgbi/Makefile
>>>> +++ b/drivers/scsi/cxgbi/Makefile
>>>> @@ -1,2 +1,6 @@
>>>> +
>>>> +ccflags-y			:=3D -Idrivers/net/ethernet/chelsio
>>>> +subdir-ccflags-y		:=3D -Idrivers/net/ethernet/chelsio
>>>> +
>>>>  obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+=3D libcxgbi.o cxgb3i/
>>>>  obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+=3D libcxgbi.o cxgb4i/
>>>> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxg=
bi/cxgb3i/cxgb3i.c
>>>> index 49692a1..ca92e72 100644
>>>> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>>> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>>> @@ -18,13 +18,13 @@
>>>>  #include <linux/moduleparam.h>
>>>>  #include <scsi/scsi_host.h>
>>>> =20
>>>> -#include "common.h"
>>>> -#include "t3_cpl.h"
>>>> -#include "t3cdev.h"
>>>> -#include "cxgb3_defs.h"
>>>> -#include "cxgb3_ctl_defs.h"
>>>> -#include "cxgb3_offload.h"
>>>> -#include "firmware_exports.h"
>>>> +#include "cxgb3/common.h"
>>>> +#include "cxgb3/t3_cpl.h"
>>>> +#include "cxgb3/t3cdev.h"
>>>> +#include "cxgb3/cxgb3_defs.h"
>>>> +#include "cxgb3/cxgb3_ctl_defs.h"
>>>> +#include "cxgb3/cxgb3_offload.h"
>>>> +#include "cxgb3/firmware_exports.h"
>>>>  #include "cxgb3i.h"
>>>> =20
>>>>  static unsigned int dbg_level;
>>>> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxg=
bi/cxgb4i/cxgb4i.c
>>>> index f924b3c..a5795d5 100644
>>>> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
>>>> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
>>>> @@ -20,11 +20,11 @@
>>>>  #include <net/dst.h>
>>>>  #include <linux/netdevice.h>
>>>> =20
>>>> -#include "t4_msg.h"
>>>> -#include "cxgb4.h"
>>>> -#include "cxgb4_uld.h"
>>>> -#include "t4fw_api.h"
>>>> -#include "l2t.h"
>>>> +#include "cxgb4/t4_msg.h"
>>>> +#include "cxgb4/cxgb4.h"
>>>> +#include "cxgb4/cxgb4_uld.h"
>>>> +#include "cxgb4/t4fw_api.h"
>>>> +#include "cxgb4/l2t.h"
>>>>  #include "cxgb4i.h"
>>>> =20
>>>>  static unsigned int dbg_level;
>>>>
>>>
>>>
>>
>>
>=20
>=20


--=20
Chen Gang

Asianux Corporation
