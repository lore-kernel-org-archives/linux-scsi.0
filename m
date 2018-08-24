From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 24 Aug 2018 18:12:39 -0400
Message-ID: <yq1pny776so.fsf@oracle.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
        <yq1in4gq5jf.fsf@oracle.com> <yq1lg8zb2lp.fsf@oracle.com>
        <20180822062016.GA10356@infradead.org>
        <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
        <CAKv+Gu-RwCrdgW69NVpyRLwGPGPCZx+ksTBM7NZk7v0-dzczGg@mail.gmail.com>
        <yq1a7pb9196.fsf@oracle.com>
        <CAKv+Gu8Y7YmyB5rmxaj-SGB7q03in7ijv2cOifwYnhP5CNastw@mail.gmail.com>
        <yq1tvnj780o.fsf@oracle.com>
        <CAKv+Gu8dMBUKmw+5rxWoiRKXngPeAsNyXzOY-nZwd3GPi1S5FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8dMBUKmw+5rxWoiRKXngPeAsNyXzOY-nZwd3GPi1S5FA@mail.gmail.com>
        (Ard Biesheuvel's message of "Fri, 24 Aug 2018 22:54:26 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jeffrey Lien <Jeff.Lien@wdc.com>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Ard,

> This looks like it should work, yes. It does rely on the module name
> to start with 'crct10dif' but I guess that is reasonable, and matches
> the current state on all architectures.

Yep, I verified the module names on ARM and Power. There really wasn't
much I could key off of other than the name string.

> Anyone care to boot test this? Jeffrey?

Did some quick tests on my end with both scsi_debug and FC hardware. I
verified that performance went up as I loaded crct10dif-pclmul while the
test was running:

[   23.488059] CRC T10 DIF calculated using crypto hash crct10dif-generic
[  156.922455] sd 0:0:0:0: [sda] Enabling DIX T10-DIF-TYPE1-CRC protection
[  221.577731] CRC T10 DIF calculated using crypto hash crct10dif-pclmul

R  63.60 MB/s, W  61.00 MB/s, IOPS  486 | Ops     4460, Rec  0, Err  0
R  61.80 MB/s, W  62.00 MB/s, IOPS  493 | Ops     6926, Rec  0, Err  0
R  62.60 MB/s, W  60.80 MB/s, IOPS  494 | Ops     9396, Rec  0, Err  0
R  59.40 MB/s, W  58.80 MB/s, IOPS  482 | Ops    11804, Rec  0, Err  0
R 151.40 MB/s, W 155.40 MB/s, IOPS 1216 | Ops    17883, Rec  0, Err  0
R 165.00 MB/s, W 166.40 MB/s, IOPS 1327 | Ops    24520, Rec  0, Err  0
R 175.00 MB/s, W 177.40 MB/s, IOPS 1417 | Ops    31604, Rec  0, Err  0
R 185.80 MB/s, W 188.60 MB/s, IOPS 1507 | Ops    39137, Rec  0, Err  0
R 200.60 MB/s, W 203.00 MB/s, IOPS 1629 | Ops    47284, Rec  0, Err  0

Note that in this case the CRC is calculated twice per I/O (block layer
and scsi_debug).

I'll do some more testing over the weekend...

-- 
Martin K. Petersen	Oracle Linux Engineering
