From: Jon Mason <jdmason@kudzu.us>
Subject: Re: Warning: qla4xxx/qla2xxx/lpfc : removal of PCI_CAP_ID_EXP
Date: Fri, 1 Jul 2011 10:10:32 -0500
Message-ID: <BANLkTim0FYKz6Uu=_DScHg847LR_oJFTnQ@mail.gmail.com>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
	<4E0CDF8B.3020505@emulex.com>
	<3ad06450-f7bc-4367-88de-615c530054e2@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1GAPKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2011 11:10:34 -0400
Received: by eyx24 with SMTP id 24so1150280eyx.19
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2011 08:10:33 -0700 (PDT)
In-Reply-To: <3ad06450-f7bc-4367-88de-615c530054e2@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Richard Lary <rlary@us.ibm.com>, Ravi Anand <ravi.anand@qlogic.com>, vikas.chaudhary@qlogic.com, iscsi-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>

pci_is_pcie checks for a PCI-E capability offset that was determined
by calling pci_find_capability during the PCI bus walking.  Based on
the description below this should be functionally equivalent.  If
this is not safe, then the PCI bus walking code is most likely busted
on EEH enabled PPC systems (and that is a BIG problem).  I'll e-mail
the PPC mailing list to verify the issue.

Thanks,
Jon

On Fri, Jul 1, 2011 at 9:48 AM, James Smart <james.smart@emulex.com> wr=
ote:
> All,
>
> I wanted to communicate a potential warning to those drivers that had=
 a
> patch submitted to replace config space searches of PCI_CAP_ID_EXP wi=
th
> shorthand options such as is_pcie and pci_is_pcie().
>
> Testing with the lpfc driver and AER/EEH identified cases where the
> short-hand search options would fail on PPC platforms. =A0The only su=
ccessful
> option in all cases was the explicit search via PCI_CAP_ID_EXP. =A0 T=
herefore,
> I recommend that this change not be accepted until the platform level=
 issue
> can be identified and corrected.
>
> -- james s
>
>
>
> On 6/30/2011 4:41 PM, James Smart wrote:
>>
>> Jon,
>>
>> I must NACK this patch to the lpfc driver and recommend that all oth=
er
>> patches
>> which replace pci_find_capability(pdef, PCI_CAP_ID_EXP) with
>> "pci_is_pcie(pdev)" are NACK'd as well.
>>
>> The reason is due to an issue on PPC platforms whereby use of
>> "pdev->is_pcie"
>> and pci_is_pcie() will erroneously fail under some conditions, but
>> explicit
>> search for the capability struct via pci_find_capability() is always
>> successful. =A0 I expect this to be due a shadowing of pci config sp=
ace in
>> the
>> hal/platform that isn't sufficiently built up. =A0We detected this i=
ssue
>> while
>> testing AER/EEH, and are functional only if the pci_find_capability(=
)
>> option
>> is used.
>>
>> -- james s
>>
>>
>>
>> On 6/27/2011 1:39 PM, Jon Mason wrote:
>>>
>>> The PCIE capability offset is saved during PCI bus walking. =A0It w=
ill
>>> remove an unnecessary search in the PCI configuration space if this
>>> value is referenced instead of reacquiring it. =A0Also, pci_is_pcie=
 is a
>>> better way of determining if the device is PCIE or not (as it uses =
the
>>> same saved PCIE capability offset).
>>>
>>> Signed-off-by: Jon Mason<jdmason@kudzu.us>
>>> ---
>>> =A0 drivers/scsi/lpfc/lpfc_init.c | =A0 =A02 +-
>>> =A0 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/scsi/lpfc/lpfc_init.c
>>> b/drivers/scsi/lpfc/lpfc_init.c
>>> index 148b98d..9000ad0 100644
>>> --- a/drivers/scsi/lpfc/lpfc_init.c
>>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>>> @@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>>> =A0 =A0 =A0 =A0pci_save_state(pdev);
>>>
>>> =A0 =A0 =A0 =A0/* PCIe EEH recovery on powerpc platforms needs fund=
amental reset
>>> */
>>> - =A0 =A0 =A0 if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
>>> + =A0 =A0 =A0 if (pci_is_pcie(pdev))
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdev->needs_freset =3D 1;
>>>
>>> =A0 =A0 =A0 =A0return 0;
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
