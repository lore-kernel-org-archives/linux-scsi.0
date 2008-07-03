From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Thu, 03 Jul 2008 09:25:35 +0200
Message-ID: <87skur1lao.fsf@denkblock.local>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local>
	<1214963700.3316.41.camel@localhost.localdomain>
	<87zlp0n4p8.fsf@denkblock.local>
	<1215009983.3330.14.camel@localhost.localdomain>
	<87vdzomg4c.fsf@denkblock.local>
	<1215016350.3330.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:56843 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937004AbYGCHZr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 03:25:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-07-02 at 17:59 +0200, Elias Oltmanns wrote:
>> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
[...]
>> > unless we get down to zero depth in which case the decrements are done
>> > under lock.
>> 
>> Sorry, but this simply doesn't resolve the matter at hand.
>> scsi_finish_command() can change (host|device)_blocked values to zero at
>> any time currently *not* protected by any lock. In much the same way
>> scsi_queue_insert() can change these values from zero to something else
>> at any time.
>
> Look more closely at the requirements for the decrements:  There have to
> be no outstanding commands: nothing can be in scsi_finish_command for
> the device (or the host for host_blocked).

Yes, I agree as far as the decrements are concerned. There still is the
check

if (sdev->device_blocked)

which can happen while ->device_blocked is changed either by
scsi_finish_command() or scsi_queue_insert(). If I understand Matthew and
you correctly, this doesn't pose any problem because assigning an int is
an atomic operation anyway.

Thanks for explaining,

Elias
