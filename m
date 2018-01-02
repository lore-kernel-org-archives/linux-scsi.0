From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH 1/9] scsi: qla4xxx: Use zeroing allocator rather than
 allocator/memset
Date: Tue, 2 Jan 2018 04:39:20 +0000
Message-ID: <D6710A8A.4F523%manish.rangankar@cavium.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
 <1514647712-6332-2-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-2-git-send-email-himanshujha199640@gmail.com>
Content-Language: en-US
Content-ID: <2FB69548789AF442AF02C8A3D2024691@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@adaptec.com" <aacraid@adaptec.com>
Cc: "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>, "Kalluru, Sudarsana" <Sudarsana.Kalluru@cavium.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "satishkh@cisco.com" <satishkh@cisco.com>, "sebaddel@cisco.com" <sebaddel@cisco.com>, "kartilak@cisco.com" <kartilak@cisco.com>Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 30/12/17 8:58 PM, "Himanshu Jha" <himanshujha199640@gmail.com> wrote:

>Use dma_zalloc_coherent instead of dma_alloc_coherent followed by memset
>0.
>
>Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
>
>Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
>Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
>---
> drivers/scsi/qla4xxx/ql4_init.c |  5 ++---
> drivers/scsi/qla4xxx/ql4_mbx.c  | 21 +++++++++------------
> drivers/scsi/qla4xxx/ql4_nx.c   |  5 ++---
> drivers/scsi/qla4xxx/ql4_os.c   | 12 +++++-------
> 4 files changed, 18 insertions(+), 25 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_init.c
>b/drivers/scsi/qla4xxx/ql4_init.c
>index 5d6d158..52b1a0b 100644
>--- a/drivers/scsi/qla4xxx/ql4_init.c
>+++ b/drivers/scsi/qla4xxx/ql4_init.c
>@@ -153,15 +153,14 @@ int qla4xxx_get_sys_info(struct scsi_qla_host *ha)
> 	dma_addr_t sys_info_dma;
> 	int status =3D QLA_ERROR;
>=20
>-	sys_info =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
>-				      &sys_info_dma, GFP_KERNEL);
>+	sys_info =3D dma_zalloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
>+				       &sys_info_dma, GFP_KERNEL);
> 	if (sys_info =3D=3D NULL) {
> 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
> 			      ha->host_no, __func__));
>=20
> 		goto exit_get_sys_info_no_free;
> 	}
>-	memset(sys_info, 0, sizeof(*sys_info));
>=20
> 	/* Get flash sys info */
> 	if (qla4xxx_get_flash(ha, sys_info_dma, FLASH_OFFSET_SYS_INFO,
>diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c
>b/drivers/scsi/qla4xxx/ql4_mbx.c
>index 1da04f3..bda2e64 100644
>--- a/drivers/scsi/qla4xxx/ql4_mbx.c
>+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
>@@ -625,15 +625,14 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host *
>ha)
> 	uint32_t mbox_sts[MBOX_REG_COUNT];
> 	int status =3D QLA_ERROR;
>=20
>-	init_fw_cb =3D dma_alloc_coherent(&ha->pdev->dev,
>-					sizeof(struct addr_ctrl_blk),
>-					&init_fw_cb_dma, GFP_KERNEL);
>+	init_fw_cb =3D dma_zalloc_coherent(&ha->pdev->dev,
>+					 sizeof(struct addr_ctrl_blk),
>+					 &init_fw_cb_dma, GFP_KERNEL);
> 	if (init_fw_cb =3D=3D NULL) {
> 		DEBUG2(printk("scsi%ld: %s: Unable to alloc init_cb\n",
> 			      ha->host_no, __func__));
> 		goto exit_init_fw_cb_no_free;
> 	}
>-	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
>=20
> 	/* Get Initialize Firmware Control Block. */
> 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
>@@ -710,9 +709,9 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host
>* ha)
> 	uint32_t mbox_cmd[MBOX_REG_COUNT];
> 	uint32_t mbox_sts[MBOX_REG_COUNT];
>=20
>-	init_fw_cb =3D dma_alloc_coherent(&ha->pdev->dev,
>-					sizeof(struct addr_ctrl_blk),
>-					&init_fw_cb_dma, GFP_KERNEL);
>+	init_fw_cb =3D dma_zalloc_coherent(&ha->pdev->dev,
>+					 sizeof(struct addr_ctrl_blk),
>+					 &init_fw_cb_dma, GFP_KERNEL);
> 	if (init_fw_cb =3D=3D NULL) {
> 		printk("scsi%ld: %s: Unable to alloc init_cb\n", ha->host_no,
> 		       __func__);
>@@ -720,7 +719,6 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host
>* ha)
> 	}
>=20
> 	/* Get Initialize Firmware Control Block. */
>-	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
> 	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma) !=
=3D
> 	    QLA_SUCCESS) {
> 		DEBUG2(printk("scsi%ld: %s: Failed to get init_fw_ctrl_blk\n",
>@@ -1342,16 +1340,15 @@ int qla4xxx_about_firmware(struct scsi_qla_host
>*ha)
> 	uint32_t mbox_sts[MBOX_REG_COUNT];
> 	int status =3D QLA_ERROR;
>=20
>-	about_fw =3D dma_alloc_coherent(&ha->pdev->dev,
>-				      sizeof(struct about_fw_info),
>-				      &about_fw_dma, GFP_KERNEL);
>+	about_fw =3D dma_zalloc_coherent(&ha->pdev->dev,
>+				       sizeof(struct about_fw_info),
>+				       &about_fw_dma, GFP_KERNEL);
> 	if (!about_fw) {
> 		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Unable to alloc memory "
> 				  "for about_fw\n", __func__));
> 		return status;
> 	}
>=20
>-	memset(about_fw, 0, sizeof(struct about_fw_info));
> 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
> 	memset(&mbox_sts, 0, sizeof(mbox_sts));
>=20
>diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
>index e91abb3..968bd85 100644
>--- a/drivers/scsi/qla4xxx/ql4_nx.c
>+++ b/drivers/scsi/qla4xxx/ql4_nx.c
>@@ -4050,15 +4050,14 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host
>*ha)
> 	dma_addr_t sys_info_dma;
> 	int status =3D QLA_ERROR;
>=20
>-	sys_info =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
>-				      &sys_info_dma, GFP_KERNEL);
>+	sys_info =3D dma_zalloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
>+				       &sys_info_dma, GFP_KERNEL);
> 	if (sys_info =3D=3D NULL) {
> 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
> 		    ha->host_no, __func__));
> 		return status;
> 	}
>=20
>-	memset(sys_info, 0, sizeof(*sys_info));
> 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
> 	memset(&mbox_sts, 0, sizeof(mbox_sts));
>=20
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index 2b8a8ce..82e889b 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -2689,16 +2689,15 @@ qla4xxx_iface_set_param(struct Scsi_Host *shost,
>void *data, uint32_t len)
> 	uint32_t rem =3D len;
> 	struct nlattr *attr;
>=20
>-	init_fw_cb =3D dma_alloc_coherent(&ha->pdev->dev,
>-					sizeof(struct addr_ctrl_blk),
>-					&init_fw_cb_dma, GFP_KERNEL);
>+	init_fw_cb =3D dma_zalloc_coherent(&ha->pdev->dev,
>+					 sizeof(struct addr_ctrl_blk),
>+					 &init_fw_cb_dma, GFP_KERNEL);
> 	if (!init_fw_cb) {
> 		ql4_printk(KERN_ERR, ha, "%s: Unable to alloc init_cb\n",
> 			   __func__);
> 		return -ENOMEM;
> 	}
>=20
>-	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
> 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
> 	memset(&mbox_sts, 0, sizeof(mbox_sts));
>=20
>@@ -4196,15 +4195,14 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host
>*ha)
> 			  sizeof(struct shadow_regs) +
> 			  MEM_ALIGN_VALUE +
> 			  (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
>-	ha->queues =3D dma_alloc_coherent(&ha->pdev->dev, ha->queues_len,
>-					&ha->queues_dma, GFP_KERNEL);
>+	ha->queues =3D dma_zalloc_coherent(&ha->pdev->dev, ha->queues_len,
>+					 &ha->queues_dma, GFP_KERNEL);
> 	if (ha->queues =3D=3D NULL) {
> 		ql4_printk(KERN_WARNING, ha,
> 		    "Memory Allocation failed - queues.\n");
>=20
> 		goto mem_alloc_error_exit;
> 	}
>-	memset(ha->queues, 0, ha->queues_len);
>=20
> 	/*
> 	 * As per RISC alignment requirements -- the bus-address must be a
>--=20

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>

>
