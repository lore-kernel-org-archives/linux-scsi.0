From: Jordan Hargrave <jharg93@gmail.com>
Subject: Re: [PATCH] Remove check for SAS expander when querying bay/enclosure IDs.
Date: Mon, 31 Aug 2015 11:26:02 -0500
Message-ID: <CAC1AzdfFMVMps5XyYt-9iEbZYCeyK7JKzjhPdimgs4Q+FNpukA@mail.gmail.com>
References: <1436797653-9822-1-git-send-email-jordan_hargrave@dell.com>
	<55A4F137.8010100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33851 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbbHaQ0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 12:26:04 -0400
In-Reply-To: <55A4F137.8010100@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com, Jordan Hargrave <jordan_hargrave@dell.com>

On Tue, Jul 14, 2015 at 6:23 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 07/13/2015 04:27 PM, Jordan Hargrave wrote:
>> Dell Server backplanes can report bay/enclosure IDs without an
>> expander present.  This patch allows the bay/enclosure IDs to be
>> propagaged to sysfs.we
>>
>> Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
>> ---
>>  drivers/scsi/scsi_transport_sas.c | 10 ----------
>>  1 file changed, 10 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_t=
ransport_sas.c
>> index 9a05819..30d26e3 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -1222,13 +1222,6 @@ show_sas_rphy_enclosure_identifier(struct dev=
ice *dev,
>>       u64 identifier;
>>       int error;
>>
>> -     /*
>> -      * Only devices behind an expander are supported, because the
>> -      * enclosure identifier is a SMP feature.
>> -      */
>> -     if (scsi_is_sas_phy_local(phy))
>> -             return -EINVAL;
>> -
>>       error =3D i->f->get_enclosure_identifier(rphy, &identifier);
>>       if (error)
>>               return error;
>> @@ -1248,9 +1241,6 @@ show_sas_rphy_bay_identifier(struct device *de=
v,
>>       struct sas_internal *i =3D to_sas_internal(shost->transportt);
>>       int val;
>>
>> -     if (scsi_is_sas_phy_local(phy))
>> -             return -EINVAL;
>> -
>>       val =3D i->f->get_bay_identifier(rphy);
>>       if (val < 0)
>>               return val;
>>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                            zSeries & Storage
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)

Any updates on getting this included?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
