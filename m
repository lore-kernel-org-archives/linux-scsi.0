From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 11:22:44 -0500
Message-ID: <43EA1AD4.8010402@emulex.com>
References: <43E99248.7090505@gmail.com> <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57748 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161098AbWBHQW4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 11:22:56 -0500
In-Reply-To: <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>



James Bottomley wrote:
> On Wed, 2006-02-08 at 15:40 +0900, Tejun Heo wrote:
> ...<snip>...
> Unfortunately, though, this is only half the problem.
> 
> The other half is busy/queue_full processing and error recovery
> 
> For the first: busy/queue_full processing, the issue is that when we
> send out a command, we could get a BUSY or QUEUE_FULL return which comes
> back to us via IRQ context.  Unfortunately, we could have multiple
> commands that do this and a command will be accepted as soon as the busy
> condition alleviates, so we could see say two commands go down in order,
> the first one will get BUSY, the second is accepted and only then do we
> get the IRQ that says BUSY to the first ... now we have out of order
> execution.

James is also not disclosing other areas that may fail...

- How does multipathing affect this (maybe not dm, but others that exist).
- The implicit expectation of the LLDD and the hardware is that commands are
   placed on the wire in the same order given to queuecommand. However, no
   where is this mandated. In general, they do keep order. However, I've seen
   driver implementations that don't dispatch directly to hardware in
   queuecommand, allowing the intermediate steps to fail and perhaps disrupt
   ordering.
- Some adapters may actually be multipath/raid cards, thus affecting command
   delivery.
- SCSI Transports are not 100% reliable, affecting ordering. For FC,
   a single Frame corruption could cause a command frame to be dropped thus
   the next command received and executed out of order. You would not notice
   an issue until the scsi i/o timeout fires and aborts the i/o. The subsequent
   i/o may have already completed by that time. Some transports due have
   command sequence numbering to avoid this, but it's an optional feature.

-- james s
