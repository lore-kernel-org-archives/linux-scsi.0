From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] RFC scsi_error: handle REPORT_LUNS_DATA_CHANGED, CAPACITY_DATA_CHANGED,
Date: Wed, 20 May 2009 16:46:35 +0200
Message-ID: <4A1417CB.7000009@suse.de>
References: <12385252751209-git-send-email-michaelc@cs.wisc.edu>	<49E90243.7080806@cs.wisc.edu>	<49EC46A8.1070704@suse.de> <20090508094158T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51611 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbZETOqf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 10:46:35 -0400
In-Reply-To: <20090508094158T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Hi all,

=46UJITA Tomonori wrote:
> On Mon, 20 Apr 2009 11:55:52 +0200
> Hannes Reinecke <hare@suse.de> wrote:
>=20
>> Hi Mike,
>>
[ .. ]
>>> I was thinking that maybe using kobject_uevent_env would be better.=
 The
>>> info that gets passed to userspace would be the decoded sense and
>>> asc/ascq based on values from the drivers/scsi/constants.c.
>>>
>> No. This patch has the possibility of generating _huge_ amounts of
>> messages, most of which are information only and of no influence
>> to the actual operation.
>> udev would be flooded with it and won't be able to react to 'importa=
nt'
>> messages while processing them.
>=20
> Do we really have huge amount of messages, errors, unit attentions,
> etc?
>=20
There is a potential for that. Things which would normally ignored/retr=
ied
silently (like UNIT ATTENTION) will suddenly be visible.
And what's more, we'll be likely be getting plenty of errors if the
target has some failure. And these will get multiplied when having
a multipathed setup.
But this is exactly when we rely on udev to process any 'real' events
like device remove etc in time. So I'd rather use a separate mechanism
for this.

> We already have a mechanism to send events to user space,
> sdev_evt_send(). Could we simply use (or extend) it?
>=20
No, not really for above reasons.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
