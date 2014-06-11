From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length
 in case pi exists on the wire
Date: Wed, 11 Jun 2014 22:32:19 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46D1D8C7@avmb2.qlogic.org>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
 <1402223228-23768-4-git-send-email-sagig@mellanox.com>
 <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
 <504EB66DAC8D234EB8E8560985C2D7AD46D1D00E@avmb2.qlogic.org>
 <53980434.1000306@dev.mellanox.co.il>
 <1402522215.17740.29.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D8C7avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:6630 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbaFKWcW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 18:32:22 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s5BMVR1B010818
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2014 15:32:22 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1mefa31487-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2014 15:32:21 -0700
In-Reply-To: <1402522215.17740.29.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "roland@kernel.org" <roland@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D8C7avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E512AFB7755CE4FA40F6102A06B7182@qlogic.com>
Content-Transfer-Encoding: quoted-printable



On 6/11/14 2:30 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>On Wed, 2014-06-11 at 10:24 +0300, Sagi Grimberg wrote:
>> On 6/11/2014 12:17 AM, Quinn Tran wrote:
>>
>> <SNIP>
>>
>> > QT> Instead of using existing value within cmd->data_length, can we
>> > calculated data_length based on secstors & blocksize.
>> >
>> > cmd->data_length =3D sectors * dev->dev_attrib.block_size;
>>
>> We can do that I suppose...
>> Although it seems weird that the core discards the transport
>>byte-count...
>> Just wandering if we should recalc on the DIF case only or always.
>>
>
>Yeah, same concern here wrt to discarding the transport length.
>
>This effectively makes the residual handling further down in
>sbc_parse_cdb() -> target_cmd_size_check() always match size =3D=3D
>cmd->data_length, because the latter as been recalculated by the former.
>
>Honestly, I don't know if this is a problem for normal READ + WRITE with
>prot=3D1 as I've never seen size !=3D cmd->data_length for I/O related
>commands, but it does seem potentially dangerous.
>
>> >
>> >  From the QLogic perfective, the cmd->data_length is pull directly
>>from the
>> > wire (i.e. FCP header) when cmd is received.  In essence, it's
>>whatever
>> > the Initiator is set it to.  We does not have any indicator to spot
>>DIF vs
>> > none-DIF cmd when 1st received, unless the code do a peek.
>>
>> Same for all transports I assume...
>>
>
>So just to confirm Quinn, the Qlogic the initiator includes the PI bytes
>into the FCP header data_length for the target-side *_PASS and
>DOUT_STRIP / DIN_INSERT, that is currently passed into
>qla_tgt_ops->handle_cmd(), right..?

QT>
Initiator:
DOUT_STRIP/DIN_Insert:  FCP_DL =3D data length only (no dif length)
Dif PASS: FCP_DL =3D data length + Dif length.

Target:
DOUT_strip/DIN_Insert:  qla_tgt_ops->handle_cmd(data length only)

sbc_check_prot()
If (protect)
   cmd->data_length -=3D cmd->prot_length;  << truncation


---
DIF_PASS: qla_tgt_ops->handle_cmd(data length + Dif length)


>
>If that is the case, Sagi's v1 to cmd->data_length -=3D cmd->prot_length
>seems like it would still do right thing for *_PASS and DOUT_STRIP /
>DIN_INSERT, given that cmd->prot_length is calculated in
>sbc_check_prot() based upon dev->prot_length * sectors..
>
>> >
>> > With that said, the cmd->data_length does not guarantee to contain
>>both
>> > "data length" & "protection length" when cmd is submit to
>> > TCM/target_submit_cmd().  In Dif-Insert mode, data_length will only
>> > contain the actual data(no Dif).
>>
>> No, in the DOUT_INSERT/DIN_STRIP case, protect bits are off and the
>>core
>> will take the data length as is.
>> This case is covered.
>>
>
><nod>

QT> agree.

>
>> > It's best that the SBC code re-calculate the actual data length and
>>dif
>> > data length based on the number of sectors derived from the cmd.
>>
>> Nic, what's your take on this?
>>
>
>Hard to say.  Discarding the transport length in v2 doesn't seem like a
>good idea, but subtracting from cmd->prot_length in v1 is using the
>sector count from the CDB anyways, so it's essentially the same tradeoff
>of recalculating the transport's cmd->data_length from values within the
>CDB w/ prot=3D1.
>
>MKP, WDYT..?
>
>--nab
>
>
>
>


________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D8C7avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+Iq4nAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADIzMzc5NDI4
QjE4M0VFNDc4MjRGNTdDOTMwOEQ0MzlCAAYHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBgALABYA
IAATAAMAQgEBIIADAA4AAADeBwYACwAWACAAEwADAEIBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAGEAAABSZTogW1BBVENIIHYxIDMvM10gVEFSR0VUL3NiYyxsb29wYmFj
azogQWRqdXN0IGNvbW1hbmQgZGF0YSBsZW5ndGggaW4gY2FzZSBwaSBleGlzdHMgb24gdGhlIHdp
cmUAOyABA5AGABwYAAA1AAAAAgF/AAEAAAA8AAAAPDUwNEVCNjZEQUM4RDIzNEVCOEU4NTYwOTg1
QzJEN0FENDZEMUQ4QzdAYXZtYjIucWxvZ2ljLm9yZz4ACwAfDgEAAAACAQkQAQAAAJ4JAACaCQAA
HBIAAExaRnWI2b1DYQAKZmJpZAQAAGNjwHBnMTI1MgD+A0PwdGV4dAH3AqQD4wIABGNoCsBzZXQw
IO8HbQKDAFARTTIKgAa0AoCWfQqACMg7CWIxOQ7AvwnDFnIKMhZxAoAVYioJsHMJ8ASQYXQFsg5Q
A2Bzom8BgCBFeBHBbhgwXQZSdgSQF7YCEHIAwHR9CFBuGjEQIAXABaAbZGSaIANSIBAiF7JcdgiQ
5HdrC4BkNR1TBPAHQA0XcDAKcRfyYmttawZzAZAAICBCTV9C4EVHSU59CvwB8QvyWmwLgGUKgSGk
TwOgNggvMTEisDQgMjoCMxIwUE0sICJOlQ5QaAbwYQQgQS4fsAxlbCGhGDByIiA8im4BoEAhoXV4
LQQACmMAkC4FsGc+IHerA2AQIDohnD4icVcJgIcjkAHQIvAtMDYtIsBKIBiAIB6QOjIjACsaMCNA
MCOQBhBnaSCuRwUQBtAEkGcmjD4mcM8idihiKTAjIDE3JEAjgexRdQuAA6BUGHADoCr9wStYPFNO
SVAu+CtYaSZwUVQmcEkAgBAgYbMcYBkwIHUAkBnAIBAwdQQAdDJidgdAClAmgGkMdGgLgBvQbWQt
PvJkGIBhXx5wGcAzsCOQmx5QLfFlMJoeUWN1C2BzHEI0WSBiJCAcUQIgIG8SACYAGJEEICY3oAkA
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
I5D/H8IeQn0i6KAx4DUBlwBhAf9PYT2CauBw0YXhXHRiUhm4/x93fWN3VmIkRTPSsILwGiL3M9FO
YMUQct5Bl5BKsn0h/+9gBdUg8nuRalBpkHtRUzL/XrHooCjgnkBGgFNwvQDfpp/GApeQ7PMWyDmG
fX0ToAEusAAAHwBCAAEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwBlAAEAAAAsAAAA
cQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAGQAAQAAAAoAAABT
AE0AVABQAAAAAAACAUEAAQAAAGQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBRAHUAaQBuAG4A
IABUAHIAYQBuAAAAUwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAHwACXQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAfAOVfAQAAADQAAABzAGkAcAA6AHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAHwAaDAEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAfDAEA
AAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAB4MAQAA
AAoAAABTAE0AVABQAAAAAAACARkMAQAAAGQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBRAHUA
aQBuAG4AIABUAHIAYQBuAAAAUwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAHwABXQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcA
aQBjAC4AYwBvAG0AAAAfAPg/AQAAABYAAABRAHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfACNAAQAA
ACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAA
CgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAZAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBp
AG4AbgAgAFQAcgBhAG4AAABTAE0AVABQAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcA
aQBjAC4AYwBvAG0AAAAfAAldAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoA
AQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAACwBAOgEAAAADAP0/5AQAAAIBCzAB
AAAAEAAAACM3lCixg+5Hgk9XyTCNQ5sDABcAAQAAAEAAOQCAWxEBxYXPAUAACDC+kRoBxYXPAQsA
AIAIIAYAAAAAAMAAAAAAAABGAAAAABSFAAABAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAA
AGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAALAACA
CCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAwgAAAFIAZQA6ACAAWwBQAEEAVABD
AEgAIAB2ADEAIAAzAC8AMwBdACAAVABBAFIARwBFAFQALwBzAGIAYwAsAGwAbwBvAHAAYgBhAGMA
awA6ACAAQQBkAGoAdQBzAHQAIABjAG8AbQBtAGEAbgBkACAAZABhAHQAYQAgAGwAZQBuAGcAdABo
ACAAaQBuACAAYwBhAHMAZQAgAHAAaQAgAGUAeABpAHMAdABzACAAbwBuACAAdABoAGUAIAB3AGkA
cgBlAAAAAAAfAD0AAQAAAAoAAABSAGUAOgAgAAAAAAADADYAAAAAAB8AQhABAAAAdAAAADwAMQA0
ADAAMgA1ADIAMgAyADEANQAuADEANwA3ADQAMAAuADIAOQAuAGMAYQBtAGUAbABAAGgAYQBhAGsA
bwBuADMALgByAGkAcwBpAG4AZwB0AGkAZABlAHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+AAAAAgFx
AAEAAAAvAAAAAQHPgwRFWsxSlCHTdkaAVg3rFunje5tqdG4AgABoP4CAAR8IAIAA7EWA//+b/YAA
HwBwAAEAAAC6AAAAWwBQAEEAVABDAEgAIAB2ADEAIAAzAC8AMwBdACAAVABBAFIARwBFAFQALwBz
AGIAYwAsAGwAbwBvAHAAYgBhAGMAawA6ACAAQQBkAGoAdQBzAHQAIABjAG8AbQBtAGEAbgBkACAA
ZABhAHQAYQAgAGwAZQBuAGcAdABoACAAaQBuACAAYwBhAHMAZQAgAHAAaQAgAGUAeABpAHMAdABz
ACAAbwBuACAAdABoAGUAIAB3AGkAcgBlAAAAAAAfADUQAQAAAHgAAAA8ADUAMAA0AEUAQgA2ADYA
RABBAEMAOABEADIAMwA0AEUAQgA4AEUAOAA1ADYAMAA5ADgANQBDADIARAA3AEEARAA0ADYARAAx
AEQAOABDADcAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAfADkQAQAAAIYC
AAA8ADEANAAwADIAMgAyADMAMgAyADgALQAyADMANwA2ADgALQAxAC0AZwBpAHQALQBzAGUAbgBk
AC0AZQBtAGEAaQBsAC0AcwBhAGcAaQBnAEAAbQBlAGwAbABhAG4AbwB4AC4AYwBvAG0APgAgADwA
MQA0ADAAMgAyADIAMwAyADIAOAAtADIAMwA3ADYAOAAtADQALQBnAGkAdAAtAHMAZQBuAGQALQBl
AG0AYQBpAGwALQBzAGEAZwBpAGcAQABtAGUAbABsAGEAbgBvAHgALgBjAG8AbQA+ACAAPAAxADQA
MAAyADMAOAA3ADQANQAwAC4ANQA3ADcANAAuADUANgAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBu
ADMALgByAGkAcwBpAG4AZwB0AGkAZABlAHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+ACAAPAA1ADAA
NABFAEIANgA2AEQAQQBDADgARAAyADMANABFAEIAOABFADgANQA2ADAAOQA4ADUAQwAyAEQANwBB
AEQANAA2AEQAMQBEADAAMABFAEAAYQB2AG0AYgAyAC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+ACAA
PAA1ADMAOQA4ADAANAAzADQALgAxADAAMAAwADMAMAA2AEAAZABlAHYALgBtAGUAbABsAGEAbgBv
AHgALgBjAG8ALgBpAGwAPgAgADwAMQA0ADAAMgA1ADIAMgAyADEANQAuADEANwA3ADQAMAAuADIA
OQAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4AZwB0AGkAZABlAHMAeQBz
AHQAZQBtAHMALgBjAG8AbQA+AAAAAAADAN4/n04AAEAABzCdbRMBxYXPAQMAJgAAAAAAAgFHAAEA
AAAtAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMi0xNDA2MTEyMjMyMTlaLTg3MjAAAAAAHwAV
EAEAAABYAAAAOABFADUAMQAyAEEARgBCADcANwA1ADUAQwBFADQARgBBADQAMABGADYAMQAwADIA
QQAwADYAQgA3ADEAOAAyAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAIBFDABAAAADAAAAJsBAACO
H3RiTwAAAB8A+j8BAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AAICGAwIAAAAAAMAA
AAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAAAAABAAAARgAAAE0AaQBjAHIAbwBz
AG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAuADQALgAyAC4AMQA0ADAANQAwADkA
AAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEAdABpAG8AbgBJ
AG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAABEAQAASQBJAD0AMAAxADAAMQBDAEYA
OAA1AEMANQAwADEAOQAxADIAQgAwADQAMQBDAEMANgBEADAAMgA1ADQANwBCAEIAQgA5AEIAMAAw
AEIARQAzADYAMQBEADYARQBBADsAUwBCAE0ASQBEAD0AMwA7AFMAMQA9ADwAMQA0ADAAMgA1ADIA
MgAyADEANQAuADEANwA3ADQAMAAuADIAOQAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgBy
AGkAcwBpAG4AZwB0AGkAZABlAHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+ADsAVgBlAHIAcwBpAG8A
bgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAyACAAKABCAHUAaQBsAGQAIAAzADgANwAuADAAKQAs
ACAAUwB0AGEAZwBlAD0ASAAyAAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAgAAAA
eAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAAABoA
AABbADEAMAAuADMALgAxADAALgA4ADEAXQAAAAAAYOM=

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D8C7avmb2qlogicorg_--
