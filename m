From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
Date: Mon, 7 Jul 2014 17:46:24 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD8C6C0F7B@avmb3.qlogic.org>
References: <20140704182756.GA9319@himangi-Dell>
 <94D0CD8314A33A4D9D801C0FE68B402958B866EB@G9W0745.americas.hpqcorp.net>
 <alpine.DEB.2.02.1407042235390.1984@localhost6.localdomain6>
 <53BACB4A.7080706@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_3FC4AB8B47ECD546BCD4B361A64BEACD8C6C0F7Bavmb3qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38434 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbaGGRq3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 13:46:29 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s67HhKgo010109
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2014 10:46:28 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1mqfn25m3m-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 07 Jul 2014 10:46:28 -0700
In-Reply-To: <53BACB4A.7080706@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Julia Lawall <julia.lawall@lip6.fr>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Himangi Saraogi <himangi774@gmail.com>, Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--_000_3FC4AB8B47ECD546BCD4B361A64BEACD8C6C0F7Bavmb3qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F96774D0898E046A6B3971B49E12BA0@qlogic.com>
Content-Transfer-Encoding: quoted-printable



On 07/07/14 10:01 pm, "Mike Christie" <michaelc@cs.wisc.edu> wrote:

>On 07/04/2014 03:37 PM, Julia Lawall wrote:
>>=20
>>=20
>> On Fri, 4 Jul 2014, Elliott, Robert (Server Storage) wrote:
>>=20
>>>
>>>
>>>> -----Original Message-----
>>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>>> owner@vger.kernel.org] On Behalf Of Himangi Saraogi
>>>> Sent: Friday, 04 July, 2014 1:28 PM
>>>> To: Vikas Chaudhary; iscsi-driver@qlogic.com; James E.J. Bottomley;
>>>>linux-
>>>> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>>>> Cc: julia.lawall@lip6.fr
>>>> Subject: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
>>>>
>>>> In this code, 0 is returned on memory allocation failure, even though
>>>> other failures return -ENOMEM or other similar values.
>>>>
>>>> A simplified version of the Coccinelle semantic match that finds this
>>>> problem is as follows:
>>>>
>>>> // <smpl>
>>>> @@
>>>> expression ret;
>>>> expression x,e1,e2,e3;
>>>> identifier alloc;
>>>> @@
>>>>
>>>> ret =3D 0
>>>> ... when !=3D ret =3D e1
>>>> *x =3D alloc(...)
>>>> ... when !=3D ret =3D e2
>>>> if (x =3D=3D NULL) { ... when !=3D ret =3D e3
>>>>   return ret;
>>>> }
>>>> // </smpl>
>>>>
>>>> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
>>>> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
>>>> ---
>>>>  drivers/scsi/qla4xxx/ql4_os.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c
>>>>b/drivers/scsi/qla4xxx/ql4_os.c
>>>> index c5d9564..72ba671 100644
>>>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>>>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>>>> @@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct
>>>>Scsi_Host
>>>> *shost, char *buf, int len)
>>>>  	if (!ql_iscsi_stats) {
>>>>  		ql4_printk(KERN_ERR, ha,
>>>>  			   "Unable to allocate memory for iscsi stats\n");
>>>> +		ret =3D -ENOMEM;
>>>>  		goto exit_host_stats;
>>>>  	}
>>>>
>>>
>>> Also, the only caller of this function doesn't use the return
>>> value - it's overwritten by another function call:
>>>
>>> drivers/scsi/scsi_transport_iscsi.c:
>>>                 err =3D transport->get_host_stats(shost, buf,
>>>host_stats_size);
>>>
>>>                 actual_size =3D nlmsg_total_size(sizeof(*ev) +
>>>host_stats_size);
>>>                 skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
>>>                 nlhhost_stats->nlmsg_len =3D actual_size;
>>>
>>>                 err =3D iscsi_multicast_skb(skbhost_stats,
>>>ISCSI_NL_GRP_ISCSID,
>>>                                           GFP_KERNEL);
>>=20
>> Maybe that is intentional?
>
>I think it was a mistake. There is also one more issue in
>qla4xxx_get_host_stats where it is returning an internal qlogic
>specific error value. This patch should fix all issues.
>
>
>[PATCH] qla4xxx/iscsi: fix get_host_stats error propagation
>
>This patch fixes 2 bugs.
>
>1. qla4xxx was not always returning -EXYZ error codes when
>qla4xxx_get_host_stats failed.
>
>2. iscsi_get_host_stats was dropping the error code returned
>by drivers like qla4xxx.
>
>Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index 459b9f7..e4dc3e0 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host
>*shost, char *buf, int len)
> 	if (!ql_iscsi_stats) {
> 		ql4_printk(KERN_ERR, ha,
> 			   "Unable to allocate memory for iscsi stats\n");
>+		ret =3D -ENOMEM;
> 		goto exit_host_stats;
> 	}
>=20
>@@ -1058,6 +1059,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host
>*shost, char *buf, int len)
> 	if (ret !=3D QLA_SUCCESS) {
> 		ql4_printk(KERN_ERR, ha,
> 			   "Unable to retrieve iscsi stats\n");
>+		ret =3D -EIO;
> 		goto exit_host_stats;
> 	}
> 	host_stats->mactx_frames =3D le64_to_cpu(ql_iscsi_stats->mac_tx_frames);
>diff --git a/drivers/scsi/scsi_transport_iscsi.c
>b/drivers/scsi/scsi_transport_iscsi.c
>index 0102a2d..ea2996a 100644
>--- a/drivers/scsi/scsi_transport_iscsi.c
>+++ b/drivers/scsi/scsi_transport_iscsi.c
>@@ -3467,6 +3467,10 @@ iscsi_get_host_stats(struct iscsi_transport
>*transport, struct nlmsghdr *nlh)
> 		memset(buf, 0, host_stats_size);
>=20
> 		err =3D transport->get_host_stats(shost, buf, host_stats_size);
>+		if (err) {
>+			kfree(skbhost_stats);
>+			goto exit_host_stats;
>+		}
>=20
> 		actual_size =3D nlmsg_total_size(sizeof(*ev) + host_stats_size);
> 		skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));


Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


--_000_3FC4AB8B47ECD546BCD4B361A64BEACD8C6C0F7Bavmb3qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
PKorbzYq/8aPx5/IqGQ/Pg8dUMyvzb/vzs8EdHecf6hWAyDjQQYgmGF1ZDIhuRA8dnmSO36QefZA
6iR+mjNFfX0DHOB9YAAfAEIAAQAAACAAAABWAGkAawBhAHMAIABDAGgAYQB1AGQAaABhAHIAeQAA
AB8AZQABAAAANgAAAHYAaQBrAGEAcwAuAGMAaABhAHUAZABoAGEAcgB5AEAAcQBsAG8AZwBpAGMA
LgBjAG8AbQAAAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAAB4AAAAAAAAAIErH6S+
oxAZnW4A3QEPVAIAAACAVgBpAGsAYQBzACAAQwBoAGEAdQBkAGgAYQByAHkAAABTAE0AVABQAAAA
dgBpAGsAYQBzAC4AYwBoAGEAdQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAC
XQEAAAA2AAAAdgBpAGsAYQBzAC4AYwBoAGEAdQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAAAAfAOVfAQAAAD4AAABzAGkAcAA6AHYAaQBrAGEAcwAuAGMAaABhAHUAZABoAGEAcgB5
AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAaDAEAAAAgAAAAVgBpAGsAYQBzACAAQwBoAGEA
dQBkAGgAYQByAHkAAAAfAB8MAQAAADYAAAB2AGkAawBhAHMALgBjAGgAYQB1AGQAaABhAHIAeQBA
AHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAA
eAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFYAaQBrAGEAcwAgAEMAaABhAHUAZABoAGEAcgB5
AAAAUwBNAFQAUAAAAHYAaQBrAGEAcwAuAGMAaABhAHUAZABoAGEAcgB5AEAAcQBsAG8AZwBpAGMA
LgBjAG8AbQAAAB8AAV0BAAAANgAAAHYAaQBrAGEAcwAuAGMAaABhAHUAZABoAGEAcgB5AEAAcQBs
AG8AZwBpAGMALgBjAG8AbQAAAAAAHwD4PwEAAAAgAAAAVgBpAGsAYQBzACAAQwBoAGEAdQBkAGgA
YQByAHkAAAAfACNAAQAAADYAAAB2AGkAawBhAHMALgBjAGgAYQB1AGQAaABhAHIAeQBAAHEAbABv
AGcAaQBjAC4AYwBvAG0AAAAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAeAAAAAAA
AACBKx+kvqMQGZ1uAN0BD1QCAAAAgFYAaQBrAGEAcwAgAEMAaABhAHUAZABoAGEAcgB5AAAAUwBN
AFQAUAAAAHYAaQBrAGEAcwAuAGMAaABhAHUAZABoAGEAcgB5AEAAcQBsAG8AZwBpAGMALgBjAG8A
bQAAAB8ACV0BAAAANgAAAHYAaQBrAGEAcwAuAGMAaABhAHUAZABoAGEAcgB5AEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8A
GgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgEL
MAEAAAAQAAAAJthaeOgXR0WFsgkvj5in1gMAFwABAAAAQAA5AACYoV4Lms8BQAAIMHhatF4Lms8B
CwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAe
AAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsA
AIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAACCAAAAUgBlADoAIABbAFAAQQBU
AEMASABdACAAcQBsAGEANAB4AHgAeAA6ACAAUgBlAHQAdQByAG4AIAAtAEUATgBPAE0ARQBNACAA
bwBuACAAbQBlAG0AbwByAHkAIABhAGwAbABvAGMAYQB0AGkAbwBuACAAZgBhAGkAbAB1AHIAZQAA
AAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2AAAAAAAfAEIQAQAAAD4AAAA8ADUAMwBCAEEA
QwBCADQAQQAuADcAMAA4ADAANwAwADYAQABjAHMALgB3AGkAcwBjAC4AZQBkAHUAPgAAAAAAAgFx
AAEAAAAqAAAAAQHPl7Wwb31o/uIXRkONZQuENG7h+puQzAMAgAAJcgCABHIrAIAAcTsAAAAfAHAA
AQAAAHoAAABbAFAAQQBUAEMASABdACAAcQBsAGEANAB4AHgAeAA6ACAAUgBlAHQAdQByAG4AIAAt
AEUATgBPAE0ARQBNACAAbwBuACAAbQBlAG0AbwByAHkAIABhAGwAbABvAGMAYQB0AGkAbwBuACAA
ZgBhAGkAbAB1AHIAZQAAAAAAHwA1EAEAAAB4AAAAPAAzAEYAQwA0AEEAQgA4AEIANAA3AEUAQwBE
ADUANAA2AEIAQwBEADQAQgAzADYAMQBBADYANABCAEUAQQBDAEQAOABDADYAQwAwAEYANwBCAEAA
YQB2AG0AYgAzAC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+AAAAHwA5EAEAAACSAQAAPAAyADAAMQA0
ADAANwAwADQAMQA4ADIANwA1ADYALgBHAEEAOQAzADEAOQBAAGgAaQBtAGEAbgBnAGkALQBEAGUA
bABsAD4AIAA8ADkANABEADAAQwBEADgAMwAxADQAQQAzADMAQQA0AEQAOQBEADgAMAAxAEMAMABG
AEUANgA4AEIANAAwADIAOQA1ADgAQgA4ADYANgBFAEIAQABHADkAVwAwADcANAA1AC4AYQBtAGUA
cgBpAGMAYQBzAC4AaABwAHEAYwBvAHIAcAAuAG4AZQB0AD4AIAA8AGEAbABwAGkAbgBlAC4ARABF
AEIALgAyAC4AMAAyAC4AMQA0ADAANwAwADQAMgAyADMANQAzADkAMAAuADEAOQA4ADQAQABsAG8A
YwBhAGwAaABvAHMAdAA2AC4AbABvAGMAYQBsAGQAbwBtAGEAaQBuADYAPgAgADwANQAzAEIAQQBD
AEIANABBAC4ANwAwADgAMAA3ADAANgBAAGMAcwAuAHcAaQBzAGMALgBlAGQAdQA+AAAAAAADAN4/
n04AAEAABzD81KpeC5rPAQMAJgAAAAAAAgFHAAEAAAAuAAAAYz1VUzthPSA7cD1RTG9naWM7bD1B
Vk1CMy0xNDA3MDcxNzQ2MjRaLTI4NzE3AAAAHwAVEAEAAABYAAAANwBGADkANgA3ADcANABEADAA
OAA5ADgARQAwADQANgBBADYAQgAzADkANwAxAEIANAA5AEUAMQAyAEIAQQAwAEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAAIBFDABAAAADAAAAHUBAAAH5wPpTwAAAB8A+j8BAAAAIAAAAFYAaQBrAGEA
cwAgAEMAaABhAHUAZABoAGEAcgB5AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBl
AHIALQBhAGcAZQBuAHQAAAAAAAEAAABGAAAATQBpAGMAcgBvAHMAbwBmAHQALQBNAGEAYwBPAHUA
dABsAG8AbwBrAC8AMQA0AC4AMwAuADkALgAxADMAMQAwADMAMAAAAAAAHwAAgB+k6zOoei5Cvnt5
4amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsA
aQBuAGcARQB4AAAAAQAAAA4BAABJAEkAPQAwADEAMAAxAEMARgA5AEEAMABCADUARQBBAEYAOAAz
ADIANAAyAEEAQgA3ADgARQAyAEYANAAxAEIANgAzADIARgAxAEEARQAwADAAQwA4AEEAMAAzADAA
OwBTAEIATQBJAEQAPQAzADsAUwAxAD0APAA1ADMAQgBBAEMAQgA0AEEALgA3ADAAOAAwADcAMAA2
AEAAYwBzAC4AdwBpAHMAYwAuAGUAZAB1AD4AOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8A
bgAgADEANAAuADIAIAAoAEIAdQBpAGwAZAAgADMAOAA3AC4AMAApACwAIABTAHQAYQBnAGUAPQBI
ADIAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEA
cwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAA
AHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAYAAAAWwAxADAALgAxAC4A
NAAuADEAMABdAAAAnas=

--_000_3FC4AB8B47ECD546BCD4B361A64BEACD8C6C0F7Bavmb3qlogicorg_--
