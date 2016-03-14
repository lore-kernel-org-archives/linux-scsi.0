From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] lpfc: fix misleading indentation
Date: Mon, 14 Mar 2016 16:26:28 +0100
Message-ID: <56E6D824.3080809@suse.de>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
 <1457965789-3373916-3-git-send-email-arnd@arndb.de>
 <56E6D69E.1050008@suse.de> <13330994.pIJCLN5xX1@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934381AbcCNP0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 11:26:31 -0400
In-Reply-To: <13330994.pIJCLN5xX1@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sebastian Herbszt <herbszt@gmx.de>

On 03/14/2016 04:25 PM, Arnd Bergmann wrote:
> On Monday 14 March 2016 16:19:58 Hannes Reinecke wrote:
>>>       vports =3D lpfc_create_vport_work_array(phba);
>>> -     if (vports !=3D NULL)
>>> +     if (vports !=3D NULL) {
>>>               for (i =3D 0; i <=3D phba->max_vports && vports[i] !=3D=
 NULL; i++) {
>>>                       struct Scsi_Host *shost;
>>>                       shost =3D lpfc_shost_from_vport(vports[i]);
>>> @@ -2877,7 +2877,8 @@ lpfc_online(struct lpfc_hba *phba)
>>>                       }
>>>                       spin_unlock_irq(shost->host_lock);
>>>               }
>>> -             lpfc_destroy_vport_work_array(phba, vports);
>>> +     }
>>> +     lpfc_destroy_vport_work_array(phba, vports);
>>> =20
>>>       lpfc_unblock_mgmt_io(phba);
>>>       return 0;
>>>
>> Nope.
>>
>> vports is only valid from within the indentation block, so it should
>> be moved into it.
>>
>>
>=20
> Well, every other user of the function also looks like
>=20
> 	vports =3D lpfc_create_vport_work_array(phba);
> 	if (vports !=3D NULL) {
> 		do_something(vports);
> 	}
> 	lpfc_destroy_vport_work_array(phba, vports);
>=20
> and lpfc_destroy_vport_work_array() does nothing if its argument is N=
ULL.
>=20
> I still think my patch is the correct fix for the warning.
>=20
Okay, good point.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
