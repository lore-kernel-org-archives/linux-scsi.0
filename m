From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Buffer overflow in the mptctl_replace_fw() function in linux
 kernel MPT ioctl driver
Date: Fri, 1 Sep 2017 11:24:16 +0300
Message-ID: <20170901082416.2mdhdpp46ismg2kp@mwanda>
References: <CAJsXRPFEOoZjHKhJ=1rfXpmFqEdaORtxYUkm3bRJ_v+_oENt3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJsXRPFEOoZjHKhJ=1rfXpmFqEdaORtxYUkm3bRJ_v+_oENt3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dison River <pwn2river@gmail.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 01, 2017 at 02:00:48PM +0800, Dison River wrote:
>     newFwSize = ALIGN(karg.newImageSize, 4);

This is an integer overflow, but it's harmless...  As a static checker
developer this is where I would print a warning:
drivers/message/fusion/mptctl.c:1748 mptctl_replace_fw() warn: potential integer overflow from user '((karg.newImageSize)) + (((4)) - 1)'
I also caught the integer overflow from two days ago but there are too
many ones like this so I can't check them all.  In mpt_alloc_fw_memory()
there is another potential integer overflow when we do:

	ioc->alloc_total += size;

But ->alloc_total is not used anywhere.

I don't see a buffer overflow here.

regards,
dan carpenter
