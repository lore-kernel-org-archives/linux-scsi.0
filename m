From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: runtime change of use_blk_mq ?
Date: Wed, 10 Aug 2016 15:57:17 -0700
Message-ID: <ea50fda5-d120-b9b2-0efe-73c55c8187a2@sandisk.com>
References: <201608110049.44832.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0059.outbound.protection.outlook.com ([104.47.37.59]:47584
	"EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbcHJW5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 18:57:30 -0400
In-Reply-To: <201608110049.44832.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arekm@maven.pl, linux-scsi@vger.kernel.org

On 08/10/2016 03:49 PM, Arkadiusz Miskiewicz wrote:
> Is runtime enabling/disabling of blk-mq  supported?
>
> Doesn't seem to work here:
>
> 4.1.30 (but the same thing on 4.6.3):
>
> # zcat /proc/config.gz |grep _MQ_DEF
> # CONFIG_SCSI_MQ_DEFAULT is not set
> # CONFIG_DM_MQ_DEFAULT is not set
> # cat  /sys/module/scsi_mod/parameters/use_blk_mq
> N
> # grep "" /sys/block/sd*/queue/scheduler
> /sys/block/sda/queue/scheduler:noop [deadline] cfq
> /sys/block/sdb/queue/scheduler:noop [deadline] cfq
> /sys/block/sdc/queue/scheduler:noop [deadline] cfq
> /sys/block/sdd/queue/scheduler:noop [deadline] cfq
> /sys/block/sde/queue/scheduler:noop [deadline] cfq
> /sys/block/sdf/queue/scheduler:noop [deadline] cfq
> /sys/block/sdg/queue/scheduler:noop [deadline] cfq
> # echo Y > /sys/module/scsi_mod/parameters/use_blk_mq
> # cat  /sys/module/scsi_mod/parameters/use_blk_mq
> Y
> # grep "" /sys/block/sd*/queue/scheduler
> /sys/block/sda/queue/scheduler:noop [deadline] cfq
> /sys/block/sdb/queue/scheduler:noop [deadline] cfq
> /sys/block/sdc/queue/scheduler:noop [deadline] cfq
> /sys/block/sdd/queue/scheduler:noop [deadline] cfq
> /sys/block/sde/queue/scheduler:noop [deadline] cfq
> /sys/block/sdf/queue/scheduler:noop [deadline] cfq
> /sys/block/sdg/queue/scheduler:noop [deadline] cfq
>
> so use_blk_mq is Y but queue/scheduler for existing devices still contains I/O
> schedulers and shows deadline as active. Looks like blk-mq is not active.

Hello Arkadiusz,

 From drivers/scsi/hosts.c, scsi_host_alloc():

shost->use_blk_mq = scsi_use_blk_mq && !shost->hostt->disable_blk_mq;

In other words, if you want the change of 
/sys/module/scsi_mod/parameters/use_blk_mq to become effective, you will 
have to trigger SCSI host removal and re-add. For a boot drive this is 
not possible. But when using a SCSI-over-network driver unloading and 
reloading the appropriate SCSI LLD should be sufficient. Some SCSI LLD 
drivers, e.g. ib_srp, allow to log out and relogin without unloading and 
reloading the kernel driver.

Bart.
