From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH 2/4] tcm_qla2xxx: T10-Dif set harware capability
Date: Mon, 31 Mar 2014 15:38:17 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46CE91BC@avmb2.qlogic.org>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
 <1396047927-14189-3-git-send-email-quinn.tran@qlogic.com>
 <5336100B.1010604@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46CE91BCavmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:30433 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbaCaPiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 11:38:19 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s2VFY3ta011601
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2014 08:38:18 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1jvq785p3e-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2014 08:38:18 -0700
In-Reply-To: <5336100B.1010604@mellanox.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE91BCavmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3CF1216CF1953D4FADADDC1244AF6B92@qlogic.com>
Content-Transfer-Encoding: quoted-printable


Regards,
Quinn Tran




On 3/28/14 5:12 PM, "sagi grimberg" <sagig@mellanox.com> wrote:

>On 3/29/2014 2:05 AM, Quinn Tran wrote:
>> Set Protection Type(1,2,3) capabilities, Guarg type (CRC/IPchksm)
>> capabilities bits to let TCM core knows of HW/fabric capabilities.
>>
>> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> ---
>>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 23 +++++++++++++++++++++++
>>   drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 +
>>   2 files changed, 24 insertions(+)
>>
>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>>b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> index b23a0ff..4d93081 100644
>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> @@ -910,12 +910,20 @@ DEF_QLA_TPG_ATTR_BOOL(demo_mode_login_only);
>>   DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
>>   QLA_TPG_ATTR(demo_mode_login_only, S_IRUGO | S_IWUSR);
>>
>> +/*
>> + * Define tcm_qla2xxx_tpg_attrib_s_t10dif_force_on
>> + */
>> +DEF_QLA_TPG_ATTR_BOOL(t10dif_force_on);
>> +DEF_QLA_TPG_ATTRIB(t10dif_force_on);
>> +QLA_TPG_ATTR(t10dif_force_on, S_IRUGO | S_IWUSR);
>> +
>>   static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] =3D {
>>      &tcm_qla2xxx_tpg_attrib_generate_node_acls.attr,
>>      &tcm_qla2xxx_tpg_attrib_cache_dynamic_acls.attr,
>>      &tcm_qla2xxx_tpg_attrib_demo_mode_write_protect.attr,
>>      &tcm_qla2xxx_tpg_attrib_prod_mode_write_protect.attr,
>>      &tcm_qla2xxx_tpg_attrib_demo_mode_login_only.attr,
>> +    &tcm_qla2xxx_tpg_attrib_t10dif_force_on.attr,
>>      NULL,
>>   };
>>
>> @@ -1049,6 +1057,18 @@ static struct se_portal_group
>>*tcm_qla2xxx_make_tpg(
>>      tpg->tpg_attrib.demo_mode_write_protect =3D 1;
>>      tpg->tpg_attrib.cache_dynamic_acls =3D 1;
>>      tpg->tpg_attrib.demo_mode_login_only =3D 1;
>> +    tpg->tpg_attrib.t10dif_force_on =3D 0;
>> +    tpg->se_tpg.fabric_sup_prot_type =3D 0;
>> +    tpg->se_tpg.fabric_sup_guard_type =3D 0;
>
>You can lose guard_type - this is more relevant to the initiator side.

QT> OK

>
>> +
>> +    if (scsi_host_get_prot(lport->qla_vha->host)) {
>> +            tpg->se_tpg.fabric_sup_prot_type =3D (TARGET_DIF_TYPE0_PROT=
|
>> +                    TARGET_DIF_TYPE1_PROT|TARGET_DIF_TYPE2_PROT|
>> +                    TARGET_DIF_TYPE3_PROT);
>> +
>> +            tpg->se_tpg.fabric_sup_guard_type =3D TARGET_GUARD_CRC|
>> +                    TARGET_GUARD_IP;
>> +    }
>>
>>      ret =3D core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn=
,
>>                              &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMA=
L);
>> @@ -1127,6 +1147,8 @@ static ssize_t tcm_qla2xxx_npiv_tpg_store_enable(
>>              qlt_stop_phase1(vha->vha_tgt.qla_tgt);
>>      }
>>
>> +    core_tpg_set_fabric_t10dif(se_tpg, tpg->tpg_attrib.t10dif_force_on)=
;
>> +
>
>Any way we can get this logic to be shared also with iscsi, srp, etc...
>all fabrics should
>be set with t10dif right? so I would imagine it would be better to
>centralize it right?

QT> Not sure how you want this logic to be shared.  This patch is specific
to Qlogic driver registering its capabilities.


>
>>      return count;
>>   }
>>
>> @@ -1169,6 +1191,7 @@ static struct se_portal_group
>>*tcm_qla2xxx_npiv_make_tpg(
>>      tpg->tpg_attrib.demo_mode_write_protect =3D 1;
>>      tpg->tpg_attrib.cache_dynamic_acls =3D 1;
>>      tpg->tpg_attrib.demo_mode_login_only =3D 1;
>> +    tpg->tpg_attrib.t10dif_force_on =3D 0;
>>
>>      ret =3D core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops=
,
>>wwn,
>>                              &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMA=
L);
>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>>b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>> index 33aaac8..62fdce3 100644
>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>> @@ -28,6 +28,7 @@ struct tcm_qla2xxx_tpg_attrib {
>>      int demo_mode_write_protect;
>>      int prod_mode_write_protect;
>>      int demo_mode_login_only;
>> +    int t10dif_force_on;
>>   };
>>
>>   struct tcm_qla2xxx_tpg {


________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE91BCavmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AAAfAGUAAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAA
AB8AZAABAAAACgAAAFMATQBUAFAAAAAAAAIBQQABAAAAZAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QC
AAAAgFEAdQBpAG4AbgAgAFQAcgBhAG4AAABTAE0AVABQAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBA
AHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAJdAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A5V8BAAAANAAAAHMAaQBwADoAcQB1AGkAbgBuAC4AdABy
AGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfABoMAQAAABYAAABRAHUAaQBuAG4AIABUAHIA
YQBuAAAAAAAfAB8MAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAZAAAAAAAAACBKx+kvqMQGZ1u
AN0BD1QCAAAAgFEAdQBpAG4AbgAgAFQAcgBhAG4AAABTAE0AVABQAAAAcQB1AGkAbgBuAC4AdABy
AGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFdAQAAACwAAABxAHUAaQBuAG4ALgB0AHIA
YQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A+D8BAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBh
AG4AAAAAAB8AI0ABAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAABkAAAAAAAAAIErH6S+oxAZnW4A
3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEAbgAAAFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIA
YQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8ACV0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBh
AG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoBAAAAHwAwQAEA
AAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAA
AAMA/T/kBAAAAgELMAEAAAAQAAAA8XnEJ3gozUSjNRwoy5+NTgMAFwABAAAAQAA5AID6Vjz3TM8B
QAAIMFh0bTz3TM8BCwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUA
bgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAAB4AAAAUgBl
ADoAIABbAFAAQQBUAEMASAAgADIALwA0AF0AIAB0AGMAbQBfAHEAbABhADIAeAB4AHgAOgAgAFQA
MQAwAC0ARABpAGYAIABzAGUAdAAgAGgAYQByAHcAYQByAGUAIABjAGEAcABhAGIAaQBsAGkAdAB5
AAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2AAAAAAAfAEIQAQAAAEAAAAA8ADUAMwAzADYA
MQAwADAAQgAuADEAMAAxADAANgAwADQAQABtAGUAbABsAGEAbgBvAHgALgBjAG8AbQA+AAAAAgFx
AAEAAAAgAAAAAQHPSt9e9ta5B2T2/0evxxeD0FTJx5r3puKAgAOx1YAfAHAAAQAAAHAAAABbAFAA
QQBUAEMASAAgADIALwA0AF0AIAB0AGMAbQBfAHEAbABhADIAeAB4AHgAOgAgAFQAMQAwAC0ARABp
AGYAIABzAGUAdAAgAGgAYQByAHcAYQByAGUAIABjAGEAcABhAGIAaQBsAGkAdAB5AAAAHwA1EAEA
AAB4AAAAPAA1ADAANABFAEIANgA2AEQAQQBDADgARAAyADMANABFAEIAOABFADgANQA2ADAAOQA4
ADUAQwAyAEQANwBBAEQANAA2AEMARQA5ADEAQgBDAEAAYQB2AG0AYgAyAC4AcQBsAG8AZwBpAGMA
LgBvAHIAZwA+AAAAHwA5EAEAAAAoAQAAPAAxADMAOQA2ADAANAA3ADkAMgA3AC0AMQA0ADEAOAA5
AC0AMQAtAGcAaQB0AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAHEAdQBpAG4AbgAuAHQAcgBhAG4A
QABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AIAA8ADEAMwA5ADYAMAA0ADcAOQAyADcALQAxADQAMQA4
ADkALQAzAC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AcQB1AGkAbgBuAC4AdAByAGEA
bgBAAHEAbABvAGcAaQBjAC4AYwBvAG0APgAgADwANQAzADMANgAxADAAMABCAC4AMQAwADEAMAA2
ADAANABAAG0AZQBsAGwAYQBuAG8AeAAuAGMAbwBtAD4AAAADAN4/n04AAEAABzDY7mM890zPAQMA
JgAAAAAAAgFHAAEAAAAvAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMi0xNDAzMzExNTM4MTda
LTE3NTAzMQAAHwAVEAEAAABYAAAAMwBDAEYAMQAyADEANgBDAEYAMQA5ADUAMwBEADQARgBBAEQA
QQBEAEQAQwAxADIANAA0AEEARgA2AEIAOQAyAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAIBFDAB
AAAADAAAAPYAAAD1SIRXUgAAAB8A+j8BAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8A
AICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAAAAABAAAARgAA
AE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAuADMALgA5AC4A
MQAzADEAMAAzADAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBz
AGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAAQAQAASQBJAD0A
MAAxADAAMQBDAEYANABDAEYANwAzAEMARgBEADMAMAAwAEQARgA3AEIAOAAzADUARgA1ADQANwBC
AEUAMwA5ADgAQgA1ADAANQA1AEEAQgAxADEAOAAwADsAUwBCAE0ASQBEAD0ANQA7AFMAMQA9ADwA
NQAzADMANgAxADAAMABCAC4AMQAwADEAMAA2ADAANABAAG0AZQBsAGwAYQBuAG8AeAAuAGMAbwBt
AD4AOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADIAIAAoAEIAdQBpAGwA
ZAAgADMAOAA3AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAADAA00/T8AAB8AAICGAwIAAAAA
AMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAA
AAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBn
AC0AaQBwAAAAAAABAAAAHAAAAFsAMQA3ADIALgAzADAALgA0AC4AOQAwAF0AAAAChA==

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE91BCavmb2qlogicorg_--
