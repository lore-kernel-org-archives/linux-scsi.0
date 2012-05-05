From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] Make scsi_free_queue() abort pending requests
Date: Sat, 05 May 2012 13:41:41 +0000
Message-ID: <4FA52E15.7020609@acm.org>
References: <4FA3EF10.3040104@acm.org> <4FA3F0B1.9040207@acm.org> <4FA43B21.2060906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:35402 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2EENls (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 May 2012 09:41:48 -0400
In-Reply-To: <4FA43B21.2060906@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 05/04/12 20:25, Mike Christie wrote:

> On 05/04/2012 10:07 AM, Bart Van Assche wrote:
>> It is possible that a SCSI LLD invokes scsi_remove_host() after a
>> request has been queued via scsi_host_template.queuecommand() but
>> before scsi_done() has been invoked for that request. This may
> 
> If that happens won't we wait in blk_cleanup_queue->blk_drain_queue for
> that IO to be completed (completed normally or timed out and processed
> through that path)?

As far as I understand the block layer requests that have been queued
but for which scsi_request_fn() has not yet been invoked are on the
request_queue.queue_head list. Requests that have been passed to the
SCSI LLD but for which scsi_done() has not yet been invoked are on the
request_queue.timeout_list list. blk_drain_queue() works on the former
list while blk_abort_queue() processes the latter.

Bart.
