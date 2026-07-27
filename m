Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C2A3F23C9;
	Mon, 27 Jul 2026 09:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785146386; cv=none; b=bHqDMDHbolIaI7u9rOr29Djbtt3qePR9eN5bARrof4/QsFWr4YH9dk0ObVOwX+ERKRimDmelfGzLqhQlAOAvq6QSbgzZVub6pzDsg+nIoBN0GaFAQG/taOxNeX08xdQPAvL4jd6UyXUrWZHiSKPewjkqTE/P946ab+sY3avNFtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785146386; c=relaxed/simple;
	bh=bfyacnrkO+Us/h0qrnmz0o/JfoZswPjdZs21jlnlp+Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=a1i1Rxcy76+QawOC++KcxFCYPu9CPmVcA7VxcDUNWJ4zYpW9uqjaWd6Rv8ENdiKIWIH8sprZOl6E32yF4FaIaJQr1R+F0H+eNCri0hhgc9RWDnLnM3mwjkYCZaeQttyERqBdF2OAK5PUTdAZQyPtx0/EI0yjSGNMMG9lw5IOEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcNW6ROT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcNW6ROT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ACC1F000E9;
	Mon, 27 Jul 2026 09:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785146384;
	bh=exTJjX1MTtXFRxLb8sndeHN2JbCf3AH5l7nquElVlL8=;
	h=From:Subject:Date:To:Cc;
	b=lcNW6ROTK+ND9VfZpHkWL370jZ20wMWa3DG7NFUyvmM7rDLaHFcaAelprqbzyH2Zq
	 /wxYaMLPrCeBGEnrj4w0VTE5C+o9GDE0kG/qBfN49z+Fpf5+9sC7EtQgo+T71W2Pju
	 TUYVA7QqbXaZMOUYy5La4pX/ZC2RVklYdFKc4HJi8+J4oPv0kBWFFyA7QovkSsAE2B
	 twxWbI3jY1F7mllX9Z8Wj6PfKHB4YX3o7o2uAZEdj83S1p1dWQlpv2WgdYH+HB8T5y
	 r4kpTAOQph6UZG4o0/jIJvjCAC04DZj1YzOujSkf6Em2xhCFpgmm4YkUhs//9X4aJS
	 2M/VPpHk0y9SA==
From: Konrad Dybcio <konradybcio@kernel.org>
Subject: [PATCH v5 0/3] Retrieve information about DDR from SMEM
Date: Mon, 27 Jul 2026 11:59:26 +0200
Message-Id: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33P3WoCMRAF4FeRXDcyk5389arvUaTEJFsDjbGJL
 hXZdzcK0l6svRk4A+cb5sJarCk29rq6sBqn1FLZ9yBfVszv3P4z8hR6ZgKEBALLj+WQPG855o9
 QXfZckdJotPNGSdZrhxrH9HMn3zc971I7lnq+X5jwtv0Hm5ADtxQkSB+ktMNbaW39fXJfvuS87
 oPdzEn8cRAWHNGdEF1AKRRppCfO8HAUIJgFZ+iO2ioKozQOUD9x6NfRAhcc6o4mM1orhDZu6a9
 5nq9C3nnAjwEAAA==
X-Change-ID: 20250409-topic-smem_dramc-6467187ac865
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785146373; l=4321;
 i=konrad.dybcio@oss.qualcomm.com; s=20230215; h=from:subject:message-id;
 bh=bfyacnrkO+Us/h0qrnmz0o/JfoZswPjdZs21jlnlp+Y=;
 b=k0ce6jaZZ8+A1zymxLM1fkILonljjaOOQpJjx9iMqEa84quikNZcCUTZnSqY7YUc35G18R9Ul
 rUGS99vmJ1kCFSedj9A21OsZDVxS3Wk1t3CmaUkFdxEIA3/qn0w7QU6
X-Developer-Key: i=konrad.dybcio@oss.qualcomm.com; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=

SMEM allows the OS to retrieve information about the DDR memory.
Among that information, is a semi-magic value called 'HBB', or Highest
Bank address Bit, which multimedia drivers (for hardware like Adreno
and MDSS) must retrieve in order to program the IP blocks correctly.

This series introduces an API to retrieve that value, uses it in the
aforementioned programming sequences and exposes available DDR
frequencies in debugfs (to e.g. pass to aoss_qmp debugfs). More
information can be exposed in the future, as needed.

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
---
Changes in v5:
- Parse DRAM data before publishing __smem
- Add trivial patch 1 converting 'unsigned' to 'unsigned int' to make
  checkpatch happy
- Link to v4: https://patch.msgid.link/20260721-topic-smem_dramc-v4-0-748f992278a3@oss.qualcomm.com

Changes in v4:
- Rebase on top of Dmitry's cleanups to ubwc_config
- Mark and consume the shared data as little-endian
- Fix compiler optimizing out what it thinks is impossible (odd
  v3_14freq case)
- Rework qcom_ubwc_config_get_data() per discussion to not alter
  hardcoded data
- Remove some unnecessary comments and assignments
- Return -ENODATA instead of -EINVAL for out-of-sensible-range HBB
- Cosmetic/line wrapping fixups
- Drop applied drm/msm patch
- Link to v3: https://lore.kernel.org/r/20260108-topic-smem_dramc-v3-0-6b64df58a017@oss.qualcomm.com

Changes in v3:
- Support v6 and v7 DDRInfo (v7 is used on e.g. Hamoa)
- Handle rare cases of DDRInfo v5 with additional trailing data
- Rebase/adjust to SSoT UBWC
- Expose hbb value in debugfs
- cosmetic changes
- Link to v2: https://lore.kernel.org/r/20250410-topic-smem_dramc-v2-0-dead15264714@oss.qualcomm.com

Changes in v2:
- Avoid checking for < 0 on unsigned types
- Overwrite Adreno UBWC data to keep the data shared with userspace
  coherent with what's programmed into the hardware
- Call get_hbb() in msm_mdss_enable() instead of all UBWC setup
  branches separately
- Pick up Bjorn's rb on patch 1
- Link to v1: https://lore.kernel.org/r/20250409-topic-smem_dramc-v1-0-94d505cd5593@oss.qualcomm.com

To: Bjorn Andersson <andersson@kernel.org>
To: Konrad Dybcio <konradybcio@kernel.org>
To: Kees Cook <kees@kernel.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
To: Avri Altman <avri.altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Mike Leach <mike.leach@arm.com>
To: James Clark <james.clark@linaro.org>
To: Leo Yan <leo.yan@arm.com>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
To: Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>
To: Mao Jinlong <jinlong.mao@oss.qualcomm.com>
To: Jie Gan <jie.gan@oss.qualcomm.com>
To: Paul Walmsley <pjw@kernel.org>
To: Palmer Dabbelt <palmer@dabbelt.com>
To: Albert Ou <aou@eecs.berkeley.edu>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: coresight@lists.linaro.org
Cc: devicetree@vger.kernel.org
Cc: linux-riscv@lists.infradead.org

---
Konrad Dybcio (3):
      soc: qcom: smem: Use 'unsigned int' instead of 'unsigned'
      soc: qcom: smem: Expose DDR data from SMEM
      soc: qcom: ubwc: Get HBB from SMEM

 drivers/soc/qcom/Makefile      |   3 +-
 drivers/soc/qcom/smem.c        |  80 +++++---
 drivers/soc/qcom/smem.h        |  12 ++
 drivers/soc/qcom/smem_dramc.c  | 430 +++++++++++++++++++++++++++++++++++++++++
 drivers/soc/qcom/ubwc_config.c |  40 +++-
 include/linux/soc/qcom/smem.h  |   2 +
 6 files changed, 533 insertions(+), 34 deletions(-)
---
base-commit: c5e32e86ca02b003f86e095d379b38148999293d
change-id: 20250409-topic-smem_dramc-6467187ac865

Best regards,
--  
Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

