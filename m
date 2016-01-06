From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH v2 00/16]  qla2xxx: Patches for target-pending branch
Date: Wed, 6 Jan 2016 17:00:14 +0000
Message-ID: <D2B2862C.D155F%himanshu.madhani@qlogic.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
 <1450681047.25674.32.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D2B2862CD155Fhimanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:1315 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbcAFRAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 12:00:16 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u06Gw0IT016535
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jan 2016 09:00:16 -0800
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 206ek0e10k-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 06 Jan 2016 09:00:16 -0800
In-Reply-To: <1450681047.25674.32.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

--_000_D2B2862CD155Fhimanshumadhaniqlogiccom_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4F8789A2507B72449B1A029289B0A861@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Nic,


On 12/20/15, 10:57 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Himanshu & Co,
>
>On Thu, 2015-12-17 at 14:56 -0500, Himanshu Madhani wrote:
>> Hi Nic,
>>=20
>> Please apply this series to target-pending at your earliest convenience.
>>=20
>> changes from v1 -> v2
>>=20
>> o Added Reviewed-by tag for reviewed patches.
>>=20
>> o Dropped following patches for rework.
>>   - qla2xxx: Change check_stop_free to always return 1
>>   - qla2xxx: Fix interaction issue between qla2xxx and Target Core
>>Module
>>   - qla2xxx: Add TAS detection for kernel 3.15 n newer
>>   - target/tmr: LUN reset cause cmd premature free.
>>=20
>
>Thanks for dropping these for the moment.
>
>I'll be following up on outstanding TMR LUN_RESET reference counting
>bugs over the holiday.
>
>> o Fixed patch description on following patches
>>   - qla2xxx: Enable Extended Login support
>>   - qla2xxx: Enable Exchange offload support.
>>=20
>> o Fixed patch description as well as kbuild warning for
>>   - qla2xxx: Added interface to send explicit LOGO.
>>=20
>> o Fixed kbuild warning for
>>   - qla2xxx: Remove dependency on hardware_lock to reduce lock
>>     contention.
>>=20
>> Thanks,
>> Himanshu
>>=20
>> Alexei Potashnik (2):
>>   qla2xxx: Delete session if initiator is gone from FW
>>   qla2xxx: Wait for all conflicts before ack'ing PLOGI
>>=20
>> Dilip Kumar Uppugandla (1):
>>   qla2xxx: Check for online flag instead of active reset when
>>     transmitting responses
>>=20
>> Himanshu Madhani (4):
>>   qla2xxx: Enable Extended Logins support
>>   qla2xxx: Enable Exchange offload support.
>>   qla2xxx: Enable Target counters in DebugFS.
>>   qla2xxx: Added interface to send explicit LOGO.
>>=20
>> Quinn Tran (9):
>>   qla2xxx: Add FW resource count in DebugFS.
>>   qla2xxx: Replace QLA_TGT_STATE_ABORTED with a bit.
>>   qla2xxx: Remove dependency on hardware_lock to reduce lock
>>     contention.
>>   qla2xxx: Add irq affinity notification
>>   qla2xxx: Add selective command queuing
>>   qla2xxx: Move atioq to a different lock to reduce lock contention
>>   qla2xxx: Disable ZIO at start time.
>>   qla2xxx: Set all queues to 4k
>>   qla2xxx: Add bulk send for atio & ctio completion paths.
>>=20
>>  drivers/scsi/qla2xxx/qla_attr.c        |   36 ++
>>  drivers/scsi/qla2xxx/qla_dbg.c         |   19 +-
>>  drivers/scsi/qla2xxx/qla_def.h         |   86 ++++-
>>  drivers/scsi/qla2xxx/qla_dfs.c         |  106 +++++
>>  drivers/scsi/qla2xxx/qla_gbl.h         |   18 +-
>>  drivers/scsi/qla2xxx/qla_init.c        |   58 ++-
>>  drivers/scsi/qla2xxx/qla_inline.h      |    2 +
>>  drivers/scsi/qla2xxx/qla_iocb.c        |  188 +++++++++
>>  drivers/scsi/qla2xxx/qla_isr.c         |  129 ++++++-
>>  drivers/scsi/qla2xxx/qla_mbx.c         |  265 ++++++++++++-
>>  drivers/scsi/qla2xxx/qla_os.c          |  165 ++++++++-
>>  drivers/scsi/qla2xxx/qla_target.c      |  690
>>+++++++++++++++++++++++++-------
>>  drivers/scsi/qla2xxx/qla_target.h      |   36 ++-
>>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  107 ++++-
>>  drivers/target/target_core_transport.c |    5 +-
>>  include/target/target_core_base.h      |    1 +
>>  16 files changed, 1671 insertions(+), 240 deletions(-)
>>=20
>
>Applied patches #1 -> #14 + #16 to target-pending/for-next code.
>
>Adding commenting inline for patch #15.
>
>Thank you,
>
>--nab

We need to rework patch #11 (=B3qla2xxx: Add selective command queuing=B2) =
to
address review comments from Bart and Christoph.
Can you please drop it from your queue. We=B9ll send updated patch once its
ready.

Thanks,
Himanshu
>


--_000_D2B2862CD155Fhimanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AC4AYwBvAG0AAAAfAAJdAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A5V8BAAAAQAAAAHMAaQBwADoAaABpAG0AYQBuAHMAaAB1
AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfABoMAQAAACIAAABIAGkA
bQBhAG4AcwBoAHUAIABNAGEAZABoAGEAbgBpAAAAAAAfAB8MAQAAADgAAABoAGkAbQBhAG4AcwBo
AHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AHgwBAAAACgAAAFMA
TQBUAFAAAAAAAAIBGQwBAAAAfAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEgAaQBtAGEAbgBz
AGgAdQAgAE0AYQBkAGgAYQBuAGkAAABTAE0AVABQAAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQA
aABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFdAQAAADgAAABoAGkAbQBhAG4AcwBo
AHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A+D8BAAAAIgAAAEgA
aQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAAAAAB8AI0ABAAAAOAAAAGgAaQBtAGEAbgBz
AGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAiQAEAAAAKAAAA
UwBNAFQAUAAAAAAAAgH5PwEAAAB8AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACASABpAG0AYQBu
AHMAaAB1ACAATQBhAGQAaABhAG4AaQAAAFMATQBUAFAAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEA
ZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8ACV0BAAAAOAAAAGgAaQBtAGEAbgBz
AGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAACwBAOgEAAAAfABoA
AQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAACwBAOgEAAAADAP0/5AQAAAIBCzAB
AAAAEAAAAPi8Ze0TZVNItRkD2pqXFDsDABcAAQAAAEAAOQAAI/S1o0jRAUAACDCtPnG2o0jRAQsA
AIAIIAYAAAAAAMAAAAAAAABGAAAAABSFAAABAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAA
AGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAALAACA
CCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAggAAAFIAZQA6ACAAWwBQAEEAVABD
AEgAIAB2ADIAIAAwADAALwAxADYAXQAgACAAcQBsAGEAMgB4AHgAeAA6ACAAUABhAHQAYwBoAGUA
cwAgAGYAbwByACAAdABhAHIAZwBlAHQALQBwAGUAbgBkAGkAbgBnACAAYgByAGEAbgBjAGgAAAAA
AB8APQABAAAACgAAAFIAZQA6ACAAAAAAAAMANgAAAAAAHwBCEAEAAAB0AAAAPAAxADQANQAwADYA
OAAxADAANAA3AC4AMgA1ADYANwA0AC4AMwAyAC4AYwBhAG0AZQBsAEAAaABhAGEAawBvAG4AMwAu
AHIAaQBzAGkAbgBnAHQAaQBkAGUAcwB5AHMAdABlAG0AcwAuAGMAbwBtAD4AAAACAXEAAQAAACAA
AAABAdE5Cs4VdayoAmxuQb5zz0t7p3BhntWNuoCAGUeXAB8AcAABAAAAegAAAFsAUABBAFQAQwBI
ACAAdgAyACAAMAAwAC8AMQA2AF0AIAAgAHEAbABhADIAeAB4AHgAOgAgAFAAYQB0AGMAaABlAHMA
IABmAG8AcgAgAHQAYQByAGcAZQB0AC0AcABlAG4AZABpAG4AZwAgAGIAcgBhAG4AYwBoAAAAAAAf
ADUQAQAAAFoAAAA8AEQAMgBCADIAOAA2ADIAQwAuAEQAMQA1ADUARgAlAGgAaQBtAGEAbgBzAGgA
dQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AAAAAAB8AORABAAAA8gAA
ADwAMQA0ADUAMAAzADgAMgAyADMAMQAtADQAMgA1ADkALQAxAC0AZwBpAHQALQBzAGUAbgBkAC0A
ZQBtAGEAaQBsAC0AaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBj
AC4AYwBvAG0APgAgADwAMQA0ADUAMAA2ADgAMQAwADQANwAuADIANQA2ADcANAAuADMAMgAuAGMA
YQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4AZwB0AGkAZABlAHMAeQBzAHQAZQBt
AHMALgBjAG8AbQA+AAAAAAADAN4/r28AAEAABzAxuWe2o0jRAQMAJgAAAAAAAgFHAAEAAAAvAAAA
Yz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMy0xNjAxMDYxNzAwMTRaLTEyNDkxNwAAHwAVEAEAAABY
AAAANABGADgANwA4ADkAQQAyADUAMAA3AEIANwAyADQANAA5AEIAMQBBADAAMgA5ADIAOAA5AEIA
MABBADgANgAxAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAIBFDABAAAADAAAAHEBAACwo6UmSAAA
AB8A+j8BAAAAIgAAAEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAAAAAB8AAICGAwIA
AAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAAAAABAAAARgAAAE0AaQBj
AHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAuADUALgA5AC4AMQA1ADEA
MQAxADkAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEAdABp
AG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAABEAQAASQBJAD0AMAAxADAA
MQBEADEANAA4AEEAMwBCADYARABFADEAOAA4AEYAMQAyADgAMgA3ADUAQwA0ADQANgA5ADkAMAAw
ADcAMwBFAEQAOQA5AEIARgA5ADYAMwBDADsAUwBCAE0ASQBEAD0ANAA7AFMAMQA9ADwAMQA0ADUA
MAA2ADgAMQAwADQANwAuADIANQA2ADcANAAuADMAMgAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBu
ADMALgByAGkAcwBpAG4AZwB0AGkAZABlAHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+ADsAVgBlAHIA
cwBpAG8AbgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAzACAAKABCAHUAaQBsAGQAIAAyADMANQAu
ADAAKQAsACAAUwB0AGEAZwBlAD0ASAAyAAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEA
AAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACAhgMC
AAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAA
AQAAABwAAABbADEAMAAuADIAOQAuADcALgAxADYAOABdAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAFgAAAGQAaQBzAGMAbABhAGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMAAAAAACU5

--_000_D2B2862CD155Fhimanshumadhaniqlogiccom_--
