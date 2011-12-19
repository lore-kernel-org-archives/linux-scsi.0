From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
Date: Mon, 19 Dec 2011 12:59:16 +0100
Message-ID: <4EEF2714.1080402@suse.de>
References: <1321572864-23628-1-git-send-email-richard@nod.at>  <4EEDFC16.90303@nod.at> <1324219540.3091.28.camel@dabdike.int.hansenpartnership.com> <4EEDFE4E.6090104@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1LSL7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 06:59:18 -0500
In-Reply-To: <4EEDFE4E.6090104@nod.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/18/2011 03:53 PM, Richard Weinberger wrote:
> Am 18.12.2011 15:45, schrieb James Bottomley:
>> On Sun, 2011-12-18 at 15:43 +0100, Richard Weinberger wrote:
>>> Am 18.11.2011 00:34, schrieb Richard Weinberger:
>>>> scsi_dh_attach() should return a negative value on error.
>>>>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>> ---
>>>>  include/scsi/scsi_dh.h |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
>>>> index e3f2db2..e07ab10 100644
>>>> --- a/include/scsi/scsi_dh.h
>>>> +++ b/include/scsi/scsi_dh.h
>>>> @@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const ch=
ar *name)
>>>>  }
>>>>  static inline int scsi_dh_attach(struct request_queue *req, const=
 char *name)
>>>>  {
>>>> -	return SCSI_DH_NOSYS;
>>>> +	return -SCSI_DH_NOSYS;
>>>>  }
>>>>  static inline void scsi_dh_detach(struct request_queue *q)
>>>>  {
>>>
>>> James,
>>>
>>> can you please pickup this patch?
>>
>> It still needs an ack from rdac people (other one just got overlooke=
d).
>>
>=20
> Who are the rdac people?
> I sent the patch to all addresses reported by get_maintainers.pl.
>=20
Nack.

This patch is wrong.

scsi_dh_attach() (and, incidentally, scsi_dh_set_params()) should
return a standard error value. SCSI_DH_XXX are internal to
device_handler and should never see the light of day.

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
