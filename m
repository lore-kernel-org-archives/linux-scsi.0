From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sdparm cannot start or stop SATA disks
Date: Sat, 30 Jul 2005 13:25:43 +1000
Message-ID: <42EAF337.8040601@torque.net>
References: <42EA0957.9010408@torque.net> <42EA553A.1070304@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:50577 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262761AbVG3DZV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 23:25:21 -0400
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
A further thought about implementing the START STOP
UNIT SCSI command in libata: the TEST UNIT READY
SCSI command should become more than just a no-op.

Additional sense code 4 ("Logical unit not ready, ...")
seems to have a special for SAS (including SAS's ability
to hold a SATA disk spun down at power on):
ASC/ASCQ=[0x4,0x11]  "Logical unit not ready, notify
(enable spinup) required".

Doug Gilbert

