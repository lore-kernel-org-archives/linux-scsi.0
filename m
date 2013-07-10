From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 1/1] scsi: qla4xxx: change some variables to hexadecimal
 string via %pm, %pmR and %pM  formats
Date: Wed, 10 Jul 2013 11:24:38 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD30EFCB44@avmb3.qlogic.org>
References: <1373092804-1380-1-git-send-email-Oleksandr.Khoshaba@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_3FC4AB8B47ECD546BCD4B361A64BEACD30EFCB44avmb3qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:46879
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474Ab3GJLYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jul 2013 07:24:43 -0400
Received: from mail123-va3 (localhost [127.0.0.1])	by
 mail123-va3-R.bigfish.com (Postfix) with ESMTP id 4DF66C0336	for
 <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2013 11:24:42 +0000 (UTC)
Received: from VA3EHSMHS030.bigfish.com (unknown [10.7.14.229])	by
 mail123-va3.bigfish.com (Postfix) with ESMTP id 256A6440062	for
 <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2013 11:24:40 +0000 (UTC)
In-Reply-To: <1373092804-1380-1-git-send-email-Oleksandr.Khoshaba@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>

--_000_3FC4AB8B47ECD546BCD4B361A64BEACD30EFCB44avmb3qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF0F619C1FE77743A6576F32C109EE4D@qlogic.com>
Content-Transfer-Encoding: quoted-printable

-----Original Message-----
From: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>
Date: Saturday 6 July 2013 12:10 PM
To: scsi <linux-scsi@vger.kernel.org>, Dept-Eng Linux Driver
<Linux-Driver@qlogic.com>, "James E.J. Bottomley"
<JBottomley@parallels.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Oleksandr Khoshaba
<Oleksandr.Khoshaba@gmail.com>
Subject: [PATCH 1/1] scsi: qla4xxx: change some variables to hexadecimal
string via %pm, %pmR and %pM  formats

>The patch modifies some variables using the formats '%pm', '%pmR', '%pM'
>and prints them as a hexadecimal string with the '' and ':'  separators.
>
>Signed-off-by: Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>
>---
> drivers/scsi/qla4xxx/ql4_mbx.c |    6 ++----
> drivers/scsi/qla4xxx/ql4_nx.c  |    8 ++------
> drivers/scsi/qla4xxx/ql4_os.c  |   15 ++++-----------
> 3 files changed, 8 insertions(+), 21 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c
>b/drivers/scsi/qla4xxx/ql4_mbx.c
>index a501bea..004ada6 100644
>--- a/drivers/scsi/qla4xxx/ql4_mbx.c
>+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
>@@ -1837,10 +1837,8 @@ int qla4xxx_set_param_ddbentry(struct
>scsi_qla_host *ha,
> 	ptid =3D (uint16_t *)&fw_ddb_entry->isid[1];
> 	*ptid =3D cpu_to_le16((uint16_t)ddb_entry->sess->target_id);
>=20
>-	DEBUG2(ql4_printk(KERN_INFO, ha, "ISID [%02x%02x%02x%02x%02x%02x]\n",
>-			  fw_ddb_entry->isid[5], fw_ddb_entry->isid[4],
>-			  fw_ddb_entry->isid[3], fw_ddb_entry->isid[2],
>-			  fw_ddb_entry->isid[1], fw_ddb_entry->isid[0]));
>+	DEBUG2(ql4_printk(KERN_INFO, ha, "ISID [%pmR]\n",
>+			  fw_ddb_entry->isid));
>=20
> 	iscsi_opts =3D le16_to_cpu(fw_ddb_entry->iscsi_options);
> 	memset(fw_ddb_entry->iscsi_alias, 0, sizeof(fw_ddb_entry->iscsi_alias));
>diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
>index eaf00c1..2bc1046 100644
>--- a/drivers/scsi/qla4xxx/ql4_nx.c
>+++ b/drivers/scsi/qla4xxx/ql4_nx.c
>@@ -3455,12 +3455,8 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host
>*ha)
> 	ha->phy_port_num =3D sys_info->port_num;
> 	ha->iscsi_pci_func_cnt =3D sys_info->iscsi_pci_func_cnt;
>=20
>-	DEBUG2(printk("scsi%ld: %s: "
>-	    "mac %02x:%02x:%02x:%02x:%02x:%02x "
>-	    "serial %s\n", ha->host_no, __func__,
>-	    ha->my_mac[0], ha->my_mac[1], ha->my_mac[2],
>-	    ha->my_mac[3], ha->my_mac[4], ha->my_mac[5],
>-	    ha->serial_number));
>+	DEBUG2(printk("scsi%ld: %s: mac %pM serial %s\n", ha->host_no,
>+	    __func__, ha->my_mac, ha->serial_number));
>=20
> 	status =3D QLA_SUCCESS;
>=20
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index b246b3c..2797b8f 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -4786,13 +4786,9 @@ static int qla4xxx_compare_tuple_ddb(struct
>scsi_qla_host *ha,
> 	 * ISID would not match firmware generated ISID.
> 	 */
> 	if (is_isid_compare) {
>-		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: old ISID [%02x%02x%02x"
>-			"%02x%02x%02x] New ISID [%02x%02x%02x%02x%02x%02x]\n",
>-			__func__, old_tddb->isid[5], old_tddb->isid[4],
>-			old_tddb->isid[3], old_tddb->isid[2], old_tddb->isid[1],
>-			old_tddb->isid[0], new_tddb->isid[5], new_tddb->isid[4],
>-			new_tddb->isid[3], new_tddb->isid[2], new_tddb->isid[1],
>-			new_tddb->isid[0]));
>+		DEBUG2(ql4_printk(KERN_INFO, ha,
>+			"%s: old ISID [%pmR] New ISID [%pmR]\n",
>+			__func__, old_tddb->isid, new_tddb->isid));
>=20
> 		if (memcmp(&old_tddb->isid[0], &new_tddb->isid[0],
> 			   sizeof(old_tddb->isid)))
>@@ -6211,10 +6207,7 @@ qla4xxx_sysfs_ddb_get_param(struct
>iscsi_bus_flash_session *fnode_sess,
> 		rc =3D sprintf(buf, "%u\n", fnode_conn->keepalive_timeout);
> 		break;
> 	case ISCSI_FLASHNODE_ISID:
>-		rc =3D sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",
>-			     fnode_sess->isid[0], fnode_sess->isid[1],
>-			     fnode_sess->isid[2], fnode_sess->isid[3],
>-			     fnode_sess->isid[4], fnode_sess->isid[5]);
>+		rc =3D sprintf(buf, "%pm\n", fnode_sess->isid);
> 		break;
> 	case ISCSI_FLASHNODE_TSID:
> 		rc =3D sprintf(buf, "%u\n", fnode_sess->tsid);
>--=20
>1.7.9.5


Thanks for the patch.
Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


--_000_3FC4AB8B47ECD546BCD4B361A64BEACD30EFCB44avmb3qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+Ill1AQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAEQ1RjM0MjQ4
OURDNzcxNDI5MENDOUQ5QTBCRTBCNjI4ADgHAQ2ABAACAAAAAgACAAEFgAMADgAAAN0HBwAKAAsA
GAAmAAMAQQEBIIADAA4AAADdBwcACgALABgAJgADAEEBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAGoAAABSZTogW1BBVENIIDEvMV0gc2NzaTogcWxhNHh4eDogY2hhbmdl
IHNvbWUgdmFyaWFibGVzIHRvIGhleGFkZWNpbWFsIHN0cmluZyB2aWEgJXBtLCAlcG1SIGFuZCAl
cE0gIGZvcm1hdHMAXyMBA5AGAHgVAAAyAAAAAgF/AAEAAAA8AAAAPDNGQzRBQjhCNDdFQ0Q1NDZC
Q0Q0QjM2MUE2NEJFQUNEMzBFRkNCNDRAYXZtYjMucWxvZ2ljLm9yZz4ACwAfDgEAAAACAQkQAQAA
ANgIAADUCAAAJhUAAExaRnVeE60LYQAKZmJpZAQAAGNjwHBnMTI1MgD+A0PwdGV4dAH3AqQD4wIA
BGNoCsBzZXQwIO8HbQKDAFARTTIKgAa0AoCWfQqACMg7CWIxOQ7AvwnDFnIKMhZxAoAVYioJsHMJ
8ASQYXQFsg5QA2Bzom8BgCBFeBHBbhgwXQZSdgSQF7YCEHIAwHR9CFBuGjEQIAXABaAbZGSaIANS
IBAiF7JcdgiQ5HdrC4BkNR1TBPAHQA0XcDAKcRfyYmttawZzAZAAICBCTV9C4EVHSU59CvwB8Qvx
1CAtIaJPBRBnC4AHQDMF0AeQc2EYMCGjXGwVC4BlCoBGA2E6IE+XHnAfUABwZAXAS2gZEGER0GJh
IDwG8CQ1LrJrJMVAZwDAAxAuBaDUbT4jRUQYgGUj8AYQAnQIcGRheSA2IBhKdWwoYAHQMTMgRQ6Q
Oh6QIFBNI0VUPm8j8ATwAJAlMCNRdXhyLSpyQHYYMCXRBJFlAybABbBnPiwgRGXJBTAtRRnAIEwq
4iyQVwUQGjEjRTwtMy0tlEA2cQkAIiBjJtMsgCJKQmEHgkUuSi4fsG+nAkADcB5weSIt9kow185A
CrEHQB5wbHMvpQYQKQhwYXYkoGEk4Hlh/nAlMCKwM8Il4DQkLzojRTRDYyPwQR3AKGBTaMxldhHA
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
YwBoAGEAdQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAGQAAQAAAAoAAABT
AE0AVABQAAAAAAACAUEAAQAAAHgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBWAGkAawBhAHMA
IABDAGgAYQB1AGQAaABhAHIAeQAAAFMATQBUAFAAAAB2AGkAawBhAHMALgBjAGgAYQB1AGQAaABh
AHIAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAJdAQAAADYAAAB2AGkAawBhAHMALgBjAGgA
YQB1AGQAaABhAHIAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8A5V8BAAAAPgAAAHMAaQBw
ADoAdgBpAGsAYQBzAC4AYwBoAGEAdQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
AAAfABoMAQAAACAAAABWAGkAawBhAHMAIABDAGgAYQB1AGQAaABhAHIAeQAAAB8AHwwBAAAANgAA
AHYAaQBrAGEAcwAuAGMAaABhAHUAZABoAGEAcgB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAA
HwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAAB4AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIA
AACAVgBpAGsAYQBzACAAQwBoAGEAdQBkAGgAYQByAHkAAABTAE0AVABQAAAAdgBpAGsAYQBzAC4A
YwBoAGEAdQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA2AAAAdgBp
AGsAYQBzAC4AYwBoAGEAdQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAPg/
AQAAACAAAABWAGkAawBhAHMAIABDAGgAYQB1AGQAaABhAHIAeQAAAB8AI0ABAAAANgAAAHYAaQBr
AGEAcwAuAGMAaABhAHUAZABoAGEAcgB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAiQAEA
AAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAAB4AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAVgBp
AGsAYQBzACAAQwBoAGEAdQBkAGgAYQByAHkAAABTAE0AVABQAAAAdgBpAGsAYQBzAC4AYwBoAGEA
dQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAJXQEAAAA2AAAAdgBpAGsAYQBz
AC4AYwBoAGEAdQBkAGgAYQByAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAALAEA6AQAAAB8A
GgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgEL
MAEAAAAQAAAA1fNCSJ3HcUKQzJ2aC+C2KAMAFwABAAAAQAA5AADfDRBgfc4BQAAIMLtjMRBgfc4B
CwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAe
AAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsA
AIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAADUAAAAUgBlADoAIABbAFAAQQBU
AEMASAAgADEALwAxAF0AIABzAGMAcwBpADoAIABxAGwAYQA0AHgAeAB4ADoAIABjAGgAYQBuAGcA
ZQAgAHMAbwBtAGUAIAB2AGEAcgBpAGEAYgBsAGUAcwAgAHQAbwAgAGgAZQB4AGEAZABlAGMAaQBt
AGEAbAAgAHMAdAByAGkAbgBnACAAdgBpAGEAIAAlAHAAbQAsACAAJQBwAG0AUgAgAGEAbgBkACAA
JQBwAE0AIAAgAGYAbwByAG0AYQB0AHMAAAAfAD0AAQAAAAoAAABSAGUAOgAgAAAAAAADADYAAAAA
AB8AQhABAAAAgAAAADwAMQAzADcAMwAwADkAMgA4ADAANAAtADEAMwA4ADAALQAxAC0AZwBpAHQA
LQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0ATwBsAGUAawBzAGEAbgBkAHIALgBLAGgAbwBzAGgAYQBi
AGEAQABnAG0AYQBpAGwALgBjAG8AbQA+AAAAAgFxAAEAAAAbAAAAAQHOehOt4NRJew9eeka7ts5z
GQk3iplenYAAAB8AcAABAAAAzAAAAFsAUABBAFQAQwBIACAAMQAvADEAXQAgAHMAYwBzAGkAOgAg
AHEAbABhADQAeAB4AHgAOgAgAGMAaABhAG4AZwBlACAAcwBvAG0AZQAgAHYAYQByAGkAYQBiAGwA
ZQBzACAAdABvACAAaABlAHgAYQBkAGUAYwBpAG0AYQBsACAAcwB0AHIAaQBuAGcAIAB2AGkAYQAg
ACUAcABtACwAIAAlAHAAbQBSACAAYQBuAGQAIAAlAHAATQAgACAAZgBvAHIAbQBhAHQAcwAAAB8A
NRABAAAAeAAAADwAMwBGAEMANABBAEIAOABCADQANwBFAEMARAA1ADQANgBCAEMARAA0AEIAMwA2
ADEAQQA2ADQAQgBFAEEAQwBEADMAMABFAEYAQwBCADQANABAAGEAdgBtAGIAMwAuAHEAbABvAGcA
aQBjAC4AbwByAGcAPgAAAAMA3j+fTgAAQAAHMDfeJxBgfc4BAwAmAAAAAAACAUcAAQAAAC4AAABj
PVVTO2E9IDtwPVFMb2dpYztsPUFWTUIzLTEzMDcxMDExMjQzOFotNjY2MTEAAAAfABUQAQAAAFgA
AABCAEYAMABGADYAMQA5AEMAMQBGAEUANwA3ADcANAAzAEEANgA1ADcANgBGADMAMgBDADEAMAA5
AEUARQA0AEQAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEUMAEAAAAMAAAAFAEAAKH9mnEtAAAA
HwD6PwEAAAAgAAAAVgBpAGsAYQBzACAAQwBoAGEAdQBkAGgAYQByAHkAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAWAAAAdQBzAGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAAAEYAAABNAGkAYwByAG8A
cwBvAGYAdAAtAE0AYQBjAE8AdQB0AGwAbwBvAGsALwAxADQALgAyAC4ANAAuADEAMgAwADgAMgA0
AAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4A
SQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAAUgEAAEkASQA9ADAAMQAwADEAQwBF
ADcARAA2ADAAMQAwADgAMgBBAEUAQQA1AEQANwAwAEEAOAA4ADcARAA0ADAAQgA5ADAANAA1ADEA
RQBFADIANQAyADYARQBBADgARgA7AFMAQgBNAEkARAA9ADEANQA7AFMAMQA9ADwAMQAzADcAMwAw
ADkAMgA4ADAANAAtADEAMwA4ADAALQAxAC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0A
TwBsAGUAawBzAGEAbgBkAHIALgBLAGgAbwBzAGgAYQBiAGEAQABnAG0AYQBpAGwALgBjAG8AbQA+
ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAyACAAKABCAHUAaQBsAGQA
IAAzADEAOAAuADAAKQAsACAAUwB0AGEAZwBlAD0ASAAyAAAAAAADAA00/T8AAB8AAICGAwIAAAAA
AMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAA
AAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBn
AC0AaQBwAAAAAAABAAAAGgAAAFsAMQAwAC4AMwA1AC4ANAAuADYAOQBdAAAAAAAseA==

--_000_3FC4AB8B47ECD546BCD4B361A64BEACD30EFCB44avmb3qlogicorg_--
