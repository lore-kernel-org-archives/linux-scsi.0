From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: runtime change of use_blk_mq ?
Date: Thu, 11 Aug 2016 00:49:44 +0200
Message-ID: <201608110049.44832.a.miskiewicz@gmail.com>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36028 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbcHJWtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 18:49:49 -0400
Received: by mail-wm0-f46.google.com with SMTP id q128so120431460wma.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 15:49:48 -0700 (PDT)
Received: from xps.localnet (89-75-168-105.dynamic.chello.pl. [89.75.168.105])
        by smtp.gmail.com with ESMTPSA id g40sm7994215ljg.22.2016.08.10.15.49.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 15:49:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi.

Is runtime enabling/disabling of blk-mq  supported?

Doesn't seem to work here:

4.1.30 (but the same thing on 4.6.3):

# zcat /proc/config.gz |grep _MQ_DEF
# CONFIG_SCSI_MQ_DEFAULT is not set
# CONFIG_DM_MQ_DEFAULT is not set
# cat  /sys/module/scsi_mod/parameters/use_blk_mq
N
# grep "" /sys/block/sd*/queue/scheduler
/sys/block/sda/queue/scheduler:noop [deadline] cfq
/sys/block/sdb/queue/scheduler:noop [deadline] cfq
/sys/block/sdc/queue/scheduler:noop [deadline] cfq
/sys/block/sdd/queue/scheduler:noop [deadline] cfq
/sys/block/sde/queue/scheduler:noop [deadline] cfq
/sys/block/sdf/queue/scheduler:noop [deadline] cfq
/sys/block/sdg/queue/scheduler:noop [deadline] cfq
# echo Y > /sys/module/scsi_mod/parameters/use_blk_mq
# cat  /sys/module/scsi_mod/parameters/use_blk_mq
Y
# grep "" /sys/block/sd*/queue/scheduler
/sys/block/sda/queue/scheduler:noop [deadline] cfq
/sys/block/sdb/queue/scheduler:noop [deadline] cfq
/sys/block/sdc/queue/scheduler:noop [deadline] cfq
/sys/block/sdd/queue/scheduler:noop [deadline] cfq
/sys/block/sde/queue/scheduler:noop [deadline] cfq
/sys/block/sdf/queue/scheduler:noop [deadline] cfq
/sys/block/sdg/queue/scheduler:noop [deadline] cfq

so use_blk_mq is Y but queue/scheduler for existing devices still contains I/O 
schedulers and shows deadline as active. Looks like blk-mq is not active.

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
