From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Wed, 20 Nov 2002 07:45:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211200737020.12032-100000@home.transmeta.com>
References: <20021120072653.BC52C2C055@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021120072653.BC52C2C055@lists.samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexander Viro <viro@math.psu.edu>, Doug Ledford <dledford@redhat.com>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Wed, 20 Nov 2002, Rusty Russell wrote:
> 
> 	Linus, I would like an answer: how does one register two /proc
> entries?

I think the answer is simple: you don't.

In practice this doesn't happen. And even in theory when it does happen, 
trying to do it right is _worse_ than just letting it be. So what if one 
of them fails? Big deal. You didn't get the file, because you are playing 
with modules that do something that they shouldn't have done.

	Rule #1: KISS

	Rule #2: "don't overdesign" aka "perfect is the enemy of the good"

In other words, screw the cases that don't matter, we only need to verify 
that we don't oops. Which means that the _right_ approach for proc entries 
is something like this:

	if (register_device(....))
		return -ENOMEM;

	if (!create_proc_entry("foo"...))
		printk("Unable to create '/proc/foo'\n");
	if (!create_proc_entry("bar"...))
		printk("Unable to create '/proc/bar'\n");
	return 0;

and simply face the fact that trying to fail the module load at a late 
time is a bad idea, and if somebody already has registered your /proc 
entries then the system maintainer is doing something wrong and it is 
_his_ problem and he can

The kernel shouldn't oops. And if that means that we should just leave the 
module loaded (not return an error), then so what? Hey, it may work fine 
without the /proc entries, erroring out might be _worse_.

This is what happens with built-in drivers already. Modules are nothing 
but a convenience. They're not "worthy" of complexity.

		Linus
