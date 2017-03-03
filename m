From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] [v2] scsi: qedi: fix build error without DEBUG_FS
Date: Fri, 3 Mar 2017 07:17:51 +0000
Message-ID: <D4DF163F.37B89%manish.rangankar@cavium.com>
References: <20170302145845.1096307-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0069.outbound.protection.outlook.com ([104.47.41.69]:64590
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751137AbdCCI5S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Mar 2017 03:57:18 -0500
In-Reply-To: <20170302145845.1096307-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <E6E1E9516A6A9540B9430DB7A317CAF1@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, "Dupuis, Chad" <Chad.Dupuis@cavium.com>, "Easi, Arun" <Arun.Easi@cavium.com>, "Kashyap, Saurav" <Saurav.Kashyap@cavium.com>, Hannes Reinecke <hare@suse.de>, Wei Yongjun <weiyongjun1@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


On 02/03/17 8:28 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:

>Without CONFIG_DEBUG_FS, we run into a link error:
>
>drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_poll':
>qedi_iscsi.c:(.text.qedi_ep_poll+0x134): undefined reference to
>`do_not_recover'
>drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_disconnect':
>qedi_iscsi.c:(.text.qedi_ep_disconnect+0x36c): undefined reference to
>`do_not_recover'
>drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_connect':
>qedi_iscsi.c:(.text.qedi_ep_connect+0x350): undefined reference to
>`do_not_recover'
>drivers/scsi/qedi/qedi_fw.o: In function `qedi_tmf_work':
>qedi_fw.c:(.text.qedi_tmf_work+0x3b4): undefined reference to
>`do_not_recover'
>
>This defines the symbol as a constant in this case, as there is no way to
>set it to anything other than zero without DEBUG_FS. In addition, I'm
>renaming
>it to qedi_do_not_recover in order to put it into a driver specific
>namespace,
>as "do_not_recover" is a really bad name for a kernel-wide global
>identifier
>when it is used only in one driver.
>
>Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI
>driver framework.")
>Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>---
>v2: don't rename references to do_not_recover in string literals
>---
> drivers/scsi/qedi/qedi_debugfs.c | 16 ++++++++--------
> drivers/scsi/qedi/qedi_fw.c      |  4 ++--
> drivers/scsi/qedi/qedi_gbl.h     |  8 +++++++-
> drivers/scsi/qedi/qedi_iscsi.c   |  8 ++++----
> 4 files changed, 21 insertions(+), 15 deletions(-)
>
>diff --git a/drivers/scsi/qedi/qedi_debugfs.c
>b/drivers/scsi/qedi/qedi_debugfs.c
>index 955936274241..59417199bf36 100644
>--- a/drivers/scsi/qedi/qedi_debugfs.c
>+++ b/drivers/scsi/qedi/qedi_debugfs.c
>@@ -14,7 +14,7 @@
> #include <linux/debugfs.h>
> #include <linux/module.h>
>=20
>-int do_not_recover;
>+int qedi_do_not_recover;
> static struct dentry *qedi_dbg_root;
>=20
> void
>@@ -74,22 +74,22 @@ qedi_dbg_exit(void)
> static ssize_t
> qedi_dbg_do_not_recover_enable(struct qedi_dbg_ctx *qedi_dbg)
> {
>-	if (!do_not_recover)
>-		do_not_recover =3D 1;
>+	if (!qedi_do_not_recover)
>+		qedi_do_not_recover =3D 1;
>=20
> 	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=3D%d\n",
>-		  do_not_recover);
>+		  qedi_do_not_recover);
> 	return 0;
> }
>=20
> static ssize_t
> qedi_dbg_do_not_recover_disable(struct qedi_dbg_ctx *qedi_dbg)
> {
>-	if (do_not_recover)
>-		do_not_recover =3D 0;
>+	if (qedi_do_not_recover)
>+		qedi_do_not_recover =3D 0;
>=20
> 	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=3D%d\n",
>-		  do_not_recover);
>+		  qedi_do_not_recover);
> 	return 0;
> }
>=20
>@@ -141,7 +141,7 @@ qedi_dbg_do_not_recover_cmd_read(struct file *filp,
>char __user *buffer,
> 	if (*ppos)
> 		return 0;
>=20
>-	cnt =3D sprintf(buffer, "do_not_recover=3D%d\n", do_not_recover);
>+	cnt =3D sprintf(buffer, "do_not_recover=3D%d\n", qedi_do_not_recover);
> 	cnt =3D min_t(int, count, cnt - *ppos);
> 	*ppos +=3D cnt;
> 	return cnt;
>diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
>index c9f0ef4e11b3..2bce3efc66a4 100644
>--- a/drivers/scsi/qedi/qedi_fw.c
>+++ b/drivers/scsi/qedi/qedi_fw.c
>@@ -1461,9 +1461,9 @@ static void qedi_tmf_work(struct work_struct *work)
> 		  get_itt(tmf_hdr->rtt), get_itt(ctask->itt), cmd->task_id,
> 		  qedi_conn->iscsi_conn_id);
>=20
>-	if (do_not_recover) {
>+	if (qedi_do_not_recover) {
> 		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT %d\n",
>-			 do_not_recover);
>+			 qedi_do_not_recover);
> 		goto abort_ret;
> 	}
>=20
>diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
>index 8e488de88ece..63d793f46064 100644
>--- a/drivers/scsi/qedi/qedi_gbl.h
>+++ b/drivers/scsi/qedi/qedi_gbl.h
>@@ -12,8 +12,14 @@
>=20
> #include "qedi_iscsi.h"
>=20
>+#ifdef CONFIG_DEBUG_FS
>+extern int qedi_do_not_recover;
>+#else
>+#define qedi_do_not_recover (0)
>+#endif
>+
> extern uint qedi_io_tracing;
>-extern int do_not_recover;
>+
> extern struct scsi_host_template qedi_host_template;
> extern struct iscsi_transport qedi_iscsi_transport;
> extern const struct qed_iscsi_ops *qedi_ops;
>diff --git a/drivers/scsi/qedi/qedi_iscsi.c
>b/drivers/scsi/qedi/qedi_iscsi.c
>index b9f79d36142d..4cc474364c50 100644
>--- a/drivers/scsi/qedi/qedi_iscsi.c
>+++ b/drivers/scsi/qedi/qedi_iscsi.c
>@@ -833,7 +833,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct
>sockaddr *dst_addr,
> 		return ERR_PTR(ret);
> 	}
>=20
>-	if (do_not_recover) {
>+	if (qedi_do_not_recover) {
> 		ret =3D -ENOMEM;
> 		return ERR_PTR(ret);
> 	}
>@@ -957,7 +957,7 @@ static int qedi_ep_poll(struct iscsi_endpoint *ep,
>int timeout_ms)
> 	struct qedi_endpoint *qedi_ep;
> 	int ret =3D 0;
>=20
>-	if (do_not_recover)
>+	if (qedi_do_not_recover)
> 		return 1;
>=20
> 	qedi_ep =3D ep->dd_data;
>@@ -1025,7 +1025,7 @@ static void qedi_ep_disconnect(struct
>iscsi_endpoint *ep)
> 		}
>=20
> 		if (test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
>-			if (do_not_recover) {
>+			if (qedi_do_not_recover) {
> 				QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
> 					  "Do not recover cid=3D0x%x\n",
> 					  qedi_ep->iscsi_cid);
>@@ -1039,7 +1039,7 @@ static void qedi_ep_disconnect(struct
>iscsi_endpoint *ep)
> 		}
> 	}
>=20
>-	if (do_not_recover)
>+	if (qedi_do_not_recover)
> 		goto ep_exit_recover;
>=20
> 	switch (qedi_ep->state) {
>--=20
>2.9.0

Thanks Arnd.

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
