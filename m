From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Mon, 2 May 2016 15:28:04 -0400 (EDT)
Message-ID: <766510830.33459561.1462217284242.JavaMail.zimbra@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com> <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com> <57223D36.60304@sandisk.com> <74308856.32308210.1461862044976.JavaMail.zimbra@redhat.com> <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com> <5723FE06.70501@sandisk.com> <1184712515.32596182.1461977223746.JavaMail.zimbra@redhat.com> <5727A152.70109@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:53860 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbcEBT2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 15:28:10 -0400
In-Reply-To: <5727A152.70109@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org



Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-block@vger.kernel.org, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org
Sent: Monday, May 2, 2016 2:49:54 PM
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM

On 04/29/2016 05:47 PM, Laurence Oberman wrote:
> From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, linux-block@vger.kernel.org, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org
> Sent: Friday, April 29, 2016 8:36:22 PM
> Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM
>
>> On 04/29/2016 02:47 PM, Laurence Oberman wrote:
>>> Recovery with 21 LUNS is 300s that have in-flights to abort.
>>> [ ... ]
>>> eh_deadline is set to 10 on the 2 qlogic ports, eh_timeout is set
>>> to 10 for all devices. In multipath fast_io_fail_tmo=5
>>>
>>> I jam one of the target array ports and discard the commands
>>> effectively black-holing the commands and leave it that way until
>>> we recover and I watch the I/O. The recovery takes around 300s even
>>> with all the tuning and this effectively lands up in Oracle cluster
>>> evictions.
>>
>> This discussion started as a discussion about the time needed to fail
>> over from one path to another. How long did it take in your test before
>> I/O failed over from the jammed port to another port?
 >
 > Around 300s before the paths were declared hard failed and the
 > devices offlined. This is when I/O restarts.
 > The remaining paths on the second Qlogic port (that are not jammed)
 > will not be used until the error handler activity completes.
 >
 > Until we get these for example, and device-mapper starts declaring
 > paths down we are blocked.
 > Apr 29 17:20:51 localhost kernel: sd 1:0:1:0: Device offlined - not
 > ready after error recovery
 > Apr 29 17:20:51 localhost kernel: sd 1:0:1:13: Device offlined - not
 > ready after error recovery

Hello Laurence,

Everyone else on all mailing lists to which this message has been posted 
replies below the message. Please follow this convention.

Regarding the fail-over time: the ib_srp driver guarantees that 
scsi_done() is invoked from inside its terminate_rport_io() function. 
Apparently the lpfc and the qla2xxx drivers behave differently. Please 
work with the maintainers of these drivers to reduce fail-over time.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Bart

Even in the case of the ib_srp, don't we also have to still run the eh_timeout for each of the devices that has inflight requiring error handling serially.
This means we will still have to wait to get a path failover until all are through the timeout.

Thanks
Laurence
