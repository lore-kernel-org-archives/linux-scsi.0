From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Tue, 21 Aug 2018 21:40:34 -0400
Message-ID: <yq1lg8zb2lp.fsf@oracle.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
        <yq1in4gq5jf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1in4gq5jf.fsf@oracle.com> (Martin K. Petersen's message of
        "Sat, 11 Aug 2018 11:36:20 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Lien <jeff.lien@wdc.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org


> These days we obviously use the hardware-accelerated CRC calculation
> so the software table approach mostly serves as a reference
> implementation.

I was puzzled as to why WDC's tests did not seem to use the hardware-
accelerated CRC calculation whereas tests on my end worked fine. Turns
out this is due to an unfortunate side effect of how the crypto
subsystem works.

When crc-t10dif is initialized, the crypto infrastructure will pick the
algorithm with the highest priority currently registered. Both block and
SCSI will cause crc-t10dif to be compiled as a built-in so this
selection happens very early.

If crct10dif-pclmul is compiled as a module it will not be available at
the time the T10 CRC library is initialized. And thus the block layer
integrity code will be stuck with the sluggish table CRC. The workaround
is to build with CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y.

However, it seems like a bit of a deficiency in crypto that there is no
way to upgrade existing transformations if higher priority algorithms
become available. btrfs and a few others work around this issue by not
using the generic lib/ CRC functions (which defeats the purpose of
having these in the first place). Instead they are registering their own
transformation at a later time where any accelerator modules are more
likely to be loaded.

Anyway. Just a heads up to people that wonder why the table algorithm is
being exercised despite their hardware supporting CRC acceleration.

-- 
Martin K. Petersen	Oracle Linux Engineering
