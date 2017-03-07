From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: Help needed for a SCSI hang (SATA drives)
Date: Tue, 7 Mar 2017 12:58:38 +0100
Message-ID: <CAD+HZHXv87Brm=QSgh77PpX9G-yfMWAn1RmonuH45dumc04=Mg@mail.gmail.com>
References: <CAF9xHmThNk7m5hK-R_JGD2KMhJkm-yaDgrW6CeMdfUtjjRzF3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34623 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754681AbdCGM24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 07:28:56 -0500
Received: by mail-lf0-f49.google.com with SMTP id k202so85312lfe.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2017 04:28:55 -0800 (PST)
In-Reply-To: <CAF9xHmThNk7m5hK-R_JGD2KMhJkm-yaDgrW6CeMdfUtjjRzF3g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: V <viswesh.vichu@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2017-03-07 1:54 GMT+01:00 V <viswesh.vichu@gmail.com>:
> Hi,
>
> I am reaching out regarding a SCSI error handler issue, which we see
> in our lab systems.
>
> Environment: Ubuntu 4.4.0-31-generic
>
> Issue: Write IOs are getting stuck in our system randomly. All drives
> seen with the issue are all SATA drives.
> Root cause: SCSI error handler is not woken up (or) it is up, but not
> able to flush commands and hence the IOs get stuck. (as the requests
> are not flushed out and host is not restarted)
>
> We have 6 instances seen till now.
>
> This is what we see.
> 1) As part of testing our drives, we start lot of read/writes, along
> with some user space utilities running to check the drive health.
> 1) In our recent testing, we see lot of commands going through the
> "abort scheduled" path. And we see that in between, for one of the
> commands, the error handler is not woken up, and majority of
> processes, which were writing, gets stalled.
> 2) We are still trying to figure out what is causing this much number
> of abort? Is it usual? Are there some other debugs, which I could
> enable to get more information? We know these are user space commands
> which are being aborted, but not sure which exact command it is for
> now.
> 3) I see the "abort scheduled" messages in almost all drives in all
> systems, hence i dont believe it is a drive issue.
> 4) I checked the host_failed and host_busy variables, both are set to
> 1 in system 1. 2nd one is still alive, havent taken a crash dump yet.
> 5) All drives seen with the issue are SATA drives.
> 6) I have attached udevadm info of a drive which failed in system 2.
>
> Thanks in advance,
> Viswesh
>
>
> Logs
> -------
> System 1
>
> [371546.605736] sd 9:0:0:0: scsi_block_when_processing_errors: rtn: 1
> [371546.606727] sd 9:0:0:0: scsi_block_when_processing_errors: rtn: 1
> [371546.607721] sd 9:0:0:0: scsi_block_when_processing_errors: rtn: 1
> [371546.618113] sd 9:0:0:0: [sg19] tag#20 abort scheduled
> [371546.624039] sd 9:0:0:0: [sg19] tag#20 aborting command
> [371546.624045] sd 9:0:0:0: [sg19] tag#20 cmd abort failed
> [371546.624051] scsi host9: Waking error handler thread
> [371546.624060] scsi host9: scsi_eh_9: waking up 0/1/1
> [371546.624081] sd 9:0:0:0: [sg19] tag#20 scsi_eh_9: flush finish cmd
> [371546.624095] scsi host9: waking up host to restart
> [371546.624098] scsi host9: scsi_eh_9: sleeping
>
>
> [371546.635314] sd 8:0:0:0: [sg17] tag#13 abort scheduled
> [371546.640031] sd 8:0:0:0: [sg17] tag#13 aborting command
> [371546.640037] sd 8:0:0:0: [sg17] tag#13 cmd abort failed
> [371546.640043] scsi host8: Waking error handler thread
> [371546.640078] scsi host8: scsi_eh_8: waking up 0/1/1
> [371546.640098] sd 8:0:0:0: [sg17] tag#13 scsi_eh_8: flush finish cmd
> [371546.640113] scsi host8: waking up host to restart
> [371546.640117] scsi host8: scsi_eh_8: sleeping
>
> [371546.657269] sd 6:0:0:0: [sg12] tag#1 abort scheduled
> [371546.664034] sd 6:0:0:0: [sg12] tag#1 aborting command
> [371546.664040] sd 6:0:0:0: [sg12] tag#1 cmd abort failed
>
> Here we can see that, error handler is not woken up.  And the entire
> IO subsystem goes for a toss.
>
> [371777.594510] INFO: task md2_raid1:508 blocked for more than 120 seconds.
> [371777.594571]      Not tainted 4.4.0-31-generic #50~14.04.1-Ubuntu
> [371777.594613] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [371777.594665] md2_raid1      D ffff883fed2afc78    0  508      2 0x00000000
> [371777.594673]  ffff883fed2afc78 ffff881fef0e8000 ffff883fed21c4c0
> ffff883fed2b0000
> [371777.594678]  ffff883ff236e298 ffff883ff236e000 ffff883ff236e018
> ffff883ff236e018
>
> By enabling more scsi logs(in a different system), including LL, we
> get some more info ( I have enabled the full scsi levels for all
> categories and it is still running)
>
>
> System 2
>
> [405197.171574] sd 5:0:0:0: [sg3] sg_write: count=3D88
> [405197.171577] sd 5:0:0:0: scsi_block_when_processing_errors: rtn: 1
> [405197.171581] sd 5:0:0:0: [sg3] sg_common_write:  scsi
> opcode=3D0x85, cmd_size=3D16
> [405197.171583] sd 5:0:0:0: [sg3] sg_start_req: dxfer_len=3D512
> [405197.171605] sd 5:0:0:0: [sg3] sg_link_reserve: size=3D512
> [405197.171623] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104
> [405197.172648] sd 5:0:0:0: [sg3] sg_cmd_done: pack_id=3D0, res=3D0x0
> [405197.172701] sd 5:0:0:0: [sg3] sg_poll: res=3D0x145
> [405197.172710] sd 5:0:0:0: [sg3] sg_read: count=3D88
> [405197.172716] sd 5:0:0:0: [sg3] sg_finish_rem_req: res_used=3D1
> [405197.172721] sd 5:0:0:0: [sg3] sg_unlink_reserve: req->k_use_sg=3D1
> [405197.172756] sd 5:0:0:0: [sg3] sg_write: count=3D88
> [405197.172760] sd 5:0:0:0: scsi_block_when_processing_errors: rtn: 1
> [405197.172764] sd 5:0:0:0: [sg3] sg_common_write:  scsi
> opcode=3D0x85, cmd_size=3D16
> [405197.172767] sd 5:0:0:0: [sg3] sg_start_req: dxfer_len=3D512
> [405197.172774] sd 5:0:0:0: [sg3] sg_link_reserve: size=3D512
> [405197.172793] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104
> [405197.173806] sd 5:0:0:0: [sg3] sg_cmd_done: pack_id=3D0, res=3D0x0
> [405197.173829] sd 5:0:0:0: [sg3] sg_poll: res=3D0x145
> [405197.173836] sd 5:0:0:0: [sg3] sg_read: count=3D88
> [405197.173839] sd 5:0:0:0: [sg3] sg_finish_rem_req: res_used=3D1
> [405197.173843] sd 5:0:0:0: [sg3] sg_unlink_reserve: req->k_use_sg=3D1
> [405197.173893] sd 5:0:0:0: [sg3] sg_write: count=3D88
> [405197.173896] sd 5:0:0:0: scsi_block_when_processing_errors: rtn: 1
> [405197.173900] sd 5:0:0:0: [sg3] sg_common_write:  scsi
> opcode=3D0x85, cmd_size=3D16
> [405197.173903] sd 5:0:0:0: [sg3] sg_start_req: dxfer_len=3D0
> [405197.173921] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104
>
> [405197.174082] sd 5:0:0:0: [sg3] tag#5 abort scheduled
> [405197.179372] sd 5:0:0:0: [sg3] tag#5 aborting command
> [405197.179378] sd 5:0:0:0: [sg3] tag#5 cmd abort failed
>
> [405257.225584] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104
> [405257.225599] sd 5:0:0:0: [sg3] sg_release
> [405257.225617] sd 5:0:0:0: [sg3] sg_open: flags=3D0x8002
>
> Error handler thread is not waken up here (or) i dont see flush
> command trace (even if it is already woken up)
>
> [405349.082863] INFO: task md2_raid1:484 blocked for more than 120 seconds
> [405349.082922]      Not tainted 4.4.0-31-generic #50~14.04.1-Ubuntu
> [405349.082964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [405349.083016] md2_raid1      D ffff881feca2bc78    0  484      2 0x00000000

Can you reproduce without md raid1? I suppose it shouldn't related.

You mentioned it's only with SATA, are they all the same HDDs or from
different vendors?

Regards,
Jack
