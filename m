From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/8] pm80xx: Remove unnecessary phy disconnect while link
 error
Date: Wed, 29 Jul 2015 11:21:57 +0200
Message-ID: <55B89B35.8010008@suse.de>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com> <1438151240-4097-6-git-send-email-Viswas.G@pmcs.com> <55B8952E.5000004@suse.de> <DB8BCD22E410A84DA91083F3479A3DB3C6274FC2@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbbG2JV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 05:21:59 -0400
In-Reply-To: <DB8BCD22E410A84DA91083F3479A3DB3C6274FC2@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

On 07/29/2015 11:20 AM, Viswas G wrote:
>=20
> On Wed, Jul 29, 2015 at 2:26 PM, Hannes Reinecke <hare@suse.de> wrote=
:
>> On 07/29/2015 08:27 AM, Viswas.G@pmcs.com wrote:
>>> From: Viswas G <Viswas.G@pmcs.com>
>>>
>>> If the link error happens, we don't need to disconnect the phy,
>>> which will remove the drive. Instead acknowledging the controller
>>> and logging the error will be enough.
>>>
>>> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
>>> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
>>> ---
>>>  drivers/scsi/pm8001/pm80xx_hwi.c |   12 ------------
>>>  1 files changed, 0 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001=
/pm80xx_hwi.c
>>> index dced9f7..3d8b4ae 100644
>>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>>> @@ -3176,9 +3176,6 @@ static int mpi_hw_event(struct pm8001_hba_inf=
o *pm8001_ha, void *piomb)
>>>                       pm8001_printk("HW_EVENT_LINK_ERR_INVALID_DWOR=
D\n"));
>>>               pm80xx_hw_event_ack_req(pm8001_ha, 0,
>>>                       HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy=
_id, 0, 0);
>>> -             sas_phy_disconnected(sas_phy);
>>> -             phy->phy_attached =3D 0;
>>> -             sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_E=
RR);
>>>               break;
>>>       case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
>>>               PM8001_MSG_DBG(pm8001_ha,
>>> @@ -3186,9 +3183,6 @@ static int mpi_hw_event(struct pm8001_hba_inf=
o *pm8001_ha, void *piomb)
>>>               pm80xx_hw_event_ack_req(pm8001_ha, 0,
>>>                       HW_EVENT_LINK_ERR_DISPARITY_ERROR,
>>>                       port_id, phy_id, 0, 0);
>>> -             sas_phy_disconnected(sas_phy);
>>> -             phy->phy_attached =3D 0;
>>> -             sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_E=
RR);
>>>               break;
>>>       case HW_EVENT_LINK_ERR_CODE_VIOLATION:
>>>               PM8001_MSG_DBG(pm8001_ha,
>>> @@ -3196,9 +3190,6 @@ static int mpi_hw_event(struct pm8001_hba_inf=
o *pm8001_ha, void *piomb)
>>>               pm80xx_hw_event_ack_req(pm8001_ha, 0,
>>>                       HW_EVENT_LINK_ERR_CODE_VIOLATION,
>>>                       port_id, phy_id, 0, 0);
>>> -             sas_phy_disconnected(sas_phy);
>>> -             phy->phy_attached =3D 0;
>>> -             sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_E=
RR);
>>>               break;
>>>       case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
>>>               PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
>>> @@ -3206,9 +3197,6 @@ static int mpi_hw_event(struct pm8001_hba_inf=
o *pm8001_ha, void *piomb)
>>>               pm80xx_hw_event_ack_req(pm8001_ha, 0,
>>>                       HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH,
>>>                       port_id, phy_id, 0, 0);
>>> -             sas_phy_disconnected(sas_phy);
>>> -             phy->phy_attached =3D 0;
>>> -             sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_E=
RR);
>>>               break;
>>>       case HW_EVENT_MALFUNCTION:
>>>               PM8001_MSG_DBG(pm8001_ha,
>>>
>> So what happens with the port, then?
>> Will you be getting another event when the port finally disconnects?
>> If not, how to you remove the port after a link failure?
>>
>=20
> When the Phy disconnects, we will be getting the PHY DOWN events for=20
> the phys in that port and we will remove that port.=20
>=20
Okay, thanks.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
