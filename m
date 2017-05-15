From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: generate uevent for SCSI sense code
Date: Mon, 15 May 2017 16:57:10 +0000
Message-ID: <25F5D4C2-F452-46D5-919C-EA84A972ED91@fb.com>
References: <20170504005013.2865393-1-songliubraving@fb.com>
 <20170504005013.2865393-2-songliubraving@fb.com>
 <54323B49-47CF-403A-970E-F94EDE2E0558@fb.com>
 <54b76bb9-8279-dc71-2c08-661eb3c4512f@suse.de>
 <1494851512.1081.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932514AbdEOQ5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 May 2017 12:57:21 -0400
In-Reply-To: <1494851512.1081.28.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <55BF178A21C2F74AA08C8BF8EE9A9C35@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>


> On May 15, 2017, at 5:31 AM, Ewan D. Milne <emilne@redhat.com> wrote:
>=20
> On Mon, 2017-05-15 at 08:04 +0200, Hannes Reinecke wrote:
>> In general I like the idea; however, the 'filter' thingie is somewhat
>> odd. I could somewhat buy into the idea of filtering for sense keys, but
>> then I would have expected to use the 'sense_event_filter' as a bitmap
>> of allowed sense keys.
>> With your current design you can only filter for one specific sense key,
>> _and_ you leave the remaining bits of the sense_event_filter variable
>> unused.
>> So either turn it into a bitmap and allow for several sense keys to be
>> filtered, or treat it as mask for the _entire_ sense, but then you'd
>> need for ASC and ASCQ, too.
>>=20
>> Cheers,
>>=20
>> Hannes
>=20
> I think what would help here is understanding what you are trying to
> accomplish with this change.  Are you trying to allow generation of
> a uevent on a particular sense KCQ combination you know in advance,
> or a set of them, or do you want to be able to normally generate
> uevents for every sense keys/codes (i.e. all the bitmap bits set)
> and then perhaps narrow down to a specific one when you are looking
> for a problem?

Thanks for these feedbacks!

My goal here is to generate uevent for a set of sense keys. I would=20
like to store these information for a fleet of many HDDs over a=20
couple years. We are hoping to use these information to get insights
in the quality of the HDDs.=20

> When I added the sense code uevent generation for Unit Attentions,
> one big concern I had was how many events per second would be generated.
> The userspace event handling is very slow, and can only handle a few
> hundred events per second before it starts backing up, and then you
> can lose events, which you don't want.

Thanks for this information. I am trying to limit the rate with the=20
filter. But I am not sure whether this is sufficient.=20

> Generating a uevent on MEDIUM ERROR is somewhat worrying, when a drive
> goes bad you could easily get these on every I/O.

MEDIUM ERROR is an important event that we would like to keep. Maybe=20
we need better mechanism for rate limit, for example, no more than 10=20
MEDIUM ERROR per second per drive.=20

>=20
> Your actual uevent emit:
>=20
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +       case SDEV_EVT_SCSI_SENSE:
> +               envp[idx++] =3D "SDEV_UA=3DSCSI_SENSE";
> +               for (i =3D idx; i < idx + 3; ++i) {
> +                       envp[i] =3D kzalloc(32, GFP_ATOMIC);
> +                       if (!envp[i])
> +                               break;
> +                       free_envp =3D i;
> +               }
> +               snprintf(envp[idx++], 32, "LBA=3D%lu", evt->sense_evt_dat=
a.lba);
> +               snprintf(envp[idx++], 32, "SIZE=3D%d", evt->sense_evt_dat=
a.size);
> +               snprintf(envp[idx++], 32, "SENSE_CODE=3D%1x/%02x/%02x",
> +                        evt->sense_evt_data.sshdr.sense_key,
> +                        evt->sense_evt_data.sshdr.asc,
> +                        evt->sense_evt_data.sshdr.ascq);
> +               break;
> +#endif
>=20
> Is a little strange.  The "SDEV_UA" property implies that it was a
> UNIT ATTENTION, but you are filtering on other sense types, so you
> would probably want a different property.  Many SCSI commands do not
> have a LOGICAL BLOCK ADDRESS field, or a TRANSFER LENGTH field, so
> you might be reporting garbage if they don't.  And, since this is a
> SCSI command, you probably want to report the length from the command,
> not the count in bytes from the request structure.

I didn't realize SDEV_UA means UNIT ATTENTION. Let me think about a=20
different name.=20

For the data being logged, I was thinking to log the whole SCSI command
and full sense buffer. Let me try a few different things.=20

Thanks again,
Song
