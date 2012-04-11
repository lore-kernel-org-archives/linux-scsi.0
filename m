From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Wed, 11 Apr 2012 19:47:55 +0000
Message-ID: <4F85DFEB.5080000@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>    <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>   <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>  <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org> <1333732525.2953.16.camel@dabdike> <4F81CCF9.8010408@acm.org> <4F85CACA.8060803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:45498 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761109Ab2DKTsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Apr 2012 15:48:05 -0400
In-Reply-To: <4F85CACA.8060803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/11/12 18:17, Mike Christie wrote:

> I would like scsi core to handle this, but I think right now drivers are
> doing work arounds like your patch.


I've been wondering whether the following approach would make sense
(haven't tested this yet):
- Let scsi_remove_host() stop the SCSI error handler thread instead of
  keeping the error handler thread around until scsi_host_dev_release()
  gets invoked.
- After blk_cleanup_queue() finished, kill all outstanding SCSI
  requests from inside scsi_remove_device() (those requests that have
  already been passed to the LLD via queuecommand) instead of waiting
  until the SCSI error handler detects a timeout.

An advantage of that approach would be that independent of the context
from which an I/O request is submitted (scanning / user space / ...)
that no new requests would be passed to the SCSI LLD after
scsi_remove_host() has finished. So this approach could be an
alternative for Tomas' patch at the start of this thread. However, a
disadvantage is that this approach will only work fine if the LLD stops
I/O completion notifications before invoking scsi_remove_host(). Several
LLDs seem to do that, but not ib_srp. But that's something Dave and I
can take care of.

Bart.
