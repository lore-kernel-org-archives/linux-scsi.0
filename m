From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Wed, 15 Aug 2018 20:31:34 +0200
Message-ID: <20180815182538.GB9709@xo-6d-61-c0.localdomain>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Lien <jeff.lien@wdc.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org

Hi!

> This patch provides a performance improvement for the CRC16 calculations done in read/write
> workloads using the T10 Type 1/2/3 guard field.  For example, today with sequential write
> workloads (one thread/CPU of IO) we consume 100% of the CPU because of the CRC16 computation
> bottleneck.  Today's block devices are considerably faster, but the CRC16 calculation prevents
> folks from utilizing the throughput of such devices.  To speed up this calculation and expose
> the block device throughput, we slice the old single byte for loop into a 16 byte for loop,
> with a larger CRC table to match.  The result has shown 5x performance improvements on various
> big endian and little endian systems running the 4.18.0 kernel version.

Well, 8K table fits in cache easily, and when running benchmark, table will be cached so it is
a win... Is it also win on non-benchmark workloads and smaller systems?

											Pavel
