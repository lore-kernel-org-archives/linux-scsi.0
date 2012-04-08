From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Sun, 08 Apr 2012 17:38:01 +0000
Message-ID: <4F81CCF9.8010408@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>    <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>   <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>  <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org> <1333732525.2953.16.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:59788 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2DHRiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Apr 2012 13:38:09 -0400
In-Reply-To: <1333732525.2953.16.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/06/12 17:15, James Bottomley wrote:

> Consider where the command came from: either it's come from startup (the
> current problem), operation (in which case the device must be open to
> send and receive it) or teardown (which is synchronous).


And what about e.g. sd_check_events() or sr_check_events() ?

Maybe I should explain why I started looking at the SCSI error handler
in so much detail. While running disk removal tests against ib_srp I
found out that the SCSI error handler thread can invoke the LLD's abort
and reset handlers long after scsi_remove_host() finished. That's why I
came up with this patch: "[PATCH 05/15] ib_srp: Avoid that SCSI error
handling triggers a crash"
(http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg11234.html).
But I'm still wondering whether that's the right approach. Should this
issue be addressed in each LLD or in the SCSI core ?

Thanks,

Bart.
