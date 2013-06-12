From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 10/10] qla2xxx: Fix a memory leak in an error path of
 qla2x00_process_els()
Date: Wed, 12 Jun 2013 08:11:49 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D35391094@AVMB1.qlogic.org>
References: <51AF38A7.6020808@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_F5D084D6342F9B479C34599BB0A03E4D35391094AVMB1qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:11936
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443Ab3FLIMA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jun 2013 04:12:00 -0400
Received: from mail92-co9 (localhost [127.0.0.1])	by mail92-co9-R.bigfish.com
 (Postfix) with ESMTP id 5B2BF2055B	for <linux-scsi@vger.kernel.org>; Wed, 12
 Jun 2013 08:11:59 +0000 (UTC)
Received: from CO9EHSMHS007.bigfish.com (unknown [10.236.132.251])	by
 mail92-co9.bigfish.com (Postfix) with ESMTP id 0CB69D00059	for
 <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2013 08:11:56 +0000 (UTC)
In-Reply-To: <51AF38A7.6020808@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>

--_000_F5D084D6342F9B479C34599BB0A03E4D35391094AVMB1qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <56BAEE4BB6FE4F4CB25D4B56A387A10A@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Bart,
In this case online check is move to far, the vha is still not
dereferenced. The right patch is moving online flag just after getting vha.

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c
b/drivers/scsi/qla2xxx/qla_bsg.c
index 9520b1f..11f84dc 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -269,6 +269,12 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
                type =3D "FC_BSG_HST_ELS_NOLOGIN";
        }
=20
+       if (!vha->flags.online) {
+               ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
+               rval =3D -EIO;
+               goto done;
+       }
+
        /* pass through is supported only for ISP 4Gb or higher */
        if (!IS_FWI2_CAPABLE(ha)) {
                ql_dbg(ql_dbg_user, vha, 0x7001,
@@ -326,12 +332,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
                        NPH_FABRIC_CONTROLLER : NPH_F_PORT;
        }
=20
-       if (!vha->flags.online) {
-               ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
-               rval =3D -EIO;
-               goto done;
-       }
-
        req_sg_cnt =3D
                dma_map_sg(&ha->pdev->dev,
bsg_job->request_payload.sg_list,
                bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -399,7 +399,7 @@ done_unmap_sg:
        goto done_free_fcport;
=20
 done_free_fcport:
-       if (bsg_job->request->msgcode =3D=3D FC_BSG_HST_ELS_NOLOGIN)
+       if (bsg_job->request->msgcode =3D=3D FC_BSG_RPT_ELS)
                kfree(fcport);
 done:
        return rval;


Thanks,
~Saurav



-----Original Message-----
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 5 Jun 2013 15:09:59 +0200
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap
<saurav.kashyap@qlogic.com>
Subject: [PATCH 10/10] qla2xxx: Fix a memory leak in an error path of
qla2x00_process_els()

>Avoid that the fcport structure gets leaked if
>bsg_job->request->msgcode =3D=3D FC_BSG_HST_ELS_NOLOGIN, the fcport
>allocation succeeds and the !vha->flags.online branch is taken.
>This was detected by Coverity. However, Coverity does not recognize
>that all qla2x00_process_els() callers specify either
>FC_BSG_RPT_ELS or FC_BSG_HST_ELS_NOLOGIN in the field
>bsg_job->request->msgcode and that the value of that field is not
>modified inside that function. This results in a false positive
>report about a possible memory leak in an error path for
>bsg_job->request->msgcode values other than the two mentioned
>values.  Make it easy for Coverity (and for humans) to recognize
>that there is no fcport leak in the error path by changing the
>bsg_job->request->msgcode =3D=3D FC_BSG_HST_ELS_NOLOGIN test into
>bsg_job->request->msgcode !=3D FC_BSG_RPT_ELS.
>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>Cc: Chad Dupuis <chad.dupuis@qlogic.com>
>Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
>---
> drivers/scsi/qla2xxx/qla_bsg.c |   14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_bsg.c
>b/drivers/scsi/qla2xxx/qla_bsg.c
>index cf07491..f8a2634 100644
>--- a/drivers/scsi/qla2xxx/qla_bsg.c
>+++ b/drivers/scsi/qla2xxx/qla_bsg.c
>@@ -255,6 +255,12 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
> 	int rval =3D  (DRIVER_ERROR << 16);
> 	uint16_t nextlid =3D 0;
>=20
>+	if (!vha->flags.online) {
>+		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
>+		rval =3D -EIO;
>+		goto done;
>+	}
>+
> 	if (bsg_job->request->msgcode =3D=3D FC_BSG_RPT_ELS) {
> 		rport =3D bsg_job->rport;
> 		fcport =3D *(fc_port_t **) rport->dd_data;
>@@ -326,12 +332,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
> 			NPH_FABRIC_CONTROLLER : NPH_F_PORT;
> 	}
>=20
>-	if (!vha->flags.online) {
>-		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
>-		rval =3D -EIO;
>-		goto done;
>-	}
>-
> 	req_sg_cnt =3D
> 		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
> 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
>@@ -399,7 +399,7 @@ done_unmap_sg:
> 	goto done_free_fcport;
>=20
> done_free_fcport:
>-	if (bsg_job->request->msgcode =3D=3D FC_BSG_HST_ELS_NOLOGIN)
>+	if (bsg_job->request->msgcode !=3D FC_BSG_RPT_ELS)
> 		kfree(fcport);
> done:
> 	return rval;
>--=20
>1.7.10.4
>


--_000_F5D084D6342F9B479C34599BB0A03E4D35391094AVMB1qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AHMAYQB1AHIAYQB2AC4AawBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAGQA
AQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAHQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBT
AGEAdQByAGEAdgAgAEsAYQBzAGgAeQBhAHAAAABTAE0AVABQAAAAcwBhAHUAcgBhAHYALgBrAGEA
cwBoAHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAl0BAAAANAAAAHMAYQB1AHIAYQB2
AC4AawBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAOVfAQAAADwAAABzAGkA
cAA6AHMAYQB1AHIAYQB2AC4AawBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAf
ABoMAQAAAB4AAABTAGEAdQByAGEAdgAgAEsAYQBzAGgAeQBhAHAAAAAAAB8AHwwBAAAANAAAAHMA
YQB1AHIAYQB2AC4AawBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAB4MAQAA
AAoAAABTAE0AVABQAAAAAAACARkMAQAAAHQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBTAGEA
dQByAGEAdgAgAEsAYQBzAGgAeQBhAHAAAABTAE0AVABQAAAAcwBhAHUAcgBhAHYALgBrAGEAcwBo
AHkAYQBwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAV0BAAAANAAAAHMAYQB1AHIAYQB2AC4A
awBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAPg/AQAAAB4AAABTAGEAdQBy
AGEAdgAgAEsAYQBzAGgAeQBhAHAAAAAAAB8AI0ABAAAANAAAAHMAYQB1AHIAYQB2AC4AawBhAHMA
aAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfACJAAQAAAAoAAABTAE0AVABQAAAAAAAC
Afk/AQAAAHQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBTAGEAdQByAGEAdgAgAEsAYQBzAGgA
eQBhAHAAAABTAE0AVABQAAAAcwBhAHUAcgBhAHYALgBrAGEAcwBoAHkAYQBwAEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAB8ACV0BAAAANAAAAHMAYQB1AHIAYQB2AC4AawBhAHMAaAB5AGEAcABAAHEA
bABvAGcAaQBjAC4AYwBvAG0AAAALAEA6AQAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAA
AAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEAAAAQAAAA51OdzaFn1Eaoa5ebFiVfVQMA
FwABAAAAQAA5AICQ03xEZ84BQAAIMJ5OBX1EZ84BCwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUA
AAEAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEA
ZwBlAAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAA
AAAAHwA3AAEAAACuAAAAUgBlADoAIABbAFAAQQBUAEMASAAgADEAMAAvADEAMABdACAAcQBsAGEA
MgB4AHgAeAA6ACAARgBpAHgAIABhACAAbQBlAG0AbwByAHkAIABsAGUAYQBrACAAaQBuACAAYQBu
ACAAZQByAHIAbwByACAAcABhAHQAaAAgAG8AZgAgAHEAbABhADIAeAAwADAAXwBwAHIAbwBjAGUA
cwBzAF8AZQBsAHMAKAApAAAAAAAfAD0AAQAAAAoAAABSAGUAOgAgAAAAAAADADYAAAAAAB8AQhAB
AAAANgAAADwANQAxAEEARgAzADgAQQA3AC4ANgAwADIAMAA4ADAAOABAAGEAYwBtAC4AbwByAGcA
PgAAAAAAAgFxAAEAAAAbAAAAAQHOYe3+AZdw/x2d3ECoeOrmeDmRuZkylqYAAB8AcAABAAAApgAA
AFsAUABBAFQAQwBIACAAMQAwAC8AMQAwAF0AIABxAGwAYQAyAHgAeAB4ADoAIABGAGkAeAAgAGEA
IABtAGUAbQBvAHIAeQAgAGwAZQBhAGsAIABpAG4AIABhAG4AIABlAHIAcgBvAHIAIABwAGEAdABo
ACAAbwBmACAAcQBsAGEAMgB4ADAAMABfAHAAcgBvAGMAZQBzAHMAXwBlAGwAcwAoACkAAAAAAB8A
NRABAAAAeAAAADwARgA1AEQAMAA4ADQARAA2ADMANAAyAEYAOQBCADQANwA5AEMAMwA0ADUAOQA5
AEIAQgAwAEEAMAAzAEUANABEADMANQAzADkAMQAwADkANABAAEEAVgBNAEIAMQAuAHEAbABvAGcA
aQBjAC4AbwByAGcAPgAAAAMA3j+fTgAAQAAHMN6LAH1EZ84BAwAmAAAAAAACAUcAAQAAAC4AAABj
PVVTO2E9IDtwPVFMb2dpYztsPUFWTUIxLTEzMDYxMjA4MTE0OVotMzM3OTUAAAAfABUQAQAAAFgA
AAA1ADYAQgBBAEUARQA0AEIAQgA2AEYARQA0AEYANABDAEIAMgA1AEQANABCADUANgBBADMAOAA3
AEEAMQAwAEEAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEUMAEAAAAMAAAAaAEAAD8heNtIAAAA
HwD6PwEAAAAeAAAAUwBhAHUAcgBhAHYAIABLAGEAcwBoAHkAYQBwAAAAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAWAAAAdQBzAGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAAAEgAAABNAGkAYwByAG8A
cwBvAGYAdAAtAE0AYQBjAE8AdQB0AGwAbwBvAGsALwAxADQALgAxADAALgAwAC4AMQAxADAAMwAx
ADAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4A
SQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAABgEAAEkASQA9ADAAMQAwADEAQwBF
ADYANwA0ADQANwBDADkARgBCADkAQwBGAEEANAA3ADEAOABGAEIAMwA0ADYAOAAwADcARgA1ADcA
RgA2AEMAOQA3AEQARQA0ADgAMwA7AFMAQgBNAEkARAA9ADIAOwBTADEAPQA8ADUAMQBBAEYAMwA4
AEEANwAuADYAMAAyADAAOAAwADgAQABhAGMAbQAuAG8AcgBnAD4AOwBWAGUAcgBzAGkAbwBuAD0A
VgBlAHIAcwBpAG8AbgAgADEANAAuADIAIAAoAEIAdQBpAGwAZAAgADMAMQA4AC4AMAApACwAIABT
AHQAYQBnAGUAPQBIADIAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgA
LQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAaAAAA
WwAxADAALgAzADUALgA3AC4ANAA1AF0AAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAABk
AGkAcwBjAGwAYQBpAG0AZQByAAAAAAABAAAADgAAAGIAeQBwAGEAcwBzAAAAAAAGLQ==

--_000_F5D084D6342F9B479C34599BB0A03E4D35391094AVMB1qlogicorg_--
