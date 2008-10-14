From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: Checkin 7404ad3b6d04efbd918e9e2e776bf560fbedf47d breaks boot
	on KVM
Date: Tue, 14 Oct 2008 20:00:06 +0200
Message-ID: <20081014175901.GA5584@joi>
References: <48F3E1C9.6030007@zytor.com> <1223990609.12440.8.camel@localhost.localdomain> <48F4C237.2060103@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753033AbYJNSBX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48F4C237.2060103@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jejb@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 14, 2008 at 09:00:55AM -0700, H. Peter Anvin wrote:
> James Bottomley wrote:
>> Actually, it is surprising.  That patch takes the default arithmetic for
>> calculating the disk size out of sd and uses a routine to do it more
>> efficiently in lib/string_helpers.c
>> So there are two problems:  Why does it panic on revert (could you post
>> the oops) and what does kvm object to in string_get_size ... it's a
>> fairly innocuous routine as I read it ... your symptoms sound like the
>> for loop isn't terminating.
>
> Here is the oops.  Note that it does get well past the hang point before it 
> crashes.  It is 100% reproducible.
>
> (...)
> BUG: spinlock bad magic on CPU#0, swapper/1
>  lock: c0b75418, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> Pid: 1, comm: swapper Not tainted 2.6.27 #17
> Call Trace:
>  [<c0597388>] ? printk+0xf/0x17
>  [<c03ac8ae>] spin_bug+0x75/0x80
>  [<c03ac97c>] _raw_spin_lock+0x1e/0xe4
>  [<c0412a3f>] ? serial8250_startup+0x33e/0x4e5
>  [<c0599821>] _spin_lock_irq+0x32/0x3a
>  [<c0412a3f>] ? serial8250_startup+0x33e/0x4e5
>  [<c0412a3f>] serial8250_startup+0x33e/0x4e5
>  [<c040f5fb>] uart_startup+0x84/0x143
>  [<c0410309>] uart_open+0x14b/0x381
>  [<c05996ba>] ? _spin_unlock+0x27/0x3c
>  [<c03f483f>] ? check_tty_count+0x3b/0x8a
>  [<c03f70b9>] tty_open+0x263/0x366
>  [<c0271b2a>] chrdev_open+0x168/0x180
>  [<c026df19>] __dentry_open+0x146/0x234
>  [<c026e08e>] nameidata_to_filp+0x1f/0x33
>  [<c02719c2>] ? chrdev_open+0x0/0x180
>  [<c0278ed1>] do_filp_open+0x342/0x659
>  [<c023651c>] ? trace_hardirqs_off+0xb/0xd
>  [<c05996ba>] ? _spin_unlock+0x27/0x3c
>  [<c026dcff>] do_sys_open+0x42/0xb7
>  [<c026ddb6>] sys_open+0x1e/0x26
>  [<c0201216>] init_post+0x2a/0x13c
>  [<c0203d53>] ? kernel_thread_helper+0x7/0x10

It's a different issue.
See: http://lkml.org/lkml/2008/10/13/470 and http://lkml.org/lkml/2008/10/13/474

Marcin
