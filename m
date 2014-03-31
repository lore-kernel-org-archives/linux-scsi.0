From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: scsi_debug driver puzzle
Date: Mon, 31 Mar 2014 19:01:32 +0100
Message-ID: <5339AD7C.3020302@redhat.com>
References: <CAAzz28gZtn5HaXwQvmvnyK0wAWn-9et8Z8ZL9HVYDvLqFv9ibA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaCaSBh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 14:01:37 -0400
In-Reply-To: <CAAzz28gZtn5HaXwQvmvnyK0wAWn-9et8Z8ZL9HVYDvLqFv9ibA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 03/31/2014 06:32 PM, Laurence Oberman wrote:
>   File         Line
> 0 scsi_debug.c 3551 int scsi_debug_queuecommand_lck(struct scsi_cmnd
> *SCpnt, done_funct_t done)
> 1 scsi_debug.c 3900 static DEF_SCSI_QCMD(scsi_debug_queuecommand)
> 2 scsi_debug.c 3912 .queuecommand =  scsi_debug_queuecommand,

Magical scsi_host.h macro as part of the effort to push host_lock down.
The macro creates a function named as its argument which takes and drops
the shost->host_lock around a call to the real queuecommand function:

        spin_lock_irqsave(shost->host_lock, irq_flags);
        scsi_cmd_get_serial(shost, cmd);
        rc = func_name##_lck (cmd,cmd->scsi_done);
        spin_unlock_irqrestore(shost->host_lock, irq_flags);

http://fpaste.org/90345/88875139/

Cheers,
Bryn.
