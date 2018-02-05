From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH 5/6] scsi: qedi: fix building with LTO
Date: Mon, 5 Feb 2018 06:08:28 +0000
Message-ID: <D69DF242.54308%manish.rangankar@cavium.com>
References: <20180202131225.1658853-1-arnd@arndb.de>
 <20180202131225.1658853-6-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180202131225.1658853-6-arnd@arndb.de>
Content-Language: en-US
Content-ID: <D093491A855B64489831983D522ED5A8@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, "Tayar, Tomer" <Tomer.Tayar@cavium.com>, "David S. Miller" <davem@davemloft.net>, "Elior, Ariel" <Ariel.Elior@cavium.com>, "Easi, Arun" <Arun.Easi@cavium.com>, "Javali, Nilesh" <Nilesh.Javali@cavium.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 02/02/18 6:42 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:

>When link-time optimizations are enabled, qedi fails to build because
>of mismatched prototypes:
>
>drivers/scsi/qedi/qedi_gbl.h:27:37: error: type of 'qedi_dbg_fops' does
>not match original declaration [-Werror=3Dlto-type-mismatch]
> extern const struct file_operations qedi_dbg_fops;
>                                     ^
>drivers/scsi/qedi/qedi_debugfs.c:239:30: note: 'qedi_dbg_fops' was
>previously declared here
> const struct file_operations qedi_dbg_fops[] =3D {
>                              ^
>drivers/scsi/qedi/qedi_gbl.h:26:32: error: type of 'qedi_debugfs_ops'
>does not match original declaration [-Werror=3Dlto-type-mismatch]
> extern struct qedi_debugfs_ops qedi_debugfs_ops;
>                                ^
>drivers/scsi/qedi/qedi_debugfs.c:102:25: note: 'qedi_debugfs_ops' was
>previously declared here
> struct qedi_debugfs_ops qedi_debugfs_ops[] =3D {
>
>This changes the declaration to match the definition, and adapts the
>users as necessary. Since both array can be constant here, I'm adding
>the 'const' everywhere for consistency.
>
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>---
> drivers/scsi/qedi/qedi_dbg.h     | 2 +-
> drivers/scsi/qedi/qedi_debugfs.c | 4 ++--
> drivers/scsi/qedi/qedi_gbl.h     | 4 ++--
> drivers/scsi/qedi/qedi_main.c    | 4 ++--
> 4 files changed, 7 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
>index c55572badfb0..358f40567849 100644
>--- a/drivers/scsi/qedi/qedi_dbg.h
>+++ b/drivers/scsi/qedi/qedi_dbg.h
>@@ -134,7 +134,7 @@ struct qedi_debugfs_ops {
> }
>=20
> void qedi_dbg_host_init(struct qedi_dbg_ctx *qedi,
>-			struct qedi_debugfs_ops *dops,
>+			const struct qedi_debugfs_ops *dops,
> 			const struct file_operations *fops);
> void qedi_dbg_host_exit(struct qedi_dbg_ctx *qedi);
> void qedi_dbg_init(char *drv_name);
>diff --git a/drivers/scsi/qedi/qedi_debugfs.c
>b/drivers/scsi/qedi/qedi_debugfs.c
>index fd8a1eea3163..fd914ca4149a 100644
>--- a/drivers/scsi/qedi/qedi_debugfs.c
>+++ b/drivers/scsi/qedi/qedi_debugfs.c
>@@ -19,7 +19,7 @@ static struct dentry *qedi_dbg_root;
>=20
> void
> qedi_dbg_host_init(struct qedi_dbg_ctx *qedi,
>-		   struct qedi_debugfs_ops *dops,
>+		   const struct qedi_debugfs_ops *dops,
> 		   const struct file_operations *fops)
> {
> 	char host_dirname[32];
>@@ -99,7 +99,7 @@ static struct qedi_list_of_funcs
>qedi_dbg_do_not_recover_ops[] =3D {
> 	{ NULL, NULL }
> };
>=20
>-struct qedi_debugfs_ops qedi_debugfs_ops[] =3D {
>+const struct qedi_debugfs_ops qedi_debugfs_ops[] =3D {
> 	{ "gbl_ctx", NULL },
> 	{ "do_not_recover", qedi_dbg_do_not_recover_ops},
> 	{ "io_trace", NULL },
>diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
>index f5b5a31999aa..a2aa06ed1620 100644
>--- a/drivers/scsi/qedi/qedi_gbl.h
>+++ b/drivers/scsi/qedi/qedi_gbl.h
>@@ -23,8 +23,8 @@ extern uint qedi_io_tracing;
> extern struct scsi_host_template qedi_host_template;
> extern struct iscsi_transport qedi_iscsi_transport;
> extern const struct qed_iscsi_ops *qedi_ops;
>-extern struct qedi_debugfs_ops qedi_debugfs_ops;
>-extern const struct file_operations qedi_dbg_fops;
>+extern const struct qedi_debugfs_ops qedi_debugfs_ops[];
>+extern const struct file_operations qedi_dbg_fops[];
> extern struct device_attribute *qedi_shost_attrs[];
>=20
> int qedi_alloc_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep);
>diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
>index 029e2e69b29f..e992f9d3ef00 100644
>--- a/drivers/scsi/qedi/qedi_main.c
>+++ b/drivers/scsi/qedi/qedi_main.c
>@@ -2303,8 +2303,8 @@ static int __qedi_probe(struct pci_dev *pdev, int
>mode)
> 	}
>=20
> #ifdef CONFIG_DEBUG_FS
>-	qedi_dbg_host_init(&qedi->dbg_ctx, &qedi_debugfs_ops,
>-			   &qedi_dbg_fops);
>+	qedi_dbg_host_init(&qedi->dbg_ctx, qedi_debugfs_ops,
>+			   qedi_dbg_fops);
> #endif
> 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
> 		  "QLogic FastLinQ iSCSI Module qedi %s, FW %d.%d.%d.%d\n",
>--=20
>2.9.0

Thanks

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>


>
