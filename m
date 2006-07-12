From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: question about sd_sync_cache and shutdown
Date: Wed, 12 Jul 2006 20:49:37 +0200
Message-ID: <44B54441.1030300@s5r6.in-berlin.de>
References: <44B44909.1000703@cs.wisc.edu> <44B5227C.5080707@s5r6.in-berlin.de> <44B52639.4040609@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:2521 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932429AbWGLSub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 14:50:31 -0400
In-Reply-To: <44B52639.4040609@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Stefan Richter wrote:
...
>>scsi_remove_device.) The last time I checked (2.6.16), this *always*
>>called SCSI high-level's shutdown methods, particularly sd_sync_cache.
...
> If the ULD's shutdown function is called during system shutdown when all
> the other shutdown routines are called the sdev state is online and so
> the sync cache will be sent. If you call scsi_remove_device manually or
> through scsi_remove_host the sdev state will be in the cancel state and
> so the command will not get sent.

You are right and I am wrong.

Indeed, 2.6.16 does not call sd_sync_cache anymore when the driver 
called scsi_remove_device. I just had a look at Linus' history via 
gitweb but did not find which patch changed that behaviour. I think 
2.6.13 and probably 2.6.14 still sync'ed the cache. I don't know about 
2.6.15. But Linux 2.6.13's scsi_remove_device sets the state to CANCEL 
too before proceding to remove the device.

The difference is that 2.6.13's sd_shutdown had 
if(!(sdkp=dev_get_drvdata(dev))) return; instead of now 
if(!(sdkp=scsi_disk_get_from_dev(dev))) return;. scsi_disk_get_from_dev 
essentially evaluates to (dev_get_drvdata(...) && disk->private_data && 
scsi_device_get(sdkp->device)).

...
>> Sbp2 does not use scsi_device_set_state.
> 
> Neither does iscsi or FC or any other transport or driver.

(The SPI transport and dpt_i2o.c do.)
-- 
Stefan Richter
-=====-=-==- -=== -==--
http://arcgraph.de/sr/
