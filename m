From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Thu, 28 Apr 2016 12:47:24 -0400 (EDT)
Message-ID: <74308856.32308210.1461862044976.JavaMail.zimbra@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com> <20160428121108.GA9903@redhat.com> <1461858038.2307.16.camel@HansenPartnership.com> <5722320E.5080202@sandisk.com> <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com> <57223D36.60304@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:37054 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbcD1Qr3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2016 12:47:29 -0400
In-Reply-To: <57223D36.60304@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

Hello Bart, This is when we have a subset of the paths fails.
As you know the remaining path wont be used until the eh_handler is either done or is short circuited.

What I will do is set this up via my jammer and capture a test using latest upstream.

Of course my customer pain points are all in the RHEL kernels so I need to capture a recovery trace
on the latest upstream kernel.

When the SCSI commands for a path are black-holed and remain that way, even with eh_deadline and the short circuited adapter resets 
we simply try again and get back in the wait loop until we finally declare the device offline.

This can take a while and differs depending on Qlogic, Emulex or fnic etc.

First thing tomorrow will set this up and show you what I mean.

Thanks!!

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-block@vger.kernel.org, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org
Sent: Thursday, April 28, 2016 12:41:26 PM
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM

On 04/28/2016 09:23 AM, Laurence Oberman wrote:
> We still suffer from periodic complaints in our large customer base
 > regarding the long recovery times for dm-multipath.
> Most of the time this is when we have something like a switch
 > back-plane issue or an issue where RSCN'S are blocked coming back up
 > the fabric. Corner cases still bite us often.
>
> Most of the complaints originate from customers for example seeing
 > Oracle cluster evictions where during the waiting on the mid-layer
 > all mpath I/O is blocked until recovery.
>
> We have to tune eh_deadline, eh_timeout and fast_io_fail_tmo but
 > even tuning those we have to wait on serial recovery even if we
 > set the timeouts low.
>
> Lately we have been living with
> eh_deadline=10
> eh_timeout=5
> fast_fail_io_tmo=10
> leaving default sd timeout at 30s
>
> So this continues to be an issue and I have specific examples using
 > the jammer I can provide showing the serial recovery times here.

Hello Laurence,

The long recovery times you refer to, is that for a scenario where all 
paths failed or for a scenario where some paths failed and other paths 
are still working? In the latter case, how long does it take before 
dm-multipath fails over to another path?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
