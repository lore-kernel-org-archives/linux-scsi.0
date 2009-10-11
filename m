From: Christian Vilhelm <christian.vilhelm@univ-lille2.fr>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Sun, 11 Oct 2009 20:34:26 +0200
Message-ID: <4AD22532.9060001@univ-lille2.fr>
References: <200910091141.52303.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010708000808050101030806"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.univ-lille2.fr ([194.254.117.4]:42554 "EHLO
	smtp.univ-lille2.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZJKSpT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Oct 2009 14:45:19 -0400
In-Reply-To: <200910091141.52303.tfjellstrom@shaw.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010708000808050101030806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thomas Fjellstrom wrote:
> Hi,
> 
> I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS card) to 
> work with linux for the past month or so. I've recently just RMAed my first 
> card, and tested the new one under linux, and I see the same problems.
> 
> The very first time I made a new array off the controller, formated (with xfs) 
> and mounted the volume, it seemed to work. ioozone even seemed to run for a 
> while. Sadly after a few minutes I got a stream of mvs_abort_task messages in 
> dmesg, and any accesses to the volume, or any disks connected to the 
> controller lock up.
> 
> After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of kernel.org, 
> and the volume fails to mount with the same mvs_abort_task messages.

I have the exact same problem with another Marvell 88SE64xx based card, 
namely an Areca ARC-1300ix-16 and the mvsas driver.
If the disks are just used alone, with a filesystem on them, all seems 
to work fine. dd and badblocks run fine on them. Mounting them, 
reading/writing work fine. The error seem to popup but rarely when 
several disks are used simultaneously.
But, an absolute sure way to trigger the error is to assemble (or 
create) a md raid array with the disks. I join a syslog extract from the 
error. You can see it happens seconds after the array creation.
I tried :
1) disabling the write cache on the disks => same error
2) disabling NCQ : in mv_sas.h :
#define MV_DISABLE_NCQ  1
same error.
Afer a while, the devices handled by the card are just dropped from the 
system and the card stops working at all, a reboot is necessary.

Does anyone have a working config based on a Marvell 64xx card ?

I'm willing to explore solutions, patches or anything, just tell me what 
to do to help.

Christian Vilhelm.

-- 
/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\
|       Christian Vilhelm : christian.vilhelm@univ-lille2.fr         |
|            Reality is for people who lack imagination              |
\____________________________________________________________________/

--------------010708000808050101030806
Content-Type: text/plain;
 name="syslog.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog.out"

Oct 11 20:15:14 almery kernel: md: bind<sdh>                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: md: bind<sdi>                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: md: bind<sdj>                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: md: bind<sdk>                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: md: bind<sdl>                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: md: bind<sdm>                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: raid5: device sdl operational as raid disk 4                                                                                                                                                                                    
Oct 11 20:15:14 almery kernel: raid5: device sdk operational as raid disk 3                                                                                                                                                                                    
Oct 11 20:15:14 almery kernel: raid5: device sdj operational as raid disk 2                                                                                                                                                                                    
Oct 11 20:15:14 almery kernel: raid5: device sdi operational as raid disk 1                                                                                                                                                                                    
Oct 11 20:15:14 almery kernel: raid5: device sdh operational as raid disk 0                                                                                                                                                                                    
Oct 11 20:15:14 almery kernel: raid5: allocated 6384kB for md1                                                                                                                                                                                                 
Oct 11 20:15:14 almery kernel: raid5: raid level 5 set md1 active with 5 out of 6 devices, algorithm 2                                                                                                                                                         
Oct 11 20:15:14 almery kernel: RAID5 conf printout:                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: --- rd:6 wd:5                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: disk 0, o:1, dev:sdh                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 1, o:1, dev:sdi                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 2, o:1, dev:sdj                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 3, o:1, dev:sdk                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 4, o:1, dev:sdl                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: md1: detected capacity change from 0 to 2500536565760                                                                                                                                                                           
Oct 11 20:15:14 almery kernel: RAID5 conf printout:                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: --- rd:6 wd:5                                                                                                                                                                                                                   
Oct 11 20:15:14 almery kernel: disk 0, o:1, dev:sdh                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 1, o:1, dev:sdi                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 2, o:1, dev:sdj                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 3, o:1, dev:sdk                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 4, o:1, dev:sdl                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: disk 5, o:1, dev:sdm                                                                                                                                                                                                            
Oct 11 20:15:14 almery kernel: md: recovery of RAID array md1                                                                                                                                                                                                  
Oct 11 20:15:14 almery kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.                                                                                                                                                                              
Oct 11 20:15:14 almery kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.                                                                                                                                   
Oct 11 20:15:14 almery kernel: md: using 128k window, over a total of 488386048 blocks.                                                                                                                                                                        
Oct 11 20:15:14 almery ata_id[16774]: HDIO_GET_IDENTITY failed for '/dev/sdi'                                                                                                                                                                                  
Oct 11 20:15:14 almery ata_id[16782]: HDIO_GET_IDENTITY failed for '/dev/sdj'                                                                                                                                                                                  
Oct 11 20:15:14 almery ata_id[16785]: HDIO_GET_IDENTITY failed for '/dev/sdl'                                                                                                                                                                                  
Oct 11 20:15:14 almery ata_id[16786]: HDIO_GET_IDENTITY failed for '/dev/sdk'                                                                                                                                                                                  
Oct 11 20:15:14 almery ata_id[16790]: HDIO_GET_IDENTITY failed for '/dev/sdm'                                                                                                                                                                                  
Oct 11 20:15:44 almery kernel: md1:                                                                                                                                                                                                                            
Oct 11 20:15:44 almery kernel: sas: command 0xffff880138191600, task 0xffff8801399de380, timed out: BLK_EH_NOT_HANDLED                                                                                                                                         
Oct 11 20:15:44 almery kernel: sas: command 0xffff880138191800, task 0xffff8801399de540, timed out: BLK_EH_NOT_HANDLED                                                                                                                                         
Oct 11 20:15:44 almery kernel: sas: command 0xffff880138191000, task 0xffff8801399de000, timed out: BLK_EH_NOT_HANDLED                                                                                                                                         
Oct 11 20:15:44 almery kernel: sas: command 0xffff880138191100, task 0xffff8801399de1c0, timed out: BLK_EH_NOT_HANDLED                                                                                                                                         
Oct 11 20:15:44 almery kernel: sas: command 0xffff880138191900, task 0xffff8801399de700, timed out: BLK_EH_NOT_HANDLED                                                                                                                                         
Oct 11 20:15:44 almery kernel: sas: command 0xffff88013ac77800, task 0xffff88013ea19500, timed out: BLK_EH_NOT_HANDLED                                                                                                                                         
Oct 11 20:15:44 almery kernel: sas: Enter sas_scsi_recover_host                                                                                                                                                                                                
Oct 11 20:15:44 almery kernel: sas: trying to find task 0xffff8801399de380                                                                                                                                                                                     
Oct 11 20:15:44 almery kernel: sas: sas_scsi_find_task: aborting task 0xffff8801399de380                                                                                                                                                                       
Oct 11 20:15:44 almery kernel: drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5                                                                                                                                                                           
Oct 11 20:15:44 almery kernel: sas: sas_scsi_find_task: querying task 0xffff8801399de380                                                                                                                                                                       
Oct 11 20:15:44 almery kernel: drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5                                                                                                                                                                           
Oct 11 20:15:44 almery kernel: sas: sas_scsi_find_task: task 0xffff8801399de380 failed to abort                                                                                                                                                                
Oct 11 20:15:44 almery kernel: sas: task 0xffff8801399de380 is not at LU: I_T recover                                                                                                                                                                          
Oct 11 20:15:44 almery kernel: sas: I_T nexus reset for dev 5001b4d5020e2000                                                                                                                                                                                   
Oct 11 20:15:44 almery kernel: sas: I_T 5001b4d5020e2000 recovered                                                                                                                                                                                             

--------------010708000808050101030806--
