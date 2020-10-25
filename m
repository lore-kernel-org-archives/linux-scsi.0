Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14459C55178
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 15:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE02E20790
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 15:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417004AbgJYPjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 11:39:19 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50469 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1416999AbgJYPjS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 11:39:18 -0400
Received: from [192.168.0.6] (ip5f5ae91d.dynamic.kabel-deutschland.de [95.90.233.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3F6EE20643C72;
        Sun, 25 Oct 2020 16:39:09 +0100 (CET)
Subject: Re: smartpqi: Adaptec 1100-8e failure with Linux 5.9
To:     Don.Brace@microchip.com
References: <7d22510c-da28-ea2d-a1b1-fc9e126879d1@molgen.mpg.de>
 <SN6PR11MB2848E684D3C996A0707417F9E1030@SN6PR11MB2848.namprd11.prod.outlook.com>
Cc:     storagedev@microchip.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <1d968915-e450-1511-e1f6-0ac98b4dccc5@molgen.mpg.de>
Date:   Sun, 25 Oct 2020 16:39:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848E684D3C996A0707417F9E1030@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16.10.20 20:33, Don.Brace@microchip.com wrote:
> 
> The 6100C lockup is the result of the controller running out of commands to process new incoming requests from the driver.
> 
> We are actively looking into this issue.
> 
> We will keep you posted,

Dear Don,

thanks for your reply regarding this issue.

So Linux since 5.9 seems to have a problem with the Adaptec 1100-8e controllers, which my colleague Paul and me accidentally reported redundantly to linux-scsi (Paul also included LKML):

- https://www.spinics.net/lists/linux-scsi/msg148676.html
- https://www.spinics.net/lists/linux-scsi/msg148594.html

You kindly replied in both threads, that you are working on the issue.

We were also asked to open a ticket at ask.adaptec.com, which Paul did.

 From there, he got the message:

> Please update the cards FW to 3.00.
> https://storage.microsemi.com/en-us/speed/raid/asr/fw_bios/adaptec_smartfwx100_v3_00_b0_zip.php
>  
> Latest driver is available here https://storage.microsemi.com/en-us/downloads/linux_source/linux_source_code/productid=aha-1100-8e&dn=microsemi+adaptec+hba+1100-8e.php
> Version 1.2.14-016

I've upgrade to FW 3.00, which works fine with Linux 5.4, but the controllers still lock up after some hours of operation with Linux 5.9.

So I was going to try the 1.2.14-016 driver as suggested. I can't parse the lawyertalk at the referenced download page, but the source archive, you'd get there, seems to be identical to https://github.com/Smart-Storage/smartpqi, the only difference being the version numbers ( 1.2.14.015 vs 1.2.14.016 ).

However, the driver neither compiles with 5.9 nor with the Linux master branch:

     buczek@theinternet:~/linux_problems/done_49_hba/smartpqi (main)$ make -C /scratch/local/linux M=$(pwd)
     make: Entering directory '/scratch/local/linux'
       CC [M]  /home/buczek/linux_problems/done_49_hba/smartpqi/smartpqi_init.o
     In file included from /home/buczek/linux_problems/done_49_hba/smartpqi/smartpqi_init.c:38:0:
     /home/buczek/linux_problems/done_49_hba/smartpqi/smartpqi_kernel_compat.h: In function ‘pqi_get_hw_queue’:
     /home/buczek/linux_problems/done_49_hba/smartpqi/smartpqi_kernel_compat.h:454:6: error: implicit declaration of function ‘shost_use_blk_mq’ [-Werror=implicit-function-declaration]
       if (shost_use_blk_mq(scmd->device->host))
           ^~~~~~~~~~~~~~~~
     /home/buczek/linux_problems/done_49_hba/smartpqi/smartpqi_kernel_compat.h: At top level:
     /home/buczek/linux_problems/done_49_hba/smartpqi/smartpqi_kernel_compat.h:520:29: error: conflicting types for ‘ktime_get_real_seconds’
      static inline unsigned long ktime_get_real_seconds(void)
                                  ^~~~~~~~~~~~~~~~~~~~~~
     In file included from ./include/linux/ktime.h:232:0,
                      from ./include/linux/timer.h:6,
                      from ./include/linux/workqueue.h:9,
     [...]
  
I can't see or update Paul's issue at https://ask.adaptec.com/app/account/questions/detail/i_id/144738 , so I reply by email.

Let me add that the primary reason, why we are using these HBAs (lots of them) is, that the driver is in-tree. So I'm not too happy, that we are redirected to some closed bug-tracking system or out-of-tree drivers with unparsable lawyertalk.

If there is a problem with the smartpqi driver in Linux 5.9 and if fixes are available, they should, of course, go upstream ( No Regression Policy ). I'll be happy to test any fixes.

Best

   Donald


> Thanks,
> Don
> 
> -----Original Message-----
> From: Donald Buczek [mailto:buczek@molgen.mpg.de]
> Sent: Friday, October 16, 2020 5:27 AM
> To: storagedev <storagedev@microchip.com>; James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: smartpqi: Adaptec 1100-8e failure with Linux 5.9
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi,
> 
> we have a system with two Adaptec 1100-8e HBAs which was running for month with Linux 5.4 ( .39, .54, .57 ) without problems.
> 
> On two attempts with Linux 5.9 (smartpqi 1.2.10-025), one of the adapters failed after some time ( 1 hour, 8 hours ) of heavy operation.
> 
> After the adapter went offline, neither 'arcconf getlogs` nor `arcconf savesupportarchive` was able to get any information (from the failed controller).
> 
> Controller Firmware is 2.62.
> 
> Only related syslog lines following.
> 
> Best
>     Donald
> 
> --
> Donald Buczek
> buczek@molgen.mpg.de
> 
> ========================= snip ====
> 
> 
> 2020-10-15T14:38:48.448452+02:00 done kernel: [    0.000000] Linux version 5.9.0.mx64.348 (root@theinternet.molgen.mpg.de) (gcc (GCC) 7.5.0, GNU ld (GNU Binutils) 2.32) #1 SMP Tue Oct 13 04:00:30 CEST 2020
> 
> 2020-10-15T14:38:48.449855+02:00 done kernel: [   14.391644] Microsemi PQI Driver (v1.2.10-025)
> 2020-10-15T14:38:48.449856+02:00 done kernel: [   14.396257] smartpqi 0000:19:00.0: Microsemi Smart Family Controller found
> 2020-10-15T14:38:48.449863+02:00 done kernel: [   14.635277] smartpqi 0000:19:00.0: Online Firmware Activation enabled
> 2020-10-15T14:38:48.449864+02:00 done kernel: [   14.641831] smartpqi 0000:19:00.0: Serial Management Protocol enabled
> 2020-10-15T14:38:48.449866+02:00 done kernel: [   14.648371] smartpqi 0000:19:00.0: New Soft Reset Handshake enabled
> 2020-10-15T14:38:48.449866+02:00 done kernel: [   14.654738] smartpqi 0000:19:00.0: RAID IU Timeout enabled
> 2020-10-15T14:38:48.449867+02:00 done kernel: [   14.660320] smartpqi 0000:19:00.0: TMF IU Timeout enabled
> 2020-10-15T14:38:48.449867+02:00 done kernel: [   14.706259] scsi host14: smartpqi
> 2020-10-15T14:38:48.449889+02:00 done kernel: [   14.924724] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66ec7d5 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449890+02:00 done kernel: [   14.937139] scsi 14:0:0:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449890+02:00 done kernel: [   14.947180] sd 14:0:0:0: Attached scsi generic sg2 type 0
> 2020-10-15T14:38:48.449891+02:00 done kernel: [   14.952707] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a676fd19 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449891+02:00 done kernel: [   14.965570] sd 14:0:0:0: [sdc] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449892+02:00 done kernel: [   14.973942] scsi 14:0:1:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449892+02:00 done kernel: [   14.982244] sd 14:0:0:0: [sdc] Write Protect is off
> 2020-10-15T14:38:48.449894+02:00 done kernel: [   14.987225] sd 14:0:0:0: [sdc] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449895+02:00 done kernel: [   14.988552] sd 14:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449895+02:00 done kernel: [   14.988980] sd 14:0:1:0: Attached scsi generic sg3 type 0
> 2020-10-15T14:38:48.449896+02:00 done kernel: [   14.990798] sd 14:0:1:0: [sdd] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449897+02:00 done kernel: [   14.991466] sd 14:0:1:0: [sdd] Write Protect is off
> 2020-10-15T14:38:48.449897+02:00 done kernel: [   14.991467] sd 14:0:1:0: [sdd] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449898+02:00 done kernel: [   14.992705] sd 14:0:1:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449900+02:00 done kernel: [   15.003992] sd 14:0:1:0: [sdd] Attached SCSI disk
> 2020-10-15T14:38:48.449900+02:00 done kernel: [   15.008662] sd 14:0:0:0: [sdc] Attached SCSI disk
> 2020-10-15T14:38:48.449901+02:00 done kernel: [   15.010850] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a676f751 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449901+02:00 done kernel: [   15.058043] scsi 14:0:2:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449902+02:00 done kernel: [   15.073701] sd 14:0:2:0: Attached scsi generic sg4 type 0
> 2020-10-15T14:38:48.449902+02:00 done kernel: [   15.075504] sd 14:0:2:0: [sde] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449903+02:00 done kernel: [   15.079238] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66f8211 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449905+02:00 done kernel: [   15.087918] sd 14:0:2:0: [sde] Write Protect is off
> 2020-10-15T14:38:48.449906+02:00 done kernel: [   15.103611] sd 14:0:2:0: [sde] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449906+02:00 done kernel: [   15.104908] sd 14:0:2:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449907+02:00 done kernel: [   15.107312] scsi 14:0:3:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449908+02:00 done kernel: [   15.125011] sd 14:0:2:0: [sde] Attached SCSI disk
> 2020-10-15T14:38:48.449908+02:00 done kernel: [   15.129624] sd 14:0:3:0: Attached scsi generic sg5 type 0
> 2020-10-15T14:38:48.449909+02:00 done kernel: [   15.131432] sd 14:0:3:0: [sdf] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449911+02:00 done kernel: [   15.132102] sd 14:0:3:0: [sdf] Write Protect is off
> 2020-10-15T14:38:48.449911+02:00 done kernel: [   15.132103] sd 14:0:3:0: [sdf] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449912+02:00 done kernel: [   15.133346] sd 14:0:3:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449912+02:00 done kernel: [   15.144640] sd 14:0:3:0: [sdf] Attached SCSI disk
> 2020-10-15T14:38:48.449913+02:00 done kernel: [   15.147876] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66f4b91 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449916+02:00 done kernel: [   15.201312] scsi 14:0:4:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449917+02:00 done kernel: [   15.229425] sd 14:0:4:0: Attached scsi generic sg6 type 0
> 2020-10-15T14:38:48.449918+02:00 done kernel: [   15.229447] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66c15f9 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449918+02:00 done kernel: [   15.231279] sd 14:0:4:0: [sdg] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449919+02:00 done kernel: [   15.231954] sd 14:0:4:0: [sdg] Write Protect is off
> 2020-10-15T14:38:48.449919+02:00 done kernel: [   15.231954] sd 14:0:4:0: [sdg] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449921+02:00 done kernel: [   15.233215] sd 14:0:4:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449922+02:00 done kernel: [   15.244534] sd 14:0:4:0: [sdg] Attached SCSI disk
> 2020-10-15T14:38:48.449922+02:00 done kernel: [   15.541341] scsi 14:0:5:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449923+02:00 done kernel: [   15.543080] sd 14:0:5:0: Attached scsi generic sg7 type 0
> 2020-10-15T14:38:48.449923+02:00 done kernel: [   15.543100] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66afef9 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449935+02:00 done kernel: [   15.544874] sd 14:0:5:0: [sdh] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449936+02:00 done kernel: [   15.545540] sd 14:0:5:0: [sdh] Write Protect is off
> 2020-10-15T14:38:48.449938+02:00 done kernel: [   15.545541] sd 14:0:5:0: [sdh] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449939+02:00 done kernel: [   15.546773] sd 14:0:5:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449939+02:00 done kernel: [   15.552073] scsi 14:0:6:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449940+02:00 done kernel: [   15.553805] sd 14:0:6:0: Attached scsi generic sg8 type 0
> 2020-10-15T14:38:48.449940+02:00 done kernel: [   15.553827] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a681564d Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449941+02:00 done kernel: [   15.555613] sd 14:0:6:0: [sdi] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449941+02:00 done kernel: [   15.556286] sd 14:0:6:0: [sdi] Write Protect is off
> 2020-10-15T14:38:48.449942+02:00 done kernel: [   15.556287] sd 14:0:6:0: [sdi] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449944+02:00 done kernel: [   15.557531] sd 14:0:6:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449944+02:00 done kernel: [   15.558056] sd 14:0:5:0: [sdh] Attached SCSI disk
> 2020-10-15T14:38:48.449945+02:00 done kernel: [   15.568884] sd 14:0:6:0: [sdi] Attached SCSI disk
> 2020-10-15T14:38:48.449946+02:00 done kernel: [   15.603693] scsi 14:0:7:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449947+02:00 done kernel: [   15.636469] sd 14:0:7:0: [sdj] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449949+02:00 done kernel: [   15.648821] sd 14:0:7:0: [sdj] Write Protect is off
> 2020-10-15T14:38:48.449950+02:00 done kernel: [   15.652863] sd 14:0:7:0: Attached scsi generic sg9 type 0
> 2020-10-15T14:38:48.449950+02:00 done kernel: [   15.661044] sd 14:0:7:0: [sdj] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449951+02:00 done kernel: [   15.662321] sd 14:0:7:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449951+02:00 done kernel: [   15.687865] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66f7971 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449952+02:00 done kernel: [   15.701962] sd 14:0:7:0: [sdj] Attached SCSI disk
> 2020-10-15T14:38:48.449952+02:00 done kernel: [   15.726853] scsi 14:0:8:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449953+02:00 done kernel: [   15.866749] sd 14:0:8:0: Attached scsi generic sg10 type 0
> 2020-10-15T14:38:48.449955+02:00 done kernel: [   15.868558] sd 14:0:8:0: [sdk] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449956+02:00 done kernel: [   15.872820] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a6775fe5 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449956+02:00 done kernel: [   15.881937] sd 14:0:8:0: [sdk] Write Protect is off
> 2020-10-15T14:38:48.449957+02:00 done kernel: [   15.898475] sd 14:0:8:0: [sdk] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449957+02:00 done kernel: [   15.899759] sd 14:0:8:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449958+02:00 done kernel: [   15.920288] sd 14:0:8:0: [sdk] Attached SCSI disk
> 2020-10-15T14:38:48.449961+02:00 done kernel: [   15.936148] scsi 14:0:9:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449964+02:00 done kernel: [   16.009970] scsi 14:0:9:0: Attached scsi generic sg11 type 0
> 2020-10-15T14:38:48.449966+02:00 done kernel: [   16.012081] sd 14:0:9:0: [sdl] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449966+02:00 done kernel: [   16.016416] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66989e9 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449967+02:00 done kernel: [   16.025860] sd 14:0:9:0: [sdl] Write Protect is off
> 2020-10-15T14:38:48.449967+02:00 done kernel: [   16.042828] sd 14:0:9:0: [sdl] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449968+02:00 done kernel: [   16.044189] sd 14:0:9:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449968+02:00 done kernel: [   16.055550] sd 14:0:9:0: [sdl] Attached SCSI disk
> 2020-10-15T14:38:48.449969+02:00 done kernel: [   16.059760] scsi 14:0:10:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449971+02:00 done kernel: [   16.112477] sd 14:0:10:0: Attached scsi generic sg12 type 0
> 2020-10-15T14:38:48.449972+02:00 done kernel: [   16.114284] sd 14:0:10:0: [sdm] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449984+02:00 done kernel: [   16.118619] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a6770c75 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449985+02:00 done kernel: [   16.128090] sd 14:0:10:0: [sdm] Write Protect is off
> 2020-10-15T14:38:48.449985+02:00 done kernel: [   16.145019] sd 14:0:10:0: [sdm] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449986+02:00 done kernel: [   16.146295] sd 14:0:10:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449986+02:00 done kernel: [   16.167038] sd 14:0:10:0: [sdm] Attached SCSI disk
> 2020-10-15T14:38:48.449989+02:00 done kernel: [   16.183279] scsi 14:0:11:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449990+02:00 done kernel: [   16.234678] sd 14:0:11:0: Attached scsi generic sg13 type 0
> 2020-10-15T14:38:48.449990+02:00 done kernel: [   16.236505] sd 14:0:11:0: [sdn] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449991+02:00 done kernel: [   16.240827] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a677cee5 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449991+02:00 done kernel: [   16.250334] sd 14:0:11:0: [sdn] Write Protect is off
> 2020-10-15T14:38:48.449992+02:00 done kernel: [   16.267293] sd 14:0:11:0: [sdn] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449992+02:00 done kernel: [   16.268593] sd 14:0:11:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.449993+02:00 done kernel: [   16.289347] sd 14:0:11:0: [sdn] Attached SCSI disk
> 2020-10-15T14:38:48.449995+02:00 done kernel: [   16.305445] scsi 14:0:12:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.449995+02:00 done kernel: [   16.356814] sd 14:0:12:0: Attached scsi generic sg14 type 0
> 2020-10-15T14:38:48.449996+02:00 done kernel: [   16.358645] sd 14:0:12:0: [sdo] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.449997+02:00 done kernel: [   16.362977] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a6770f89 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.449997+02:00 done kernel: [   16.372468] sd 14:0:12:0: [sdo] Write Protect is off
> 2020-10-15T14:38:48.449998+02:00 done kernel: [   16.389443] sd 14:0:12:0: [sdo] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.449998+02:00 done kernel: [   16.390735] sd 14:0:12:0: [sdo] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450000+02:00 done kernel: [   16.411542] sd 14:0:12:0: [sdo] Attached SCSI disk
> 2020-10-15T14:38:48.450001+02:00 done kernel: [   16.427595] scsi 14:0:13:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450001+02:00 done kernel: [   16.479033] sd 14:0:13:0: Attached scsi generic sg15 type 0
> 2020-10-15T14:38:48.450002+02:00 done kernel: [   16.480854] sd 14:0:13:0: [sdp] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450003+02:00 done kernel: [   16.485200] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a66f7ba1 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450003+02:00 done kernel: [   16.494690] sd 14:0:13:0: [sdp] Write Protect is off
> 2020-10-15T14:38:48.450004+02:00 done kernel: [   16.511666] sd 14:0:13:0: [sdp] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450006+02:00 done kernel: [   16.512939] sd 14:0:13:0: [sdp] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450006+02:00 done kernel: [   16.533767] sd 14:0:13:0: [sdp] Attached SCSI disk
> 2020-10-15T14:38:48.450007+02:00 done kernel: [   16.549795] scsi 14:0:14:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450007+02:00 done kernel: [   16.605466] sd 14:0:14:0: Attached scsi generic sg16 type 0
> 2020-10-15T14:38:48.450008+02:00 done kernel: [   16.607306] sd 14:0:14:0: [sdq] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450008+02:00 done kernel: [   16.611616] smartpqi 0000:19:00.0: added 14:0:-:- 5000c500a681810d Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450009+02:00 done kernel: [   16.621050] sd 14:0:14:0: [sdq] Write Protect is off
> 2020-10-15T14:38:48.450011+02:00 done kernel: [   16.637980] sd 14:0:14:0: [sdq] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450012+02:00 done kernel: [   16.639270] sd 14:0:14:0: [sdq] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450012+02:00 done kernel: [   16.660110] sd 14:0:14:0: [sdq] Attached SCSI disk
> 2020-10-15T14:38:48.450013+02:00 done kernel: [   16.676181] scsi 14:0:15:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450013+02:00 done kernel: [   16.727615] sd 14:0:15:0: Attached scsi generic sg17 type 0
> 2020-10-15T14:38:48.450014+02:00 done kernel: [   16.729432] sd 14:0:15:0: [sdr] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450014+02:00 done kernel: [   16.733767] smartpqi 0000:19:00.0: added 14:0:-:- 50015b21405c023d Enclosure         AIC 12G  3U16SAS3swap     AIO-
> 2020-10-15T14:38:48.450015+02:00 done kernel: [   16.743245] sd 14:0:15:0: [sdr] Write Protect is off
> 2020-10-15T14:38:48.450017+02:00 done kernel: [   16.759351] sd 14:0:15:0: [sdr] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450017+02:00 done kernel: [   16.760643] sd 14:0:15:0: [sdr] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450018+02:00 done kernel: [   16.781446] sd 14:0:15:0: [sdr] Attached SCSI disk
> 2020-10-15T14:38:48.450018+02:00 done kernel: [   16.796814] scsi 14:0:16:0: Enclosure         AIC 12G  3U16SAS3swap     0c01 PQ: 0 ANSI: 5
> 2020-10-15T14:38:48.450019+02:00 done kernel: [   16.827432] ses 14:0:16:0: Attached Enclosure device
> 2020-10-15T14:38:48.450019+02:00 done kernel: [   16.832977] ses 14:0:16:0: Attached scsi generic sg18 type 13
> 2020-10-15T14:38:48.450020+02:00 done kernel: [   16.883465] smartpqi 0000:19:00.0: added 14:0:-:- 50000d1e0019d658 Enclosure         Adaptec  Smart Adapter    AIO-
> 2020-10-15T14:38:48.450034+02:00 done kernel: [   16.917075] scsi 14:0:17:0: Enclosure         Adaptec  Smart Adapter    2.62 PQ: 0 ANSI: 5
> 2020-10-15T14:38:48.450034+02:00 done kernel: [   16.947392] ses 14:0:17:0: Attached Enclosure device
> 2020-10-15T14:38:48.450035+02:00 done kernel: [   16.952945] ses 14:0:17:0: Attached scsi generic sg19 type 13
> 2020-10-15T14:38:48.450035+02:00 done kernel: [   17.002123] smartpqi 0000:19:00.0: added 14:2:0:0 0000000000000000 RAID              Adaptec  1100-8e
> 2020-10-15T14:38:48.450036+02:00 done kernel: [   17.034767] scsi 14:2:0:0: RAID              Adaptec  1100-8e          2.62 PQ: 0 ANSI: 5
> 2020-10-15T14:38:48.450036+02:00 done kernel: [   17.065006] scsi 14:2:0:0: Attached scsi generic sg20 type 12
> 2020-10-15T14:38:48.450037+02:00 done kernel: [   17.092996] smartpqi 0000:89:00.0: Microsemi Smart Family Controller found
> 2020-10-15T14:38:48.450039+02:00 done kernel: [   17.294270] smartpqi 0000:89:00.0: Online Firmware Activation enabled
> 2020-10-15T14:38:48.450040+02:00 done kernel: [   17.301304] smartpqi 0000:89:00.0: Serial Management Protocol enabled
> 2020-10-15T14:38:48.450040+02:00 done kernel: [   17.308318] smartpqi 0000:89:00.0: New Soft Reset Handshake enabled
> 2020-10-15T14:38:48.450041+02:00 done kernel: [   17.315119] smartpqi 0000:89:00.0: RAID IU Timeout enabled
> 2020-10-15T14:38:48.450041+02:00 done kernel: [   17.321124] smartpqi 0000:89:00.0: TMF IU Timeout enabled
> 2020-10-15T14:38:48.450041+02:00 done kernel: [   17.360262] scsi host15: smartpqi
> 2020-10-15T14:38:48.450042+02:00 done kernel: [   17.859218] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f62f1 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450044+02:00 done kernel: [   17.922714] scsi 15:0:0:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450045+02:00 done kernel: [   17.973251] sd 15:0:0:0: Attached scsi generic sg21 type 0
> 2020-10-15T14:38:48.450045+02:00 done kernel: [   17.975083] sd 15:0:0:0: [sds] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450046+02:00 done kernel: [   17.979287] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f7c41 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450046+02:00 done kernel: [   17.988383] sd 15:0:0:0: [sds] Write Protect is off
> 2020-10-15T14:38:48.450047+02:00 done kernel: [   18.004901] sd 15:0:0:0: [sds] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450047+02:00 done kernel: [   18.006195] sd 15:0:0:0: [sds] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450048+02:00 done kernel: [   18.026681] sd 15:0:0:0: [sds] Attached SCSI disk
> 2020-10-15T14:38:48.450050+02:00 done kernel: [   18.092508] scsi 15:0:1:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450050+02:00 done kernel: [   18.135580] sd 15:0:1:0: Attached scsi generic sg22 type 0
> 2020-10-15T14:38:48.450051+02:00 done kernel: [   18.137378] sd 15:0:1:0: [sdt] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450052+02:00 done kernel: [   18.141611] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f4c75 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450052+02:00 done kernel: [   18.150694] sd 15:0:1:0: [sdt] Write Protect is off
> 2020-10-15T14:38:48.450053+02:00 done kernel: [   18.167212] sd 15:0:1:0: [sdt] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450053+02:00 done kernel: [   18.168503] sd 15:0:1:0: [sdt] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450055+02:00 done kernel: [   18.188983] sd 15:0:1:0: [sdt] Attached SCSI disk
> 2020-10-15T14:38:48.450056+02:00 done kernel: [   18.228544] scsi 15:0:2:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450056+02:00 done kernel: [   18.271600] sd 15:0:2:0: Attached scsi generic sg23 type 0
> 2020-10-15T14:38:48.450057+02:00 done kernel: [   18.273407] sd 15:0:2:0: [sdu] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450058+02:00 done kernel: [   18.277632] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f4911 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450058+02:00 done kernel: [   18.286716] sd 15:0:2:0: [sdu] Write Protect is off
> 2020-10-15T14:38:48.450058+02:00 done kernel: [   18.303232] sd 15:0:2:0: [sdu] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450061+02:00 done kernel: [   18.304525] sd 15:0:2:0: [sdu] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450061+02:00 done kernel: [   18.325016] sd 15:0:2:0: [sdu] Attached SCSI disk
> 2020-10-15T14:38:48.450062+02:00 done kernel: [   18.384667] scsi 15:0:3:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450062+02:00 done kernel: [   18.462150] sd 15:0:3:0: Attached scsi generic sg24 type 0
> 2020-10-15T14:38:48.450063+02:00 done kernel: [   18.463973] sd 15:0:3:0: [sdv] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450064+02:00 done kernel: [   18.468178] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66ad50d Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450064+02:00 done kernel: [   18.477267] sd 15:0:3:0: [sdv] Write Protect is off
> 2020-10-15T14:38:48.450065+02:00 done kernel: [   18.493772] sd 15:0:3:0: [sdv] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450067+02:00 done kernel: [   18.495069] sd 15:0:3:0: [sdv] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450067+02:00 done kernel: [   18.515572] sd 15:0:3:0: [sdv] Attached SCSI disk
> 2020-10-15T14:38:48.450068+02:00 done kernel: [   18.577044] scsi 15:0:4:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450068+02:00 done kernel: [   18.652446] sd 15:0:4:0: Attached scsi generic sg25 type 0
> 2020-10-15T14:38:48.450069+02:00 done kernel: [   18.654288] sd 15:0:4:0: [sdw] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450081+02:00 done kernel: [   18.658477] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500adf18a49 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450081+02:00 done kernel: [   18.667564] sd 15:0:4:0: [sdw] Write Protect is off
> 2020-10-15T14:38:48.450083+02:00 done kernel: [   18.684086] sd 15:0:4:0: [sdw] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450084+02:00 done kernel: [   18.685395] sd 15:0:4:0: [sdw] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450085+02:00 done kernel: [   18.705838] sd 15:0:4:0: [sdw] Attached SCSI disk
> 2020-10-15T14:38:48.450085+02:00 done kernel: [   18.745584] scsi 15:0:5:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450086+02:00 done kernel: [   18.788646] sd 15:0:5:0: Attached scsi generic sg26 type 0
> 2020-10-15T14:38:48.450086+02:00 done kernel: [   18.790449] sd 15:0:5:0: [sdx] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450087+02:00 done kernel: [   18.794684] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f4cad Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450089+02:00 done kernel: [   18.803782] sd 15:0:5:0: [sdx] Write Protect is off
> 2020-10-15T14:38:48.450089+02:00 done kernel: [   18.820322] sd 15:0:5:0: [sdx] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450090+02:00 done kernel: [   18.821614] sd 15:0:5:0: [sdx] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450090+02:00 done kernel: [   18.842088] sd 15:0:5:0: [sdx] Attached SCSI disk
> 2020-10-15T14:38:48.450091+02:00 done kernel: [   18.898382] scsi 15:0:6:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450091+02:00 done kernel: [   18.941433] sd 15:0:6:0: Attached scsi generic sg27 type 0
> 2020-10-15T14:38:48.450092+02:00 done kernel: [   18.943254] sd 15:0:6:0: [sdy] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450093+02:00 done kernel: [   18.947500] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f77dd Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450095+02:00 done kernel: [   18.956637] sd 15:0:6:0: [sdy] Write Protect is off
> 2020-10-15T14:38:48.450096+02:00 done kernel: [   18.973230] sd 15:0:6:0: [sdy] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450097+02:00 done kernel: [   18.974522] sd 15:0:6:0: [sdy] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450097+02:00 done kernel: [   18.995029] sd 15:0:6:0: [sdy] Attached SCSI disk
> 2020-10-15T14:38:48.450098+02:00 done kernel: [   19.048666] scsi 15:0:7:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450098+02:00 done kernel: [   19.102351] sd 15:0:7:0: Attached scsi generic sg28 type 0
> 2020-10-15T14:38:48.450099+02:00 done kernel: [   19.104181] sd 15:0:7:0: [sdz] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450101+02:00 done kernel: [   19.108424] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f3b99 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450101+02:00 done kernel: [   19.117535] sd 15:0:7:0: [sdz] Write Protect is off
> 2020-10-15T14:38:48.450102+02:00 done kernel: [   19.134121] sd 15:0:7:0: [sdz] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450102+02:00 done kernel: [   19.135418] sd 15:0:7:0: [sdz] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450103+02:00 done kernel: [   19.155958] sd 15:0:7:0: [sdz] Attached SCSI disk
> 2020-10-15T14:38:48.450103+02:00 done kernel: [   19.195402] scsi 15:0:8:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450104+02:00 done kernel: [   19.238480] sd 15:0:8:0: Attached scsi generic sg29 type 0
> 2020-10-15T14:38:48.450106+02:00 done kernel: [   19.240319] sd 15:0:8:0: [sdaa] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450107+02:00 done kernel: [   19.244549] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a662b575 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450107+02:00 done kernel: [   19.253776] sd 15:0:8:0: [sdaa] Write Protect is off
> 2020-10-15T14:38:48.450108+02:00 done kernel: [   19.270436] sd 15:0:8:0: [sdaa] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450108+02:00 done kernel: [   19.271717] sd 15:0:8:0: [sdaa] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450109+02:00 done kernel: [   19.292300] sd 15:0:8:0: [sdaa] Attached SCSI disk
> 2020-10-15T14:38:48.450109+02:00 done kernel: [   19.357538] scsi 15:0:9:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450111+02:00 done kernel: [   19.434541] sd 15:0:9:0: Attached scsi generic sg30 type 0
> 2020-10-15T14:38:48.450112+02:00 done kernel: [   19.436359] sd 15:0:9:0: [sdab] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450112+02:00 done kernel: [   19.440611] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a660e829 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450113+02:00 done kernel: [   19.449813] sd 15:0:9:0: [sdab] Write Protect is off
> 2020-10-15T14:38:48.450113+02:00 done kernel: [   19.466495] sd 15:0:9:0: [sdab] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450114+02:00 done kernel: [   19.467773] sd 15:0:9:0: [sdab] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450114+02:00 done kernel: [   19.488335] sd 15:0:9:0: [sdab] Attached SCSI disk
> 2020-10-15T14:38:48.450115+02:00 done kernel: [   19.556972] scsi 15:0:10:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450117+02:00 done kernel: [   19.639764] sd 15:0:10:0: Attached scsi generic sg31 type 0
> 2020-10-15T14:38:48.450118+02:00 done kernel: [   19.641593] sd 15:0:10:0: [sdac] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450130+02:00 done kernel: [   19.645924] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f67bd Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450130+02:00 done kernel: [   19.655219] sd 15:0:10:0: [sdac] Write Protect is off
> 2020-10-15T14:38:48.450131+02:00 done kernel: [   19.671965] sd 15:0:10:0: [sdac] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450131+02:00 done kernel: [   19.673278] sd 15:0:10:0: [sdac] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450133+02:00 done kernel: [   19.693916] sd 15:0:10:0: [sdac] Attached SCSI disk
> 2020-10-15T14:38:48.450135+02:00 done kernel: [   19.760583] scsi 15:0:11:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450136+02:00 done kernel: [   19.810246] sd 15:0:11:0: Attached scsi generic sg32 type 0
> 2020-10-15T14:38:48.450136+02:00 done kernel: [   19.812052] sd 15:0:11:0: [sdad] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450137+02:00 done kernel: [   19.816401] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f60e5 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450138+02:00 done kernel: [   19.825696] sd 15:0:11:0: [sdad] Write Protect is off
> 2020-10-15T14:38:48.450138+02:00 done kernel: [   19.842459] sd 15:0:11:0: [sdad] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450139+02:00 done kernel: [   19.843749] sd 15:0:11:0: [sdad] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450141+02:00 done kernel: [   19.864383] sd 15:0:11:0: [sdad] Attached SCSI disk
> 2020-10-15T14:38:48.450141+02:00 done kernel: [   19.935155] scsi 15:0:12:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450142+02:00 done kernel: [   20.007811] sd 15:0:12:0: Attached scsi generic sg33 type 0
> 2020-10-15T14:38:48.450142+02:00 done kernel: [   20.009666] sd 15:0:12:0: [sdae] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450143+02:00 done kernel: [   20.013970] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f4a15 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450143+02:00 done kernel: [   20.023261] sd 15:0:12:0: [sdae] Write Protect is off
> 2020-10-15T14:38:48.450144+02:00 done kernel: [   20.040026] sd 15:0:12:0: [sdae] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450146+02:00 done kernel: [   20.041325] sd 15:0:12:0: [sdae] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450147+02:00 done kernel: [   20.062017] sd 15:0:12:0: [sdae] Attached SCSI disk
> 2020-10-15T14:38:48.450147+02:00 done kernel: [   20.124128] scsi 15:0:13:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450148+02:00 done kernel: [   20.167276] sd 15:0:13:0: Attached scsi generic sg34 type 0
> 2020-10-15T14:38:48.450148+02:00 done kernel: [   20.169094] sd 15:0:13:0: [sdaf] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450149+02:00 done kernel: [   20.173434] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a6a371e9 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450149+02:00 done kernel: [   20.182723] sd 15:0:13:0: [sdaf] Write Protect is off
> 2020-10-15T14:38:48.450150+02:00 done kernel: [   20.199489] sd 15:0:13:0: [sdaf] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450152+02:00 done kernel: [   20.200780] sd 15:0:13:0: [sdaf] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450152+02:00 done kernel: [   20.221425] sd 15:0:13:0: [sdaf] Attached SCSI disk
> 2020-10-15T14:38:48.450153+02:00 done kernel: [   20.283343] scsi 15:0:14:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450154+02:00 done kernel: [   20.326486] sd 15:0:14:0: Attached scsi generic sg35 type 0
> 2020-10-15T14:38:48.450154+02:00 done kernel: [   20.328295] sd 15:0:14:0: [sdag] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450155+02:00 done kernel: [   20.332642] smartpqi 0000:89:00.0: added 15:0:-:- 5000c500a66f8395 Direct-Access     SEAGATE  ST8000NM0065     AIO+ qd=64
> 2020-10-15T14:38:48.450155+02:00 done kernel: [   20.341929] sd 15:0:14:0: [sdag] Write Protect is off
> 2020-10-15T14:38:48.450157+02:00 done kernel: [   20.358699] sd 15:0:14:0: [sdag] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450158+02:00 done kernel: [   20.359984] sd 15:0:14:0: [sdag] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450158+02:00 done kernel: [   20.380648] sd 15:0:14:0: [sdag] Attached SCSI disk
> 2020-10-15T14:38:48.450159+02:00 done kernel: [   20.419891] scsi 15:0:15:0: Direct-Access     SEAGATE  ST8000NM0065     K004 PQ: 0 ANSI: 6
> 2020-10-15T14:38:48.450159+02:00 done kernel: [   20.463099] sd 15:0:15:0: Attached scsi generic sg36 type 0
> 2020-10-15T14:38:48.450160+02:00 done kernel: [   20.464917] sd 15:0:15:0: [sdah] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> 2020-10-15T14:38:48.450161+02:00 done kernel: [   20.469258] smartpqi 0000:89:00.0: added 15:0:-:- 50015b21405c11bd Enclosure         AIC 12G  3U16SAS3swap     AIO-
> 2020-10-15T14:38:48.450163+02:00 done kernel: [   20.478540] sd 15:0:15:0: [sdah] Write Protect is off
> 2020-10-15T14:38:48.450163+02:00 done kernel: [   20.494448] sd 15:0:15:0: [sdah] Mode Sense: db 00 10 08
> 2020-10-15T14:38:48.450164+02:00 done kernel: [   20.495748] sd 15:0:15:0: [sdah] Write cache: enabled, read cache: enabled, supports DPO and FUA
> 2020-10-15T14:38:48.450164+02:00 done kernel: [   20.516438] sd 15:0:15:0: [sdah] Attached SCSI disk
> 2020-10-15T14:38:48.450165+02:00 done kernel: [   20.555116] scsi 15:0:16:0: Enclosure         AIC 12G  3U16SAS3swap     0c01 PQ: 0 ANSI: 5
> 2020-10-15T14:38:48.450165+02:00 done kernel: [   20.597447] ses 15:0:16:0: Attached Enclosure device
> 2020-10-15T14:38:48.450166+02:00 done kernel: [   20.603012] ses 15:0:16:0: Attached scsi generic sg37 type 13
> 2020-10-15T14:38:48.450168+02:00 done kernel: [   20.676983] smartpqi 0000:89:00.0: added 15:0:-:- 50000d1e0019d948 Enclosure         Adaptec  Smart Adapter    AIO-
> 2020-10-15T14:38:48.450170+02:00 done kernel: [   20.722338] scsi 15:0:17:0: Enclosure         Adaptec  Smart Adapter    2.62 PQ: 0 ANSI: 5
> 2020-10-15T14:38:48.450171+02:00 done kernel: [   20.764305] ses 15:0:17:0: Attached Enclosure device
> 2020-10-15T14:38:48.450171+02:00 done kernel: [   20.769863] ses 15:0:17:0: Attached scsi generic sg38 type 13
> 2020-10-15T14:38:48.450172+02:00 done kernel: [   20.842452] smartpqi 0000:89:00.0: added 15:2:0:0 0000000000000000 RAID              Adaptec  1100-8e
> 2020-10-15T14:38:48.450173+02:00 done kernel: [   20.886790] scsi 15:2:0:0: RAID              Adaptec  1100-8e          2.62 PQ: 0 ANSI: 5
> 2020-10-15T14:38:48.450173+02:00 done kernel: [   20.928710] scsi 15:2:0:0: Attached scsi generic sg39 type 12
> 
> 2020-10-15T14:38:50.164435+02:00 done kernel: [   23.685632] md: md0 stopped.
> 2020-10-15T14:38:50.183948+02:00 done kernel: [   23.695922] md/raid:md0: device sds operational as raid disk 0
> 2020-10-15T14:38:50.183952+02:00 done kernel: [   23.702178] md/raid:md0: device sdah operational as raid disk 15
> 2020-10-15T14:38:50.183955+02:00 done kernel: [   23.708586] md/raid:md0: device sdag operational as raid disk 14
> 2020-10-15T14:38:50.196702+02:00 done kernel: [   23.714968] md/raid:md0: device sdaf operational as raid disk 13
> 2020-10-15T14:38:50.196705+02:00 done kernel: [   23.721338] md/raid:md0: device sdae operational as raid disk 12
> 2020-10-15T14:38:50.209417+02:00 done kernel: [   23.727700] md/raid:md0: device sdad operational as raid disk 11
> 2020-10-15T14:38:50.209420+02:00 done kernel: [   23.734052] md/raid:md0: device sdac operational as raid disk 10
> 2020-10-15T14:38:50.222025+02:00 done kernel: [   23.740403] md/raid:md0: device sdab operational as raid disk 9
> 2020-10-15T14:38:50.222028+02:00 done kernel: [   23.746660] md/raid:md0: device sdaa operational as raid disk 8
> 2020-10-15T14:38:50.234438+02:00 done kernel: [   23.752909] md/raid:md0: device sdz operational as raid disk 7
> 2020-10-15T14:38:50.234441+02:00 done kernel: [   23.759072] md/raid:md0: device sdy operational as raid disk 6
> 2020-10-15T14:38:50.246751+02:00 done kernel: [   23.765234] md/raid:md0: device sdx operational as raid disk 5
> 2020-10-15T14:38:50.246754+02:00 done kernel: [   23.771385] md/raid:md0: device sdw operational as raid disk 4
> 2020-10-15T14:38:50.259057+02:00 done kernel: [   23.777543] md/raid:md0: device sdv operational as raid disk 3
> 2020-10-15T14:38:50.259060+02:00 done kernel: [   23.783691] md/raid:md0: device sdu operational as raid disk 2
> 2020-10-15T14:38:50.271337+02:00 done kernel: [   23.789837] md/raid:md0: device sdt operational as raid disk 1
> 2020-10-15T14:38:50.280433+02:00 done kernel: [   23.796941] md/raid:md0: raid level 6 active with 16 out of 16 devices, algorithm 2
> 2020-10-15T14:38:50.329437+02:00 done kernel: [   23.847122] md0: detected capacity change from 0 to 112019986448384
> 2020-10-15T14:38:50.362445+02:00 done kernel: [   23.883830] md: md1 stopped.
> 2020-10-15T14:38:50.384913+02:00 done kernel: [   23.897212] md/raid:md1: device sdk operational as raid disk 0
> 2020-10-15T14:38:50.384917+02:00 done kernel: [   23.903354] md/raid:md1: device sdj operational as raid disk 15
> 2020-10-15T14:38:50.391331+02:00 done kernel: [   23.909605] md/raid:md1: device sdi operational as raid disk 14
> 2020-10-15T14:38:50.391340+02:00 done kernel: [   23.915962] md/raid:md1: device sdh operational as raid disk 13
> 2020-10-15T14:38:50.403717+02:00 done kernel: [   23.922164] md/raid:md1: device sdg operational as raid disk 12
> 2020-10-15T14:38:50.403722+02:00 done kernel: [   23.928352] md/raid:md1: device sdf operational as raid disk 11
> 2020-10-15T14:38:50.416077+02:00 done kernel: [   23.934540] md/raid:md1: device sde operational as raid disk 10
> 2020-10-15T14:38:50.416083+02:00 done kernel: [   23.940712] md/raid:md1: device sdd operational as raid disk 9
> 2020-10-15T14:38:50.416085+02:00 done kernel: [   23.940713] md/raid:md1: device sdc operational as raid disk 8
> 2020-10-15T14:38:50.416087+02:00 done kernel: [   23.940714] md/raid:md1: device sdr operational as raid disk 7
> 2020-10-15T14:38:50.440709+02:00 done kernel: [   23.959195] md/raid:md1: device sdq operational as raid disk 6
> 2020-10-15T14:38:50.440712+02:00 done kernel: [   23.959196] md/raid:md1: device sdp operational as raid disk 5
> 2020-10-15T14:38:50.440713+02:00 done kernel: [   23.959196] md/raid:md1: device sdo operational as raid disk 4
> 2020-10-15T14:38:50.440714+02:00 done kernel: [   23.959197] md/raid:md1: device sdn operational as raid disk 3
> 2020-10-15T14:38:50.440715+02:00 done kernel: [   23.959199] md/raid:md1: device sdm operational as raid disk 2
> 2020-10-15T14:38:50.465430+02:00 done kernel: [   23.989771] md/raid:md1: device sdl operational as raid disk 1
> 2020-10-15T14:38:50.479431+02:00 done kernel: [   23.990689] md/raid:md1: raid level 6 active with 16 out of 16 devices, algorithm 2
> 2020-10-15T14:38:50.523431+02:00 done kernel: [   24.041399] md1: detected capacity change from 0 to 112019986448384
> 
> 2020-10-14T13:46:01.061790+02:00 done kernel: [   22.483277] XFS (md0): Mounting V5 Filesystem
> 2020-10-14T13:46:01.358782+02:00 done kernel: [   22.780631] XFS (md0): Ending clean mount
> 2020-10-14T13:46:03.434788+02:00 done kernel: [   24.850390] xfs filesystem being mounted at /amd/done/C/C8024 supports timestamps until 2038 (0x7fffffff)
> 2020-10-14T13:46:03.466786+02:00 done kernel: [   24.887932] XFS (md1): Mounting V5 Filesystem
> 2020-10-14T13:46:03.852789+02:00 done kernel: [   25.274524] XFS (md1): Ending clean mount
> 2020-10-14T13:46:06.158792+02:00 done kernel: [   27.574454] xfs filesystem being mounted at /amd/done/C/C8025 supports timestamps until 2038 (0x7fffffff)
> 
> [ normal operation. Heavy load on both filesystems ]
> 
> 2020-10-14T14:54:01.521406+02:00 done kernel: [ 4102.457623] smartpqi 0000:89:00.0: controller is offline: status code 0x6100c
> 2020-10-14T14:54:01.521421+02:00 done kernel: [ 4102.465324] smartpqi 0000:89:00.0: controller offline
> 2020-10-14T14:54:01.560707+02:00 done kernel: [ 4102.504136] sd 15:0:2:0: [sdu] tag#709 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560713+02:00 done kernel: [ 4102.504139] sd 15:0:15:0: [sdah] tag#274 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560715+02:00 done kernel: [ 4102.504245] sd 15:0:4:0: [sdw] tag#516 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560716+02:00 done kernel: [ 4102.504248] sd 15:0:4:0: [sdw] tag#516 CDB: Write(10) 2a 00 0d e6 9e 88 00 00 01 00
> 2020-10-14T14:54:01.560718+02:00 done kernel: [ 4102.504250] blk_update_request: I/O error, dev sdw, sector 1865741376 op 0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
> 2020-10-14T14:54:01.560720+02:00 done kernel: [ 4102.504258] sd 15:0:0:0: [sds] tag#529 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560722+02:00 done kernel: [ 4102.504259] sd 15:0:0:0: [sds] tag#529 CDB: Write(10) 2a 00 29 4e e8 ff 00 00 01 00
> 2020-10-14T14:54:01.560732+02:00 done kernel: [ 4102.504261] blk_update_request: I/O error, dev sds, sector 5544298488 op 0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
> 2020-10-14T14:54:01.560733+02:00 done kernel: [ 4102.504290] sd 15:0:0:0: [sds] tag#627 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560734+02:00 done kernel: [ 4102.504293] sd 15:0:0:0: [sds] tag#627 CDB: Read(10) 28 00 5d df 2c 04 00 00 04 00
> 2020-10-14T14:54:01.560735+02:00 done kernel: [ 4102.504295] blk_update_request: I/O error, dev sds, sector 12599255072 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 0
> 2020-10-14T14:54:01.560736+02:00 done kernel: [ 4102.504389] sd 15:0:5:0: [sdx] tag#567 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560737+02:00 done kernel: [ 4102.504391] sd 15:0:5:0: [sdx] tag#567 CDB: Write(10) 2a 00 21 4e ce 04 00 00 04 00
> 2020-10-14T14:54:01.560747+02:00 done kernel: [ 4102.504392] blk_update_request: I/O error, dev sdx, sector 4470501408 op 0x1:(WRITE) flags 0x0 phys_seg 4 prio class 0
> 2020-10-14T14:54:01.560749+02:00 done kernel: [ 4102.504414] sd 15:0:8:0: [sdaa] tag#573 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560749+02:00 done kernel: [ 4102.504415] sd 15:0:8:0: [sdaa] tag#573 CDB: Write(10) 2a 00 0e db fd 77 00 00 01 00
> 2020-10-14T14:54:01.560754+02:00 done kernel: [ 4102.504416] blk_update_request: I/O error, dev sdaa, sector 1994386360 op 0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
> 2020-10-14T14:54:01.560755+02:00 done kernel: [ 4102.504510] sd 15:0:0:0: [sds] tag#704 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560756+02:00 done kernel: [ 4102.504511] sd 15:0:0:0: [sds] tag#704 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> 2020-10-14T14:54:01.560756+02:00 done kernel: [ 4102.504514] blk_update_request: I/O error, dev sds, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
> 2020-10-14T14:54:01.560758+02:00 done kernel: [ 4102.504517] sd 15:0:15:0: [sdah] tag#705 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560759+02:00 done kernel: [ 4102.504518] sd 15:0:15:0: [sdah] tag#705 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> 2020-10-14T14:54:01.560760+02:00 done kernel: [ 4102.504520] blk_update_request: I/O error, dev sdah, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
> 2020-10-14T14:54:01.560761+02:00 done kernel: [ 4102.504523] sd 15:0:14:0: [sdag] tag#706 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> 2020-10-14T14:54:01.560771+02:00 done kernel: [ 4102.504524] sd 15:0:14:0: [sdag] tag#706 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> 2020-10-14T14:54:01.560772+02:00 done kernel: [ 4102.504526] blk_update_request: I/O error, dev sdag, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
> 2020-10-14T14:54:01.560773+02:00 done kernel: [ 4102.504529] blk_update_request: I/O error, dev sdaf, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
> 2020-10-14T14:54:01.560774+02:00 done kernel: [ 4102.504532] blk_update_request: I/O error, dev sdae, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
> 2020-10-14T14:54:01.561699+02:00 done kernel: [ 4102.504962] md: super_written gets error=-5
> 2020-10-14T14:54:01.561703+02:00 done kernel: [ 4102.504964] md/raid:md0: Disk failure on sds, disabling device.
> 2020-10-14T14:54:01.561705+02:00 done kernel: [ 4102.504964] md/raid:md0: Operation continuing on 15 devices.
> 2020-10-14T14:54:01.561706+02:00 done kernel: [ 4102.504971] md: super_written gets error=-5
> 2020-10-14T14:54:01.561707+02:00 done kernel: [ 4102.504972] md/raid:md0: Disk failure on sdah, disabling device.
> 2020-10-14T14:54:01.561713+02:00 done kernel: [ 4102.504972] md/raid:md0: Operation continuing on 14 devices.
> 2020-10-14T14:54:01.561714+02:00 done kernel: [ 4102.504979] md: super_written gets error=-5
> 2020-10-14T14:54:01.561715+02:00 done kernel: [ 4102.504985] md: super_written gets error=-5
> 2020-10-14T14:54:01.561716+02:00 done kernel: [ 4102.504993] md: super_written gets error=-5
> 2020-10-14T14:54:01.561722+02:00 done kernel: [ 4102.504998] md: super_written gets error=-5
> 2020-10-14T14:54:01.561722+02:00 done kernel: [ 4102.505004] md: super_written gets error=-5
> 2020-10-14T14:54:01.561723+02:00 done kernel: [ 4102.505010] md: super_written gets error=-5
> 2020-10-14T14:54:01.561723+02:00 done kernel: [ 4102.505014] md: super_written gets error=-5
> 2020-10-14T14:54:01.561724+02:00 done kernel: [ 4102.505018] md: super_written gets error=-5
> 2020-10-14T14:54:01.561725+02:00 done kernel: [ 4102.505023] md: super_written gets error=-5
> 2020-10-14T14:54:01.561725+02:00 done kernel: [ 4102.505028] md: super_written gets error=-5
> 2020-10-14T14:54:01.561730+02:00 done kernel: [ 4102.505032] md: super_written gets error=-5
> 2020-10-14T14:54:01.561736+02:00 done kernel: [ 4102.505036] md: super_written gets error=-5
> 2020-10-14T14:54:01.561738+02:00 done kernel: [ 4102.505040] md: super_written gets error=-5
> 2020-10-14T14:54:01.685718+02:00 done kernel: [ 4102.514668] sd 15:0:2:0: [sdu] tag#709 CDB: Read(10) 28 00 4c a9 ae 80 00 00 04 00
> 2020-10-14T14:54:01.685723+02:00 done kernel: [ 4102.525338] sd 15:0:15:0: [sdah] tag#274 CDB: Read(10) 28 00 27 f7 81 80 00 00 04 00
> 2020-10-14T14:54:01.685724+02:00 done kernel: [ 4102.535735] md/raid:md0: read error not correctable (sector 10289509376 on sdu).
> 2020-10-14T14:54:01.685725+02:00 done kernel: [ 4102.543864] md/raid:md0: read error not correctable (sector 5364255744 on sdah).
> 2020-10-14T14:54:01.685726+02:00 done kernel: [ 4102.555190] md/raid:md0: read error not correctable (sector 10289509384 on sdu).
> 2020-10-14T14:54:01.685727+02:00 done kernel: [ 4102.565598] md/raid:md0: read error not correctable (sector 5364255752 on sdah).
> 2020-10-14T14:54:01.685728+02:00 done kernel: [ 4102.573737] md/raid:md0: read error not correctable (sector 10289509392 on sdu).
> 2020-10-14T14:54:01.685729+02:00 done kernel: [ 4102.585012] md/raid:md0: read error not correctable (sector 5364255760 on sdah).
> 2020-10-14T14:54:01.685729+02:00 done kernel: [ 4102.595422] md/raid:md0: read error not correctable (sector 10289509400 on sdu).
> 2020-10-14T14:54:01.685730+02:00 done kernel: [ 4102.603479] md/raid:md0: read error not correctable (sector 5364255768 on sdah).
> 2020-10-14T14:54:01.685731+02:00 done kernel: [ 4102.614941] md/raid:md0: read error not correctable (sector 10285809280 on sdv).
> 2020-10-14T14:54:01.685732+02:00 done kernel: [ 4102.625464] md/raid:md0: read error not correctable (sector 5377956896 on sdt).
> 2020-10-14T14:54:01.685732+02:00 done kernel: [ 4102.628633] md: super_written gets error=-5
> 2020-10-14T14:54:01.685733+02:00 done kernel: [ 4102.628645] md: super_written gets error=-5
> 2020-10-14T14:54:01.685734+02:00 done kernel: [ 4102.628654] md: super_written gets error=-5
> [...]
> 2020-10-14T14:54:01.685801+02:00 done kernel: [ 4102.628950] md: super_written gets error=-5
> 2020-10-14T14:54:01.685801+02:00 done kernel: [ 4102.628956] md: super_written gets error=-5
> 2020-10-14T14:54:01.685802+02:00 done kernel: [ 4102.629010] md: super_written gets error=-5
> 2020-10-14T14:54:01.685802+02:00 done kernel: [ 4102.629022] XFS (md0): metadata I/O error in "xfs_buf_iodone_error+0x36/0x240" at daddr 0xe9241dc20 len 32 error 5
> 2020-10-14T14:54:01.685803+02:00 done kernel: [ 4102.629027] md: super_written gets error=-5
> 2020-10-14T14:54:01.685804+02:00 done kernel: [ 4102.629033] md: super_written gets error=-5
> 2020-10-14T14:54:01.685804+02:00 done kernel: [ 4102.629037] md: super_written gets error=-5
> [...]
> 2020-10-14T14:54:06.503718+02:00 done kernel: [ 4107.446528] md: super_written gets error=-5
> 2020-10-14T14:54:06.503720+02:00 done kernel: [ 4107.446532] md: super_written gets error=-5
> 2020-10-14T14:54:06.564275+02:00 done kernel: [ 4107.503783] md: super_written gets error=-5
> 2020-10-14T14:54:06.564282+02:00 done kernel: [ 4107.508047] scsi_io_completion_action: 2816 callbacks suppressed
> 2020-10-14T14:54:06.564285+02:00 done kernel: [ 4107.508049] sd 15:0:12:0: [sdae] tag#356 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=0s
> 2020-10-14T14:54:06.589473+02:00 done kernel: [ 4107.524287] sd 15:0:12:0: [sdae] tag#356 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> 2020-10-14T14:54:06.609469+02:00 done kernel: [ 4107.533247] print_req_error: 2816 callbacks suppressed
> 2020-10-14T14:54:06.609474+02:00 done kernel: [ 4107.533249] blk_update_request: I/O error, dev sdae, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 0
> 2020-10-14T14:54:06.609475+02:00 done kernel: [ 4107.548930] md: super_written gets error=-5
> [...]
> 
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
