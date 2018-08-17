From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Thu, 16 Aug 2018 23:20:05 -0400
Message-ID: <yq1a7plel22.fsf@oracle.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
        <20180810201601.GA80850@gmail.com>
        <SN1PR04MB1824A5944E0428AC84B62886EA3E0@SN1PR04MB1824.namprd04.prod.outlook.com>
        <ba74a9d1-cccc-913a-927a-82e561afef3d@interlog.com>
        <7f1b5ca8-cd89-71cc-21bb-5a058bc1e908@c-s.fr>
        <e2f9fa43-6104-214e-1570-b3753cb14b13@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e2f9fa43-6104-214e-1570-b3753cb14b13@interlog.com> (Douglas
        Gilbert's message of "Thu, 16 Aug 2018 13:38:22 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christophe LEROY <christophe.leroy@c-s.fr>, Jeffrey Lien <Jeff.Lien@wdc.com>, Eric Biggers <ebiggers@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org


> With regard to your comment about slice (table ?) size, that is
> partially addressed by a kernel build time option shown in the above
> patch. That could be taken a bit further with a sysfs knob (where ?)
> to reduce the effective table size from that which the kernel is built
> with. To increase the size of the table would imply fetching some more
> heap and having an algorithm that could generate the extra part of
> that table required.

I am not a big fan of punting the decision to whoever compiles the
kernel to pick a number between 1 and 11 ("this CRC calculation is one
louder"). I would prefer to find a reasonable compromise between
bandwidth and cache thrashing side effects instead of overwhelming
people with build time choices and runtime tunables.

Almost everyone is running either Tim's PCLMULQDQ version or using IP
checksum for DIX. The software T10 CRC table implementation is mainly
there as a reference. I don't know of any production environments using
the table-based T10 CRC.

I don't have a problem making the code genuinely useful so it can be
leveraged by processors without hardware CRC acceleration capability.
But there needs to be some solid data guiding this decision so I'm
looking forward to see what WDC has in store.

Our results definitely matched Christophe's in that larger slice-by-N
are not always a win. And "faster" isn't automatically "better" from an
application performance perspective. With the caveat that our
measurements were done about 10 years ago and I'm sure we've come a long
way with processors and caches since then. So the results should be
interesting...

-- 
Martin K. Petersen	Oracle Linux Engineering
