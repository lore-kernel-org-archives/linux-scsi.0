From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH, RESEND] scsi: lpfc: fix linking against modular NVMe support
Date: Wed, 26 Jul 2017 11:16:10 +0200
Message-ID: <CAK8P3a2EnPuTNU0O5va+Xz3nCthhpz3Po1z7SOVRiAUV_2+OhA@mail.gmail.com>
References: <20170721205401.3374331-1-arnd@arndb.de> <20170726090820.GH4039@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170726090820.GH4039@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "# 3.4.x" <stable@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, James Smart <jsmart2021@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 26, 2017 at 11:08 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Fri, Jul 21, 2017 at 10:53:46PM +0200, Arnd Bergmann wrote:
>> I originally sent the patch in March 2013, the day after the broken
>                                        ^ 2017?

Oops. Let me resend that.

>> +     depends on NVME_TARGET_FC || NVME_TARGET_FC=n
>> +     depends on NVME_FC || NVME_FC=n
>
> OK Kconfig is black magic, but X || X=n ? I have no doubt you do the right
> thing, I just don't understand it.

We use this construct in many places these days. A few years ago I added
a comment whenever I added an instance, but most others don't so I treat
it as an idiom now.

"depends on X" means that if X=m, the current symbol can only be "m" or
"n", while "X=y" means it can have any value.

So for "depends on X || X=n", the current symbol cannot be "y" when "X=m",
but otherwise can have any of the three possibilities. This is exactly what
we need here.

       Arnd
