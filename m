From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 0/5] [SCSI] ufshcd: UFS Host Controller Driver
Date: Thu, 22 Mar 2012 13:51:51 +0000
Message-ID: <1332424311.2946.15.camel@dabdike.int.hansenpartnership.com>
References: <1330497714-26504-1-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330497714-26504-1-git-send-email-santoshsy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org, stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-02-29 at 12:11 +0530, Santosh Y wrote:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>=20
> UFS:
> Universal Flash Storage is a storage specification for flash devices.
> It is aimed to provide a universal storage interface for both
> embedded and removable flash memory based storage in mobile
> devices such as smart phones and tablet computers. The specification
> is defined by JEDEC Solid State Technology Association. UFS is based
> on MIPI M-PHY physical layer standard. UFS uses MIPI M-PHY as the
> physical layer and MIPI Unipro as the link layer.

This doesn't compile correctly on a 32 bit platform:

  CC [M]  drivers/scsi/ufs/ufshcd.o
drivers/scsi/ufs/ufshcd.c: In function =E2=80=98ufshcd_map_sg=E2=80=99:
drivers/scsi/ufs/ufshcd.c:555:5: warning: right shift count >=3D width =
of
type [enabled by default]
drivers/scsi/ufs/ufshcd.c: In function =E2=80=98ufshcd_host_memory_conf=
igure=E2=80=99:
drivers/scsi/ufs/ufshcd.c:831:5: warning: right shift count >=3D width =
of
type [enabled by default]
drivers/scsi/ufs/ufshcd.c: In function =E2=80=98ufshcd_initialize_hba=E2=
=80=99:
drivers/scsi/ufs/ufshcd.c:1037:2: warning: right shift count >=3D width=
 of
type [enabled by default]
drivers/scsi/ufs/ufshcd.c:1041:2: warning: right shift count >=3D width=
 of
type [enabled by default]

That's because you use >> 32 for the upper address bits.

I did the replacement below to use macros which do this correctly
(basically trick the compiler).

James

---

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 07ec973..52b96e8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -550,9 +550,9 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
 			prd_table[i].size  =3D
 				cpu_to_le32(((u32) sg_dma_len(sg))-1);
 			prd_table[i].base_addr =3D
-				cpu_to_le32(sg->dma_address);
+				cpu_to_le32(lower_32_bits(sg->dma_address));
 			prd_table[i].upper_addr =3D
-				cpu_to_le32((sg->dma_address >> 32));
+				cpu_to_le32(upper_32_bits(sg->dma_address));
 		}
 	} else {
 		lrbp->utr_descriptor_ptr->prd_table_length =3D 0;
@@ -826,9 +826,9 @@ static void ufshcd_host_memory_configure(struct ufs=
_hba *hba)
 		cmd_desc_element_addr =3D
 				(cmd_desc_dma_addr + (cmd_desc_size * i));
 		utrdlp[i].command_desc_base_addr_lo =3D
-				cpu_to_le32(cmd_desc_element_addr);
+				cpu_to_le32(lower_32_bits(cmd_desc_element_addr));
 		utrdlp[i].command_desc_base_addr_hi =3D
-				cpu_to_le32(cmd_desc_element_addr >> 32);
+				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
=20
 		/* Response upiu and prdt offset should be in double words */
 		utrdlp[i].response_upiu_offset =3D
@@ -1034,11 +1034,11 @@ static int ufshcd_initialize_hba(struct ufs_hba=
 *hba)
 	/* Configure UTRL and UTMRL base address registers */
 	writel(hba->utrdl_dma_addr,
 	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
-	writel((hba->utrdl_dma_addr >> 32),
+	writel(lower_32_bits(hba->utrdl_dma_addr),
 	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
 	writel(hba->utmrdl_dma_addr,
 	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
-	writel((hba->utmrdl_dma_addr >> 32),
+	writel(upper_32_bits(hba->utmrdl_dma_addr),
 	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
=20
 	/* Initialize unipro link startup procedure */
