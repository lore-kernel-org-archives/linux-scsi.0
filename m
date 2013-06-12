From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 07/10] qla2xxx: Help Coverity with analyzing ct_sns_pkt
 initialization
Date: Wed, 12 Jun 2013 08:09:54 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D3539103A@AVMB1.qlogic.org>
References: <51AF3825.8090401@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_F5D084D6342F9B479C34599BB0A03E4D3539103AAVMB1qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:56147
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755308Ab3FLIKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jun 2013 04:10:06 -0400
Received: from mail25-ch1 (localhost [127.0.0.1])	by mail25-ch1-R.bigfish.com
 (Postfix) with ESMTP id 7019D3A01BB	for <linux-scsi@vger.kernel.org>; Wed, 12
 Jun 2013 08:10:04 +0000 (UTC)
Received: from CH1EHSMHS040.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.250])	by mail25-ch1.bigfish.com (Postfix) with ESMTP id 577954601A7
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2013 08:10:01 +0000 (UTC)
In-Reply-To: <51AF3825.8090401@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>

--_000_F5D084D6342F9B479C34599BB0A03E4D3539103AAVMB1qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24011A2C0293E446811B80FF7F0433E0@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>



>Coverity reports "Overrunning struct type ct_sns_req of 1228 bytes
>by passing it to a function which accesses it at byte offset 8207"
>for each qla2x00_prep_ct_req(), qla2x00_prep_ct_fdmi_req() and
>qla24xx_prep_ct_fm_req() call. Help Coverity to recognize that
>these calls do not trigger a buffer overflow by making it explicit
>that these three functions initializes both the request and reply
>structures. This patch does not change any functionality.
>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>Cc: Chad Dupuis <chad.dupuis@qlogic.com>
>Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
>---
> drivers/scsi/qla2xxx/qla_gs.c |   86
>++++++++++++++++++-----------------------
> 1 file changed, 38 insertions(+), 48 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
>index f26442a..1ad361b 100644
>--- a/drivers/scsi/qla2xxx/qla_gs.c
>+++ b/drivers/scsi/qla2xxx/qla_gs.c
>@@ -99,17 +99,17 @@ qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t
>req_size, uint32_t rsp_size)
>  * Returns a pointer to the intitialized @ct_req.
>  */
> static inline struct ct_sns_req *
>-qla2x00_prep_ct_req(struct ct_sns_req *ct_req, uint16_t cmd, uint16_t
>rsp_size)
>+qla2x00_prep_ct_req(struct ct_sns_pkt *p, uint16_t cmd, uint16_t
>rsp_size)
> {
>-	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
>+	memset(p, 0, sizeof(struct ct_sns_pkt));
>=20
>-	ct_req->header.revision =3D 0x01;
>-	ct_req->header.gs_type =3D 0xFC;
>-	ct_req->header.gs_subtype =3D 0x02;
>-	ct_req->command =3D cpu_to_be16(cmd);
>-	ct_req->max_rsp_size =3D cpu_to_be16((rsp_size - 16) / 4);
>+	p->p.req.header.revision =3D 0x01;
>+	p->p.req.header.gs_type =3D 0xFC;
>+	p->p.req.header.gs_subtype =3D 0x02;
>+	p->p.req.command =3D cpu_to_be16(cmd);
>+	p->p.req.max_rsp_size =3D cpu_to_be16((rsp_size - 16) / 4);
>=20
>-	return (ct_req);
>+	return &p->p.req;
> }
>=20
> static int
>@@ -188,8 +188,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t
>*fcport)
> 	    GA_NXT_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, GA_NXT_CMD,
>-	    GA_NXT_RSP_SIZE);
>+	ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, GA_NXT_CMD, GA_NXT_RSP_SIZE);
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare CT arguments -- port_id */
>@@ -284,8 +283,7 @@ qla2x00_gid_pt(scsi_qla_host_t *vha, sw_info_t *list)
> 	    gid_pt_rsp_size);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, GID_PT_CMD,
>-	    gid_pt_rsp_size);
>+	ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, GID_PT_CMD, gid_pt_rsp_size);
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare CT arguments -- port_type */
>@@ -359,7 +357,7 @@ qla2x00_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
> 		    GPN_ID_RSP_SIZE);
>=20
> 		/* Prepare CT request */
>-		ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, GPN_ID_CMD,
>+		ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, GPN_ID_CMD,
> 		    GPN_ID_RSP_SIZE);
> 		ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
>@@ -421,7 +419,7 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
> 		    GNN_ID_RSP_SIZE);
>=20
> 		/* Prepare CT request */
>-		ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, GNN_ID_CMD,
>+		ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, GNN_ID_CMD,
> 		    GNN_ID_RSP_SIZE);
> 		ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
>@@ -495,7 +493,7 @@ qla2x00_rft_id(scsi_qla_host_t *vha)
> 	    RFT_ID_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFT_ID_CMD,
>+	ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, RFT_ID_CMD,
> 	    RFT_ID_RSP_SIZE);
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
>@@ -551,8 +549,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha)
> 	    RFF_ID_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFF_ID_CMD,
>-	    RFF_ID_RSP_SIZE);
>+	ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, RFF_ID_CMD, RFF_ID_RSP_SIZE);
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare CT arguments -- port_id, FC-4 feature, FC-4 type */
>@@ -606,8 +603,7 @@ qla2x00_rnn_id(scsi_qla_host_t *vha)
> 	    RNN_ID_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, RNN_ID_CMD,
>-	    RNN_ID_RSP_SIZE);
>+	ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, RNN_ID_CMD, RNN_ID_RSP_SIZE);
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare CT arguments -- port_id, node_name */
>@@ -676,8 +672,7 @@ qla2x00_rsnn_nn(scsi_qla_host_t *vha)
> 	ms_pkt =3D ha->isp_ops->prep_ms_iocb(vha, 0, RSNN_NN_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, RSNN_NN_CMD,
>-	    RSNN_NN_RSP_SIZE);
>+	ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, RSNN_NN_CMD, RSNN_NN_RSP_SIZE=
);
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare CT arguments -- node_name, symbolic node_name, size */
>@@ -1262,18 +1257,17 @@ qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *vha,
>uint32_t req_size)
>  * Returns a pointer to the intitialized @ct_req.
>  */
> static inline struct ct_sns_req *
>-qla2x00_prep_ct_fdmi_req(struct ct_sns_req *ct_req, uint16_t cmd,
>-    uint16_t rsp_size)
>+qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, uint16_t cmd, uint16_t
>rsp_size)
> {
>-	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
>+	memset(p, 0, sizeof(struct ct_sns_pkt));
>=20
>-	ct_req->header.revision =3D 0x01;
>-	ct_req->header.gs_type =3D 0xFA;
>-	ct_req->header.gs_subtype =3D 0x10;
>-	ct_req->command =3D cpu_to_be16(cmd);
>-	ct_req->max_rsp_size =3D cpu_to_be16((rsp_size - 16) / 4);
>+	p->p.req.header.revision =3D 0x01;
>+	p->p.req.header.gs_type =3D 0xFA;
>+	p->p.req.header.gs_subtype =3D 0x10;
>+	p->p.req.command =3D cpu_to_be16(cmd);
>+	p->p.req.max_rsp_size =3D cpu_to_be16((rsp_size - 16) / 4);
>=20
>-	return ct_req;
>+	return &p->p.req;
> }
>=20
> /**
>@@ -1301,8 +1295,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
> 	ms_pkt =3D ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RHBA_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RHBA_CMD,
>-	    RHBA_RSP_SIZE);
>+	ct_req =3D qla2x00_prep_ct_fdmi_req(ha->ct_sns, RHBA_CMD, RHBA_RSP_SIZE)=
;
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare FDMI command arguments -- attribute block, attributes. */
>@@ -1490,8 +1483,7 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
> 	    DHBA_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, DHBA_CMD,
>-	    DHBA_RSP_SIZE);
>+	ct_req =3D qla2x00_prep_ct_fdmi_req(ha->ct_sns, DHBA_CMD, DHBA_RSP_SIZE)=
;
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare FDMI command arguments -- portname. */
>@@ -1547,8 +1539,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
> 	ms_pkt =3D ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RPA_RSP_SIZE);
>=20
> 	/* Prepare CT request */
>-	ct_req =3D qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RPA_CMD,
>-	    RPA_RSP_SIZE);
>+	ct_req =3D qla2x00_prep_ct_fdmi_req(ha->ct_sns, RPA_CMD, RPA_RSP_SIZE);
> 	ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
> 	/* Prepare FDMI command arguments -- attribute block, attributes. */
>@@ -1775,7 +1766,7 @@ qla2x00_gfpn_id(scsi_qla_host_t *vha, sw_info_t
>*list)
> 		    GFPN_ID_RSP_SIZE);
>=20
> 		/* Prepare CT request */
>-		ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFPN_ID_CMD,
>+		ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, GFPN_ID_CMD,
> 		    GFPN_ID_RSP_SIZE);
> 		ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
>@@ -1842,18 +1833,17 @@ qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *vha,
>uint32_t req_size,
>=20
>=20
> static inline struct ct_sns_req *
>-qla24xx_prep_ct_fm_req(struct ct_sns_req *ct_req, uint16_t cmd,
>-    uint16_t rsp_size)
>+qla24xx_prep_ct_fm_req(struct ct_sns_pkt *p, uint16_t cmd, uint16_t
>rsp_size)
> {
>-	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
>+	memset(p, 0, sizeof(struct ct_sns_pkt));
>=20
>-	ct_req->header.revision =3D 0x01;
>-	ct_req->header.gs_type =3D 0xFA;
>-	ct_req->header.gs_subtype =3D 0x01;
>-	ct_req->command =3D cpu_to_be16(cmd);
>-	ct_req->max_rsp_size =3D cpu_to_be16((rsp_size - 16) / 4);
>+	p->p.req.header.revision =3D 0x01;
>+	p->p.req.header.gs_type =3D 0xFA;
>+	p->p.req.header.gs_subtype =3D 0x01;
>+	p->p.req.command =3D cpu_to_be16(cmd);
>+	p->p.req.max_rsp_size =3D cpu_to_be16((rsp_size - 16) / 4);
>=20
>-	return ct_req;
>+	return &p->p.req;
> }
>=20
> /**
>@@ -1889,7 +1879,7 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
> 		    GPSC_RSP_SIZE);
>=20
> 		/* Prepare CT request */
>-		ct_req =3D qla24xx_prep_ct_fm_req(&ha->ct_sns->p.req,
>+		ct_req =3D qla24xx_prep_ct_fm_req(ha->ct_sns,
> 		    GPSC_CMD, GPSC_RSP_SIZE);
> 		ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
>@@ -2000,7 +1990,7 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t
>*list)
> 		    GFF_ID_RSP_SIZE);
>=20
> 		/* Prepare CT request */
>-		ct_req =3D qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFF_ID_CMD,
>+		ct_req =3D qla2x00_prep_ct_req(ha->ct_sns, GFF_ID_CMD,
> 		    GFF_ID_RSP_SIZE);
> 		ct_rsp =3D &ha->ct_sns->p.rsp;
>=20
>--=20
>1.7.10.4
>
>


--_000_F5D084D6342F9B479C34599BB0A03E4D3539103AAVMB1qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IscJAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAEFCNURGNEQ1
MTI5NTFDNEQ4RjcyNDQxMTA4QTIyODJBABUHAQ2ABAACAAAAAgACAAEFgAMADgAAAN0HBgAMAAgA
CQA2AAMAQAEBIIADAA4AAADdBwYADAAIAAkANgADAEABAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAFIAAABSZTogW1BBVENIIDA3LzEwXSBxbGEyeHh4OiBIZWxwIENvdmVy
aXR5IHdpdGggYW5hbHl6aW5nIGN0X3Nuc19wa3QgaW5pdGlhbGl6YXRpb24AyRwBA5AGAEAYAAAz
AAAAAgF/AAEAAAA8AAAAPEY1RDA4NEQ2MzQyRjlCNDc5QzM0NTk5QkIwQTAzRTREMzUzOTEwM0FA
QVZNQjEucWxvZ2ljLm9yZz4ACwAfDgEAAAACAQkQAQAAAHAMAABsDAAA9isAAExaRnUAEhScYQAK
ZmJpZAQAAGNjwHBnMTI1MgD+A0PwdGV4dAH3AqQD4wIABGNoCsBzZXQwIO8HbQKDAFARTTIKgAa0
AoCWfQqACMg7CWIxOQ7AvwnDFnIKMhZxAoAVYioJsHMJ8ASQYXQFsg5QA2Bzom8BgCBFeBHBbhgw
XQZSdgSQF7YCEHIAwHR9CFBuGjEQIAXABaAbZGSaIANSIBAiF7JcdgiQ5HdrC4BkNR1TBPAHQA0X
cDAKcRfyYmttawZzAZAAICBCTV9C4EVHSU59CvwB8QvxECBBY2sJgC1ieQY6BgEIcGF2IEthAHNo
eWFwIDxzSSJTLmsixEBxCQBnhQ5QLgWgbT5cbAuAbmUKgST/JZE+CFAaMWlodHkgCXBwCREEICJi
TxoxcnVuAwAZwCDbH2AoEGMFQCcQcBngKNCUX3MAgF8JcHEgGTDiIA6QMjggIgAQIA4A+yZFIgAg
CrAEEChSJwAcwLhvIGEccCggKNBpAiAoIHdoDlBoLFBjY/8HkBIABCAsARiAKnMp8QPQyRIQIDgB
0DciJjYa4RwgZQDQLVAkMGEyeGkeoF9wJ0FfKVEpwSjMKSwwfwVwbWkxdCxQRx3AJjYwgjR4eDJo
bQMzNR5RbC4gSGVsXyMQJrcsMQlwBaBnAwB69RngdBHQdCY2N/AHkCkxyzXxBCBkLEBubyjhBRDO
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
QABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAAB0
AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUwBhAHUAcgBhAHYAIABLAGEAcwBoAHkAYQBwAAAA
UwBNAFQAUAAAAHMAYQB1AHIAYQB2AC4AawBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBv
AG0AAAAfAAJdAQAAADQAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBhAHAAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwDlXwEAAAA8AAAAcwBpAHAAOgBzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBh
AHAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAaDAEAAAAeAAAAUwBhAHUAcgBhAHYAIABLAGEA
cwBoAHkAYQBwAAAAAAAfAB8MAQAAADQAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBhAHAAQABx
AGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAAB0AAAA
AAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUwBhAHUAcgBhAHYAIABLAGEAcwBoAHkAYQBwAAAAUwBN
AFQAUAAAAHMAYQB1AHIAYQB2AC4AawBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0A
AAAfAAFdAQAAADQAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBhAHAAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAHwD4PwEAAAAeAAAAUwBhAHUAcgBhAHYAIABLAGEAcwBoAHkAYQBwAAAAAAAfACNA
AQAAADQAAABzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBhAHAAQABxAGwAbwBnAGkAYwAuAGMAbwBt
AAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAAB0AAAAAAAAAIErH6S+oxAZnW4A3QEP
VAIAAACAUwBhAHUAcgBhAHYAIABLAGEAcwBoAHkAYQBwAAAAUwBNAFQAUAAAAHMAYQB1AHIAYQB2
AC4AawBhAHMAaAB5AGEAcABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAAADQAAABzAGEA
dQByAGEAdgAuAGsAYQBzAGgAeQBhAHAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAACwBAOgEAAAAf
ABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAACwBAOgEAAAADAP0/5AQAAAIB
CzABAAAAEAAAAKtd9NUSlRxNj3JEEQiiKCoDABcAAQAAAEAAOQAA9Uc4RGfOAUAACDCe5844RGfO
AQsAAIAIIAYAAAAAAMAAAAAAAABGAAAAABSFAAABAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAA
HgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAAL
AACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAApAAAAFIAZQA6ACAAWwBQAEEA
VABDAEgAIAAwADcALwAxADAAXQAgAHEAbABhADIAeAB4AHgAOgAgAEgAZQBsAHAAIABDAG8AdgBl
AHIAaQB0AHkAIAB3AGkAdABoACAAYQBuAGEAbAB5AHoAaQBuAGcAIABjAHQAXwBzAG4AcwBfAHAA
awB0ACAAaQBuAGkAdABpAGEAbABpAHoAYQB0AGkAbwBuAAAAHwA9AAEAAAAKAAAAUgBlADoAIAAA
AAAAAwA2AAAAAAAfAEIQAQAAADYAAAA8ADUAMQBBAEYAMwA4ADIANQAuADgAMAA5ADAANAAwADEA
QABhAGMAbQAuAG8AcgBnAD4AAAAAAAIBcQABAAAAGwAAAAEBzmHtsqGMzGep9MZAlrToYcgb9FiZ
MpYbgAAfAHAAAQAAAJwAAABbAFAAQQBUAEMASAAgADAANwAvADEAMABdACAAcQBsAGEAMgB4AHgA
eAA6ACAASABlAGwAcAAgAEMAbwB2AGUAcgBpAHQAeQAgAHcAaQB0AGgAIABhAG4AYQBsAHkAegBp
AG4AZwAgAGMAdABfAHMAbgBzAF8AcABrAHQAIABpAG4AaQB0AGkAYQBsAGkAegBhAHQAaQBvAG4A
AAAfADUQAQAAAHgAAAA8AEYANQBEADAAOAA0AEQANgAzADQAMgBGADkAQgA0ADcAOQBDADMANAA1
ADkAOQBCAEIAMABBADAAMwBFADQARAAzADUAMwA5ADEAMAAzAEEAQABBAFYATQBCADEALgBxAGwA
bwBnAGkAYwAuAG8AcgBnAD4AAAADAN4/n04AAEAABzDeJMo4RGfOAQMAJgAAAAAAAgFHAAEAAAAu
AAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMS0xMzA2MTIwODA5NTRaLTMzNzkyAAAAHwAVEAEA
AABYAAAAMgA0ADAAMQAxAEEAMgBDADAAMgA5ADMARQA0ADQANgA4ADEAMQBCADgAMABGAEYANwBG
ADAANAAzADMARQAwAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAIBFDABAAAADAAAAJQCAADZkccq
QQAAAB8A+j8BAAAAHgAAAFMAYQB1AHIAYQB2ACAASwBhAHMAaAB5AGEAcAAAAAAAHwAAgIYDAgAA
AAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBuAHQAAAAAAAEAAABIAAAATQBpAGMA
cgBvAHMAbwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8AMQA0AC4AMQAwAC4AMAAuADEAMQAw
ADMAMQAwAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkA
bwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAAAYBAABJAEkAPQAwADEAMAAx
AEMARQA2ADcANAA0ADMAOAAyAEQAOABBADEAMgBCAEEANgAxADMAMwA3ADAANAA1ADkAQwBGADkA
MwBEAEUAMgA4AEQANwA2ADYAMQBFADMAOwBTAEIATQBJAEQAPQAyADsAUwAxAD0APAA1ADEAQQBG
ADMAOAAyADUALgA4ADAAOQAwADQAMAAxAEAAYQBjAG0ALgBvAHIAZwA+ADsAVgBlAHIAcwBpAG8A
bgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAyACAAKABCAHUAaQBsAGQAIAAzADEAOAAuADAAKQAs
ACAAUwB0AGEAZwBlAD0ASAAyAAAAAAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAA
AAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAA
AMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAA
GgAAAFsAMQAwAC4AMwA1AC4ANwAuADQANQBdAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAW
AAAAZABpAHMAYwBsAGEAaQBtAGUAcgAAAAAAAQAAAA4AAABiAHkAcABhAHMAcwAAAAAAvDM=

--_000_F5D084D6342F9B479C34599BB0A03E4D3539103AAVMB1qlogicorg_--
