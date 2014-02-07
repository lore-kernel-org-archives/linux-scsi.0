From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] Add EVPD page 0x83 entries to sysfs
Date: Fri, 07 Feb 2014 16:15:34 +0100
Message-ID: <52F4F896.5050808@suse.de>
References: <1391691878-61265-1-git-send-email-hare@suse.de> <52F3DF25.10208@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaBGPPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 10:15:37 -0500
In-Reply-To: <52F3DF25.10208@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Kay Sievers <kay@vrfy.org>, Jeremy Linton <jlinton@tributary.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 02/06/2014 08:14 PM, Douglas Gilbert wrote:
> On 14-02-06 08:04 AM, Hannes Reinecke wrote:
>> EVPD page 0x83 is used to uniquely identify the device.
>> So instead of having each and every program issue a separate
>> SG_IO call to retrieve this information it does make far more
>> sense to display it in sysfs.
>>
>> Cc: Jeremy Linton <jlinton@tributary.com>
>> Cc: Doug Gilbert <dgilbert@interlog.com>
>=20
> See below.
>=20
>> Cc: Kai Makisara <kai.makisara@kolumbus.fi>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_scan.c   |   3 +
>>   drivers/scsi/scsi_sysfs.c  | 166
>> ++++++++++++++++++++++++++++++++++++++++++++-
>>   include/scsi/scsi_device.h |   3 +
>>   3 files changed, 171 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 307a811..073fb84 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -929,6 +929,9 @@ static int scsi_add_lun(struct scsi_device
>> *sdev, unsigned char *inq_result,
>>       if (*bflags & BLIST_SKIP_VPD_PAGES)
>>           sdev->skip_vpd_pages =3D 1;
>>
>> +    if (sdev->scsi_level >=3D SCSI_3)
>> +        scsi_attach_vpd_ident(sdev);
>> +
>>       transport_configure_device(&sdev->sdev_gendev);
>>
>>       if (sdev->host->hostt->slave_configure) {
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 9117d0b..ffe7cb5 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -725,8 +725,170 @@ show_queue_type_field(struct device *dev,
>> struct device_attribute *attr,
>>
>>   static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field,
>> NULL);
>>
>> +void scsi_attach_vpd_ident(struct scsi_device *sdev)
>> +{
>> +    int ret;
>> +    int vpd_len =3D 255;
>> +    unsigned char *buffer;
>> +retry:
>> +    buffer =3D kmalloc(vpd_len, GFP_KERNEL);
>> +    if (buffer) {
>> +        ret =3D scsi_get_vpd_page(sdev, 0x83, buffer, vpd_len);
>> +        if (ret =3D=3D 0) {
>> +            vpd_len =3D (buffer[2] << 8) + buffer[3];
>> +            if (vpd_len > 255) {
>> +                kfree(buffer);
>> +                goto retry;
>> +            }
>> +            sdev->vpd_ident_len =3D vpd_len;
>> +            sdev->vpd_ident =3D buffer;
>> +        }
>> +    }
>> +}
>> +
>> +#define SCSI_VPD_ASSOC_lun 0x0
>> +#define SCSI_VPD_ASSOC_port 0x10
>> +#define SCSI_VPD_ASSOC_target 0x20
>> +
>> +#define SCSI_VPD_DESIG_vendor 0x0
>> +#define SCSI_VPD_DESIG_t10 0x1
>> +#define SCSI_VPD_DESIG_eui 0x2
>> +#define SCSI_VPD_DESIG_naa 0x3
>> +#define SCSI_VPD_DESIG_relport 0x4
>> +#define SCSI_VPD_DESIG_tpgrp 0x5
>> +#define SCSI_VPD_DESIG_lugrp 0x6
>> +#define SCSI_VPD_DESIG_md5 0x7
>> +#define SCSI_VPD_DESIG_scsi_name 0x8
>> +
>> +int scsi_parse_vpd_ident(struct scsi_device *sdev,
>> +             int assoc, int desig, char *buf)
>> +{
>> +    unsigned char *d;
>> +    int len =3D 0;
>> +
>> +    if (!sdev->vpd_ident)
>> +        return -EINVAL;
>> +
>> +    d =3D sdev->vpd_ident + 4;
>> +    while (d < sdev->vpd_ident + sdev->vpd_ident_len) {
>> +        if ((d[1] & 0x30) =3D=3D assoc &&
>=20
> Wouldn't it be clearer if:
>                 if (((d[1] & 0x30) >> 4) =3D=3D assoc &&
>=20
> and the lun, port and target defines were changed to agree
> with T10?
>=20
Yes, I could. Just thought it a bit pointless given
that we're (currently) the only ones using it.

Will be fixing it up with the next version.

>> +            (d[1] & 0xf) =3D=3D desig) {
>> +            switch (d[1] & 0xf) {
>> +            case SCSI_VPD_DESIG_eui:
>> +            case SCSI_VPD_DESIG_naa:
>> +            case SCSI_VPD_DESIG_md5:
>> +                switch (d[3]) {
>> +                case 8:
>> +                    len +=3D sprintf(buf + len,
>> +                              "%8phN\n", d + 4);
>> +                    break;
>> +                case 12:
>> +                    len +=3D sprintf(buf + len,
>> +                              "%12phN\n", d + 4);
>> +                    break;
>> +                case 16:
>> +                    len +=3D sprintf(buf + len,
>> +                              "%16phN\n", d + 4);
>> +                    break;
>> +                }
>> +                break;
>> +            case SCSI_VPD_DESIG_relport:
>> +            case SCSI_VPD_DESIG_tpgrp:
>> +            case SCSI_VPD_DESIG_lugrp:
>> +                len +=3D sprintf(buf + len, "%d\n",
>> +                          (int)(d[6] << 8) + d[7]);
>> +                break;
>> +            case SCSI_VPD_DESIG_vendor:
>> +            case SCSI_VPD_DESIG_t10:
>> +            case SCSI_VPD_DESIG_scsi_name:
>> +                len +=3D snprintf(buf + len, d[3] + 2, "%s\n",
>> +                        d + 4);
>> +                break;
>> +            }
>> +        }
>> +        d +=3D d[3] + 4;
>> +    }
>> +
>> +    return len ? len : -EINVAL;
>> +}
>> +
>> +#define sdev_evpd_ident(assoc,desig)                \
>> +static ssize_t                            \
>> +sdev_show_evpd_ident_##assoc##_##desig (struct device *dev,        =
\
>> +                    struct device_attribute *attr,    \
>> +                    char * buf)            \
>> +{                                    \
>> +    struct scsi_device *sdev =3D to_scsi_device(dev);            \
>> +    return scsi_parse_vpd_ident(sdev, SCSI_VPD_ASSOC_##assoc,    \
>> +                    SCSI_VPD_DESIG_##desig, buf);    \
>> +}
>> +
>> +#define sdev_evpd_attr(assoc, desig)                    \
>> +    sdev_evpd_ident(assoc, desig)                    \
>> +static DEVICE_ATTR(ident_##assoc##_##desig, S_IRUGO,            \
>> +           sdev_show_evpd_ident_##assoc##_##desig, NULL);
>> +
>=20
> You macros will have trouble picking up UAS and SOP port info
> stuff hiding behind the designator code 9h (Protocol specific
> port identifier). That may not matter.
>=20
As I don't have UAS and no SOP devices are on the market
it's not _that_ urgent.
But yeah, I'll be fixing it up with the next version.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
