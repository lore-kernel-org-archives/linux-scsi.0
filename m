From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Sat, 11 Aug 2018 11:36:20 -0400
Message-ID: <yq1in4gq5jf.fsf@oracle.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com> (Jeff
        Lien's message of "Fri, 10 Aug 2018 14:12:11 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Lien <jeff.lien@wdc.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org


Jeff,

> This patch provides a performance improvement for the CRC16
> calculations done in read/write workloads using the T10 Type 1/2/3
> guard field.  For example, today with sequential write workloads (one
> thread/CPU of IO) we consume 100% of the CPU because of the CRC16
> computation bottleneck.  Today's block devices are considerably
> faster, but the CRC16 calculation prevents folks from utilizing the
> throughput of such devices.  To speed up this calculation and expose
> the block device throughput, we slice the old single byte for loop
> into a 16 byte for loop, with a larger CRC table to match.  The result
> has shown 5x performance improvements on various big endian and little
> endian systems running the 4.18.0 kernel version.

The reason I went with a simple slice-by-one approach was that the
larger tables had a negative impact on the CPU caches. So while
slice-by-N numbers looked better in synthetic benchmarks, actual
application performance started getting affected as the tables grew
larger.

These days we obviously use the hardware-accelerated CRC calculation so
the software table approach mostly serves as a reference
implementation. But given your big vs. little endian performance
metrics, I'm assuming you guys are focused on embedded processors
without support for CRC acceleration?

I have no problem providing a choice for bigger tables. My only concern
is that the selection heuristics need to be more than one-dimensional.
Latency and cache side effects are often more important than throughput.
At least on the initiator side.

Also, I'd like to keep the original slice-by-one implementation for
reference purposes.

-- 
Martin K. Petersen	Oracle Linux Engineering
