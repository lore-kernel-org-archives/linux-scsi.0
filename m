From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/16] scsi_dh_alua: use local buffer for VPD inquiry
Date: Thu, 13 Feb 2014 11:10:24 +0100
Message-ID: <52FC9A10.5090201@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-7-git-send-email-hare@suse.de> <52FC9591.6020206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbaBMKKZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Feb 2014 05:10:25 -0500
In-Reply-To: <52FC9591.6020206@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: James Bottomley <jbottomley@parallels.com>, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/13/2014 10:51 AM, Maurizio Lombardi wrote:
> Hi,
>=20
> On 01/31/2014 10:29 AM, Hannes Reinecke wrote:
>>  static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_d=
h_data *h)
>>  {
>> +	unsigned char *buff;
>> +	unsigned char bufflen =3D 36;
>> 	int len, timeout =3D ALUA_FAILOVER_TIMEOUT;
> [...]
>> +	len =3D (buff[2] << 8) + buff[3] + 4;
>> +	if (len > bufflen) {
> [...]
>> +		bufflen =3D len;
>=20
> just a nit: is it safe to use char as the type of bufflen? Isn't bett=
er
> to declare it as int just in case len is > than 255 ?
>=20
Yes, true.

However, this whole section needs to be reworked anyway, as there's
a fair chance we're getting the VPD page 0x83 for free.
(Cf my latest patchset 'Display EVPD pages in sysfs').

And jejb made some positive noises that, so I'll be reworking the
scsi_dh_alua patchset to take advantage of the new fields.

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
