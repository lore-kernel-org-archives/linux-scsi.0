From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Thu, 15 Jul 2010 10:02:16 -0700
Message-ID: <20100715170216.GA21592@suse.de>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> <m1zkxtinlw.fsf@fess.ebiederm.org> <201007150929.03916.konrad@kernel.org> <4C3F3641.8020802@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839Ab0GORBt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2010 13:01:49 -0400
Content-Disposition: inline
In-Reply-To: <4C3F3641.8020802@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, Jens Axboe <axboe@kernel.dk>, Stephen Hemminger <shemminger@vyatta.com>, Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells <dhowells@redhat.com>, Dave Airlie <airlied@gmail.com>

On Thu, Jul 15, 2010 at 12:24:33PM -0400, Douglas Gilbert wrote:
> On 10-07-15 09:29 AM, Konrad Rzeszutek Wilk wrote:
>>
>>>> and the box still won't boot.
>>>
>>> The reason FC6 doesn't boot is there is a userspace tool
>>> I believe in the initrd that cares about symlinks when it should
>>> not.
>>
>> It is not just nash. Also multipathd would fail (as it expects
>> the /sys/scsi_host/..<something>  in certain directories), and 'lsscsi'. There
>> might be other tools that depend on libsysfs to be affected by this as well.
>
> lsscsi has been "CONFIG_SYSFS_DEPRECATED_V2" tolerant
> since version 0.21 released 20080710. The current
> version is 0.23 released 20091201 which will soon
> be displaced by 0.24 to cope with the most recent
> breakages.
>
> Writing a user space tool that relies on sysfs structure
> and contents, stable over the whole lk 2.6 series, is
> impossible. For a history of my pain with lsscsi see
> its ChangeLog.

Yeah, I'd recommend using libudev for any new tools if you want to
interact with sysfs.  It's much easier than mucking around with it
directly and will be future-proof as udev can handle a lot of changes to
sysfs that other tools might not realize.

thanks,

greg k-h
