From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [Lsf] Notes from the four separate IO track sessions at LSF/MM
Date: Thu, 28 Apr 2016 12:23:44 -0400 (EDT)
Message-ID: <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com> <20160428121108.GA9903@redhat.com> <1461858038.2307.16.camel@HansenPartnership.com> <5722320E.5080202@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:60101 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbcD1QXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2016 12:23:49 -0400
In-Reply-To: <5722320E.5080202@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, lsf@lists.linux-foundation.org, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello Folks,

We still suffer from periodic complaints in our large customer base regarding the long recovery times for dm-multipath.
Most of the time this is when we have something like a switch back-plane issue or an issue where RSCN'S are blocked coming back up the fabric.
Corner cases still bite us often.

Most of the complaints originate from customers for example seeing Oracle cluster evictions where during the waiting on the mid-layer all mpath I/O is blocked until recovery.

We have to tune eh_deadline, eh_timeout and fast_io_fail_tmo but even tuning those we have to wait on serial recovery even if we set the timeouts low.

Lately we have been living with
eh_deadline=10
eh_timeout=5
fast_fail_io_tmo=10
leaving default sd timeout at 30s

So this continues to be an issue and I have specific examples using the jammer I can provide showing the serial recovery times here.

Thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Mike Snitzer" <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, lsf@lists.linux-foundation.org, "device-mapper development" <dm-devel@redhat.com>, "linux-scsi" <linux-scsi@vger.kernel.org>
Sent: Thursday, April 28, 2016 11:53:50 AM
Subject: Re: [Lsf] Notes from the four separate IO track sessions at LSF/MM

On 04/28/2016 08:40 AM, James Bottomley wrote:
> Well, the entire room, that's vendors, users and implementors
> complained that path failover takes far too long.  I think in their
> minds this is enough substance to go on.

The only complaints I heard about path failover taking too long came 
from people working on FC drivers. Aren't SCSI transport layer 
implementations expected to fail I/O after fast_io_fail_tmo expired 
instead of waiting until the SCSI error handler has finished? If so, why 
is it considered an issue that error handling for the FC protocol can 
take very long (hours)?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
