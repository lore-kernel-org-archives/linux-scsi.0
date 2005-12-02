From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Fri, 02 Dec 2005 20:28:48 +1000
Message-ID: <439021E0.9040203@torque.net>
References: <4341A91A.3020000@us.ibm.com> <435E7105.4010105@pobox.com>	 <435E87E8.9010506@us.ibm.com> <435E8AC7.1080407@pobox.com>	 <435EB656.1040502@adaptec.com> <4360FAC1.8020409@us.ibm.com>	 <43850F0D.7040907@torque.net> <43851262.7020807@pobox.com>	 <58cb370e0511240012r64ad150eo90553b230992424e@mail.gmail.com>	 <438FABF8.3020802@pobox.com> <58cb370e0512020007n67f7ba30g7cae84c66b18859@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:58595 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750905AbVLBK1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2005 05:27:52 -0500
In-Reply-To: <58cb370e0512020007n67f7ba30g7cae84c66b18859@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, brking@us.ibm.com, Luben Tuikov <luben_tuikov@adaptec.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, t.schorpp@gmx.de

Bartlomiej Zolnierkiewicz wrote:
> On 12/2/05, Jeff Garzik <jgarzik@pobox.com> wrote:
> 
>>Bartlomiej Zolnierkiewicz wrote:
>>
>>>On 11/24/05, Jeff Garzik <jgarzik@pobox.com> wrote:
>>>
>>>
>>>>Douglas Gilbert wrote:
>>>>
>>>>
>>>>>I don't think a SATL is that easy. One SCSI command can
>>>>>translate into zero or more ATA commands. If it translates
>>>>>to multiple commands, then there is the possibility of an
>>>>>error prior to the last in the sequence of ATA commands
>>>>>(how to report; rollback needed ?). The SATL needs to hold
>>>>>state and needs a service thread if it is to support the
>>>>>IMMED bit on some commands (e.g. START STOP UNIT).
>>>>
>>>>It needs a conceptual service thread, not necessarily an explicit one.
>>>>
>>>>With REQUEST SENSE, I've demonstrated how to report errors with each
>>>>step in the sequence.  With demo patches I've posted, I've demonstrated
>>>>(using qc->private_data) how to hold state.
>>>>
>>>>
>>>>
>>>>
>>>>>libata still has a ways to go to catch up to SAT rev 7
>>>>>but has made some good progress lately with the addition
>>>>>of the ATA pass through commands (lk 2.6.15-rc1 and onward).
>>>>>smartmontools (just prior to 5.34) now works with '-d ata'
>>>>>on libata-connected SATA disks. The '-d ata' ** overrides
>>>>>the guess of a SCSI disk based on the device node (e.g.
>>>>>/dev/sda) and uses the HDIO_DRIVE_CMD and HDIO_DRIVE_TASK
>>>>>ioctls. The absence of support for the HDIO_DRIVE_TASKFILE
>>>>>ioctl means that "selective" self-test can't be done.
>>>>>I'm not sure if moving smartmontools to the ATA PASS THROUGH
>>>>>SCSI commands will win back the "selective" self-test
>>>>>capability. Anyway, going to those ATA PASS THROUGH SCSI
>>>>
>>>>ATA passthru can do anything the legacy IDE ioctls can do (and more).
>>>
>>>
>>>[ definitely ATA passthru is the way to go but... ]
>>>
>>>discrete taskfiles?
>>
>>what is this?
> 
> 
> flagged taskfiles
> 
> yes, this is a low priority but your statement is oversimplification
> and I don't even mentioned other "IDE ioctl", so:
> 
> ATA passthru can do anything _important_ that legacy IDE ioctls
> can do (write cache [dis,en]abling?)
> 
> 
>>>multi-PIO?
>>
>>what is this?  multi-sector PIO, such as READ MULTIPLE SECTORS?  ATA
> 
> 
> short for multi sector-sector PIO
> 
> 
>>passthru can do that.
> 
> 
> not in the mainline, I've just checked libata-dev and it is OK
> 
> 
>>>setting transfer speed?
>>
>>That's not a limitation of passthru, but a limitation of the driver.  I
>>don't yet see the value...
> 
> 
> Same for me...

I noticed that the protocol field in the ATA_12 and
ATA_16 pass through commands included hard reset,
SRST and device reset. Would it be useful to implement
these?

Doug Gilbert
