From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Wed, 14 Jan 2015 23:08:32 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46DA0B25@avmb2.qlogic.org>
References: <54B63F74.2040702@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46DA0B25avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:62381 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbbANXIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 18:08:34 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id t0EN8UUW009879
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 15:08:33 -0800
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1rsr5n8x7k-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 15:08:33 -0800
In-Reply-To: <54B63F74.2040702@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46DA0B25avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E77881AB1D9E294B9969DADFB417E972@qlogic.com>
Content-Transfer-Encoding: quoted-printable



On 1/14/15, 2:05 AM, "Bart Van Assche" <bart.vanassche@sandisk.com> wrote:

>The LIO and SCST SCSI target subsystems consist of the following
>components:
>* A core that processes SCSI commands and that provides common
>functionality like persistent reservations, LUN masking and an interface
>that allows configuration from user space.
>* Device handlers that allow this core to access SCSI devices, block
>devices and files uniformly as SCSI devices.
>* Target drivers that implement a storage protocol (iSCSI, FC, SRP,
>iSER, FCoE, ...) and that realize the SCSI request and response
>communication between the target system and an initiator system.
>
>A significant amount of code is shared between several LIO target
>drivers and the SCST target drivers that implement the same storage
>protocol. Since there are two sets of these drivers this means that each
>set has to be maintained, extended and tested separately. This means a
>lot of redundant work. The main difference between these two sets of
>drivers is the interface between the target drivers and the SCSI target
>core.  Hence the proposal to discuss the unification of the API between
>SCSI target core and SCSI target drivers. Implementing a single unified
>API would have the following advantages:
>* A single set of target drivers works for both projects which means a
>reduction of the maintenance effort for those who maintain target
>drivers for target driver developers and target driver users.
>* This would increase the size of the user base for the unified target
>drivers.
>* This would reduce the workload for the storage target maintainers.
>* This would motivate the SCST target driver maintainers to contribute
>to the upstream target drivers and to bring the upstream SRP and FCoE
>target drivers to the same feature and stability level as their SCST
>counterparts. In other words, the LIO users would also benefit from this
>work.
>* This effort would also help SCST users by ensuring that all latest
>target driver features are also available to SCST users. Some time ago
>(but no longer today) the LIO QLogic target driver was ahead of the SCST
>QLogic target driver. This motivated an SCST user to port the LIO QLogic
>target driver to SCST. See also Greg Wettstein, New release of
>SCST/Qlogic target interface driver, linux-scsi, April 2014,
>http://marc.info/?l=3Dlinux-scsi&m=3D139649571807085).
>
>During the first phase of this initiative the focus will be on the
>QLogic FC, SRP and FCoE target drivers since a significant part of the
>code of these drivers is shared between the two target frameworks.
>
>For those who are not following the SCST project: I'm maintaining the
>SCST SRP and FCoE target drivers.
>
>Nic, in case it was not yet clear, you would be more than welcome during
>this session :-)
>
>Bart.

QT> +1.  This would be a plus for Qlogic to have 2 stacks under a unify
API.  Test resource & devlopment cycles are limited.  A lot of cycles are
loss in keeping patches in sync.

Would like to listen in at LSF to hear the discussion.


--_000_504EB66DAC8D234EB8E8560985C2D7AD46DA0B25avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
YXlH0KK2UVhMb2cOUIQtd0CxYf8koI+BKwWgGrIvGjFiFpNF/zWzqIc8kiywH5GxrKrvhMNvrgVa
EQngo+RHCXA1cFf/EhAtABAgC4AjEAfCCXAecOeI4meYKMIvUQkAtXlpKMdWpCMQIaF1eC0E8ACQ
fSMQQS6QAxEB0CLARldoIQJAcDovLwDAcmOGLguAAhAvP2w9wPgAJm09MTM5NjQAOTU3MTgwNzDo
ODUpT09EqZYrUZ/g/SrRcF7RiZU8IU5FVsErJf9vISagAxADIF9BOIErMbTN/0XlmwdWLnWhOpF1
glCYoUL/KvUsCFHxW89SL0ykW0EpZe8DUFhhfBPF/0aBO1rysJCvgQJ4VpPHfQU6dKAnHLC/X3aZ
xb4qzE9z6k9eTg5QfyMQZUEeUFwhpJGzctbCefdyor2hwMF5CGB3NV9CLgX7A6BMYGwmYVwxqZM2
mNHi4y7ROHI6LSlPXiPSOabJIZVRVCaQKzFtYYfp/19BRDALUMoRfHK+9qgRd7J+Mp5yPlA/8gSB
RCFAEnl/IZVw4eYSSdIz8QhhOpEm5z2ChVFD42N530GstCGg/m0ysAmAbWEt0GN17KghlX8JAAQR
ZUEzEGGANVIKsHTfJJHvwyoAMjDkzVd3UzLzHzyhIaAzkt3CLmFMU0b/6DPfYSsjbvUyYeTNFUL2
8B8AQgABAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AZQABAAAALAAAAHEAdQBpAG4A
bgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAA
AAAAAgFBAAEAAABkAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEA
bgAAAFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAA
AB8AAl0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
HwDlXwEAAAA0AAAAcwBpAHAAOgBxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8AGgwBAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AHwwBAAAALAAAAHEA
dQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAeDAEAAAAKAAAAUwBN
AFQAUAAAAAAAAgEZDAEAAABkAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBuACAA
VAByAGEAbgAAAFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8AAV0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAHwD4PwEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAjQAEAAAAsAAAAcQB1
AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfACJAAQAAAAoAAABTAE0A
VABQAAAAAAACAfk/AQAAAGQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBRAHUAaQBuAG4AIABU
AHIAYQBuAAAAUwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAHwAJXQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBv
AG0AAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAA
SQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAADf
F/ZQaPP7T6S57ZPEA8tjAwAXAAEAAABAADkAAJjqA08w0AFAAAgwn5oMBE8w0AELAACACCAGAAAA
AADAAAAAAAAARgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBl
AHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAA
wAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAAAHgAAABSAGUAOgAgAFsATABTAEYALwBNAE0AIABU
AE8AUABJAEMAXQAgAFUAbgBpAGYAeQBpAG4AZwAgAHQAaABlACAATABJAE8AIABhAG4AZAAgAFMA
QwBTAFQAIAB0AGEAcgBnAGUAdAAgAGQAcgBpAHYAZQByAHMAAAAfAD0AAQAAAAoAAABSAGUAOgAg
AAAAAAADADYAAAAAAB8AQhABAAAAPgAAADwANQA0AEIANgAzAEYANwA0AC4AMgAwADQAMAA3ADAA
MgBAAHMAYQBuAGQAaQBzAGsALgBjAG8AbQA+AAAAAAACAXEAAQAAABsAAAABAdAv4a+pfj/X3SlG
R6viU7kU8bFtnMA+QgAAHwBwAAEAAABwAAAAWwBMAFMARgAvAE0ATQAgAFQATwBQAEkAQwBdACAA
VQBuAGkAZgB5AGkAbgBnACAAdABoAGUAIABMAEkATwAgAGEAbgBkACAAUwBDAFMAVAAgAHQAYQBy
AGcAZQB0ACAAZAByAGkAdgBlAHIAcwAAAB8ANRABAAAAeAAAADwANQAwADQARQBCADYANgBEAEEA
QwA4AEQAMgAzADQARQBCADgARQA4ADUANgAwADkAOAA1AEMAMgBEADcAQQBEADQANgBEAEEAMABC
ADIANQBAAGEAdgBtAGIAMgAuAHEAbABvAGcAaQBjAC4AbwByAGcAPgAAAB8AORABAAAAPgAAADwA
NQA0AEIANgAzAEYANwA0AC4AMgAwADQAMAA3ADAAMgBAAHMAYQBuAGQAaQBzAGsALgBjAG8AbQA+
AAAAAAADAN4/n04AAEAABzAfFQMETzDQAQMAJgAAAAAAAgFHAAEAAAAuAAAAYz1VUzthPSA7cD1R
TG9naWM7bD1BVk1CMi0xNTAxMTQyMzA4MzJaLTI1MTk1AAAAHwAVEAEAAABYAAAARQA3ADcAOAA4
ADEAQQBCADEARAA5AEUAMgA5ADQAQgA5ADkANgA5AEQAQQBEAEYAQgA0ADEANwBFADkANwAyAEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAAIBFDABAAAADAAAAMMBAAA4/r9hTwAAAB8A+j8BAAAAFgAA
AFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMA
ZQByAC0AYQBnAGUAbgB0AAAAAAABAAAARgAAAE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1
AHQAbABvAG8AawAvADEANAAuADQALgA3AC4AMQA0ADEAMQAxADcAAAAAAB8AAIAfpOszqHouQr57
eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBr
AGkAbgBnAEUAeAAAAAEAAAAOAQAASQBJAD0AMAAxADAAMQBEADAAMwAwADQARgAwADQAQwA4AEMA
MAAyADIANAA0AEQAMgA5AEEAQwAwADQAMABCADQARAAyADQAQgBFAEUARABCAEQAOQA1AEIARAA3
ADsAUwBCAE0ASQBEAD0AMwA7AFMAMQA9ADwANQA0AEIANgAzAEYANwA0AC4AMgAwADQAMAA3ADAA
MgBAAHMAYQBuAGQAaQBzAGsALgBjAG8AbQA+ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBv
AG4AIAAxADQALgAyACAAKABCAHUAaQBsAGQAIAAzADgANwAuADAAKQAsACAAUwB0AGEAZwBlAD0A
SAAyAAAAAAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABh
AHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIA
AAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAGgAAAFsAMQAwAC4AMwAu
ADEAMAAuADIAMwBdAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAAZABpAHMAYwBsAGEA
aQBtAGUAcgAAAAAAAQAAAA4AAABiAHkAcABhAHMAcwAAAAAAN3E=

--_000_504EB66DAC8D234EB8E8560985C2D7AD46DA0B25avmb2qlogicorg_--
