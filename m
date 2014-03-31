From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH 1/4] target/core: T10-Dif: check HW support capabilities
Date: Mon, 31 Mar 2014 17:53:02 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46CE9B32@avmb2.qlogic.org>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
 <1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>
 <53360E54.5060004@mellanox.com>
 <504EB66DAC8D234EB8E8560985C2D7AD46CE87D7@avmb2.qlogic.org>
 <533620C0.9060903@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9B32avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:33062 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbaCaRxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 13:53:05 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s2VHiHQP003046
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2014 10:53:05 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1jwyhbm65n-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2014 10:53:04 -0700
In-Reply-To: <533620C0.9060903@mellanox.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9B32avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB741EC7D5E2BB42B2C92A0FD48C2742@qlogic.com>
Content-Transfer-Encoding: quoted-printable


Regards,
Quinn Tran




On 3/28/14 6:24 PM, "sagi grimberg" <sagig@mellanox.com> wrote:

>On 3/29/2014 3:53 AM, Quinn Tran wrote:
>> +
>> +    if (dev->dev_attrib.pi_prot_type) {
>> +            uint32_t cap[] =3D { 0,
>> +                               TARGET_DIF_TYPE1_PROTECTION,
>> +                               TARGET_DIF_TYPE2_PROTECTION,
>> +                               TARGET_DIF_TYPE3_PROTECTION};
>> +            uint32_t pt_bits =3D cap[dev->dev_attrib.pi_prot_type];
>> +            pt_bits &=3D se_tpg->fabric_sup_prot_type;
>>> At what point should the fabric fill that? it can vary between portals
>>> right?
>> QT> Yes, protection mode can vary between portals. When user select the
>> physical function (via fabric_make_tpg), you know the specific portal
>> based on user input and its capability. This is where Qlogic register
>>its
>> capabilities based on specific hardware.
>>
>>
>>> I would prefer to do that as a function pointer to explicitly ask the
>>> fabric it's support.
>> QT> is it still require with previous answer ?
>>
>
>Well, I think it is nicer to explicitly ask the fabric at that point
>instead of checking what it previously set.
>
>By the way, I think this patch breaks existing iSER support as iSER
>doesn't set these bits.
>Thats why I think it would be a good idea to *explicitly* ask.

QT> I see.  No issue with converting to a callback.

>
>>
>>>> +                    pr_err("dev[%p]: DIF protection mismatch with
>>>>fabric "
>>>> +                            "(%s). Transport capability
>>>>bits[0x%x]\n",
>>>> +                            dev,
>>>>se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
>>>> +                            se_tpg->fabric_sup_prot_type);
>>>> +                    return -EFAULT;
>>> Didn't we agree that this is allowed and the target core should
>>> compensate on the lack fabric support?
>> <QT> My recollection was that it's not recommended to have different
>> portals with different supported feature.
>
>Well we seem to remember different things...
>Anyway I think it is better to compensate that in backstore/target-core
>level, that would be better
>than silently turn off protection. Martin? Nic? your takes?

QT> the error return above fail the binding (ln -sf <backend disk> <fabric
LUN>) between the back disk and the frontend/fabric LUN representation.
The failure happens during configuration time.  The commented out code
imply a silent turn off. Sorry should have clean it out.


>
>Also I don't know what rats are hiding here if the backstore is handling
>IOs in this time...
>What about cleaning up all the protection resources the backstore driver
>might be managing?

QT> hmm.  It's a big hammer.  I'll let the other folks chime in on this
because it affect user's interaction.  Nicholas ? Martin?

>
>>   Meaning a SCSI Write without Dif
>> down a none-T10PI portal update the data.  The Guard on the disk is now
>> mismatch with the data. A SCSI Read down a T10PI path will run into a
>> Guard failure.
>>
>> By introducing this option, Disk vendor require additional logic to
>> compensate for this. I think it's cheaper to have supported hardware
>> rather than support nightmare.
>>
>>>> +            }
>>>> +    }
>>>> +
>>>>       if (lun->lun_se_dev !=3D  NULL) {
>>>>               pr_err("Port Symlink already exists\n");
>>>>               return -EEXIST;
>>>> diff --git a/drivers/target/target_core_tpg.c
>>>> b/drivers/target/target_core_tpg.c
>>>> index c036595..9279971 100644
>>>> --- a/drivers/target/target_core_tpg.c
>>>> +++ b/drivers/target/target_core_tpg.c
>>>> @@ -632,6 +632,15 @@ int core_tpg_set_initiator_node_tag(
>>>>    }
>>>>    EXPORT_SYMBOL(core_tpg_set_initiator_node_tag);
>>>>
>>>> +void core_tpg_set_fabric_t10dif(
>>>> +    struct se_portal_group *tpg,
>>>> +    uint32_t fabric_t10dif_force_on)
>>>> +{
>>>> +    tpg->fabric_t10dif_force_on =3D fabric_t10dif_force_on;
>>>> +}
>>>> +EXPORT_SYMBOL(core_tpg_set_fabric_t10dif);
>>>> +
>>> Is there a user for this function in this patch?
>> QT> I'm on the fence with this piece.  Just thinking of a case where DIX
>> is not available for initiator side, but user wants to turn on
>>protection
>> at the link layer.  Our test folks would like to cover this case in the
>> future.
>
>Not sure I understand. Initiator will send the target data+protection
>(DIX disabled HBA does INSERT), why does this help?
>Why should the target fabric care who generated the protection (OS or
>HBA)?

QT> Sorry for the confusion.  The case I'm trying to get at is "Data In
Insert" and "Data out strip".    In this case, the protection starts from
front end target adapter to the back end storage.  In revisit your
previous patch, this case is not covered.


>
>Sagi.


________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9B32avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
bwBtAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAABkAAAAAAAAAIErH6S+oxAZnW4A
3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEAbgAAAFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIA
YQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAl0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBh
AG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwDlXwEAAAA0AAAAcwBpAHAAOgBxAHUAaQBuAG4A
LgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AGgwBAAAAFgAAAFEAdQBpAG4AbgAg
AFQAcgBhAG4AAAAAAB8AHwwBAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABkAAAAAAAAAIErH6S+
oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEAbgAAAFMATQBUAFAAAABxAHUAaQBuAG4A
LgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAV0BAAAALAAAAHEAdQBpAG4AbgAu
AHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwD4PwEAAAAWAAAAUQB1AGkAbgBuACAA
VAByAGEAbgAAAAAAHwAjQAEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBj
AC4AYwBvAG0AAAAfACJAAQAAAAoAAABTAE0AVABQAAAAAAACAfk/AQAAAGQAAAAAAAAAgSsfpL6j
EBmdbgDdAQ9UAgAAAIBRAHUAaQBuAG4AIABUAHIAYQBuAAAAUwBNAFQAUAAAAHEAdQBpAG4AbgAu
AHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAJXQEAAAAsAAAAcQB1AGkAbgBuAC4A
dAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAf
ADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsA
QDoBAAAAAwD9P+QEAAACAQswAQAAABAAAACiRA1eSJ7iTIJfA2FkLnOPAwAXAAEAAABAADkAABNg
DwpNzwFAAAgw+NigDwpNzwELAACACCAGAAAAAADAAAAAAAAARgAAAAAUhQAAAQAAAB8AAICGAwIA
AAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAM
AAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAAAIgA
AABSAGUAOgAgAFsAUABBAFQAQwBIACAAMQAvADQAXQAgAHQAYQByAGcAZQB0AC8AYwBvAHIAZQA6
ACAAVAAxADAALQBEAGkAZgA6ACAAYwBoAGUAYwBrACAASABXACAAcwB1AHAAcABvAHIAdAAgAGMA
YQBwAGEAYgBpAGwAaQB0AGkAZQBzAAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2AAAAAAAf
AEIQAQAAAEAAAAA8ADUAMwAzADYAMgAwAEMAMAAuADkAMAA2ADAAOQAwADMAQABtAGUAbABsAGEA
bgBvAHgALgBjAG8AbQA+AAAAAgFxAAEAAAAqAAAAAQHPSt9dHQvjHRGHk0+4TBftHQcF45r3pNcA
//+X94CAAH3/AIADw5AAAAAfAHAAAQAAAIAAAABbAFAAQQBUAEMASAAgADEALwA0AF0AIAB0AGEA
cgBnAGUAdAAvAGMAbwByAGUAOgAgAFQAMQAwAC0ARABpAGYAOgAgAGMAaABlAGMAawAgAEgAVwAg
AHMAdQBwAHAAbwByAHQAIABjAGEAcABhAGIAaQBsAGkAdABpAGUAcwAAAB8ANRABAAAAeAAAADwA
NQAwADQARQBCADYANgBEAEEAQwA4AEQAMgAzADQARQBCADgARQA4ADUANgAwADkAOAA1AEMAMgBE
ADcAQQBEADQANgBDAEUAOQBCADMAMgBAAGEAdgBtAGIAMgAuAHEAbABvAGcAaQBjAC4AbwByAGcA
PgAAAB8AORABAAAA4AEAADwAMQAzADkANgAwADQANwA5ADIANwAtADEANAAxADgAOQAtADEALQBn
AGkAdAAtAHMAZQBuAGQALQBlAG0AYQBpAGwALQBxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8A
ZwBpAGMALgBjAG8AbQA+ACAAPAAxADMAOQA2ADAANAA3ADkAMgA3AC0AMQA0ADEAOAA5AC0AMgAt
AGcAaQB0AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwA
bwBnAGkAYwAuAGMAbwBtAD4AIAA8ADUAMwAzADYAMABFADUANAAuADUAMAA2ADAAMAAwADQAQABt
AGUAbABsAGEAbgBvAHgALgBjAG8AbQA+ACAAPAA1ADAANABFAEIANgA2AEQAQQBDADgARAAyADMA
NABFAEIAOABFADgANQA2ADAAOQA4ADUAQwAyAEQANwBBAEQANAA2AEMARQA4ADcARAA3AEAAYQB2
AG0AYgAyAC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+ACAAPAA1ADMAMwA2ADIAMABDADAALgA5ADAA
NgAwADkAMAAzAEAAbQBlAGwAbABhAG4AbwB4AC4AYwBvAG0APgAAAAMA3j+fTgAAQAAHMHhTlw8K
Tc8BAwAmAAAAAAACAUcAAQAAAC8AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE0MDMzMTE3
NTMwMlotMTc1MjgwAAAfABUQAQAAAFgAAABEAEIANwA0ADEARQBDADcARAA1AEUAMgBCAEIANAAy
AEIAMgBDADkAMgBBADAARgBEADQAOABDADIANwA0ADIAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
AgEUMAEAAAAMAAAAMAIAAKDCyoJSAAAAHwD6PwEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAA
AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBuAHQAAAAAAAEA
AABGAAAATQBpAGMAcgBvAHMAbwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8AMQA0AC4AMwAu
ADkALgAxADMAMQAwADMAMAAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYA
ZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAABABAABJ
AEkAPQAwADEAMAAxAEMARgA0AEQAMABBADAARgAwAEEANQBCADQAQwAxADMANwAzADEAOAA2AEMA
NAA2AEEAOAAzADEAQwAwAEEAOQAwADYANAA0AEQAOQBDADUAOwBTAEIATQBJAEQAPQA2ADsAUwAx
AD0APAA1ADMAMwA2ADIAMABDADAALgA5ADAANgAwADkAMAAzAEAAbQBlAGwAbABhAG4AbwB4AC4A
YwBvAG0APgA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMgAgACgAQgB1
AGkAbABkACAAMwA4ADcALgAwACkALAAgAFMAdABhAGcAZQA9AEgAMgAAAAMADTT9PwAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAA
AAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQA
aQBuAGcALQBpAHAAAAAAAAEAAAAaAAAAWwAxADAALgA4AC4ANgAuADEANQAzAF0AAAAAALo1

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9B32avmb2qlogicorg_--
