From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: bioset changes in 4.18 broke aha1542
Date: Thu, 18 Oct 2018 21:55:15 +0200
Message-ID: <201810182155.15935.linux@rainbow-software.org>
References: <201810182034.51724.linux@rainbow-software.org> <ee572ca2-8bbe-cd7d-5c41-8bb2fb5b204d@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ee572ca2-8bbe-cd7d-5c41-8bb2fb5b204d@kernel.dk>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 18 October 2018 20:58:57 Jens Axboe wrote:
> On 10/18/18 12:34 PM, Ondrej Zary wrote:
> > Hello,
> > aha1542 works fine in 4.17 but crashes in 4.18. It's hard to bisect because
> > of many commits that don't compile.
> > # only skipped commits left to test
> > # possible first bad commit: [52190f8abe7f2bf2b4e5f9760cbcc1427ca2136b] fs: convert block_dev.c to bioset_init()
> > # possible first bad commit: [a47a28b74a5c7c27bf621276b85ad6c124651236] target: convert to bioset_init()/mempool_init()
> > # possible first bad commit: [6f1c819c219f7841079f0f43ab62727a55b0d849] dm: convert to bioset_init()/mempool_init()
> > # possible first bad commit: [afeee514ce7f4cab605beedd03be71ebaf0c5fc8] md: convert to bioset_init()/mempool_init()
> > # possible first bad commit: [d19936a26658a7a53edd5619d631ee2c2c3151a2] bcache: convert to bioset_init()/mempool_init()
> > # possible first bad commit: [b906bbb6997785d9ea0bd3f5585537afa6257c43] lightnvm: convert to bioset_init()/mempool_init()
> > 
> > Testing manually, a47a28b74a5c7c27bf621276b85ad6c124651236 works.
> > 52190f8abe7f2bf2b4e5f9760cbcc1427ca2136b does not compile
> > 8ac9f7c1fd1d342e82ddf078425423b050652ba0 does not compile
> > e292d7bc63c8f2adb3dfda27910e805f1b6557f9 does not compile
> > dad08527525f9a8ac9c7f278864c65f94bc5e9b3 does not compile
> > 943cf9f3ca16133dbd00f9a4cbfea46512fcb0e8 works
> > ..
> > fedc3abe7bd2dcc4c80bcf3cff8708a3908d8219 works
> > 04c4950d5b373ba712d928592e05e73510785bca crashes
> 
> It looks like the ISA bioset pool isn't being initialized. You should
> have messages like this in your dmesg:
> 
> isa pool size: 16 pages
> 
> (which you do), but also something on the bioset section. Do you have
> this one:
> 
> pool size: 64 pages
> 
> as well?
> 

No, it's not there.

-- 
Ondrej Zary
