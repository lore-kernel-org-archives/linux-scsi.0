From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Thu, 15 Jul 2010 12:24:33 -0400
Message-ID: <4C3F3641.8020802@interlog.com>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> <m1zkxtinlw.fsf@fess.ebiederm.org> <201007150929.03916.konrad@kernel.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33866 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694Ab0GOQZo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2010 12:25:44 -0400
In-Reply-To: <201007150929.03916.konrad@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, Jens Axboe <axboe@kernel.dk>, Stephen Hemminger <shemminger@vyatta.com>, Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells <dhowells@redhat.com>, Dave Airlie <airlied@gmail.com>

On 10-07-15 09:29 AM, Konrad Rzeszutek Wilk wrote:
>
>>> and the box still won't boot.
>>
>> The reason FC6 doesn't boot is there is a userspace tool
>> I believe in the initrd that cares about symlinks when it should
>> not.
>
> It is not just nash. Also multipathd would fail (as it expects
> the /sys/scsi_host/..<something>  in certain directories), and 'lsscsi'. There
> might be other tools that depend on libsysfs to be affected by this as well.

lsscsi has been "CONFIG_SYSFS_DEPRECATED_V2" tolerant
since version 0.21 released 20080710. The current
version is 0.23 released 20091201 which will soon
be displaced by 0.24 to cope with the most recent
breakages.

Writing a user space tool that relies on sysfs structure
and contents, stable over the whole lk 2.6 series, is
impossible. For a history of my pain with lsscsi see
its ChangeLog.


Happily most of my tools are based on an ioctl! SG_IO
was a suggestion from Joerg Schilling and has now found
its way into most block devices. Now it has a new lease
of life in the bsg driver.

Doug Gilbert


