From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: RE: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
Date: Wed, 3 Dec 2003 11:15:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57037F83D5@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9212 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S265049AbTLCQPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2003 11:15:40 -0500
Received: from mhbs.lsil.com (mhbs.lsil.com [147.145.31.100])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id hB3FWkvf028569
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 08:13:01 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: fukuchi.masao@jp.fujitsu.com, mpt_linux_developer@lsil.com

Hi Hironobu,

About a couple weeks ago I worked with 
Masao Fukuchi<fukuchi.masao@jp.fujitsu.com> also from
Fujitsu to solve error handling issues.  I have
provided a patch for a 2.05.00.05 driver.

ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/

This may solve your problem. Can you apply this patch against 
the 2.6.0-test9 kernel, and let me know the results.

Eric Moore


Masao Fukuchi

On Wednesday, December 03, 2003 12:51 AM, Hironobu Ishii wrote:

> -----Original Message-----
> From: Hironobu Ishii [mailto:ishii.hironobu@jp.fujitsu.com]
> Sent: Wednesday, December 03, 2003 12:51 AM
> To: linux-scsi
> Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
> 
> 
> Hi all,
> 
> I also tested this probem with 2.6.0-test11.
> This problem has not been fixed yet.
> 
> Thanks, 
> Hironobu Ishii
> ----- Original Message ----- 
> From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
> To: "linux-scsi" <linux-scsi@vger.kernel.org>
> Sent: Wednesday, December 03, 2003 3:43 PM
> Subject: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
> 
> 
> > Hi all,
> > 
> > I am verifying error recovery logics of SCSI mid layer with
> > pseudo target device.
> > In my test, I found a data corruption problem.
> > Please see bellow.
> > 
> > Thanks,
> > Hironobu Ishii.
> > ---------------
> > [1.] One line summary of the problem:
> > 2.6.0-test9: SCSI mid layer tells a lie.
> > 
> > [2.] Full description of the problem/report:
> > Kernel:  2.6.0-test9 vanilla
> > 
> > Problem:
> >  SCSI mid layer failed to read(or write) the device,
> >  but it returns normal completion to the application.
> > 
> >  The sequence is as follows.
> >  SCSI mid layer repeats (a) part 5 times(SD_MAX_RETRIES).
> >  I found this problem occurs with either READ or WRITE command.
> > 
> >   Initiator              LLD(Fusion MPT)           Target
> >   -----------------------------------------------------------
> > +- READ(or WRITE)        --------------------->   (Time out)
> > |
> > | eh_abort               --------------------->
> > |                        LLD issues abort msg,
> > |                        but it doesn't wait for its completion
> > |                        and eh_aobrt_handler returns 
> 0x2003(FAILED).
> > |
> > | eh_device_reset_handler
> > |                        LLD issues nothing on the SCSI BUS
> > (a)                      and returns 0x2003(FAILED)
> > |
> > | eh_device_bus_reset_handler
> > |                        --------------------->   BUS RESET
> > |                        LLD returns 0x2002(SUCCESS)
> > |
> > | TEST UNIT READY         -------------------->
> > |                         <--------------------   CHK(06/0000)
> > |
> > | TEST UNIT READY         --------------------->
> > +-                        <---------------------  GOOD
> > 
> > The purpose of this test is to verify operation when there is
> > a medium error in disk.
> > 
> > I tested this problem with test6 and test9.
> > I got the same result with either.
> > I'm going to re-test with test11. But it takes for a while.
> > (I looked at the diff between test6 and test11, but I can't
> >  find a fix relating to this problem.)
> > 
> > Environments:
> > Initiator HBA: LSI Logic 53c1030(Fusion MPT)
> > Target:        Pseudo target device
> > Operation:     dd  if=/dev/sde of=/tmp/read_data count=1
> >               (or dd if=/tmp/data of=/dev/sde count=1)
> > 
> > [3.] Keywords (i.e., modules, networking, kernel):
> >  scsi_mod, time out
> > 
> > [4.] Kernel version (from /proc/version):
> > Linux version 2.6.0-test9 (root@lsd6129) (gcc version 3.2.2 
> 20030222 (Red Hat
> >  Linux 3.2.2-5)) #2 SMP Mon Nov 10 15:48:58 JST 2003
> > 
> > [5.] Output of Oops.. message (if applicable) with symbolic 
> information
> >      resolved (see Documentation/oops-tracing.txt)
> > [6.] A small shell script or example program which triggers the
> >      problem (if possible)
> > [7.] Environment
> >  See above.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
