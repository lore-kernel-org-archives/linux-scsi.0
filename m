From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Configure NPIV fc_vport via
 tcm_qla2xxx_npiv_make_lport
Date: Thu, 16 Jan 2014 20:54:33 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46CCE9AA@avmb2.qlogic.org>
References: <1389764525-24453-1-git-send-email-nab@daterainc.com>
 <504EB66DAC8D234EB8E8560985C2D7AD46CCE451@avmb2.qlogic.org>
 <1389837925.5567.627.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46CCE9AAavmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:15386 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbaAPUyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 15:54:35 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s0GKsZm0002027
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2014 12:54:35 -0800
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1h9ybuk46j-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2014 12:54:35 -0800
In-Reply-To: <1389837925.5567.627.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CCE9AAavmb2qlogicorg_
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <CE290D987EE22F4F8CC1DE88C9CC7963@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Nicholas,

Comments inline. Thanks.


<SNIP>
>Bullet 3) Generating NPIV WWPN id:  Qlogic overall strategy for this
>question is: Qla2xxx driver is a common driver being used by various
>hardware vendors(HP, IBM, Dell, etc..).  Each vendors have a different
>scheme on how to generate the WWPN value.  QLogic's design decision is to
>push that up to the user app to generate these values rather having
>QLA2xxx generating it dynamically.

So question here was not contents of the NPIV WWPN value, but rather if
the NPIV WWPN and NPIV WWNN are always expected to have the same suffix.

Eg, is it safe to assume that the '21' and '20' prefixes for NPIV WWPN +
NPIV WWNN are the only different part of the $NPIV_WWPN:$NPIV_WWNN tuple
passed into fc_vport_create()..?

If so, I'd like to remove $NPIV_WWNN from being passed into configfs,
and simply generate this value internally, eg:

  /sys/kernel/config/target/qla2xxx_npiv/$PHYS_WWPN:$NPIV_WWPN
<SNIP>

QT> Mis-read this one.

It's not safe to assume "21" & "20" as the standardize prefixes and the
rest of the $WWPN/$WWNN will be the same. While it is common to see "21" &
"20" (i.e. Network Addr Authority/NAA 2 format) on a lot of adapters.  The
common case that we see only cover 1 NAA format.  I've seen the NAA5
format float around on different adapters.

I don't want to paint us in to a corner, that will require future code
change in this area.  The user that generate the $NPIV_WWPN + $NPIV_WWNN
may decide to use another NAA format where it will not match this
implementation.

By collapsing the $NPIV_WWNN into the driver, its takes away the option
for an administrator of a large SAN to assign/identify storage chassis
using $WWNN.  Even though it is clunky to carry around.

I prefer the format "$PHYS_WWPN@$NPIV_WWPN:$NPIV_WWNN" with the "@" key,
for the case where the user download an older version of RSTLIB that still
follow the older format/backward compatible.  The '@' key inside the
driver provides the distinction of the new configfs format.  No preference
on $PHYS_WWPN appear at the front or back.


Network address authority Format:
NAA1 =3D10-00-vv-vv-vv-ss-ss-ss
NAA2 =3D2x-xx-vv-vv-vv-ss-ss-ss
NAA5 =3D5v-vv-vv-vs-ss-ss-ss-ss
NAA6 =3D6?-=8A (16 bytes/32 hex digits, not applicable for HW adapter)

x=3Dvendor code (0-00=3Dwwnn 1-00=3Dwwpn)
v=3Dvendor id
s=3Dserial number (NAA5: user may decide to use WWPN=3DN & WWNN=3DN+1)


----
<SNIP>
>Bullet 4) VPD Page 83h, SCSI name string.  If you implying to use the WWPN
>as part of the "SCSI name string", the answer is the same as previous
>bullet.  In this case, the setup up script would have to extract the data
>from configfs in order to generate the "SCSI name string"

This question was geared toward how SCSI name should be represented in
INQUIRY EVPD=3D0x83 for NPIV ports.

For physical ports, this ends up being the 21:00:00:XX:XX:XX:XX:XX value
matching what is passed to configfs.  For virtual ports the passed
$NPIV_WWPN part would be here in similar format, but the question was if
the port_id should also be appended here similar to existing 'lsscsi
--transport' output, eg:

root@devstack:~# lsscsi --transport
[0:0:0:0]    disk    ata:                            /dev/sda
[91:0:0:0]   disk    fc:0x21111111222222220x610101   /dev/sdb
<SNIP>


SPC4 rev 36n, section 7.8.6.11 >









                                        The SCSI NAME STRING field starts w=
ith either:

...
b) the four UTF-8 characters 'naa.' concatenated with 16 or 32 hexadecimal
digits for an NAA identifier
(see 7.8.6.6). The first hexadecimal digit shall be the most significant
four bits of the first byte (i.e.,
most significant byte) of the NAA identifier; or
...
"If the ASSOCIATION field is set to 01b (i.e., target port), the SCSI NAME
STRING field ends with the five UTF-8
characters ',t,0x' concatenated with two or more hexadecimal digits as
defined in the applicable SCSI
transport protocol standard."
...


QT> If I read SPC4 correctly, the format is as follow (minor tweak).  For
FC, there is only 1 format (i.e. Association field =3D 1).  Correct the
format if you read it differently.




[91:0:0:0] disk fc:naa.2111111122222222,t,0x610101  /dev/sdb



Scsi name string =3D "naa.2111111122222222,t,0x610101"

---







Regards,
Quinn Tran



________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CCE9AAavmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IgIvAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADUwRTgzODFD
NUZGRDIzNEY4QTJBRDVDRDBDOTYxM0NFAF8HAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HAQAQABQA
NgAhAAQAZQEBIIADAA4AAADeBwEAEAAUADYAIQAEAGUBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAE0AAABSZTogW1BBVENIXSBxbGEyeHh4OiBDb25maWd1cmUgTlBJViBm
Y192cG9ydCB2aWEgdGNtX3FsYTJ4eHhfbnBpdl9tYWtlX2xwb3J0ALEbAQOQBgD4GAAAMwAAAAIB
fwABAAAAPAAAADw1MDRFQjY2REFDOEQyMzRFQjhFODU2MDk4NUMyRDdBRDQ2Q0NFOUFBQGF2bWIy
LnFsb2dpYy5vcmc+AAsAHw4BAAAAAgEJEAEAAAAkDAAAIAwAAMIWAABMWkZ1vh/QHmEACmZiaWQE
AABjY8BwZzEyNTIA/gND8HRleHQB9wKkA+MCAARjaArAc2V0MCDvB20CgwBQEU0yCoAGtAKAln0K
gAjIOwliMTkOwL8JwxZyCjIWcQKAFWIqCbBzCfAEkGF0BbIOUANgc6JvAYAgRXgRwW4YMF0GUnYE
kBe2AhByAMB0fQhQbhoxECAFwAWgG2RkmiADUiAQIheyXHYIkOR3awuAZDUdUwTwB0ANF3AwCnEX
8mJrbWsGcwGQACAgQk1fQuBFR0lOfQr8AfEL8QsHsA5QaAbwYXMsXLpsC4BlCoEiRAhQbQeA7wIw
BCALgCJCLhJAGaEfUAYuIjwiNTxTTklQwj4iNT5CdWwecAVAsDMpIEcYRAuAZwewAFBJViBXV1BO
QSOQZDogIFEJAGf5DlAgbxoxB0ADIB9gGHGYZWd5HHAFsXRoDfFtJlVxClAfYGkCICOQcyMo0CkA
YTJ4LJAgZOcFEBoxLAEgYRvRIzAr4Wks1WJlJ9J1EgAcYGJ9KmB2CsAr0C7QJkYR0WQ+dwrAGeAa
MB3ABbBzKGBIUCwgSR/AMXBEDmUm4DFwEhBjLi4p1yQAGWAA0GgwxiAR0Bowfy1hDeABIASQI1Em
RgTwaH5lB4ApYAOgIdAH4BiQIP8YNRngKsAZ4ChjL1AKQTKhdFFMKSInBCABAACQZ78t4QWQBAAr
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
AHIAYQBuAAAAUwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAHwACXQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBv
AG0AAAAfAOVfAQAAADQAAABzAGkAcAA6AHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwAaDAEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAfDAEAAAAs
AAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAB4MAQAAAAoA
AABTAE0AVABQAAAAAAACARkMAQAAAGQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBRAHUAaQBu
AG4AIABUAHIAYQBuAAAAUwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwABXQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBj
AC4AYwBvAG0AAAAfAPg/AQAAABYAAABRAHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfACNAAQAAACwA
AABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAACgAA
AFMATQBUAFAAAAAAAAIB+T8BAAAAZAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBpAG4A
bgAgAFQAcgBhAG4AAABTAE0AVABQAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBj
AC4AYwBvAG0AAAAfAAldAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMA
LgBjAG8AbQAAAAsAQDoBAAAAHwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQA
AAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAABQ6DgcX/0jT4oq1c0MlhPOAwAXAAEAAABAADkA
gEpZKP0SzwFAAAgwJ5LFKP0SzwELAACACCAGAAAAAADAAAAAAAAARgAAAAAUhQAAAQAAAB8AAICG
AwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEA
AAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAA
AJoAAABSAGUAOgAgAFsAUABBAFQAQwBIAF0AIABxAGwAYQAyAHgAeAB4ADoAIABDAG8AbgBmAGkA
ZwB1AHIAZQAgAE4AUABJAFYAIABmAGMAXwB2AHAAbwByAHQAIAB2AGkAYQAgAHQAYwBtAF8AcQBs
AGEAMgB4AHgAeABfAG4AcABpAHYAXwBtAGEAawBlAF8AbABwAG8AcgB0AAAAAAAfAD0AAQAAAAoA
AABSAGUAOgAgAAAAAAADADYAAAAAAB8AQhABAAAAdAAAADwAMQAzADgAOQA4ADMANwA5ADIANQAu
ADUANQA2ADcALgA2ADIANwAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4A
ZwB0AGkAZABlAHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+AAAAAgFxAAEAAAAlAAAAAQHPEbdi+Y5X
Nqk2+Ui6WBANOcGBy5qGWs+AgADGtYCAALVbgAAAAB8AcAABAAAAkgAAAFsAUABBAFQAQwBIAF0A
IABxAGwAYQAyAHgAeAB4ADoAIABDAG8AbgBmAGkAZwB1AHIAZQAgAE4AUABJAFYAIABmAGMAXwB2
AHAAbwByAHQAIAB2AGkAYQAgAHQAYwBtAF8AcQBsAGEAMgB4AHgAeABfAG4AcABpAHYAXwBtAGEA
awBlAF8AbABwAG8AcgB0AAAAAAAfADUQAQAAAHgAAAA8ADUAMAA0AEUAQgA2ADYARABBAEMAOABE
ADIAMwA0AEUAQgA4AEUAOAA1ADYAMAA5ADgANQBDADIARAA3AEEARAA0ADYAQwBDAEUAOQBBAEEA
QABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAfADkQAQAAAFgBAAA8ADEAMwA4
ADkANwA2ADQANQAyADUALQAyADQANAA1ADMALQAxAC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEA
aQBsAC0AbgBhAGIAQABkAGEAdABlAHIAYQBpAG4AYwAuAGMAbwBtAD4AIAA8ADUAMAA0AEUAQgA2
ADYARABBAEMAOABEADIAMwA0AEUAQgA4AEUAOAA1ADYAMAA5ADgANQBDADIARAA3AEEARAA0ADYA
QwBDAEUANAA1ADEAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AIAA8ADEAMwA4
ADkAOAAzADcAOQAyADUALgA1ADUANgA3AC4ANgAyADcALgBjAGEAbQBlAGwAQABoAGEAYQBrAG8A
bgAzAC4AcgBpAHMAaQBuAGcAdABpAGQAZQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0APgAAAAMA3j/k
BAAAQAAHMOdJtyj9Es8BAwAmAAAAAAACAUcAAQAAAC8AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFW
TUIyLTE0MDExNjIwNTQzM1otMTExMDU5AAAfABUQAQAAAFgAAABDAEUAMgA5ADAARAA5ADgANwBF
AEUAMgAyAEYANABGADgAQwBDADEARABFADgAOABDADkAQwBDADcAOQA2ADMAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAAgEUMAEAAAAMAAAAfgIAAClae5pOAAAAHwD6PwEAAAAWAAAAUQB1AGkAbgBu
ACAAVAByAGEAbgAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcA
ZQBuAHQAAAAAAAEAAABGAAAATQBpAGMAcgBvAHMAbwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBr
AC8AMQA0AC4AMwAuADkALgAxADMAMQAwADMAMAAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAA
OAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4
AAAAAQAAAEQBAABJAEkAPQAwADEAMAAxAEMARgAxADIARgBEADIAOAAzAEYAQgAxADcAMABGAEIA
RQAzADgARAA3ADYANAAxADkAQgAwADgANgA0ADAAMABCADkARAA3ADMAMQBEADIAOwBTAEIATQBJ
AEQAPQAzADsAUwAxAD0APAAxADMAOAA5ADgAMwA3ADkAMgA1AC4ANQA1ADYANwAuADYAMgA3AC4A
YwBhAG0AZQBsAEAAaABhAGEAawBvAG4AMwAuAHIAaQBzAGkAbgBnAHQAaQBkAGUAcwB5AHMAdABl
AG0AcwAuAGMAbwBtAD4AOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADIA
IAAoAEIAdQBpAGwAZAAgADMAMQA4AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAADAA00/T8A
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMA
aAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBp
AG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAGgAAAFsAMQAwAC4AMwAuADEAMAAuADgAMQBdAAAA
AACOyQ==

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CCE9AAavmb2qlogicorg_--
