From: Albert Lee <albertcc@tw.ibm.com>
Subject: Re: unexpected scsi timeout
Date: Wed, 25 Jul 2007 13:50:28 +0800
Message-ID: <46A6E4A4.6080608@tw.ibm.com>
References: <46A0A462.2090407@sw.ru> <46A5B632.8040201@gmail.com> <46A5CF7B.40102@sw.ru>
Reply-To: albertl@mail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46A5CF7B.40102@sw.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devel@openvz.org
List-Id: linux-scsi@vger.kernel.org

Vasily Averin wrote:
> Tejun Heo wrote:
> 
>>[cc'ing Albert]
>>
>>Vasily Averin wrote:
>>
>>>Tejun, Jeff
>>>
>>>I've noticed that some scsi commands for DVD-drive attached to pata_via
>>>successfully finishes without any delays but reports about TIMEOUT condition. It
>>>happens because of ATA_ERR bit is set in status register. As result for each
>>>command  Error Handler thread awakened, requests sense buffer and go to sleep again.
>>
>>Need more info.  Please post boot dmesg and the result of 'lspci -nn'
>>and 'hdparm -I /dev/srX' and when such errors occur.
> 
> 
> It was 2.6.22 kernel with pata_via and sata_via drivers, scsi and cdrom debug
> was temporally enabled via sysctl (please see logs near Jul 24 13:42:46 timestamp)
> 
> Btw. I'm not sure that it was an error, I've looked on the sources and IMHO it's
> normal command processing cdrom without disk inserted into drive. I've checked
> 2.6.19, 2.6.20 and 2.6.22 kernels and got the same behavior.
> 

Hi Vasily,

Your log looks ok. It's normal for TEST_UNIT_READY to return ATA_ERR when no disc
inside and libata EH triggered to request sense.

--
albert

