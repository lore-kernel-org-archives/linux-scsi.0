From: George Anzinger <george@mvista.com>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #2
Date: Tue, 23 Aug 2005 15:56:16 -0700
Message-ID: <430BA990.9090807@mvista.com>
References: <355e5e5e05080103021a8239df@mail.gmail.com>	 <4789af9e050823124140eb924f@mail.gmail.com> <4789af9e050823154364c8e9eb@mail.gmail.com>
Reply-To: george@mvista.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932476AbVHWW43@vger.kernel.org>
In-Reply-To: <4789af9e050823154364c8e9eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Ramsay <jim.ramsay@gmail.com>
Cc: Linux-ide <linux-ide@vger.kernel.org>, Lukasz Kosewski <lkosewsk@gmail.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jim Ramsay wrote:
> On 8/23/05, Jim Ramsay <jim.ramsay@gmail.com> wrote:
> 
>>Then I must have found an undocumented feature!  I've applied this set
>>of patches to a 2.6.11 kernel (with few problems) and ran into a bunch
>>of "scheduling while atomic" errors when hotplugging a drive, culprit
>>being probably scsi_sysfs.c where scsi_remove_device locks a mutex, or
>>perhaps when it then calls class_device_unregister, which does a
>>'down_write'.
> 
> 
> After further debugging, it appears that the problem is the debounce
> timer in libata-core.c.
> 
> Timers appear to operate in an atomic context, so timers should not be
> allowed to call scsi_remove_device, which eventually schedules.
> 
> Any suggestions on the best way to fix this?

Workqueue, perhaps.
> 

-- 
George Anzinger   george@mvista.com
HRT (High-res-timers):  http://sourceforge.net/projects/high-res-timers/
