From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Mon, 11 Jun 2007 21:19:18 -0700
Message-ID: <466E1EC6.90509@linux.intel.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:2662 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbXFLEUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 00:20:52 -0400
In-Reply-To: <466E1D51.9070007@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>

Tejun Heo wrote:
>> do you have data to support this?
> 
> Yeah, it was some Lenovo notebook.  Pavel is more familiar with the
> hardware.  Pavel, what was the notebook which didn't save much power
> with standard SATA power save but needed port to be completely turned off?

Pavel, if you have time, could you measure this with Kristen's patch?

> 
>> The data we have from this patch is that it saves typically a Watt of
>> power (depends on the machine of course, but the range is 0.5W to
>> 1.5W). If you want to also have an even more agressive thing where
>> you want to start disabling the entire controller... I don't see how
>> this is in conflict with saving power on the link level by "just"
>> enabling a hardware feature ....
> 
> Well, both implement about the same thing.  I prefer software
> implementation because it's more generic and ALPE/ASP seems too
> aggressive to me. 

Too aggressive in what way?

There are tradeoffs on either side. Doing things in software is more 
work for the cpu, and depending on the implementation, will consume 
more power on the CPU side. (for example if you need regular timers 
that just consumes the power you are saving back up). The hardware can 
obviously switch very fast (because it's independent of any software), 
yet of course the software has higher level knowledge about how idle 
the link really is (like it knows if any files are open etc etc).

To be honest, I would be surprised if software could do significantly 
better than hardware though; it seems a simple problem: Idle -> go to 
low power, and estimating idle isn't all that hard on a link level... 
there's not all THAT much the kernel can estimate better I suspect.


This debate is very similar to the cpufreq debate from 4 years ago, 
where there were 3 levels: do it in the CPU, do it in the kernel or do 
it in userspace. All three are valid; whichever is best depends on the 
exact hardware that you have...
(and you can argue that first everyone started in userspace, then the 
hardware improved that made a kernelspace implementation better 
(ondemand) and now Turbo Mode is more or less moving this to the 
hardware... I wouldn't be surprised if the sata side will show a 
similar trend)
