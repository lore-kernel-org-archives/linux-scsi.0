From: Vasily Averin <vvs@sw.ru>
Subject: Re: unexpected scsi timeout
Date: Wed, 25 Jul 2007 14:36:46 +0700
Message-ID: <46A6FD8E.7090803@sw.ru>
References: <46A0A462.2090407@sw.ru> <46A5B632.8040201@gmail.com> <46A5CF7B.40102@sw.ru> <46A6E4A4.6080608@tw.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46A6E4A4.6080608@tw.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: albertl@mail.com
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devel@openvz.org
List-Id: linux-scsi@vger.kernel.org

Albert Lee wrote:
>>> Vasily Averin wrote:
>>>> I've noticed that some scsi commands for DVD-drive attached to pata_via
>>>> successfully finishes without any delays but reports about TIMEOUT condition. It
>>>> happens because of ATA_ERR bit is set in status register. As result for each
>>>> command  Error Handler thread awakened, requests sense buffer and go to sleep again.
>>> Need more info.  Please post boot dmesg and the result of 'lspci -nn'
>>> and 'hdparm -I /dev/srX' and when such errors occur.
> 
> Your log looks ok. It's normal for TEST_UNIT_READY to return ATA_ERR when no disc
> inside and libata EH triggered to request sense.

It's a bit strange for me, IMHO other scsi drivers requests sense buffer without
EH thread assistance.
Currently we know that ATA_ERR can be returned; it is not error, but one of
expected responses. Why we cannot request sense without EH? I would like to
understand is it implementation drawback or I missed something probably?

Thank you,
	Vasily Averin

