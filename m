From: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
Date: Wed, 03 Dec 2003 16:51:26 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <020101c3b972$456122f0$2987110a@lsd.css.fujitsu.com>
References: <016101c3b969$046cf520$2987110a@lsd.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain;	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41644 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S264507AbTLCHv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 02:51:59 -0500
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id hB37pvVv032503 for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 16:51:57 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from s4.gw.fujitsu.co.jp by m1.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id hB37pvap005114 for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 16:51:57 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from fjmail502.fjmail.jp.fujitsu.com (fjmail502-0.fjmail.jp.fujitsu.com [10.59.80.98]) by s4.gw.fujitsu.co.jp (8.12.10)
	id hB37puLu001081 for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 16:51:56 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from CARREN (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail502.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HPB00NJS76J4Y@fjmail502.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Wed,  3 Dec 2003 16:51:56 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi all,

I also tested this probem with 2.6.0-test11.
This problem has not been fixed yet.

Thanks, 
Hironobu Ishii
----- Original Message ----- 
From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
To: "linux-scsi" <linux-scsi@vger.kernel.org>
Sent: Wednesday, December 03, 2003 3:43 PM
Subject: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.


> Hi all,
> 
> I am verifying error recovery logics of SCSI mid layer with
> pseudo target device.
> In my test, I found a data corruption problem.
> Please see bellow.
> 
> Thanks,
> Hironobu Ishii.
> ---------------
> [1.] One line summary of the problem:
> 2.6.0-test9: SCSI mid layer tells a lie.
> 
> [2.] Full description of the problem/report:
> Kernel:  2.6.0-test9 vanilla
> 
> Problem:
>  SCSI mid layer failed to read(or write) the device,
>  but it returns normal completion to the application.
> 
>  The sequence is as follows.
>  SCSI mid layer repeats (a) part 5 times(SD_MAX_RETRIES).
>  I found this problem occurs with either READ or WRITE command.
> 
>   Initiator              LLD(Fusion MPT)           Target
>   -----------------------------------------------------------
> +- READ(or WRITE)        --------------------->   (Time out)
> |
> | eh_abort               --------------------->
> |                        LLD issues abort msg,
> |                        but it doesn't wait for its completion
> |                        and eh_aobrt_handler returns 0x2003(FAILED).
> |
> | eh_device_reset_handler
> |                        LLD issues nothing on the SCSI BUS
> (a)                      and returns 0x2003(FAILED)
> |
> | eh_device_bus_reset_handler
> |                        --------------------->   BUS RESET
> |                        LLD returns 0x2002(SUCCESS)
> |
> | TEST UNIT READY         -------------------->
> |                         <--------------------   CHK(06/0000)
> |
> | TEST UNIT READY         --------------------->
> +-                        <---------------------  GOOD
> 
> The purpose of this test is to verify operation when there is
> a medium error in disk.
> 
> I tested this problem with test6 and test9.
> I got the same result with either.
> I'm going to re-test with test11. But it takes for a while.
> (I looked at the diff between test6 and test11, but I can't
>  find a fix relating to this problem.)
> 
> Environments:
> Initiator HBA: LSI Logic 53c1030(Fusion MPT)
> Target:        Pseudo target device
> Operation:     dd  if=/dev/sde of=/tmp/read_data count=1
>               (or dd if=/tmp/data of=/dev/sde count=1)
> 
> [3.] Keywords (i.e., modules, networking, kernel):
>  scsi_mod, time out
> 
> [4.] Kernel version (from /proc/version):
> Linux version 2.6.0-test9 (root@lsd6129) (gcc version 3.2.2 20030222 (Red Hat
>  Linux 3.2.2-5)) #2 SMP Mon Nov 10 15:48:58 JST 2003
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> [7.] Environment
>  See above.

