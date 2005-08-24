From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #2
Date: Wed, 24 Aug 2005 03:20:01 +0200
Message-ID: <430BCB41.5070206@s5r6.in-berlin.de>
References: <355e5e5e05080103021a8239df@mail.gmail.com>	 <4789af9e050823124140eb924f@mail.gmail.com> <4789af9e050823154364c8e9eb@mail.gmail.com> <430BA990.9090807@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751335AbVHXBUQ@vger.kernel.org>
In-Reply-To: <430BA990.9090807@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

George Anzinger wrote:
> Jim Ramsay wrote:
>> On 8/23/05, Jim Ramsay <jim.ramsay@gmail.com> wrote:
>>> I've applied this set
>>> of patches to a 2.6.11 kernel (with few problems) and ran into a bunch
>>> of "scheduling while atomic" errors when hotplugging a drive, culprit
>>> being probably scsi_sysfs.c
...
>> After further debugging, it appears that the problem is the debounce
>> timer in libata-core.c.
>>
>> Timers appear to operate in an atomic context, so timers should not be
>> allowed to call scsi_remove_device, which eventually schedules.
>>
>> Any suggestions on the best way to fix this?
> 
> Workqueue, perhaps.

The USB and IEEE 1394 subsystems have kernel threads which manage node 
additions and removals (usb/storage/usb.c, ieee1394/nodemgr.c). The add 
and remove functions of their storage drivers are called from these 
threads' non-atomic context. However if you don't need an own thread for 
any further bus management purposes, a workqueue looks suitable for hot 
plugging and unplugging.
-- 
Stefan Richter
-=====-=-=-= =--- ==---
http://arcgraph.de/sr/
