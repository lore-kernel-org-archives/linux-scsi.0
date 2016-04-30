From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Fri, 29 Apr 2016 20:47:03 -0400 (EDT)
Message-ID: <1184712515.32596182.1461977223746.JavaMail.zimbra@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com> <1461858038.2307.16.camel@HansenPartnership.com> <5722320E.5080202@sandisk.com> <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com> <57223D36.60304@sandisk.com> <74308856.32308210.1461862044976.JavaMail.zimbra@redhat.com> <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com> <5723FE06.70501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46185 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbcD3ArJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 20:47:09 -0400
In-Reply-To: <5723FE06.70501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

Hello Bart

Around 300s before the paths were declared hard failed and the devices offlined.
This is when I/O restarts.
The remaining paths on the second Qlogic port (that are not jammed) will not be used until the error handler activity completes.

Until we get these for example, and device-mapper starts declaring paths down we are blocked.
Apr 29 17:20:51 localhost kernel: sd 1:0:1:0: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:13: Device offlined - not ready after error recovery

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, linux-block@vger.kernel.org, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org
Sent: Friday, April 29, 2016 8:36:22 PM
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM

On 04/29/2016 02:47 PM, Laurence Oberman wrote:
> Recovery with 21 LUNS is 300s that have in-flights to abort.
> [ ... ]
> eh_deadline is set to 10 on the 2 qlogic ports, eh_timeout is set
 > to 10 for all devices. In multipath fast_io_fail_tmo=5
>
> I jam one of the target array ports and discard the commands
 > effectively black-holing the commands and leave it that way until
 > we recover and I watch the I/O. The recovery takes around 300s even
 > with all the tuning and this effectively lands up in Oracle cluster
 > evictions.

Hello Laurence,

This discussion started as a discussion about the time needed to fail 
over from one path to another. How long did it take in your test before 
I/O failed over from the jammed port to another port?

Thanks,

Bart.
