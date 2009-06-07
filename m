From: "NeilBrown" <neilb@suse.de>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 08:55:03 +1000 (EST)
Message-ID: <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
References: <200906061959.55592.chris2553@googlemail.com>
    <200906062215.30571.chris2553@googlemail.com>
    <1244381140.30664.12.camel@ht.satnam>
    <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
    <1244413881.18742.31.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756710AbZFGWz2@vger.kernel.org>
In-Reply-To: <1244413881.18742.31.camel@ht.satnam>
Sender: linux-kernel-owner@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Chris Clayton <chris2553@googlemail.com>, linux-kernel@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, June 8, 2009 8:31 am, Jaswinder Singh Rajput wrote:
> On Sun, 2009-06-07 at 19:38 +0100, Chris Clayton wrote:
>> 2009/6/7 Jaswinder Singh Ra
>> >> > http://img231.imageshack.us/img231/8931/dscn0610.jpg

This message says that it found a vfat filesystem on 8:3x (I cannot see
what digit should be 'x').  That is probably sdc1 or sdc2. Maybe even
sdc6 or sdc7.
However the vfat filesystem didn't have /sbin/init.

>> http://img99.imageshack.us/my.php?image=dscn0617b.jpg

This one says it couldn't find anything at 8,22, which I think
should be sdb6.
It also shows that you have and sdc6, but sdb only goes up to sdb3.

So it seems that your disk drives have changed name - not a wholely
unexpected event these days.

We now need answers to questions like:
 - what device do you expect the root filesystem to be on
 - how is the kernel being told this?  Maybe it is hard coded
    into your initrd.  Knowing which distro and what /etc/fstab
    says might help (though it wouldn't help me, I'm just about out
    of my depth at this point)
Maybe if you changed /etc/fstab to mount by uuid instead of hardcoding
e.g. /etc/sdb3, and then run "mkinitramfs" or whatever, it might work.

Good luck,
NeilBrown
