From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sdparm cannot start or stop SATA disks
Date: Fri, 29 Jul 2005 23:56:24 -0400
Message-ID: <42EAFA68.8000008@pobox.com>
References: <42EA0957.9010408@torque.net> <42EA553A.1070304@pobox.com> <42EAEEA0.5010106@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:58323 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262868AbVG3D42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 23:56:28 -0400
In-Reply-To: <42EAEEA0.5010106@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> I could have a go at the SCSI half of it. According to
> SAT, START STOP UNIT should only be allowed for non-packet
> ATA devices. I assume your SATAPI code will the bypass
> libata-scsi.c SAT layer.

Mostly.  There is still a few translation bits in there.  99% bypass, 
not 100%.


> SAT suggests libata should issue a ATA STANDBY (sector=0)
> to "stop" the device. I can't see the STANDBY command (0xE2)
> defined anywhere in libata or the ide subsystem (or their
> headers).

I'm sure you're capable of adding an enum to linux/ata.h :)


> The action to start the SATA device depends on the power
> mode of the SATA device:
>   - SLEEP: send a hardware or software reset: that should
>     get it to ACTIVE or STANDBY mode
>   - STANDBY or IDLE: send a (READ) VERIFY (sector=0) ATA
>     to the command
>   - ACTIVE: I assume this would be a nop
> 
> The START STOP UNIT SCSI command also has an "IMMED"iate
> bit. That could just be ignored initially.
> 
> Is half a patch any use?

Sure.

	Jeff

