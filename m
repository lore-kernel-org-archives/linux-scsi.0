From: Jon Mason <jdmason@kudzu.us>
Subject: Re: [PATCH 03/19] lpfc: remove unnecessary read of PCI_CAP_ID_EXP
Date: Fri, 1 Jul 2011 10:05:56 -0500
Message-ID: <BANLkTim9gBx=RtbYkZu95gyRUDPy8sDuvg@mail.gmail.com>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
	<4E0CDF8B.3020505@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36683 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1GAPF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2011 11:05:58 -0400
Received: by eyx24 with SMTP id 24so1148785eyx.19
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2011 08:05:57 -0700 (PDT)
In-Reply-To: <4E0CDF8B.3020505@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Richard Lary <rlary@us.ibm.com>

On Thu, Jun 30, 2011 at 3:41 PM, James Smart <james.smart@emulex.com> w=
rote:
> Jon,
>
> I must NACK this patch to the lpfc driver and recommend that all othe=
r
> patches which replace pci_find_capability(pdef, PCI_CAP_ID_EXP) with
> "pci_is_pcie(pdev)" are NACK'd as well.
>
> The reason is due to an issue on PPC platforms whereby use of
> "pdev->is_pcie" and pci_is_pcie() will erroneously fail under some
> conditions, but explicit search for the capability struct via
> pci_find_capability() is always successful. =A0 I expect this to be d=
ue a
> shadowing of pci config space in the hal/platform that isn't sufficie=
ntly
> built up. =A0We detected this issue while testing AER/EEH, and are fu=
nctional
> only if the pci_find_capability() option is used.

pci_is_pcie checks for a PCI-E capability offset that was determined
by calling pci_find_capability during the PCI bus walking.  Based on
your description above this should be functionally equivalent.  If
this is not safe, then the PCI bus walking code is most likely busted
on EEH enabled PPC systems (and that is a BIG problem).

Thanks,
Jon

>
> -- james s
>
>
>
> On 6/27/2011 1:39 PM, Jon Mason wrote:
>>
>> The PCIE capability offset is saved during PCI bus walking. =A0It wi=
ll
>> remove an unnecessary search in the PCI configuration space if this
>> value is referenced instead of reacquiring it. =A0Also, pci_is_pcie =
is a
>> better way of determining if the device is PCIE or not (as it uses t=
he
>> same saved PCIE capability offset).
>>
>> Signed-off-by: Jon Mason<jdmason@kudzu.us>
>> ---
>> =A0drivers/scsi/lpfc/lpfc_init.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_=
init.c
>> index 148b98d..9000ad0 100644
>> --- a/drivers/scsi/lpfc/lpfc_init.c
>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> @@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>> =A0 =A0 =A0 =A0pci_save_state(pdev);
>>
>> =A0 =A0 =A0 =A0/* PCIe EEH recovery on powerpc platforms needs funda=
mental reset
>> */
>> - =A0 =A0 =A0 if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
>> + =A0 =A0 =A0 if (pci_is_pcie(pdev))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdev->needs_freset =3D 1;
>>
>> =A0 =A0 =A0 =A0return 0;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
