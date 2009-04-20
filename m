From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 1/3] mpt fusion: Queue full event handling
Date: Mon, 20 Apr 2009 09:38:55 -0700
Message-ID: <da824cf30904200938w627426ds4cee8a08b851e07@mail.gmail.com>
References: <20090420104318.GA12813@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:59839 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZDTQjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 12:39:03 -0400
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id n3KGcveN030307
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 17:38:58 +0100
Received: from an-out-0708.google.com (anac38.prod.google.com [10.100.54.38])
	by zps78.corp.google.com with ESMTP id n3KGcuQq009280
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 09:38:56 -0700
Received: by an-out-0708.google.com with SMTP id c38so409014ana.25
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 09:38:56 -0700 (PDT)
In-Reply-To: <20090420104318.GA12813@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Desai,
Some nits about comments. And suggestions that you can chose to ignore.=
 :)


On Mon, Apr 20, 2009 at 3:43 AM, Kashyap, Desai <kashyap.desai@lsi.com>=
 wrote:
=2E..
> diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion=
/mptsas.h
> index 9b47379..36578df 100644
> --- a/drivers/message/fusion/mptsas.h
> +++ b/drivers/message/fusion/mptsas.h
> @@ -83,6 +83,12 @@ struct sas_device_info {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 slot; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 /* enclosure slot id */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enclosure_logical_id; /*enclosure addre=
ss */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is_logical_volume; /* is this logica=
l volume */

"is this logical volume" comment is just repeating the variable name. :=
)
Maybe point at a description (e.g. "See page XX of Programmers Guide")
or omit this comment.

> + =C2=A0 =C2=A0 =C2=A0 /* this belongs to volume */
> + =C2=A0 =C2=A0 =C2=A0 u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is_hidden_raid_component;

Does "belongs to a volume" mean a "logical volume"?

Suggestion: replace with something like /* is physical dev part of volu=
me? */

> + =C2=A0 =C2=A0 =C2=A0 /* this valid when is_hidden_raid_component se=
t */
> + =C2=A0 =C2=A0 =C2=A0 u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0volume_id;

When looking at code, I would have associated volume_id
with "is_logical_volume" variable. Maybe call this "hidden_raid_VID" ?

> + =C2=A0 =C2=A0 =C2=A0 /* cached data for a removed device */
> + =C2=A0 =C2=A0 =C2=A0 u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is_cached;

"cached data" generally refers to user payload data.
I'm pretty sure that's not meant here.
Suggestion:  /* Device info is cached (or not) */

It's interesting to know this if the device has been removed.
But the act of caching has to take place before the device is
gone and thus, this flag will tell us the data was
read once "before" and may not be current.

Some devices will change the SCSI model string after
they've spun up and loaded the full firmware from reserved
tracks on the media.


> =C2=A0};
>
> =C2=A0struct mptsas_hotplug_event {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
