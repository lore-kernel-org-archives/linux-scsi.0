From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi-mq prototype
Date: Fri, 29 Nov 2013 15:08:54 +0100
Message-ID: <52989FF6.4020307@acm.org>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:47447 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab3K2OI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Nov 2013 09:08:58 -0500
In-Reply-To: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 07/12/13 02:23, Nicholas A. Bellinger wrote:
> [ ... ] I would like to discuss scsi-mq, a high performance SCSI
> initiator prototype that utilizes blk-mq [ ... ]

(replying to an e-mail of four months ago)

It took a while but I finally found some time to look further into
blk-mq and scsi-mq. Did I see correctly that the scsi-mq prototype
implements the so-called hw queues in the SCSI core and not in the SCSI
LLDs ? Sorry but that approach looks wrong to me. Several high-end
storage adapters already support multiple queues today. E.g. the NVMe
specification supports up to 64.000 I/O queues. With InfiniBand HCA's it
is possible to create multiple queues between initiator and target for
e.g. the iSER and SRP protocols to increase throughput. When there are
multiple queues between initiator and target there is a potential that
SCSI commands get reordered. The SCSI specifications define whether or
not it is allowed to change the submission order of commands. As an
example, if two atomic writes are submitted by the same CPU neither the
block layer nor the SCSI core nor the SCSI LLD nor the SCSI target is
allowed to reorder these. With the scsi-mq prototype present in your
repo the only way for a SCSI LLD to guarantee that SCSI commands for
which the submission order must be preserved do not get reordered is
either to limit the queue depth to one or to use a single queue for
communication with the target. I don't think this is what we want.

In other words, the so-called hw queue concept must be mapped onto
queues managed by the SCSI LLD and not onto queues managed by the SCSI
core. That will allow the block layer and the SCSI core to preserve SCSI
command submission order when necessary by queueing ordered commands on
the same hardware queue.

See also
https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/log/?h=scsi-mq.

Bart.

