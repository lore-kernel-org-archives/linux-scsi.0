From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 02/10] qla2xxx: Clean up qla84xx_mgmt_cmd()
Date: Wed, 12 Jun 2013 08:06:38 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D35390FCB@AVMB1.qlogic.org>
References: <51AF3733.2010601@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_F5D084D6342F9B479C34599BB0A03E4D35390FCBAVMB1qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36279
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545Ab3FLIGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jun 2013 04:06:44 -0400
Received: from mail49-ch1 (localhost [127.0.0.1])	by mail49-ch1-R.bigfish.com
 (Postfix) with ESMTP id CEDBE1000A3	for <linux-scsi@vger.kernel.org>; Wed, 12
 Jun 2013 08:06:43 +0000 (UTC)
Received: from CH1EHSMHS007.bigfish.com (snatpool3.int.messaging.microsoft.com
 [10.43.68.228])	by mail49-ch1.bigfish.com (Postfix) with ESMTP id A366E12005B
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2013 08:06:40 +0000 (UTC)
In-Reply-To: <51AF3733.2010601@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>

--_000_F5D084D6342F9B479C34599BB0A03E4D35390FCBAVMB1qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1953CB21931394F95CD5BC1BAA3539F@qlogic.com>
Content-Transfer-Encoding: quoted-printable

HI Bart,
Missing msg ids need to be updated on qla_dbg.c file. Here is an updated
patch.

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c
b/drivers/scsi/qla2xxx/qla_bsg.c
index 25ded57..9520b1f 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1084,14 +1084,6 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
                return -EINVAL;
        }
=20
-       ql84_mgmt =3D (struct qla_bsg_a84_mgmt *)((char *)bsg_job->request =
+
-               sizeof(struct fc_bsg_request));
-       if (!ql84_mgmt) {
-               ql_log(ql_log_warn, vha, 0x703b,
-                   "MGMT header not provided, exiting.\n");
-               return -EINVAL;
-       }
-
        mn =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
        if (!mn) {
                ql_log(ql_log_warn, vha, 0x703c,
@@ -1102,7 +1094,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
        memset(mn, 0, sizeof(struct access_chip_84xx));
        mn->entry_type =3D ACCESS_CHIP_IOCB_TYPE;
        mn->entry_count =3D 1;
-
+       ql84_mgmt =3D (void *)bsg_job->request + sizeof(struct
fc_bsg_request);
        switch (ql84_mgmt->mgmt.cmd) {
        case QLA84_MGMT_READ_MEM:
        case QLA84_MGMT_GET_INFO:
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c
b/drivers/scsi/qla2xxx/qla_dbg.c
index 980dcbc..1c1972b 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -36,7 +36,7 @@
  * |                              |                    | 0x70a8,0x70ab, |
  * |                              |                    | 0x70ad-0x70ae, |
  * |                              |                    | 0x70d1-0x70da, |
- * |                              |                    | 0x7047
     |
+ * |                              |                    | 0x7047,0x703b |
  * | Task Management              |       0x803c       | 0x8025-0x8026  |
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |               |


Thanks,
~Saurav



>Remove dead code, simplify a pointer computation and move the
>ql84_mgmt assignment to just before its first use.
>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>Cc: Chad Dupuis <chad.dupuis@qlogic.com>
>Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
>---
> drivers/scsi/qla2xxx/qla_bsg.c |    9 +--------
> 1 file changed, 1 insertion(+), 8 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_bsg.c
>b/drivers/scsi/qla2xxx/qla_bsg.c
>index 7221521..cf07491 100644
>--- a/drivers/scsi/qla2xxx/qla_bsg.c
>+++ b/drivers/scsi/qla2xxx/qla_bsg.c
>@@ -1084,14 +1084,6 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
> 		return -EINVAL;
> 	}
>=20
>-	ql84_mgmt =3D (struct qla_bsg_a84_mgmt *)((char *)bsg_job->request +
>-		sizeof(struct fc_bsg_request));
>-	if (!ql84_mgmt) {
>-		ql_log(ql_log_warn, vha, 0x703b,
>-		    "MGMT header not provided, exiting.\n");
>-		return -EINVAL;
>-	}
>-
> 	mn =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
> 	if (!mn) {
> 		ql_log(ql_log_warn, vha, 0x703c,
>@@ -1103,6 +1095,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
> 	mn->entry_type =3D ACCESS_CHIP_IOCB_TYPE;
> 	mn->entry_count =3D 1;
>=20
>+	ql84_mgmt =3D (void *)bsg_job->request + sizeof(struct fc_bsg_request);
> 	switch (ql84_mgmt->mgmt.cmd) {
> 	case QLA84_MGMT_READ_MEM:
> 	case QLA84_MGMT_GET_INFO:
>--=20
>1.7.10.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


--_000_F5D084D6342F9B479C34599BB0A03E4D35390FCBAVMB1qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
HUsgOLXRHnC4MnMoLd86Fr1Xej/I/yruPoT/0d+ntRQuVAHAMjEOsDEvIOJjATA3NDmvcIE7x+L/
0L/UT7UFhL/ZL9KoNf83D/9gT2FfyDYMhAGgUa/h2j1o/+Ixx4bikz8PQB9BL0I/5Yn/4pNEn0Wv
5ZlHf0iG6tlbz/9LH+qOTX9Oj0+f6sri7+WK/+S4yBj3U1UvVj9XT1hb5EW/Wa/iKvCfXN/dOR6Q
M96h/V7iNV8/37/gz/o9Z09oX/9paAhfay/lSEMQ5g9uD28f/+wPcZrkRXLfc+/kCXW/ds1/Fl94
38eW5VfWgC8QHpAuN9eHx3i09lQj8GtAc3WtykBj20AkEWb1EG25Af8mQSIwZJC+sGNwuJG5ER+R
jyJQ8+AeSrHxdXgt27LuIs1BtPYgUmK2QLcAZGB/txFjQGVAozG7AvtgBxByomS30G9AdszgcsYw
29twshBswMK09k27wiSnD81Bu7C4cKORaHR0cKg6Ly8lTS8kpy0nopIuKDBtbLQcfX19MAEr8B8A
QgABAAAAHgAAAFMAYQB1AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAAAAHwBlAAEAAAA0AAAAcwBh
AHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AZAABAAAA
CgAAAFMATQBUAFAAAAAAAAIBQQABAAAAdAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFMAYQB1
AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAFMATQBUAFAAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgA
eQBhAHAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwACXQEAAAA0AAAAcwBhAHUAcgBhAHYALgBr
AGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A5V8BAAAAPAAAAHMAaQBwADoA
cwBhAHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AGgwB
AAAAHgAAAFMAYQB1AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAAAAHwAfDAEAAAA0AAAAcwBhAHUA
cgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AHgwBAAAACgAA
AFMATQBUAFAAAAAAAAIBGQwBAAAAdAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFMAYQB1AHIA
YQB2ACAASwBhAHMAaAB5AGEAcAAAAFMATQBUAFAAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBh
AHAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA0AAAAcwBhAHUAcgBhAHYALgBrAGEA
cwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A+D8BAAAAHgAAAFMAYQB1AHIAYQB2
ACAASwBhAHMAaAB5AGEAcAAAAAAAHwAjQAEAAAA0AAAAcwBhAHUAcgBhAHYALgBrAGEAcwBoAHkA
YQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8B
AAAAdAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFMAYQB1AHIAYQB2ACAASwBhAHMAaAB5AGEA
cAAAAFMATQBUAFAAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBhAHAAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAHwAJXQEAAAA0AAAAcwBhAHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8A
ZwBpAGMALgBjAG8AbQAAAAsAQDoBAAAAHwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAAD
APE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAACZJvtWmG4rTbXiXYCAmIF6AwAXAAEA
AABAADkAALt0w0NnzgFAAAgwHtbVw0NnzgELAACACCAGAAAAAADAAAAAAAAARgAAAAAUhQAAAQAA
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUA
AAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAAAAAf
ADcAAQAAAG4AAABSAGUAOgAgAFsAUABBAFQAQwBIACAAMAAyAC8AMQAwAF0AIABxAGwAYQAyAHgA
eAB4ADoAIABDAGwAZQBhAG4AIAB1AHAAIABxAGwAYQA4ADQAeAB4AF8AbQBnAG0AdABfAGMAbQBk
ACgAKQAAAAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2AAAAAAAfAEIQAQAAADYAAAA8ADUA
MQBBAEYAMwA3ADMAMwAuADIAMAAxADAANgAwADEAQABhAGMAbQAuAG8AcgBnAD4AAAAAAAIBcQAB
AAAAGwAAAAEBzmHtOVYBKET6tixAqA+UuygsbsOZMpU1gAAfAHAAAQAAAGYAAABbAFAAQQBUAEMA
SAAgADAAMgAvADEAMABdACAAcQBsAGEAMgB4AHgAeAA6ACAAQwBsAGUAYQBuACAAdQBwACAAcQBs
AGEAOAA0AHgAeABfAG0AZwBtAHQAXwBjAG0AZAAoACkAAAAAAB8ANRABAAAAeAAAADwARgA1AEQA
MAA4ADQARAA2ADMANAAyAEYAOQBCADQANwA5AEMAMwA0ADUAOQA5AEIAQgAwAEEAMAAzAEUANABE
ADMANQAzADkAMABGAEMAQgBAAEEAVgBNAEIAMQAuAHEAbABvAGcAaQBjAC4AbwByAGcAPgAAAAMA
3j+fTgAAQAAHMP6xzsNDZ84BAwAmAAAAAAACAUcAAQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYzts
PUFWTUIxLTEzMDYxMjA4MDYzOFotMzM3ODcAAAAfABUQAQAAAFgAAABEADEAOQA1ADMAQwBCADIA
MQA5ADMAMQAzADkANABGADkANQBDAEQANQBCAEMAMQBCAEEAQQAzADUAMwA5AEYAQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAAgEUMAEAAAAMAAAA8gAAAMNiK0VIAAAAHwD6PwEAAAAeAAAAUwBhAHUA
cgBhAHYAIABLAGEAcwBoAHkAYQBwAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAAdQBz
AGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAAAEgAAABNAGkAYwByAG8AcwBvAGYAdAAtAE0AYQBjAE8A
dQB0AGwAbwBvAGsALwAxADQALgAxADAALgAwAC4AMQAxADAAMwAxADAAAAAfAACAH6TrM6h6LkK+
e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMA
awBpAG4AZwBFAHgAAAABAAAACAEAAEkASQA9ADAAMQAwADEAQwBFADYANwA0ADMAQwAzAEEANQAw
ADQAQQAxADIAOQA4ADEAMQAyAEMARgA0ADkAQQBDAEQAQwBCAEMAQQAyAEMAOAAzAEEANgBFADUA
RQA7AFMAQgBNAEkARAA9ADEANgA7AFMAMQA9ADwANQAxAEEARgAzADcAMwAzAC4AMgAwADEAMAA2
ADAAMQBAAGEAYwBtAC4AbwByAGcAPgA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAA
MQA0AC4AMgAgACgAQgB1AGkAbABkACAAMwAxADgALgAwACkALAAgAFMAdABhAGcAZQA9AEgAMgAA
AAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEA
dAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBv
AHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAaAAAAWwAxADAALgAzADUALgA3AC4A
NAA1AF0AAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAABkAGkAcwBjAGwAYQBpAG0AZQBy
AAAAAAABAAAADgAAAGIAeQBwAGEAcwBzAAAAAADihQ==

--_000_F5D084D6342F9B479C34599BB0A03E4D35390FCBAVMB1qlogicorg_--
