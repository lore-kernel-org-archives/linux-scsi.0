From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH] drivers: scsi: qla2xxx: Remove redundant declaration in
 'qla_gbl.h'
Date: Mon, 3 Nov 2014 04:54:57 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D0128570B02@AVMB1.qlogic.org>
References: <5454C804.50407@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_F5D084D6342F9B479C34599BB0A03E4D0128570B02AVMB1qlogicor_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32253 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbaKCEzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Nov 2014 23:55:00 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id sA34rZLp004767
	for <linux-scsi@vger.kernel.org>; Sun, 2 Nov 2014 20:55:00 -0800
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1qcs6vtesj-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 02 Nov 2014 20:54:59 -0800
In-Reply-To: <5454C804.50407@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--_000_F5D084D6342F9B479C34599BB0A03E4D0128570B02AVMB1qlogicor_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54655209CFD35D45977A89E2DECE266B@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>


>Remove 2 redundant extern inline functions: qla8044_set_qsnt_ready() and
>qla8044_need_reset_handler(). At present, within upstream next kernel
>source code, they are only used within "drivers/scsi/qla2xxx/qla_nx2.c".
>
>The related error and warnings (with allmodconfig under tile):
>
>    CC [M]  drivers/scsi/qla2xxx/qla_nx2.o
>  drivers/scsi/qla2xxx/qla_nx2.c:1633:1: error: static declaration of
>'qla8044_need_reset_handler' follows non-static declaration
>   qla8044_need_reset_handler(struct scsi_qla_host *vha)
>   ^
>  In file included from drivers/scsi/qla2xxx/qla_def.h:3706:0,
>                   from drivers/scsi/qla2xxx/qla_nx2.c:11:
>  drivers/scsi/qla2xxx/qla_gbl.h:756:20: note: previous declaration of
>'qla8044_need_reset_handler' was here
>   extern inline void qla8044_need_reset_handler(struct scsi_qla_host
>*vha);
>                      ^
>  drivers/scsi/qla2xxx/qla_gbl.h:756:20: warning: inline function
>'qla8044_need_reset_handler' declared but never defined
>  make[3]: *** [drivers/scsi/qla2xxx/qla_nx2.o] Error 1
>  make[2]: *** [drivers/scsi/qla2xxx] Error 2
>  make[1]: *** [drivers/scsi] Error 2
>  make: *** [drivers] Error 2
>
>    CC [M]  drivers/scsi/qla2xxx/qla_tmpl.o
>  In file included from drivers/scsi/qla2xxx/qla_def.h:3706:0,
>                   from drivers/scsi/qla2xxx/qla_tmpl.c:7:
>  drivers/scsi/qla2xxx/qla_gbl.h:755:20: warning: inline function
>'qla8044_set_qsnt_ready' declared but never defined
>   extern inline void qla8044_set_qsnt_ready(struct scsi_qla_host *vha);
>                    ^
>
>Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>---
> drivers/scsi/qla2xxx/qla_gbl.h | 2 --
> drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
> 2 files changed, 1 insertion(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_gbl.h
>b/drivers/scsi/qla2xxx/qla_gbl.h
>index b1865a7..7686bfe 100644
>--- a/drivers/scsi/qla2xxx/qla_gbl.h
>+++ b/drivers/scsi/qla2xxx/qla_gbl.h
>@@ -752,8 +752,6 @@ extern void qla8044_set_idc_dontreset(struct
>scsi_qla_host *ha);
> extern int qla8044_rd_direct(struct scsi_qla_host *vha, const uint32_t
>crb_reg);
> extern void qla8044_wr_direct(struct scsi_qla_host *vha,
> 			      const uint32_t crb_reg, const uint32_t value);
>-extern inline void qla8044_set_qsnt_ready(struct scsi_qla_host *vha);
>-extern inline void qla8044_need_reset_handler(struct scsi_qla_host *vha);
> extern int qla8044_device_state_handler(struct scsi_qla_host *vha);
> extern void qla8044_clear_qsnt_ready(struct scsi_qla_host *vha);
> extern void qla8044_clear_drv_active(struct qla_hw_data *);
>diff --git a/drivers/scsi/qla2xxx/qla_nx2.c
>b/drivers/scsi/qla2xxx/qla_nx2.c
>index 24a8528..ed4d6b6 100644
>--- a/drivers/scsi/qla2xxx/qla_nx2.c
>+++ b/drivers/scsi/qla2xxx/qla_nx2.c
>@@ -238,7 +238,7 @@ qla8044_rmw_crb_reg(struct scsi_qla_host *vha,
> 	return;
> }
>=20
>-inline void
>+static inline void
> qla8044_set_qsnt_ready(struct scsi_qla_host *vha)
> {
> 	uint32_t qsnt_state;
>--=20
>1.9.3


--_000_F5D084D6342F9B479C34599BB0A03E4D0128570B02AVMB1qlogicor_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IlskAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADkyQzc1OUM3
QzA4MEUwNDg5QTM0RERGMjZGNkMzNkRCAE4HAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HCwADAAQA
NgA5AAEAZwEBIIADAA4AAADeBwsAAwAEADYAOQABAGcBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAFAAAABSZTogW1BBVENIXSBkcml2ZXJzOiBzY3NpOiBxbGEyeHh4OiBS
ZW1vdmUgcmVkdW5kYW50IGRlY2xhcmF0aW9uIGluICdxbGFfZ2JsLmgnALYbAQOQBgAQEgAANgAA
AAIBfwABAAAAPgAAADxGNUQwODRENjM0MkY5QjQ3OUMzNDU5OUJCMEEwM0U0RDAxMjg1NzBCMDJA
QVZNQjEucWxvZ2ljLm9yZz4AAAALAB8OAQAAAAIBCRABAAAA3AUAANgFAADxDgAATFpGdWqjjgNh
AApmYmlkBAAAY2PAcGcxMjUyAP4DQ/B0ZXh0AfcCpAPjAgAEY2gKwHNldDAg7wdtAoMAUBFNMgqA
BrQCgJZ9CoAIyDsJYjE5DsC/CcMWcgoyFnECgBViKgmwcwnwBJBhdAWyDlADYHOibwGAIEV4EcFu
GDBdBlJ2BJAXtgIQcgDAdH0IUG4aMRAgBcAFoBtkZJogA1IgECIXslx2CJDkd2sLgGQ1HVME8AdA
DRdwMApxF/Jia21rBnMBkAAgIEJNX0LgRUdJTn0K/AHxC/EQIEFjawmALWJ5BjoGAQhwYXYgS2EA
c2h5YXAgPHNJIlMuayLEQHEJAGeFDlAuBaBtPlxsC4DGZQqBJPs+UmUEYBow6CAyIAlxdR3AAHAF
QD8QMQSSC4Ak8hxwJwBjdBppAiBzIiAkMGE4MIg0NF8SAV9xcwIwAl8JcGFkeSgpIP8AcAswJdUp
BhhQCYAqASmC1RmhZB5wcipgLiGQBUAmcCwSAjAsIAPwdGjxC4AgdXAfYCoRHLAYUO0QQCAhwASg
ZQlQJdUZIH0IcGMZ4AWgAQAtwC4AZVZ5KoAJcCACIGwxEHVnEgAcYC3lImQFEBoxc5YvBPAAkC8p
ATJ4M6CTM1IrsHgyJJAiLiXG/SXGVDDwJsELYBxCBJADYH8FwCqRLdAKwAMAGcAEICgzLeIqgGxs
BGEb4WZpPmcuQB3AG7EokB5wKToFNJ4gOnFDQyBbTe5dOnAynzOqbzn4Oz8zq+A6MTYzMz+QIiA2
U/ciIB9hKJBjPaAFkAtgGHFrKKExYGYlxicrTyxXJ78ccAbwCQAeMC7QAiAtQJ/fC5A6CEJ/LFgu
cXUogECANz5BKbAz8WgZEAVAKnbVEdApOfleOfhJA6A4cPcecCfRQSB1AQAcZT2/M6YBAQEuaDoz
NzA2+DowLDn6T91Mjz5/P4FnP/A9H1GvX2cCYE6RN/41TvAB0CIgRLAQICIgLVH/HWAIYAQgQQ9C
H0MvNvAEIM8w8AlwOfknfHZvDdBGv/9Hz0jcJcZJwxYgT09hikrJ/1P/VQ9WEzb1IiAn7Vg/XW/n
RAFXVBxRYnUFQBhQGjF/V0E4cBhQKrc6cADAIcBb9DNdIiAqbFA60GNPPEvdOwBFNmMAUGs8Mmwv
bTn3boYOwGs8MXAfbTFx32ukn3N8dK85/zsPM3l0bQtQ/zz6S39Q702fTq9hj1DPee+7evE/gDdT
T4H/VWg1ZW//Zn9niimMaW9qf1tvXH0pjd9en0mHYK9h3zTaUziAavFqLRkwZiHzQzDwA6BHOxmx
IyBnGbEkkJTBLjXgaTVqQGcAwAMQJJo8Pi2XcHgHhF9kWyB83yahl4+YnzQFmhMrmngmsNd8AgQg
GZRkLcAxJ9ESAKMAICihKCspLcAzV0HzHnAokygtSgclxg3gASDnmlEkYAVAYS+bH2RbJcZ+YqKv
o78l8x2xEDCK0DEAODY1YTcuLjeyNqgQYmYZ4B6RNo4g75b5oo+mHyXVK6ygitCqPzOrTyXzQECa
UFXgMizmOJ0wr6I2IK9hJ3WNj/0N0GN+sAIhLBOPNS+Xj8y/kLsndwVAjdYLIH6waQlwvyiAjz9J
dy3AG+FJkXW2EVwzMnrAJcYFAGIqAWfztP9cjHdytv+4D3gHDIT/v9SRpbksG9C6lLkOXIAHQPsK
UJDYLYyvjb+Oz4/fw7//xM9oH15Px7+1P8V3AQAdYP8wUClwRQHP0MufzK/Nv8ob/1dwKiC88MZP
0T/ST9Nf1GP5rQB2XwDQKJAaMNVWSTP2d36wGIBhSbCQ2KHvrU+fM+ekn90f3iynlDI0xaDNDrA4
qGAJgDRkqLCwUH+pD9x/4A+sP+R/5Y+vYjLwMzgsN50w6ZSvYbZXfm3asLqF1V++j7+UJsF0/whw
EzC/KCBAvzeXBsmp5hf/RPXwn3hhxY/VD0kvv0YAAH/ti8FHKcPP88iY4/AlxjFwLjkuMyTsFUL8
AB8AQgABAAAAHgAAAFMAYQB1AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAAAAHwBlAAEAAAA0AAAA
cwBhAHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AZAAB
AAAACgAAAFMATQBUAFAAAAAAAAIBQQABAAAAdAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFMA
YQB1AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAFMATQBUAFAAAABzAGEAdQByAGEAdgAuAGsAYQBz
AGgAeQBhAHAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwACXQEAAAA0AAAAcwBhAHUAcgBhAHYA
LgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A5V8BAAAAPAAAAHMAaQBw
ADoAcwBhAHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A
GgwBAAAAHgAAAFMAYQB1AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAAAAHwAfDAEAAAA0AAAAcwBh
AHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AHgwBAAAA
CgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAdAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFMAYQB1
AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAFMATQBUAFAAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgA
eQBhAHAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA0AAAAcwBhAHUAcgBhAHYALgBr
AGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A+D8BAAAAHgAAAFMAYQB1AHIA
YQB2ACAASwBhAHMAaAB5AGEAcAAAAAAAHwAjQAEAAAA0AAAAcwBhAHUAcgBhAHYALgBrAGEAcwBo
AHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB
+T8BAAAAdAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFMAYQB1AHIAYQB2ACAASwBhAHMAaAB5
AGEAcAAAAFMATQBUAFAAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBhAHAAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwAJXQEAAAA0AAAAcwBhAHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBs
AG8AZwBpAGMALgBjAG8AbQAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAAAAAA
AAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAACwBAOgEAAAADAP0/5AQA
AAIBCzABAAAAEAAAAJLHWcfAgOBImjTd8m9sNtsDABcAAQAAAEAAOQCAJpZQIvfPAUAACDAV4b1Q
IvfPAQsAAIAIIAYAAAAAAMAAAAAAAABGAAAAABSFAAABAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMA
AAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAoAAAAFIAZQA6ACAAWwBQ
AEEAVABDAEgAXQAgAGQAcgBpAHYAZQByAHMAOgAgAHMAYwBzAGkAOgAgAHEAbABhADIAeAB4AHgA
OgAgAFIAZQBtAG8AdgBlACAAcgBlAGQAdQBuAGQAYQBuAHQAIABkAGUAYwBsAGEAcgBhAHQAaQBv
AG4AIABpAG4AIAAnAHEAbABhAF8AZwBiAGwALgBoACcAAAAfAD0AAQAAAAoAAABSAGUAOgAgAAAA
AAADADYAAAAAAB8AQhABAAAANgAAADwANQA0ADUANABDADgAMAA0AC4ANQAwADQAMAA3AEAAZwBt
AGEAaQBsAC4AYwBvAG0APgAAAAAAAgFxAAEAAAAbAAAAAQHP9ciXzDxSSqDZGE6k65TOWg0d85xP
O1iAAB8AcAABAAAAmAAAAFsAUABBAFQAQwBIAF0AIABkAHIAaQB2AGUAcgBzADoAIABzAGMAcwBp
ADoAIABxAGwAYQAyAHgAeAB4ADoAIABSAGUAbQBvAHYAZQAgAHIAZQBkAHUAbgBkAGEAbgB0ACAA
ZABlAGMAbABhAHIAYQB0AGkAbwBuACAAaQBuACAAJwBxAGwAYQBfAGcAYgBsAC4AaAAnAAAAHwA1
EAEAAAB8AAAAPABGADUARAAwADgANABEADYAMwA0ADIARgA5AEIANAA3ADkAQwAzADQANQA5ADkA
QgBCADAAQQAwADMARQA0AEQAMAAxADIAOAA1ADcAMABCADAAMgBAAEEAVgBNAEIAMQAuAHEAbABv
AGcAaQBjAC4AbwByAGcAPgAAAB8AORABAAAANgAAADwANQA0ADUANABDADgAMAA0AC4ANQAwADQA
MAA3AEAAZwBtAGEAaQBsAC4AYwBvAG0APgAAAAAAAwDeP59OAABAAAcwt3d2UCL3zwEDACYAAAAA
AAIBRwABAAAALgAAAGM9VVM7YT0gO3A9UUxvZ2ljO2w9QVZNQjEtMTQxMTAzMDQ1NDU3Wi0zNzAz
OAAAAB8AFRABAAAAWAAAADUANAA2ADUANQAyADAAOQBDAEYARAAzADUARAA0ADUAOQA3ADcAQQA4
ADkARQAyAEQARQBDAEUAMgA2ADYAQgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAACARQwAQAAAAwA
AADQAAAAY99x7EEAAAAfAPo/AQAAAB4AAABTAGEAdQByAGEAdgAgAEsAYQBzAGgAeQBhAHAAAAAA
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAAAAABAAAA
RgAAAE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAuADQALgA1
AC4AMQA0ADEAMAAwADMAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUA
cgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAAKAQAASQBJ
AD0AMAAxADAAMQBDAEYARgA3ADIAMgA1ADAAOAA2AEMAQQBBADgAQQA0ADIANwAzAEMAQwA0ADQA
MAA5ADgARABDADQAMwBDADUANwBDAEQANQA1AEIARgAzADsAUwBCAE0ASQBEAD0ANAAwADkAOwBT
ADEAPQA8ADUANAA1ADQAQwA4ADAANAAuADUAMAA0ADAANwBAAGcAbQBhAGkAbAAuAGMAbwBtAD4A
OwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADIAIAAoAEIAdQBpAGwAZAAg
ADMAOAA3AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAA
AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcA
LQBpAHAAAAAAAAEAAAAYAAAAWwAxADAALgAxAC4ANAAuADEAMABdAAAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAFgAAAGQAaQBzAGMAbABhAGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMA
AAAAAEgP

--_000_F5D084D6342F9B479C34599BB0A03E4D0128570B02AVMB1qlogicor_--
