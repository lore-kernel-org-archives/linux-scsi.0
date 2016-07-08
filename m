From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH] Do not fire MR_DCMD_PD_LIST_QUERY to controllers which do not support it
Date: Fri,  8 Jul 2016 03:20:32 -0700
Message-ID: <1467973232-17382-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, lucz@geza.com, stable@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

There was an issue reported by Lucz Geza on Dell Perc 6i. As per issue =
reported,
driver goes into an infinite error reporting loop as soon as there is a=
 change
in the status of one of the arrays (degrade, resync online etc =E2=80=A6=
).
Below are the error logs reported continuously-=20

Jun 25 08:49:30 ns8 kernel: [  757.757017] megaraid_sas 0000:02:00.0: D=
CMD failed/not supported by firmware: megasas_get_pd_list 4115
Jun 25 08:49:30 ns8 kernel: [  757.778017] megaraid_sas 0000:02:00.0: D=
CMD failed/not supported by firmware: megasas_get_pd_list 4115
Jun 25 08:49:30 ns8 kernel: [  757.799017] megaraid_sas 0000:02:00.0: D=
CMD failed/not supported by firmware: megasas_get_pd_list 4115
Jun 25 08:49:30 ns8 kernel: [  757.820018] megaraid_sas 0000:02:00.0: D=
CMD failed/not supported by firmware: megasas_get_pd_list 4115
Jun 25 08:49:30 ns8 kernel: [  757.841018] megaraid_sas 0000:02:00.0: D=
CMD failed/not supported by firmware: megasas_get_pd_list 4115

This issue is very much specific to controllers which do not support DC=
MD- MR_DCMD_PD_LIST_QUERY.
In case of any hotplugging/rescanning of drives, AEN thread will be sch=
eduled by driver and fire
DCMD- MR_DCMD_PD_LIST_QUERY and if this DCMD is failed then driver will=
 fail this event processing
and will not go ahead for further events. This will cause infinite loop=
 of same event getting
retried infinitely and causing above mentioned logs.

=46ix for this problem is: not to fire DCMD MR_DCMD_PD_LIST_QUERY for c=
ontrollers which do not
support it and send DCMD SUCCESS status to AEN function so that it can =
go ahead with other event
processing.

Reported-by: Lucz Geza <geza@lucz.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>

---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
index f4b0690..2dab3dc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4079,6 +4079,12 @@ megasas_get_pd_list(struct megasas_instance *ins=
tance)
 	struct MR_PD_ADDRESS *pd_addr;
 	dma_addr_t ci_h =3D 0;
=20
+	if (instance->pd_list_not_supported) {
+		dev_info(&instance->pdev->dev, "MR_DCMD_PD_LIST_QUERY "
+		"not supported by firmware\n");
+		return ret;
+	}
+
 	cmd =3D megasas_get_cmd(instance);
=20
 	if (!cmd) {
--=20
2.4.11
