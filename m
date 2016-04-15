From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] megaraid_sas: call ISR function to clean up pending
 replies in OCR path
Date: Fri, 15 Apr 2016 16:12:24 +0200
Message-ID: <5710F6C8.4020108@suse.de>
References: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
 <1460705013-6482-3-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbcDOOM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 10:12:26 -0400
In-Reply-To: <1460705013-6482-3-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org

On 04/15/2016 09:23 AM, Sumit Saxena wrote:
> In OCR path, before calling chip reset calls function megasas_wait_fo=
r_outstanding_fusion to check reason
> of OCR. In case of firmware FAULT initiated OCR and DCMD timeout init=
iated timeout, driver will clear any
> outstanding reply(yet to be processed by driver) in reply queues befo=
re going for chip reset.
> This code is added to handle a scenario when IO timeout initiated ada=
pter reset and management application
> initiated adapter reset(by sending command to FAULT firmware) happens=
 simultaneously since adapter reset
> function is safe-guarded by reset_mutex so only thread will be doing =
controller reset. Consider IO timeout
> thread gets mutex and proceeds with adapter reset process after disab=
ling interrupts and by the time
> managementapplication has fired command to firmware to do adapter res=
et and the same command is completed by
> firmware but since interrupts are disabled, driver will not get compl=
etion and the same command will be in
> outstanding/pendingcommands list of driver and refires same command f=
rom IO timeout thread after chip reset
> which will again FAULT firmware and evntually causes kill adapter.
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
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
