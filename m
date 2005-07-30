From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sdparm cannot start or stop SATA disks
Date: Sat, 30 Jul 2005 13:06:08 +1000
Message-ID: <42EAEEA0.5010106@torque.net>
References: <42EA0957.9010408@torque.net> <42EA553A.1070304@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:1680 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262727AbVG3DFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 23:05:48 -0400
In-Reply-To: <42EA553A.1070304@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Douglas Gilbert wrote:
> 
>> sdparm uses the START STOP UNIT SCSI command to start
>> and stop (spin up and spin down) SCSI devices.
>> Currently libata does not implement that SCSI command.
>> [Hopefully Jeff contradicts me.]
> 
> 
> Correct.
> 
> Someone should submit a libata patch for this!

Jeff,
I could have a go at the SCSI half of it. According to
SAT, START STOP UNIT should only be allowed for non-packet
ATA devices. I assume your SATAPI code will the bypass
libata-scsi.c SAT layer.

SAT suggests libata should issue a ATA STANDBY (sector=0)
to "stop" the device. I can't see the STANDBY command (0xE2)
defined anywhere in libata or the ide subsystem (or their
headers).

The action to start the SATA device depends on the power
mode of the SATA device:
   - SLEEP: send a hardware or software reset: that should
     get it to ACTIVE or STANDBY mode
   - STANDBY or IDLE: send a (READ) VERIFY (sector=0) ATA
     to the command
   - ACTIVE: I assume this would be a nop

The START STOP UNIT SCSI command also has an "IMMED"iate
bit. That could just be ignored initially.

Is half a patch any use?

Doug Gilbert


