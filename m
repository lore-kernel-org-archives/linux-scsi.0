From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Thu, 14 Feb 2008 12:49:33 +0200
Message-ID: <47B41CBD.8040701@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>	 <1202917468.3109.5.camel@localhost.localdomain>	 <47B312B3.3010200@panasas.com>  <47B31BDE.2030408@panasas.com>	 <1202921122.3109.31.camel@localhost.localdomain>	 <47B31FC2.4040206@panasas.com>	 <1202922226.3109.36.camel@localhost.localdomain>	 <47B324E7.9040502@panasas.com> <1202924198.3109.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762017AbYBNKvt@vger.kernel.org>
In-Reply-To: <1202924198.3109.52.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?UTF-8?B?U3ZlbiBLw7ZobGVy?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 13 2008 at 19:36 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
<snip>
>> ---
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Subject: [PATCH] gdth: bugfix for the at-exit problems
>>
>> gdth_exit would first remove all cards then stop the timer
>> and would not sync with the timer function. This caused a crash
>> in gdth_timer() when module was unloaded.
>> So del_timer_sync the timer before we delete the cards.
>>
>> also the reboot notifier function would crash. So unify
>> the exit and halt functions with a gdth_shutdown() that's
>> called by both.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
<snip>
>> +static struct notifier_block gdth_notifier = {
>> +    gdth_halt, NULL, 0
>> +};
>> +
>> +bool gdth_shutdown_done;
> 

right forgot the static. But I use it in gdth_init(), so it
must be external. Unless you promise me that gdth_init() will
never ever be called after a call to shutdown.
Any way the hot-plug patch changes all that. This is only
for 2.6.24 bugfixs.

> Static police alert!  Just make it static and move it into
> gdth_shutdown()
> 
>> +static void gdth_shutdown()
>> +{
>> +	gdth_ha_str *ha;
>> +	if (gdth_shutdown_done)
>> +		return;
>> +
>> +	gdth_shutdown_done = true;
>> +	unregister_chrdev(major,"gdth");
>> +	unregister_reboot_notifier(&gdth_notifier);
> 
> I'm not sure you can do this, aren't reboot notifiers called with the
> rwsem held?  In which case the unregister which also takes the rwsem
> will hang the system.
> 
humm, can't remove a notifier from within the notifier. Thanks James for 
the catch, it's what happens when you don't test your own patches.

I have moved unregister_reboot_notifier to gdth_exit.
> James
> 

Will send a new version for review. Please note that this is a bugfix patch
on top of 2.6.24. It is not needed for Jeff's hot-plug path.

There will be one more bugfix patch for a crash at the user-mode ioctl code.

Boaz
