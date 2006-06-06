From: Vasily Averin <vvs@sw.ru>
Subject: Re: [SCSI] 3w-9xxx: kmap_atomic in twa_scsiop_execute_scsi
Date: Tue, 06 Jun 2006 23:28:27 +0400
Message-ID: <4485D75B.7070902@sw.ru>
References: <DB599F406D04E34389140B7D99C71B1B0203D625@SDCEXCHANGE01.ad.amcc.com>	 <44851778.7010107@sw.ru> <b1bc6a000606061146p7a26aca9o62f9a8c22ffb0c63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:27216 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1750983AbWFFTZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2006 15:25:12 -0400
In-Reply-To: <b1bc6a000606061146p7a26aca9o62f9a8c22ffb0c63@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Adam Radford <aradford@amcc.com>, linuxraid <linuxraid@amcc.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, devel@openvz.org, Andrew Morton <akpm@osdl.org>

Adam,

adam radford wrote:
> Vasily,
> 
> On 6/5/06, Vasily Averin <vvs@sw.ru> wrote:
> 
>> I'm agree that queuecommand() executed with disabled interrupts. However
>> twa_scsiop_execute_scsi() can be called not only from queuecommand.
>> For example,
>>
>> twa_interrupts (note: with _enabled_ interrupts)
>>    twa_aen_read_queue
>>      twa_scsiop_execute_scsi
>>
> 
> twa_scsiop_execute_scsi() will not perform the
> kmap_atomic()/kunmap_atomic()
> calls here because it is being used for an internal AEN drain  (cdb
> post), i.e. "sglistarg" is non NULL.  See below:
> 
> if (!sglistarg) {
> 
>  ....
>   kmap_atomc()
>   kunmap_atomic()
> 
> } else {
>   /* Internal cdb post */
> 
> }

Ok, I'm agree.

Thank you for your explanation,
	Vasily Averin

SWsoft Virtuozzo/OpenVZ Linux kernel team
