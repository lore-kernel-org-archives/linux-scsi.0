From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 07:48:03 +0200
Message-ID: <51B56893.6040803@suse.de>
References: <1370511835-50072-1-git-send-email-hare@suse.de> <1370511835-50072-4-git-send-email-hare@suse.de> <CAC9+an+BRiFQXVtyjLYwpJGzT_vabQco7hgbp_MQY06j7st5Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab3FJFsN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 01:48:13 -0400
In-Reply-To: <CAC9+an+BRiFQXVtyjLYwpJGzT_vabQco7hgbp_MQY06j7st5Aw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On 06/10/2013 02:12 AM, Baruch Even wrote:
> On Thu, Jun 6, 2013 at 12:43 PM, Hannes Reinecke <hare@suse.de> wrote=
:
>> When a command runs into a timeout we need to send an 'ABORT TASK'
>> TMF. This is typically done by the 'eh_abort_handler' LLDD callback.
>>
>> Conceptually, however, this function is a normal SCSI command, so
>> there is no need to enter the error handler.
>>
>> This patch implements a new scsi_abort_command() function which
>> invokes an asynchronous function scsi_eh_abort_handler() to
>> abort the commands via 'eh_abort_handler'.
>>
>> If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
>> command will be retried if possible. If no retries are allowed
>> the command will be returned immediately, as we have to assume
>> the TMF succeeded and the command is completed with the LLDD.
>> For any other return code from 'eh_abort_handler' the command
>> will be pushed onto the existing SCSI EH handler, or aborted
>> with DID_TIME_OUT if that fails.
>>
>=20
> Why would you do a retry at this low level? We already have a bad pat=
h,
> the IO may already be rerouted through another path and continuing wi=
th this
> IO here may interfere with the multipath handling.
>=20
=46or multipathing no retries would be set, so the command would
be returned immediately.

I checked.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
