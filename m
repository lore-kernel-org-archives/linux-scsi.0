Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E221E8342;
	Mon, 27 Jul 2026 09:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785146397; cv=none; b=TwU1qVxusRszGSLXYkqna4eHKhaT+wrZ2lQqQe+i3MpRNIAxPuX98ZayKiqWNGU8fqbyB0LHoigHO9dnnB8zsBhjCGg8omowHTBxsBNFDZi7RguILJ8GpHxEsqXADO1rRHlDCU9CalpOjL8ohU3KS26CLBSjqee/jO/VTPryze4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785146397; c=relaxed/simple;
	bh=Uw4AWcioLWEYmLtLSr7KRMXQCxtiIzSrxS/VJ+DL4/c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A3k8LoSiC8quM841jGoTJO7uSNEuC/yI4CUKnxsAB8XJmtCNZaJO+DfWuh2MJaKLODZU5HwSV4TSSm72E3Ca2gFlfqsQ4g3XnEuSdNFY+G4+se2uKQYquZKnjbOVY+NDRjMawet8uZv9nzYVwlnfkb7/oKl8vTqmZJ3Bwpf19V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv97oQui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv97oQui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB941F00A3A;
	Mon, 27 Jul 2026 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785146396;
	bh=Y6OdZ83Q4APGIr45OOsz+zKKJru1gP6SOM6EOnmQkKw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cv97oQui8XNG17Epn/ntuv4j3FbCMa9AgU7e8erUchj8xgDmFoXECi4ZWT88oXcy1
	 1OHdXVxTrPRhK8PrlJgD25LmHoUiAWL0IoelO/2xtmujtQ8ycxTJi9K+83qQH1fYYq
	 WMcRMZq8x/XuZbtq9Rm+MZikbtwCUwrSVFB7T9y8FYIaAkK7BlsVtGL+8ncP7GgfYL
	 kotyyxGZXMtZ6r4vsXHaYhrvZTLHA8227dlTsKBS2Sv/756d6vuwEtWxVQEi0dycTX
	 SNsCrKfUqEaGMZOnnW9MAkEZs5+iyH9hkxiPNxuHIYZXnzknd3iWQ++ey0mfnDPysu
	 kEtnRcS/+dl8A==
From: Konrad Dybcio <konradybcio@kernel.org>
Date: Mon, 27 Jul 2026 11:59:27 +0200
Subject: [PATCH v5 1/3] soc: qcom: smem: Use 'unsigned int' instead of
 'unsigned'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-topic-smem_dramc-v5-1-66188b3e338d@oss.qualcomm.com>
References: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
In-Reply-To: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, Sean Paul <sean@poorly.run>, 
 Akhil P Oommen <akhilpo@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach <mike.leach@arm.com>, 
 James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>, 
 Mao Jinlong <jinlong.mao@oss.qualcomm.com>, 
 Jie Gan <jie.gan@oss.qualcomm.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-hardening@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 coresight@lists.linaro.org, devicetree@vger.kernel.org, 
 linux-riscv@lists.infradead.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785146373; l=3578;
 i=konrad.dybcio@oss.qualcomm.com; s=20230215; h=from:subject:message-id;
 bh=F4aUrv2PAPQvB9kWaGWpV8lQozQorJ16HYhrryVxf9s=;
 b=iQIKsNjdmAKai8/0cIet+uIxOLHmUyfwV8NidBkeFPMP4vZ9yET6lwNRZbfku974Ofe5Re5Ks
 LMdzyJGjLC3DFHn39Aul+Ei6Mmc8SLISSBbNwUE2AAgjlXQAX6oBm6u
X-Developer-Key: i=konrad.dybcio@oss.qualcomm.com; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

checkpatch.pl reports:

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

Convert the SMEM driver to use the less ambiguous type instead.

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
---
 drivers/soc/qcom/smem.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index afb21a778fe7..43b66120fc64 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -281,7 +281,7 @@ struct qcom_smem {
 	struct smem_partition global_partition;
 	struct xarray partitions;
 
-	unsigned num_regions;
+	unsigned int num_regions;
 	struct smem_region regions[] __counted_by(num_regions);
 };
 
@@ -399,7 +399,7 @@ EXPORT_SYMBOL_GPL(qcom_smem_is_available);
 
 static int qcom_smem_alloc_private(struct qcom_smem *smem,
 				   struct smem_partition *part,
-				   unsigned item,
+				   unsigned int item,
 				   size_t size)
 {
 	struct smem_private_entry *hdr, *end;
@@ -460,7 +460,7 @@ static int qcom_smem_alloc_private(struct qcom_smem *smem,
 }
 
 static int qcom_smem_alloc_global(struct qcom_smem *smem,
-				  unsigned item,
+				  unsigned int item,
 				  size_t size)
 {
 	struct smem_global_entry *entry;
@@ -503,7 +503,7 @@ static int qcom_smem_alloc_global(struct qcom_smem *smem,
  *
  * Return: 0 on success, negative errno on failure.
  */
-int qcom_smem_alloc(unsigned host, unsigned item, size_t size)
+int qcom_smem_alloc(unsigned int host, unsigned int item, size_t size)
 {
 	struct smem_partition *part;
 	unsigned long flags;
@@ -544,7 +544,7 @@ int qcom_smem_alloc(unsigned host, unsigned item, size_t size)
 EXPORT_SYMBOL_GPL(qcom_smem_alloc);
 
 static void *qcom_smem_get_global(struct qcom_smem *smem,
-				  unsigned item,
+				  unsigned int item,
 				  size_t *size)
 {
 	struct smem_header *header;
@@ -553,7 +553,6 @@ static void *qcom_smem_get_global(struct qcom_smem *smem,
 	u64 entry_offset;
 	u32 e_size;
 	u32 aux_base;
-	unsigned i;
 
 	header = smem->regions[0].virt_base;
 	entry = &header->toc[item];
@@ -562,7 +561,7 @@ static void *qcom_smem_get_global(struct qcom_smem *smem,
 
 	aux_base = le32_to_cpu(entry->aux_base) & AUX_BASE_MASK;
 
-	for (i = 0; i < smem->num_regions; i++) {
+	for (unsigned int i = 0; i < smem->num_regions; i++) {
 		region = &smem->regions[i];
 
 		if ((u32)region->aux_base == aux_base || !aux_base) {
@@ -584,7 +583,7 @@ static void *qcom_smem_get_global(struct qcom_smem *smem,
 
 static void *qcom_smem_get_private(struct qcom_smem *smem,
 				   struct smem_partition *part,
-				   unsigned item,
+				   unsigned int item,
 				   size_t *size)
 {
 	struct smem_private_entry *e, *end;
@@ -683,7 +682,7 @@ static void *qcom_smem_get_private(struct qcom_smem *smem,
  *
  * Return: a pointer to an SMEM item on success, ERR_PTR() on failure.
  */
-void *qcom_smem_get(unsigned host, unsigned item, size_t *size)
+void *qcom_smem_get(unsigned int host, unsigned int item, size_t *size)
 {
 	struct smem_partition *part;
 	void *ptr;
@@ -717,12 +716,12 @@ EXPORT_SYMBOL_GPL(qcom_smem_get);
  *
  * Return: number of available bytes on success, negative errno on failure.
  */
-int qcom_smem_get_free_space(unsigned host)
+int qcom_smem_get_free_space(unsigned int host)
 {
 	struct smem_partition *part;
 	struct smem_partition_header *phdr;
 	struct smem_header *header;
-	unsigned ret;
+	unsigned int ret;
 
 	if (IS_ERR(__smem))
 		return PTR_ERR(__smem);

-- 
2.55.0

