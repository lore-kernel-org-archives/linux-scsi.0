From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: disable VPD page check on error
Date: Mon, 13 Jun 2016 15:56:05 +0200
Message-ID: <575EBB75.5060407@suse.de>
References: <1465822133-22143-1-git-send-email-hare@suse.de>
 <1465825834.4088.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423450AbcFMN4I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2016 09:56:08 -0400
In-Reply-To: <1465825834.4088.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 06/13/2016 03:50 PM, Ewan D. Milne wrote:
> On Mon, 2016-06-13 at 14:48 +0200, Hannes Reinecke wrote:
>> If we encounter an error during VPD page scanning we should be
>> setting the 'skip_vpd_pages' bit to avoid further accesses.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/scsi.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 1deb6ad..0359864 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -796,6 +796,7 @@ retry_pg0:
>>  	result =3D scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
>>  	if (result < 0) {
>>  		kfree(vpd_buf);
>> +		sdev->skip_vpd_pages =3D 1;
>>  		return;
>>  	}
>>  	if (result > vpd_len) {
>> @@ -822,6 +823,7 @@ retry_pg80:
>>  		result =3D scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
>>  		if (result < 0) {
>>  			kfree(vpd_buf);
>> +			sdev->skip_vpd_pages =3D 1;
>>  			return;
>>  		}
>>  		if (result > vpd_len) {
>> @@ -851,6 +853,7 @@ retry_pg83:
>>  		result =3D scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
>>  		if (result < 0) {
>>  			kfree(vpd_buf);
>> +			sdev->skip_vpd_pages =3D 1;
>>  			return;
>>  		}
>>  		if (result > vpd_len) {
>=20
> So, this changes scsi_attach_vpd() but not scsi_get_vpd_page() ?
>=20
Yes.
scsi_get_vpd_page() is just checking 'skip_vpd_pages', but none of the
other settings (ie it's not using scsi_device_supports_vpd()).
So we already come to different results when asking for VPD pages via
scsi_get_vpd_page() and scsi_attach_vpd().
Ideally we would be using scsi_device_supports_vpd() in both instances,
but that would require a further audit and I deemed it beyond the scope
of this patch.

> This particular implementation worries me.  If we get an error
> performing a VPD inquiry, we will never, ever, attempt one again?  Wh=
at
> happens if a path is down at the time?  The idea behind getting updat=
ed
> VPD info was that it might change, so if that does happen we don't wa=
nt
> to stop updating after an isolated error.
>=20
> I think what we want to do is check if the VPD inquiry is supported o=
n
> the *initial* inquiry, and if that fails then suppress further update=
s.
>=20
=46air point. Will be updating the patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
