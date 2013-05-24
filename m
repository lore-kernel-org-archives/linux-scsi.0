From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 24 May 2013 11:45:33 +0200
Message-ID: <519F36BD.1030806@redhat.com>
References: <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522143019.GA18541@mtj.dyndns.org> <519CDDA4.2050100@redhat.com> <20130522193009.GA23845@mtj.dyndns.org> <519D360D.4050309@redhat.com> <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org> <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org> <519F12FF.6090809@redhat.com> <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com> <519F2566.2000008@redhat.com> <CAOS58YMSw6wJU07WfVG8wd_BnU4TXr7VDBHeDPa4XjSpn2p3Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOS58YMSw6wJU07WfVG8wd_BnU4TXr7VDBHeDPa4XjSpn2p3Ag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Il 24/05/2013 11:07, Tejun Heo ha scritto:
> On Fri, May 24, 2013 at 5:31 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> I agree intuition may not count, and it's perfectly possible that
>> firmware writers forgot a "break;" or put the wrong location in a jump
>> table, so that unimplemented commands give interesting results.
> 
> It's not just unimplemented commands. Exposing any new command exposes
> its borderline problems together with it.

For commands that are used by Linux already, the right way to fix the
problems is not obscuring the commands from userspace's view.  You can
hit the same problems with ioctls or even with normal operation of the
device.

>> However, the _fact_ is that this might happen anyway with the buttload
>> of commands that are already enabled by the whitelist and that most
>> disks will never implement.
> 
> Yes and that's why the whitelist is generally frowned upon. It's
> inherently fragile. These devices simply aren't designed and
> implemented to be exposed to lesser security domains directly. It's
> true that it's already kinda broken that way but as I wrote before
> it's a vicious cycle and we don't wanna keep building on top of it.
> This expansion is gonna increase the usage of whitelisting which will
> in turn attract further use cases which are likely to call for even
> more expansion.

And prohibiting the extension of whitelists is gonna increase the
usage of unpriv_sgio and less-secure userspace whitelists.

Anvil, meet hammer.

>>> The thing is that both approaches aren't perfect here so you can make
>>> similar type of argument from the other side. If the system wants to
>>> give out raw hardware access to VMs, requiring it to delegate the
>>> device fully could be reasonable.
>>
>> No, it is not unfortunately.  Allowing to do discards is one thing,
>> allowing to disrupt the settings of a SAN is another.  You can only
>> delegate the device fully in these cases:
>>
>> (a) of course, if the guest is trusted;
>> (b) if QEMU is running as a confined user;
> 
> If the bulk of filtering can be solved with userland whitelisting as a
> confined user, it should be possible to resolve peripheral problems
> like log messages in simpler way, no? Can you please elaborate on the
> log message problem? Who's spewing those messages?

For example:

        if (bdev_write_same(bdev)) {
                unsigned char bdn[BDEVNAME_SIZE];

                if (!blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask,
                                             ZERO_PAGE(0)))
                        return 0;

                bdevname(bdev, bdn);
                pr_err("%s: WRITE SAME failed. Manually zeroing.\n", bdn);
        }

        return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);

The device exposes the ability to zero out LUN blocks, but the command is
not whitelisted and it fails.

Paolo
