From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH 09/10] qla2xxx: Comment out unreachable code
Date: Thu, 11 Jun 2015 04:43:51 +0000
Message-ID: <D19E5F33.922D9%himanshu.madhani@qlogic.com>
References: <5570D656.9050704@sandisk.com> <5570D7D0.80500@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D19E5F33922D9himanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:12075 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbbFKEnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 00:43:53 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id t5B4aasW009287
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2015 21:43:53 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1uy1j60306-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2015 21:43:53 -0700
In-Reply-To: <5570D7D0.80500@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@odin.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

--_000_D19E5F33922D9himanshumadhaniqlogiccom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF9A71481D981D4E8C32E131B3210C62@qlogic.com>
Content-Transfer-Encoding: quoted-printable



On 6/4/15, 3:57 PM, "Bart Van Assche" <bart.vanassche@sandisk.com> wrote:

>Comment out the code that is never reached in qla83xx_idc_unlock()
>and also in qlt_set_data_offset() to avoid that static source code
>analysis tools report warnings for this code.
>
>Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
>Cc: Quinn Tran <quinn.tran@qlogic.com>
>Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
>---
> drivers/scsi/qla2xxx/qla_os.c     |  7 ++++++-
> drivers/scsi/qla2xxx/qla_target.c | 16 +++++++++-------
> 2 files changed, 15 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>index 0ababd5..5a5166b 100644
>--- a/drivers/scsi/qla2xxx/qla_os.c
>+++ b/drivers/scsi/qla2xxx/qla_os.c
>@@ -4417,7 +4417,10 @@ retry_lock2:
> void
> qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_t requester_id)
> {
>-	uint16_t options =3D (requester_id << 15) | BIT_7, retry;
>+#if 0
>+	uint16_t options =3D (requester_id << 15) | BIT_7;
>+#endif
>+	uint16_t retry;
> 	uint32_t data;
> 	struct qla_hw_data *ha =3D base_vha->hw;
>=20
>@@ -4453,6 +4456,7 @@ retry_unlock:
>=20
> 	return;
>=20
>+#if 0
> 	/* XXX: IDC-unlock implementation using access-control mbx */
> 	retry =3D 0;
> retry_unlock2:
>@@ -4468,6 +4472,7 @@ retry_unlock2:
> 	}
>=20
> 	return;
>+#endif
> }
>=20
> int
>diff --git a/drivers/scsi/qla2xxx/qla_target.c
>b/drivers/scsi/qla2xxx/qla_target.c
>index 59a0897..22a91a3 100644
>--- a/drivers/scsi/qla2xxx/qla_target.c
>+++ b/drivers/scsi/qla2xxx/qla_target.c
>@@ -3699,6 +3699,14 @@ static int qlt_24xx_handle_els(struct
>scsi_qla_host *vha,
>=20
> static int qlt_set_data_offset(struct qla_tgt_cmd *cmd, uint32_t offset)
> {
>+#if 1
>+	/*
>+	 * FIXME: Reject non zero SRR relative offset until we can test
>+	 * this code properly.
>+	 */
>+	pr_debug("Rejecting non zero SRR rel_offs: %u\n", offset);
>+	return -1;
>+#else
> 	struct scatterlist *sg, *sgp, *sg_srr, *sg_srr_start =3D NULL;
> 	size_t first_offset =3D 0, rem_offset =3D offset, tmp =3D 0;
> 	int i, sg_srr_cnt, bufflen =3D 0;
>@@ -3708,13 +3716,6 @@ static int qlt_set_data_offset(struct qla_tgt_cmd
>*cmd, uint32_t offset)
> 	    "cmd->sg_cnt: %u, direction: %d\n",
> 	    cmd, cmd->sg, cmd->sg_cnt, cmd->dma_data_direction);
>=20
>-	/*
>-	 * FIXME: Reject non zero SRR relative offset until we can test
>-	 * this code properly.
>-	 */
>-	pr_debug("Rejecting non zero SRR rel_offs: %u\n", offset);
>-	return -1;
>-
> 	if (!cmd->sg || !cmd->sg_cnt) {
> 		ql_dbg(ql_dbg_tgt, cmd->vha, 0xe055,
> 		    "Missing cmd->sg or zero cmd->sg_cnt in"
>@@ -3797,6 +3798,7 @@ static int qlt_set_data_offset(struct qla_tgt_cmd
>*cmd, uint32_t offset)
> 		BUG();
>=20
> 	return 0;
>+#endif
> }
>=20
> static inline int qlt_srr_adjust_data(struct qla_tgt_cmd *cmd,
>--=20
>2.1.4
>

Looks good.=20

Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>


>


--_000_D19E5F33922D9himanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
HnADoIH6vZrzN5NQXSCUEJugN0mA/3cBnD+ib6N/Xxekr6W9qTP9RaEipGF1ILpxwkG0IiMA/w3g
CXCycQIgtCELMLRyyj+/G9DI8stlzufCNMtjZADA/y3EzHe1KHX3ZSSoeGUkqX//qo+rn6yv09qu
f6+I1AaAp/9lJLGfsq+zv7TOZSS2L2UR88CcjOAoIctlReBF8ONmf8IyLpBkiHDzamNfsC3AYp/c
8OZEpBLO5WJDMHgKYP41IvDlL8sEGNAEEH8i43bvBbHVs8tpKpEiw1yTcJtz/+0whJCFM8VPxl/H
b8h/yY/x5YpCVUcr8NHviGuCCX+Jz4rfoWkhou6ou0E6EGo/fwAttPAvpHZCmHX3Mi5sMS6UhyGc
TDHQH1Agsmcx0GQudfYhlUEr0P81QTWyOX86j0HfIef+3yGzAxVCB9AfAEIAAQAAACIAAABIAGkA
bQBhAG4AcwBoAHUAIABNAGEAZABoAGEAbgBpAAAAAAAfAGUAAQAAADgAAABoAGkAbQBhAG4AcwBo
AHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AZAABAAAACgAAAFMA
TQBUAFAAAAAAAAIBQQABAAAAfAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEgAaQBtAGEAbgBz
AGgAdQAgAE0AYQBkAGgAYQBuAGkAAABTAE0AVABQAAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQA
aABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAJdAQAAADgAAABoAGkAbQBhAG4AcwBo
AHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A5V8BAAAAQAAAAHMA
aQBwADoAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBv
AG0AAAAfABoMAQAAACIAAABIAGkAbQBhAG4AcwBoAHUAIABNAGEAZABoAGEAbgBpAAAAAAAfAB8M
AQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAfAAAAAAAAACBKx+kvqMQGZ1u
AN0BD1QCAAAAgEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAABTAE0AVABQAAAAaABp
AG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFd
AQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8A+D8BAAAAIgAAAEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAAAAAB8A
I0ABAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAAB8AAAAAAAAAIErH6S+oxAZ
nW4A3QEPVAIAAACASABpAG0AYQBuAHMAaAB1ACAATQBhAGQAaABhAG4AaQAAAFMATQBUAFAAAABo
AGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A
CV0BAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAACwBAOgEAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAA
CwBAOgEAAAADAP0/5AQAAAIBCzABAAAAEAAAACJZ6wpFeQxFqSSLRSsvbxIDABcAAQAAAEAAOQCA
nX82AaTQAUAACDDoTL02AaTQAQsAAIAIIAYAAAAAAMAAAAAAAABGAAAAABSFAAABAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAA
AAwAAABlAG4ALQBVAFMAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAA
cAAAAFIAZQA6ACAAWwBQAEEAVABDAEgAIAAwADkALwAxADAAXQAgAHEAbABhADIAeAB4AHgAOgAg
AEMAbwBtAG0AZQBuAHQAIABvAHUAdAAgAHUAbgByAGUAYQBjAGgAYQBiAGwAZQAgAGMAbwBkAGUA
AAAfAD0AAQAAAAoAAABSAGUAOgAgAAAAAAADADYAAAAAAB8AQhABAAAAOgAAADwANQA1ADcAMABE
ADcARAAwAC4AOAAwADUAMAAwAEAAcwBhAG4AZABpAHMAawAuAGMAbwBtAD4AAAAAAAIBcQABAAAA
GwAAAAEB0J8Z1BFr68ag16hNjzsOj2z4XwydpsQ1AAAfAHAAAQAAAGgAAABbAFAAQQBUAEMASAAg
ADAAOQAvADEAMABdACAAcQBsAGEAMgB4AHgAeAA6ACAAQwBvAG0AbQBlAG4AdAAgAG8AdQB0ACAA
dQBuAHIAZQBhAGMAaABhAGIAbABlACAAYwBvAGQAZQAAAB8ANRABAAAAWgAAADwARAAxADkARQA1
AEYAMwAzAC4AOQAyADIARAA5ACUAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEA
bABvAGcAaQBjAC4AYwBvAG0APgAAAAAAHwA5EAEAAAB4AAAAPAA1ADUANwAwAEQANgA1ADYALgA5
ADAANQAwADcAMAA0AEAAcwBhAG4AZABpAHMAawAuAGMAbwBtAD4AIAA8ADUANQA3ADAARAA3AEQA
MAAuADgAMAA1ADAAMABAAHMAYQBuAGQAaQBzAGsALgBjAG8AbQA+AAAAAwDeP59OAABAAAcwyCi2
NgGk0AEDACYAAAAAAAIBRwABAAAALgAAAGM9VVM7YT0gO3A9UUxvZ2ljO2w9QVZNQjMtMTUwNjEx
MDQ0MzUxWi0xOTc5NQAAAB8AFRABAAAAWAAAAEYARgA5AEEANwAxADQAOAAxAEQAOQA4ADEARAA0
AEUAOABDADMAMgBFADEAMwAxAEIAMwAyADEAMABDADYAMgBAAHEAbABvAGcAaQBjAC4AYwBvAG0A
AAACARQwAQAAAAwAAAAHAQAAZgyAC08AAAAfAPo/AQAAACIAAABIAGkAbQBhAG4AcwBoAHUAIABN
AGEAZABoAGEAbgBpAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAAdQBzAGUAcgAtAGEA
ZwBlAG4AdAAAAAAAAQAAAEYAAABNAGkAYwByAG8AcwBvAGYAdAAtAE0AYQBjAE8AdQB0AGwAbwBv
AGsALwAxADQALgAzAC4AOQAuADEAMwAxADAAMwAwAAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEA
AAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBF
AHgAAAABAAAACgEAAEkASQA9ADAAMQAwADEARAAwAEEANAAwADEAMwA2ADkARABBADUAOAAyADMA
RgBEADMAQwAxADAANwA0ADUAOQBCADMAMgA2AEIARQBFAEIAQwA1AEYAMgBCADMAMAA7AFMAQgBN
AEkARAA9ADUAOwBTADEAPQA8ADUANQA3ADAARAA3AEQAMAAuADgAMAA1ADAAMABAAHMAYQBuAGQA
aQBzAGsALgBjAG8AbQA+ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAz
ACAAKABCAHUAaQBsAGQAIAAyADMANQAuADAAKQAsACAAUwB0AGEAZwBlAD0ASAAyAAAAAAADAA00
/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABh
AGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkA
ZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAGAAAAFsAMQAwAC4AMQAuADQALgAxADAAXQAA
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAABkAGkAcwBjAGwAYQBpAG0AZQByAAAAAAABAAAA
DgAAAGIAeQBwAGEAcwBzAAAAAABAew==

--_000_D19E5F33922D9himanshumadhaniqlogiccom_--
