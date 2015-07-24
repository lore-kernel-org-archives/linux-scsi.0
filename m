From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch.
Date: Fri, 24 Jul 2015 18:36:27 +0000
Message-ID: <D1D7D2D9.A6AE9%himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
 <1437719934.8929.23.camel@haakon3.risingtidesystems.com>
 <1437749478.2217.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D1D7D2D9A6AE9himanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:48490 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbbGXSga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 14:36:30 -0400
Received: from pps.filterd (m0085408.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6OIVxAM013286
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2015 11:36:29 -0700
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1vqnsn1jff-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2015 11:36:29 -0700
In-Reply-To: <1437749478.2217.13.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@lst.de" <hch@lst.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

--_000_D1D7D2D9A6AE9himanshumadhaniqlogiccom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A1EB4988AABFB4E94AEC2F9A1509B86@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Nic, James,



On 7/24/15, 7:51 AM, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Thu, 2015-07-23 at 23:38 -0700, Nicholas A. Bellinger wrote:
>> Hi Himanshu & Co,
>>=20
>> (Adding target-devel CC')
>>=20
>> On Wed, 2015-06-10 at 11:05 -0400, Himanshu Madhani wrote:
>> > Hi James,
>> >=20
>> > Please apply the following patches to the scsi tree at your earliest
>> > convenience for inclusion in the next mainline merge window.
>> >=20
>> > Thanks,
>> > Himanshu
>> >=20
>> > Himanshu Madhani (3):
>> >   qla2xxx: Enable target mode for ISP27XX
>> >   qla2xxx: Remove msleep in qlt_send_term_exchange
>> >   qla2xxx: Enable Target counters in DebugFS.
>> >=20
>> > Kanoj Sarcar (1):
>> >   qla2xxx: fix command initialization in target mode.
>> >=20
>> > Quinn Tran (4):
>> >   qla2xxx: Add flush after updating ATIOQ consumer index.
>> >   qla2xxx: release request queue reservation.
>> >   qla2xxx: adjust debug flags
>> >   qla2xxx: Add FW resource count in DebugFS.
>> >=20
>> > Saurav Kashyap (1):
>> >   qla2xxx: Fix hardware lock/unlock issue causing kernel panic.
>> >=20
>> >  drivers/scsi/qla2xxx/qla_attr.c    |    2 +-
>> >  drivers/scsi/qla2xxx/qla_def.h     |   36 ++++++++++---
>> >  drivers/scsi/qla2xxx/qla_dfs.c     |  106
>>++++++++++++++++++++++++++++++++++++
>> >  drivers/scsi/qla2xxx/qla_gbl.h     |    3 +-
>> >  drivers/scsi/qla2xxx/qla_init.c    |   20 ++++---
>> >  drivers/scsi/qla2xxx/qla_iocb.c    |    1 +
>> >  drivers/scsi/qla2xxx/qla_mbx.c     |   31 +++++------
>> >  drivers/scsi/qla2xxx/qla_os.c      |    1 +
>> >  drivers/scsi/qla2xxx/qla_sup.c     |    2 +-
>> >  drivers/scsi/qla2xxx/qla_target.c  |   60 ++++++++++++---------
>> >  drivers/scsi/qla2xxx/qla_target.h  |    3 +
>> >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    9 ++-
>> >  12 files changed, 208 insertions(+), 66 deletions(-)
>> >=20
>>=20
>> This series contains a number of qla2xxx target mode related bug-fixes
>> that have not made it into scsi.git after 6 weeks on the list.  I don't
>> see a good reason to wait another 6 weeks for v4.3-rc1 to get these into
>> mainline.
>
>According to the request, they're not fixes, they're targetted for the
>merge window.  As such, they still require reviews ... but if you'd like
>to provide them, that would be great.
>
>> That said, I'm going to merge patches #1-#7 via target-pending/master
>> now and submit for v4.2-rc code.  Please re-submit the non bug-fix
>> related changes in patches #8-#9 as for-4.3 code to JEJB -> scsi.git.
>
>I don't, in principle object to this demand, because it looks for the
>description that the bug fixes should be split out, except that you
>should follow proper process and have one independent review.  Hannes or
>Christoph are probably the best placed.

I will resubmit patches #8-#9 in next submission.

>
>James
>
>> Here's the updated diff-stat for the bug-fix series.
>>=20
>> Himanshu Madhani (2):
>>   qla2xxx: Enable target mode for ISP27XX
>>   qla2xxx: Remove msleep in qlt_send_term_exchange
>>=20
>> Kanoj Sarcar (1):
>>   qla2xxx: fix command initialization in target mode.
>>=20
>> Quinn Tran (3):
>>   qla2xxx: Add flush after updating ATIOQ consumer index.
>>   qla2xxx: release request queue reservation.
>>   qla2xxx: adjust debug flags
>>=20
>> Saurav Kashyap (1):
>>   qla2xxx: Fix hardware lock/unlock issue causing kernel panic.
>>=20
>>  drivers/scsi/qla2xxx/qla_attr.c    |  2 +-
>>  drivers/scsi/qla2xxx/qla_def.h     |  8 +++----
>>  drivers/scsi/qla2xxx/qla_init.c    |  8 +++++--
>>  drivers/scsi/qla2xxx/qla_mbx.c     |  7 +++---
>>  drivers/scsi/qla2xxx/qla_os.c      |  1 +
>>  drivers/scsi/qla2xxx/qla_sup.c     |  2 +-
>>  drivers/scsi/qla2xxx/qla_target.c  | 49
>>+++++++++++++++++++-------------------
>>  drivers/scsi/qla2xxx/qla_target.h  |  3 +++
>>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  3 +--
>>  9 files changed, 46 insertions(+), 37 deletions(-)
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>
>
>

Thanks,=20
Himanshu


--_000_D1D7D2D9A6AE9himanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
Kx+kvqMQGZ1uAN0BD1QCAAAAgEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAABTAE0A
VABQAAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBv
AG0AAAAfAAJdAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8A
ZwBpAGMALgBjAG8AbQAAAB8A5V8BAAAAQAAAAHMAaQBwADoAaABpAG0AYQBuAHMAaAB1AC4AbQBh
AGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfABoMAQAAACIAAABIAGkAbQBhAG4A
cwBoAHUAIABNAGEAZABoAGEAbgBpAAAAAAAfAB8MAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBt
AGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AHgwBAAAACgAAAFMATQBUAFAA
AAAAAAIBGQwBAAAAfAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEgAaQBtAGEAbgBzAGgAdQAg
AE0AYQBkAGgAYQBuAGkAAABTAE0AVABQAAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4A
aQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFdAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBt
AGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A+D8BAAAAIgAAAEgAaQBtAGEA
bgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAAAAAB8AI0ABAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAu
AG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAiQAEAAAAKAAAAUwBNAFQA
UAAAAAAAAgH5PwEAAAB8AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACASABpAG0AYQBuAHMAaAB1
ACAATQBhAGQAaABhAG4AaQAAAFMATQBUAFAAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEA
bgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8ACV0BAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAu
AG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAACwBAOgEAAAAfABoAAQAAABIA
AABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAACwBAOgEAAAADAP0/5AQAAAIBCzABAAAAEAAA
AP5cEhnIWBVMvXid8kpnUt4DABcAAQAAAEAAOQCAh1umP8bQAUAACDC6pJ+mP8bQAQsAAIAIIAYA
AAAAAMAAAAAAAABGAAAAABSFAAABAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBj
AGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAALAACACCAGAAAA
AADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAcgAAAFIAZQA6ACAAWwBQAEEAVABDAEgAIAAw
AC8AOQBdACAAcQBsAGEAMgB4AHgAeAA6ACAAUABhAHQAYwBoAGUAcwAgAGYAbwByACAAcwBjAHMA
aQAgACIAbQBpAHMAYwAiACAAYgByAGEAbgBjAGgALgAAAAAAHwA9AAEAAAAKAAAAUgBlADoAIAAA
AAAAAwA2AAAAAAAfAEIQAQAAAGIAAAA8ADEANAAzADcANwA0ADkANAA3ADgALgAyADIAMQA3AC4A
MQAzAC4AYwBhAG0AZQBsAEAASABhAG4AcwBlAG4AUABhAHIAdABuAGUAcgBzAGgAaQBwAC4AYwBv
AG0APgAAAAAAAgFxAAEAAAAlAAAAAQHQo5T3lIm5BX7d0EOp4EQhBYmgAZ3q5QAAgACJkwD//8mN
gAAAAB8AcAABAAAAagAAAFsAUABBAFQAQwBIACAAMAAvADkAXQAgAHEAbABhADIAeAB4AHgAOgAg
AFAAYQB0AGMAaABlAHMAIABmAG8AcgAgAHMAYwBzAGkAIAAiAG0AaQBzAGMAIgAgAGIAcgBhAG4A
YwBoAC4AAAAAAB8ANRABAAAAWgAAADwARAAxAEQANwBEADIARAA5AC4AQQA2AEEARQA5ACUAaABp
AG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0APgAAAAAA
HwA5EAEAAABSAQAAPAAxADQAMwAzADkANAA4ADcAMgA1AC0ANAAwADcAMwAtADEALQBnAGkAdAAt
AHMAZQBuAGQALQBlAG0AYQBpAGwALQBoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAA
cQBsAG8AZwBpAGMALgBjAG8AbQA+ACAAPAAxADQAMwA3ADcAMQA5ADkAMwA0AC4AOAA5ADIAOQAu
ADIAMwAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4AZwB0AGkAZABlAHMA
eQBzAHQAZQBtAHMALgBjAG8AbQA+ACAAPAAxADQAMwA3ADcANAA5ADQANwA4AC4AMgAyADEANwAu
ADEAMwAuAGMAYQBtAGUAbABAAEgAYQBuAHMAZQBuAFAAYQByAHQAbgBlAHIAcwBoAGkAcAAuAGMA
bwBtAD4AAAAAAAMA3j+fTgAAQAAHMJ2AmKY/xtABAwAmAAAAAAACAUcAAQAAAC4AAABjPVVTO2E9
IDtwPVFMb2dpYztsPUFWTUIzLTE1MDcyNDE4MzYyN1otNDUyNzAAAAAfABUQAQAAAFgAAAA1AEEA
MQBFAEIANAA5ADgAOABBAEEAQgBGAEIANABFADkANABBAEUAQwAyAEYAOQBBADEANQAwADkAQgA4
ADYAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEUMAEAAAAMAAAApQEAALfLRgtIAAAAHwD6PwEA
AAAiAAAASABpAG0AYQBuAHMAaAB1ACAATQBhAGQAaABhAG4AaQAAAAAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBuAHQAAAAAAAEAAABGAAAATQBpAGMAcgBvAHMA
bwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8AMQA0AC4AMwAuADkALgAxADMAMQAwADMAMAAA
AAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkA
bgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAADIBAABJAEkAPQAwADEAMAAxAEQAMABD
ADYAMwBGAEEANgBGADIANgA4ADIAOAAzADkAMABBADMARgBDADQANAA4AEEAMAAyAEYANwA0ADAA
OABDADMARQAxADUAQgBBAEUAOwBTAEIATQBJAEQAPQAyADsAUwAxAD0APAAxADQAMwA3ADcANAA5
ADQANwA4AC4AMgAyADEANwAuADEAMwAuAGMAYQBtAGUAbABAAEgAYQBuAHMAZQBuAFAAYQByAHQA
bgBlAHIAcwBoAGkAcAAuAGMAbwBtAD4AOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAg
ADEANAAuADMAIAAoAEIAdQBpAGwAZAAgADIAMwA1AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIA
AAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAt
AGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgA
LQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAYAAAAWwAxADAALgAxAC4ANAAu
ADEAMABdAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAGQAaQBzAGMAbABhAGkAbQBlAHIA
AAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMAAAAAAPmF

--_000_D1D7D2D9A6AE9himanshumadhaniqlogiccom_--
