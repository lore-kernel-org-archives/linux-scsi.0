From: yalin wang <yalin.wang2010@gmail.com>
Subject: Re: [TRIVIAL PATCH] block: Correct misuses of 0x%<decimal>
Date: Mon, 3 Aug 2015 16:56:36 +0800
Message-ID: <67B9124A-73E8-4AA1-81E5-18FAC69D3962@gmail.com>
References: <1438547113.29569.5.camel@perches.com> <9547AF94-2168-4987-AD89-B7F111084CC2@gmail.com> <1438589026.30149.15.camel@perches.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438589026.30149.15.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Don Brace <don.brace@pmcs.com>, open list <linux-kernel@vger.kernel.org>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Aug 3, 2015, at 16:03, Joe Perches <joe@perches.com> wrote:
>=20
> On Mon, 2015-08-03 at 15:25 +0800, yalin wang wrote:
>>> On Aug 3, 2015, at 04:25, Joe Perches <joe@perches.com> wrote:
>>>=20
>>> Correct misuse of 0x%d in logging messages.
>>>=20
> []
>> why not use like this : dev_dbg(&h->pdev->dev, "   Max outstanding=20
>> commands =3D %#x\n=E2=80=9D  ?=20
>> %#x will add 0x prefix automatically .
>=20
> It's generally a consistency thing.
> A 0 value would be emitted as 0 and not 0x0.
>=20
i try on my ubuntu ,=20

 static int __init throtl_init(void)                                   =
                                                                       =
=20
  {                                                                    =
           =20
         printk("module init test: %#x %p\n", 0, (void *)0x123);       =
          =20
          return 0;                                                    =
              =20
                                                                       =
            =20
  }                                                                    =
              =20
                                                                       =
              =20
  module_init(throtl_init);=20

#uname -a
Linux ubuntu 3.16.0-38-generic #52~14.04.1-Ubuntu SMP Fri May 8 09:43:5=
7 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

#dmesg
[259356.375586] module init test: 0x0 0000000000000123

it seems don=E2=80=99t need 0x%x for 0, just need %#x for all numbers.
there are lots of use like this, i can change them if needed:

# egrep -r  -i '0x%\d*x'  .  | wc -l=20
11776


Thanks
