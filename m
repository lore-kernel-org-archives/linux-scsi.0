From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
Date: Thu, 04 Dec 2003 08:48:43 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312032348.AA02824@fukuchi.jp.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E57037F83D5@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:26861 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262356AbTLCXtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 18:49:03 -0500
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75]) by fgwmail7.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id hB3Nn149021451 for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2003 08:49:01 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s2.gw.fujitsu.co.jp by m5.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id hB3Nn0rm025670 for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2003 08:49:00 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail505.fjmail.jp.fujitsu.com (fjmail505-0.fjmail.jp.fujitsu.com [10.59.80.104]) by s2.gw.fujitsu.co.jp (8.12.10)
	id hB3Nn0uG028676 for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2003 08:49:00 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail505.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HPC00G28FHNKF@fjmail505.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Thu,  4 Dec 2003 08:49:00 +0900 (JST)
In-reply-to: <0E3FA95632D6D047BA649F95DAB60E57037F83D5@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>, linux-scsi <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsil.com

Hi Eric,

I also tested with kernel 2.6.0-test11 + mpt fusion 2.05.00.05 driver,
but the problem didn't solve.
I think the problem is in the retry sequence of mid layer not mpt driver.
At the last retry sequence, bus reset finished with success but mid layer
didn't retry read command again and returned to application with success 
status.

Masao Fukuchi

Moore, Eric Dean wrote:
>Hi Hironobu,
>
>About a couple weeks ago I worked with 
>Masao Fukuchi<fukuchi.masao@jp.fujitsu.com> also from
>Fujitsu to solve error handling issues.  I have
>provided a patch for a 2.05.00.05 driver.
>
>ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/
>
>This may solve your problem. Can you apply this patch against 
>the 2.6.0-test9 kernel, and let me know the results.
>
>Eric Moore
>
>
>Masao Fukuchi
>
>On Wednesday, December 03, 2003 12:51 AM, Hironobu Ishii wrote:
>
>> -----Original Message-----
>> From: Hironobu Ishii [mailto:ishii.hironobu@jp.fujitsu.com]
>> Sent: Wednesday, December 03, 2003 12:51 AM
>> To: linux-scsi
>> Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
>> 
>> 
>> Hi all,
>> 
>> I also tested this probem with 2.6.0-test11.
>> This problem has not been fixed yet.
>> 
>> Thanks, 
>> Hironobu Ishii
>> ----- Original Message ----- 
>> From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
>> To: "linux-scsi" <linux-scsi@vger.kernel.org>
>> Sent: Wednesday, December 03, 2003 3:43 PM
>> Subject: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
>> 
>> 
>> > Hi all,
>> > 
>> > I am verifying error recovery logics of SCSI mid layer with
>> > pseudo target device.
>> > In my test, I found a data corruption problem.
>> > Please see bellow.
>> > 
>> > Thanks,
>> > Hironobu Ishii.
>> > ---------------
>> > [1.] One line summary of the problem:
>> > 2.6.0-test9: SCSI mid layer tells a lie.
>> > 
>> > [2.] Full description of the problem/report:
>> > Kernel:  2.6.0-test9 vanilla
>> > 
>> > Problem:
>> >  SCSI mid layer failed to read(or write) the device,
>> >  but it returns normal completion to the application.
>> > 
>> >  The sequence is as follows.
>> >  SCSI mid layer repeats (a) part 5 times(SD_MAX_RETRIES).
>> >  I found this problem occurs with either READ or WRITE command.
>> > 
>> >   Initiator              LLD(Fusion MPT)           Target
>> >   -----------------------------------------------------------
>> > +- READ(or WRITE)        --------------------->   (Time out)
>> > |
>> > | eh_abort               --------------------->
>> > |                        LLD issues abort msg,
>> > |                        but it doesn't wait for its completion
>> > |                        and eh_aobrt_handler returns 
>> 0x2003(FAILED).
>> > |
>> > | eh_device_reset_handler
>> > |                        LLD issues nothing on the SCSI BUS
>> > (a)                      and returns 0x2003(FAILED)
>> > |
>> > | eh_device_bus_reset_handler
>> > |                        --------------------->   BUS RESET
>> > |                        LLD returns 0x2002(SUCCESS)
>> > |
>> > | TEST UNIT READY         -------------------->
>> > |                         <--------------------   CHK(06/0000)
>> > |
>> > | TEST UNIT READY         --------------------->
>> > +-                        <---------------------  GOOD
>> > 
>> > The purpose of this test is to verify operation when there is
>> > a medium error in disk.
>> > 
>> > I tested this problem with test6 and test9.
>> > I got the same result with either.
>> > I'm going to re-test with test11. But it takes for a while.
>> > (I looked at the diff between test6 and test11, but I can't
>> >  find a fix relating to this problem.)
>> > 
>> > Environments:
>> > Initiator HBA: LSI Logic 53c1030(Fusion MPT)
>> > Target:        Pseudo target device
>> > Operation:     dd  if=/dev/sde of=/tmp/read_data count=1
>> >               (or dd if=/tmp/data of=/dev/sde count=1)
>> > 
>> > [3.] Keywords (i.e., modules, networking, kernel):
>> >  scsi_mod, time out
>> > 
>> > [4.] Kernel version (from /proc/version):
>> > Linux version 2.6.0-test9 (root@lsd6129) (gcc version 3.2.2 
>> 20030222 (Red Hat
>> >  Linux 3.2.2-5)) #2 SMP Mon Nov 10 15:48:58 JST 2003
>> > 
>> > [5.] Output of Oops.. message (if applicable) with symbolic 
>> information
>> >      resolved (see Documentation/oops-tracing.txt)
>> > [6.] A small shell script or example program which triggers the
>> >      problem (if possible)
>> > [7.] Environment
>> >  See above.
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
