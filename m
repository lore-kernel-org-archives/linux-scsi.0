From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Wed, 14 Jul 2010 17:40:27 -0700
Message-ID: <m1zkxtinlw.fsf@fess.ebiederm.org>
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100714163852.b3c09930.akpm@linux-foundation.org> (Andrew Morton's message of "Wed\, 14 Jul 2010 16\:38\:52 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, Jens Axboe <axboe@kernel.dk>, Stephen Hemminger <shemminger@vyatta.com>, Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells <dhowells@redhat.com>, Dave Airlie <airlied@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 9 Jul 2010 11:54:50 -0700
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
>
>> This is no longer needed by any userspace tools, so it's safe to
>> remove.
>
> Makes my FC6 test box not boot - can't find /dev/root.  Then when I go
> back to plain old mainline (2.6.35-rc5) and run `make oldconfig', the
> .config change sticks:
>
> @@ -106,8 +106,7 @@
>  CONFIG_LOG_BUF_SHIFT=17
>  CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>  # CONFIG_CGROUPS is not set
> -CONFIG_SYSFS_DEPRECATED=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> +# CONFIG_SYSFS_DEPRECATED_V2 is not set
>  CONFIG_RELAY=y
>  CONFIG_NAMESPACES=y
>  # CONFIG_UTS_NS is not set
>
> and the box still won't boot.

The reason FC6 doesn't boot is there is a userspace tool
I believe in the initrd that cares about symlinks when it should
not.

What is more interesting is that currently there is a bug in
2.6.35-rc5 where rmmod <netdriver> modprobe <netdriver> will in fact
fail.  There was an inadvertent regression and no one has noticed or
complained.  I spotted it by code review just a little bit ago and I
haven't had a chance to write and test the fix yet.

If the code is going to start bitrotting and no one is going to
notice or care simply removing the code instead of subjecting users
to weird unexpected breakage seems like a responsible thing to do.

Eric
