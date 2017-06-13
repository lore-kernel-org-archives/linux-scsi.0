From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: Application stops due to ext4 filesytsem IO error
Date: Tue, 13 Jun 2017 19:01:17 +0530
Message-ID: <4e04ad5952109c9c319383e47c1df73c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33023 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdFMNbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2017 09:31:20 -0400
Received: by mail-oi0-f46.google.com with SMTP id s3so69540428oia.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2017 06:31:20 -0700 (PDT)
References: 3e25920f0068797bd74e5ea37a2dc3dc@mail.gmail.com bf603f1c2f3873f58717101abb3d9c83@mail.gmail.com
In-Reply-To: bf603f1c2f3873f58717101abb3d9c83@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Gentle ping.

I have opened kernel BZ for this. Here is the BZ link-
https://bugzilla.kernel.org/show_bug.cgi?id=196057

Thanks,
Sumit
>-----Original Message-----
>From: Sumit Saxena [mailto:sumit.saxena@broadcom.com]
>Sent: Tuesday, June 06, 2017 9:05 PM
>To: 'Jens Axboe'
>Cc: 'linux-block@vger.kernel.org'; 'linux-scsi@vger.kernel.org'
>Subject: RE: Application stops due to ext4 filesytsem IO error
>
>Gentle ping..
>
>>-----Original Message-----
>>From: Sumit Saxena [mailto:sumit.saxena@broadcom.com]
>>Sent: Monday, June 05, 2017 12:59 PM
>>To: 'Jens Axboe'
>>Cc: 'linux-block@vger.kernel.org'; 'linux-scsi@vger.kernel.org'
>>Subject: Application stops due to ext4 filesytsem IO error
>>
>>Jens,
>>
>>We am observing  application stops while running ext4 filesystem IOs
>>along with target reset in parallel.
>>Our suspect is this behavior can be attributed to linux block layer.
>>See below for details-
>>
>>Problem statement - " Application stops due to IO error from file
>>system buffered IO. (Note - It is always a FS meta data read failure)"
>>Issue is reproducible - "Yes. It is consistently reproducible."
>>Brief about setup -
>>Latest 4.11 kernel. Issue hits irrespective of whether SCSI MQ is
>>enabled or disabled. use_blk_mq=Y and use_blk_mq=N has similar issue.
>>Direct attached 4 SAS/SATA drives connected to MegaRAID Invader
>>controller.
>>
>>Reproduction steps -
>>-Create ext4 FS on 4 JBODs(non RAID volumes) behind MegaRAID SAS
>>controller.
>>-Start Data integrity test on all four ext4 mounted partition. (Tool
>>should be configured to send Buffered FS IO).
>>-Send Target Reset  (have some delay between next reset to allow some
>>IO on device) on each JBOD to simulate error condition. (sg_reset -d
>/dev/sdX).
>>
>>End result -
>>Combination of target resets and FS IOs in parallel causes application
>>halt with ext4 Filesystem IO error.
>>We are able to restart  application without cleaning and unmounting
>>filesystem.
>>Below are the error logs at the time of application stop-
>>
>>--------------------------
>>sd 0:0:53:0: target reset called for
>>scmd(ffff88003cf25148)
>>sd 0:0:53:0: attempting target reset!
>>scmd(ffff88003cf25148) tm_dev_handle 0xb
>>sd 0:0:53:0: [sde] tag#519 BRCM Debug: request->cmd_flags: 0x80700
>bio-
>>>bi_flags: 0x2          bio->bi_opf: 0x3000 rq_flags 0x20e3
>>..
>>sd 0:0:53:0: [sde] tag#519 CDB: Read(10) 28 00 15 00 11 10 00 00 f8 00
>>EXT4-fs error (device sde): __ext4_get_inode_loc:4465: inode #11018287:
>>block 44040738: comm chaos: unable to read itable block
>>-----------------------
>>
>>We debug further to understand what is happening above LLD. See below-
>>
>>During target reset,  there may be IO coming from target with CHECK
>>CONDITION with below sense information-.
>>Sense Key : Aborted Command [current]
>>Add. Sense: No additional sense information
>>
>>Such Aborted command should be retried by SML/Block layer. This happens
>>from SML expect for FS Meta data read.
>>From driver level debug, we found IOs with REQ_FAILFAST_DEV bit set in
>>scmd->request->cmd_flags are not retried by SML and that is also as
>>expected.
>>
>>Below is the code in scsi_error.c(function- scsi_noretry_cmd) which
>>causes IOs with REQ_FAILFAST_DEV enabled not getting retried bit
>>completed back to upper layer-
>>--------
>>/*
>>     * assume caller has checked sense and determined
>>     * the check condition was retryable.
>>     */
>>    if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
>>        scmd->request->cmd_type == REQ_TYPE_BLOCK_PC)
>>        return 1;
>>    else
>>        return 0;
>>--------
>>
>>IO which causes application to stop has REQ_FAILFAST_DEV enabled inside
>>"scmd->request->cmd_flags". We noticed that this bit will be set for
>>filesystem Read ahead meta data IOs. In order to confirm the same, we
>>mounted with option inode_readahead_blks=0 to disable ext4's inode
>>table readahead algorithm and did not observe the issue. Issue does not
>>hit with DIRECT IOs but only with cached/buffered IOs.
>>
>>2. From driver level debug prints, we also noticed - There are many IO
>>failures with REQ_FAILFAST_DEV handled gracefully by filesystem.
>>Application level failure happens only If IO has RQF_MIXED_MERGE set.
>>If IO merging is disabled through sysfs parameter for SCSI device in
>>question- nomerges set to 2, we are not seeing the issue.
>>
>>3. We added few prints in driver to dump "scmd->request->cmd_flags" and
>>"scmd->request->rq_flags" for IOs completed with CHECK CONDITION and
>>culprit IOs has all these bits- REQ_FAILFAST_DEV and REQ_RAHEAD bit set
>>in "scmd->request->cmd_flags" and RQF_MIXED_MERGE bit set in "scmd-
>>>request->rq_flags". Also it's not necessarily true that all IOs with
>>>request->these
>>three bits set will cause issue but whenever issue hits, these three
>>bits are set for IO causing failure.
>>
>>
>>In summary,
>>FS mechanism of using READ AHEAD for meta data works fine (in case of
>>IO
>>failure) if there is no mix/merge at block layer.
>>FS mechanism of using READ AHEAD for meta data has some corner case
>>which is not handled properly (in case of IO failure) if  there was
>>mix/merge at block layer.
>>megaraid_sas driver's behavior seems correct here. Aborted IO goes to
>>SML with CHECK CONDITION settings and SML decided to fail fast IO as it
>>was requested.
>>
>>Query -  Is this block layer (page cache) issue?  What should be the
ideal fix
>?
>>
>>Thanks,
>>Sumit
