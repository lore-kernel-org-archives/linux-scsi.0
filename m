From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH 00/11] qla2xxx: Updates for Target Mode driver
Date: Thu, 9 Jul 2015 18:15:01 +0000
Message-ID: <D1C40805.99589%himanshu.madhani@qlogic.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
 <1436231769.6297.7.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D1C4080599589himanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:10535 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbbGISPt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2015 14:15:49 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t69IBFsU016352
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jul 2015 11:15:48 -0700
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1vhv1005nn-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2015 11:15:23 -0700
In-Reply-To: <1436231769.6297.7.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@lst.de" <hch@lst.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

--_000_D1C4080599589himanshumadhaniqlogiccom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <668E3D22684A874D9E8A3B1E7D436ECB@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Nic,=20


On 7/6/15, 6:16 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Himanshu & Co,
>
>(Adding target-devel for the qla_target.c bits, please include this
> list for future target patches :-)

Will do that for future submissions.

>
>On Thu, 2015-06-25 at 12:33 -0400, Himanshu Madhani wrote:
>> Hi James,=20
>>=20
>> This series is applied on top of patch series sent on June 10
>>   [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch
>> (http://marc.info/?l=3Dlinux-scsi&m=3D143395156920505&w=3D2)
>>=20
>> These set of patches addresses issue with reuse of stale command found
>> in a customer enviorment. Here's sequence of events which could result
>> into this reuse of stale command which could potentially lead to data
>> corruption.
>>=20
>>  - Backend driver goes out of sync with front end driver due to session
>>    management problem.
>>  - During this time a session receives a NEW login by the same
>>initiator.
>>  - All the commands from previous session are not flushed before
>>establishing
>>    a new session/connection.
>>  - These stale commands leaks into new session resulting into case
>>    where they could potentially share same Exchange ID.
>>=20
>> In such case data can cross path between old and new session when the
>>frontend
>> driver/fabric driver allows a new connection to be established without
>>backend
>> knowledge. To fix this problem, old session is destroyed first before
>>creating
>> new session. The session destroy process would wait for all existing
>>commands
>> to finish.=20
>>=20
>> Please apply these patches to scsi tree at your earliest for inclusion
>>in the
>> next mainline merge window.
>>=20
>> Thanks,
>> Himanshu
>>=20
>> Alexei Potashnik (8):
>>   qla2xxx: delay plogi/prli ack until existing sessions are deleted
>>   qla2xxx: Abort stale cmds on qla_tgt_wq when plogi arrives
>>   qla2xxx: added sess generations to detect RSCN update races
>>   qla2xxx: disable scsi_transport_fc registration in target mode
>>   qla2xxx: drop cmds/tmrs arrived while session is being deleted
>>   qla2xxx: terminate exchange when command is aborted by LIO
>>   qla2xxx: delete session if initiator is gone from FW
>>   qla2xxx: wait for all conflicts before ack'ing PLOGI
>>=20
>> Himanshu Madhani (1):
>>   qla2xxx: Added interface to send ELS commands from driver.
>>=20
>> Roland Dreier (1):
>>   qla2xxx: kill sessions/log out initiator on RSCN and port down events
>>=20
>> Swapnil Nagle (1):
>>   qla2xxx: cleanup cmd in qla workqueue before processing TMR
>>=20
>>  drivers/scsi/qla2xxx/qla_attr.c    |   36 ++
>>  drivers/scsi/qla2xxx/qla_dbg.c     |   13 +-
>>  drivers/scsi/qla2xxx/qla_def.h     |   35 ++-
>>  drivers/scsi/qla2xxx/qla_gbl.h     |    2 +
>>  drivers/scsi/qla2xxx/qla_init.c    |  188 ++++++--
>>  drivers/scsi/qla2xxx/qla_inline.h  |    2 +
>>  drivers/scsi/qla2xxx/qla_iocb.c    |  192 ++++++++
>>  drivers/scsi/qla2xxx/qla_isr.c     |    6 +
>>  drivers/scsi/qla2xxx/qla_os.c      |   13 +-
>>  drivers/scsi/qla2xxx/qla_target.c  |  930
>>+++++++++++++++++++++++++++++++++---
>>  drivers/scsi/qla2xxx/qla_target.h  |   88 +++-
>>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   23 +-
>>  12 files changed, 1387 insertions(+), 141 deletions(-)
>>=20
>
>Since this series addresses a real correctness problem and is destined
>for stable backports, I don't see a reason to wait until the v4.3-rc1
>merge window to merge this code, even though it's a pretty large change.
>
>James, are you going to push this for v4.2-rc scsi-core fixes, or shall
>I push via target-pending/master instead..?
>
>Thank you,
>
>--nab=20
>

Thanks,
-Himanshu


>


--_000_D1C4080599589himanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
HwBlAAEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBj
AC4AYwBvAG0AAAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAHwAAAAAAAAAgSsfpL6j
EBmdbgDdAQ9UAgAAAIBIAGkAbQBhAG4AcwBoAHUAIABNAGEAZABoAGEAbgBpAAAAUwBNAFQAUAAA
AGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
HwACXQEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBj
AC4AYwBvAG0AAAAfAOVfAQAAAEAAAABzAGkAcAA6AGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgA
YQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAaDAEAAAAiAAAASABpAG0AYQBuAHMAaAB1
ACAATQBhAGQAaABhAG4AaQAAAAAAHwAfDAEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQA
aABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAAC
ARkMAQAAAHwAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBIAGkAbQBhAG4AcwBoAHUAIABNAGEA
ZABoAGEAbgBpAAAAUwBNAFQAUAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABx
AGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQA
aABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAPg/AQAAACIAAABIAGkAbQBhAG4AcwBo
AHUAIABNAGEAZABoAGEAbgBpAAAAAAAfACNAAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEA
ZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAA
AAIB+T8BAAAAfAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEgAaQBtAGEAbgBzAGgAdQAgAE0A
YQBkAGgAYQBuAGkAAABTAE0AVABQAAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBA
AHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEA
ZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAsAQDoBAAAAHwAaAAEAAAASAAAASQBQ
AE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAACHuQ9w
sHwrQIgv5Een+Ex6AwAXAAEAAABAADkAgEClK3O60AFAAAgwuyIFLHO60AELAACACCAGAAAAAADA
AAAAAAAARgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAA
dABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAABoUAAAAAAAAfADcAAQAAAHQAAABSAGUAOgAgAFsAUABBAFQAQwBIACAAMAAwAC8A
MQAxAF0AIABxAGwAYQAyAHgAeAB4ADoAIABVAHAAZABhAHQAZQBzACAAZgBvAHIAIABUAGEAcgBn
AGUAdAAgAE0AbwBkAGUAIABkAHIAaQB2AGUAcgAAAB8APQABAAAACgAAAFIAZQA6ACAAAAAAAAMA
NgAAAAAAHwBCEAEAAABwAAAAPAAxADQAMwA2ADIAMwAxADcANgA5AC4ANgAyADkANwAuADcALgBj
AGEAbQBlAGwAQABoAGEAYQBrAG8AbgAzAC4AcgBpAHMAaQBuAGcAdABpAGQAZQBzAHkAcwB0AGUA
bQBzAC4AYwBvAG0APgAAAAIBcQABAAAAIAAAAAEB0K9q4i+ebt6pNm9JhISygRoyyzWdz7uFgIAD
y/EAHwBwAAEAAABsAAAAWwBQAEEAVABDAEgAIAAwADAALwAxADEAXQAgAHEAbABhADIAeAB4AHgA
OgAgAFUAcABkAGEAdABlAHMAIABmAG8AcgAgAFQAYQByAGcAZQB0ACAATQBvAGQAZQAgAGQAcgBp
AHYAZQByAAAAHwA1EAEAAABaAAAAPABEADEAQwA0ADAAOAAwADUALgA5ADkANQA4ADkAJQBoAGkA
bQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQA+AAAAAAAf
ADkQAQAAAPAAAAA8ADEANAAzADUAMgA1ADAAMAAzADEALQAyADAANQAyADUALQAxAC0AZwBpAHQA
LQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBA
AHEAbABvAGcAaQBjAC4AYwBvAG0APgAgADwAMQA0ADMANgAyADMAMQA3ADYAOQAuADYAMgA5ADcA
LgA3AC4AYwBhAG0AZQBsAEAAaABhAGEAawBvAG4AMwAuAHIAaQBzAGkAbgBnAHQAaQBkAGUAcwB5
AHMAdABlAG0AcwAuAGMAbwBtAD4AAAADAN4/n04AAEAABzCe/v0rc7rQAQMAJgAAAAAAAgFHAAEA
AAAuAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMy0xNTA3MDkxODE1MDFaLTM2ODY3AAAAHwAV
EAEAAABYAAAANgA2ADgARQAzAEQAMgAyADYAOAA0AEEAOAA3ADQARAA5AEUAOABBADMAQgAxAEUA
NwBEADQAMwA2AEUAQwBCAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAIBFDABAAAADAAAAKUBAACr
O+0uSAAAAB8A+j8BAAAAIgAAAEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAAAAAB8A
AICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAAAAABAAAARgAA
AE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAuADMALgA5AC4A
MQAzADEAMAAzADAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBz
AGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAABAAQAASQBJAD0A
MAAxADAAMQBEADAAQgBBADcAMwAyAEMAMAAwAEYAMwA5AEQAQwBCADMANAA1ADYAQwBBADQAQQBB
ADIAOQAyADYAQQAyADcAMwBBAEUARABGAEQAMQA2ADsAUwBCAE0ASQBEAD0AMgA7AFMAMQA9ADwA
MQA0ADMANgAyADMAMQA3ADYAOQAuADYAMgA5ADcALgA3AC4AYwBhAG0AZQBsAEAAaABhAGEAawBv
AG4AMwAuAHIAaQBzAGkAbgBnAHQAaQBkAGUAcwB5AHMAdABlAG0AcwAuAGMAbwBtAD4AOwBWAGUA
cgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADMAIAAoAEIAdQBpAGwAZAAgADIAMwA1
AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABG
AQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICG
AwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAA
AAABAAAAGAAAAFsAMQAwAC4AMQAuADQALgAxADAAXQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAA
ABYAAABkAGkAcwBjAGwAYQBpAG0AZQByAAAAAAABAAAADgAAAGIAeQBwAGEAcwBzAAAAAACjig==

--_000_D1C4080599589himanshumadhaniqlogiccom_--
