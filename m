From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Mon, 19 Dec 2011 10:38:48 +0000
Message-ID: <CAO+b5-q332RKkLrUV7X_D73SHBrLpt=6Xz=W7ZtOwZ+9iSOyDw@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012010.37276.bvanassche@acm.org>
	<1324265791.17849.92.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51787 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LSKiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2011 05:38:50 -0500
In-Reply-To: <1324265791.17849.92.camel@obelisk.thedillows.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: linux-rdma@vger.kernel.org, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Roland Dreier <roland@purestorage.com>, linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 3:36 AM, David Dillow <dillowda@ornl.gov> wrote=
:
> On Thu, 2011-12-01 at 20:10 +0100, Bart Van Assche wrote:
>> Rework ib_srp transport layer error handling. Instead of letting SCS=
I
>> commands time out if a transport layer error occurs,
>
> This is good, but should probably be part of the initial disconnect. =
We
> want to run the receive queue dry, processing responses to avoid
> unnecessarily resetting a command that was successful.

Blocking the SCSI host doesn't prevent ib_srp from continuing to
process IB completion notifications.

>> block the SCSI
>> host and try to reconnect until the reconnect timeout elapses or unt=
il
>> the maximum number of reconnect attempts has been exceeded, whicheve=
r
>> happens first.
>
> When we're blocked for a disconnected target, we may want to call the
> state something other than SRP_TARGET_BLOCKED. I'd like to eventually
> handle the case where the target leaves the fabric temporarily -- we
> don't necessarily disconnect in that case, but we need to block comma=
nds
> until it comes back or we give up on it.

The case where the target leaves the fabric temporarily should already
be covered by this patch series.

>> +static void srp_remove_target(struct srp_target_port *target)
>> =A0{
>
>> =A0 =A0 =A0 srp_del_scsi_host_attr(target->scsi_host);
>> + =A0 =A0 cancel_work_sync(&target->block_work);
>> + =A0 =A0 mutex_lock(&target->mutex);
>> + =A0 =A0 mutex_unlock(&target->mutex);
>
> You lock and unlock here without doing anything in the critical secti=
on.

That's on purpose.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
