From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] Add EVPD page 0x83 entries to sysfs
Date: Wed, 12 Feb 2014 09:26:59 +0100
Message-ID: <52FB3053.6060108@suse.de>
References: <1392129294-55235-1-git-send-email-hare@suse.de> <1392129294-55235-3-git-send-email-hare@suse.de> <20140212080256.GA18203@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaBLI1C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 03:27:02 -0500
In-Reply-To: <20140212080256.GA18203@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 02/12/2014 09:02 AM, Christoph Hellwig wrote:
> On Tue, Feb 11, 2014 at 03:34:54PM +0100, Hannes Reinecke wrote:
>> EVPD page 0x83 is used to uniquely identify the device.
>> So instead of having each and every program issue a separate
>> SG_IO call to retrieve this information it does make far more
>> sense to display it in sysfs.
>> The page is displayed in its entirety with the attribute
>> 'vpd_pg83', and the individual designators are stored in
>> ident_<association>_<designator> attributes.
>> Duplicate designators are added as individual lines to
>> the corresponding attribute.
>=20
> Looks correct to me, suggestions for a few possible cleanups below.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>=20
>> +#define SCSI_VPD_ASSOC_lun 0x0
>> +#define SCSI_VPD_ASSOC_port 0x1
>> +#define SCSI_VPD_ASSOC_target 0x2
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
>> +#define SCSI_VPD_DESIG_proto 0x9
>=20
> Shouldn't these constants be in a header?
>=20
Radio Yerewan answers: In principle, yes.

But then the definitions a closely tied to the following macro
(hence the lowercase in the last string), so it's not _that_
useful for a general definition.

If we were to move the constants into a header I'd have
to re-do all the macros (up to and including DEVICE_ATTR)
building up the sysfs attributes. Which currently doesn't
give any benefits whatsoever.

But if someone insists ...

>> +				switch (d[0] >> 4) {
>> +				case SCSI_PROTOCOL_FCP:
>> +					proto =3D "fcp";
>> +					break;
>> +				case SCSI_PROTOCOL_SPI:
>> +					proto =3D "spi";
>> +					break;
>=20
> Splitting the protocol mapping into a separate helper woulkd be good.
> In fact this could easily be an array lookup as well.
>=20
Ok.

>> +#define sdev_evpd_test_and_show_attr(sdev, attr, assoc, desig)		\
>> +	if (attr =3D=3D &dev_attr_ident_##assoc##_##desig.attr) {		\
>> +		if (scsi_test_vpd_ident(sdev, SCSI_VPD_ASSOC_##assoc, \
>> +					SCSI_VPD_DESIG_##desig))	\
>> +			return S_IRUGO;					\
>> +		else							\
>> +			return 0;					\
>=20
> No need for the else here.
>=20
Bzzt. The "else" branch is required, the "if" branch can be skipped.

(hch was wrong! Quick, mark the day!)

>> +	if (attr =3D=3D &dev_attr_vpd_pg83.attr) {
>> +		if (sdev->vpd_ident)
>> +			return S_IRUGO;
>> +		else
>> +			return 0;
>> +	}
>=20
> Same here.
>=20
:-)

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
