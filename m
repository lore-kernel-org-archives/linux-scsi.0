From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [RFC][PATCH]SCSI signal(I/O) failure causes no response
Date: Fri, 16 Apr 2004 10:29:07 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404160129.AA03184@fukuchi.jp.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E570442C2AC@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33702 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261262AbUDPB3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 21:29:25 -0400
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i3G1TOvH032516 for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2004 10:29:24 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s4.gw.fujitsu.co.jp by m1.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i3G1TNR6023031 for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2004 10:29:23 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail504.fjmail.jp.fujitsu.com (fjmail504-0.fjmail.jp.fujitsu.com [10.59.80.102]) by s4.gw.fujitsu.co.jp (8.12.11)
	id i3G1TMlP024571 for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2004 10:29:23 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan503-0.fjmail.jp.fujitsu.com [10.59.80.124])
 by fjmail504.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HW800LPVPGYIJ@fjmail504.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Fri, 16 Apr 2004 10:29:22 +0900 (JST)
In-reply-to: <0E3FA95632D6D047BA649F95DAB60E570442C2AC@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I checked my test report.

Moore, Eric Dean wrote:
>Which IOCSTATUS is returned when reproducing 
>this issue that provides infinite loop?
>
>Here are the meanings of IOCSTATUS from the manual:
>
>MPI_IOCSTATUS_SCSI_TASK_TERMINATED - A SCSI Task Management request
>has terminated I/O.

- no inifinite loop

>MPI_IOCSTATUS_SCSI_IOC_TERMINATED - A IOC has terminated the SCSI I/O.
>This is typically an abort or bus reset initiated by the IOC.

- cut ATN signal
  -> repeat SCSI_IOC_TERMINATED with LogInfo=0x11010100(bug! MID not found)
- cut DB signal
  -> repeat command timeout and SCSI_IOC_TERMINATED

>MPI_IOCSTATUS_SCSI_EXT_TERMINATED - An external source has terminated the 
>SCSI I/O. This is typically a bus reset from another initiator.

- I've not seen this message before.

>MPI_IOCSTATUS_SCSI_PROTOCAL_ERROR - An unrecoverable bus protocal error
>has terminated the SCSI I/O.

- cut I/O signal
  -> repeat SCSI_PROTOCOL_ERROR
- cut MSG signal
  -> repeat SCSI_PROTOCOL_ERROR

>
>On Wednesday, April 14, 2004 11:24 PM, Masao Fukuchi wrote:
>
>> 
>> 
>> I saw following IOC status by my test tool.
>>  MPI_IOCSTATUS_SCSI_TASK_TERMINATED
>>  MPI_IOCSTATUS_SCSI_IOC_TERMINATED
>> 
>> But for these IOC status, I saw some kind of error like another
>> IOC status or timeout just before(or after) the above IOC
>> status.
>> 
>> I think the SCSI_PROTOROL_ERROR has a some different meaning from
>> others.
>> 
>> Masao Fukuchi
>> 
>> Moore, Eric Dean wrote:
>> >For this particular issue, Mr Masao Fukuchi has a
>> >scsi bus test analyzer, in which he set the C/D signal 
>> >to low during read operation.  The MPT firmware
>> >returned MPI_IOCSTATUS_SCSI_PROTOCAL_ERROR, which from
>> >the mpt manual means " An unrecoverable bus protocal error
>> >as terminated the SCSI I/O" and the driver will 
>> >return DID_RESET.
>> >
>> >Here are some of the other cases which return
>> >DID_RESET, however I doubt were returned with 
>> >Mr Masao Fukuchi's test anaylzer:
>> >
>> >MPI_IOCSTATUS_SCSI_TASK_TERMINATED
>> >MPI_IOCSTATUS_SCSI_IOC_TERMINATED
>> >MPI_IOCSTATUS_SCSI_EXT_TERMINATED
>> >
>> >
>> >
>> >On Wednesday, April 14, 2004 9:28 AM, James Bottomley wrote:
>> >
>> >> 
>> >> 
>> >> On Tue, 2004-04-13 at 20:07, Masao Fukuchi wrote:
>> >> > 1.Fusion MPT driver issues read command to its firmware.
>> >> >   (our server has LSI53C1030 as SCSI adapter)
>> >> >   Then the firmware returns protocol error for the command.
>> >> >   Fusion MPT driver makes DID_RESET status by protocol error 
>> >> >   and sends it to SCSI midlayer.
>> >> > 
>> >> > 2.SCSI midlayer analyzes the status from LLD.
>> >> >   SCSI midlayer schedules command retry because the 
>> status is just
>> >> >   DID_RESET status.
>> >> >   (When the status has DID_RESET plus some sense code, the retry
>> >> >    sequence depends on the sense code. But when the 
>> status has only
>> >> >    DID_RESET, SCSI midlayer schedules command retry)
>> >> > 
>> >> > Sequence 1. and 2. are repeated infinitely and it causes no 
>> >> response.
>> >> > 
>> >> > To prevent this problem, I proposed Eric Moore to change 
>> >> the DID_RESET
>> >> > status to DID_SOFT_ERROR in fusion MPT driver.
>> >> > But he suggested me to change SCSI midlayer to prevent 
>> >> infinite loop.
>> >> 
>> >> Well, there clearly is a problem, because we can't retry no-rety
>> >> commands that return DID_RESET (like tape commands or fastfail).
>> >> 
>> >> However, DID_RESET is supposed to be returned for events 
>> where it was
>> >> determined that the command was lost because the bus or 
>> >> device was reset
>> >> (either as part of error handling or because an external 
>> entity issued
>> >> the reset).  Since these events, if they originate 
>> externally, can be
>> >> beyond the control of the device, making retryable 
>> commands subject to
>> >> the retry limit would be asking for unnecessary I/O errors 
>> because of
>> >> something we couldn't do anything about.
>> >> 
>> >> Why is the LSI driver returning DID_RESET for the problem 
>> (i.e. is it
>> >> some type of external bus reset, or is something else going on)?
>> >> 
>> >> James
>> >> 
>> >> 
>> >-
>> >To unsubscribe from this list: send the line "unsubscribe 
>> linux-scsi" in
>> >the body of a message to majordomo@vger.kernel.org
>> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
