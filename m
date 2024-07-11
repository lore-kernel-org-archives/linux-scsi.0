Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC7B16C867;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713398; cv=none; b=ZIx+nMuFksmpvn5DtcuQgu0dPl2Z88o/OFj6jcU+B38zVwv27LqZQHdRXsBqTn1OakO9bNKNIVrZ34oVMUUCzN5IRvZ0y+pf0eKXj+sfzuist+Oz/V7eUdHW1yYOSqOFOW1kAtXxpS3zksYibYdex30BZYxVJypHoHjRWoblbXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713398; c=relaxed/simple;
	bh=SdBmAK4WejGwirzKCX1X04soOQzEtI+n5BTeCUSwg9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vxk5mYjKvSYdHvgqg8En0/l73teotLNAU5Yqj9ND+MxXb82e3MhAvJ3Y4sXCbGYCMFE43PIj+Pol1YzvaU6V+z7eE+8K9O+0ucVVUgVwat93OSNmHfWP5HXOwA+5IVP/Ke5Vhk/fRdiMZ4bQ2bUwoEORHXd+7H3yePvph4VGYeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJCSzFNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJCSzFNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7F2C4AF09;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720713398;
	bh=SdBmAK4WejGwirzKCX1X04soOQzEtI+n5BTeCUSwg9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJCSzFNVhJ55+5nSyLmrtDjY+oVk/UlmeVmHMhf2W0FKD/HgQIQ8gdSL1Xn31i4De
	 JPpw8uIbKsYuEeYDOSm2FMcSNOROX+0BrTvQ1/nqKvFi4L9AK9pI06GiHOElHrWSIX
	 tftu9Wit07B0Kd5/dA3vKjp+TrjnQrhhCB9jYR8xOL4NJsS6MvHYPG895vKL62Gtem
	 AGy69YdBsPEGws4EhVkAnreWhvPJ13E+d1Ptc/GMQ5XGuNQpARFmb7Q0kENsehFrEq
	 Q4GXEqq/WsTFm9FPf6TQwn+KWKlGngtXYKqqneXUgDqcwX9N8QioNI01gq5w1/1+Ju
	 yvIHlJyCj+trw==
From: Kees Cook <kees@kernel.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] scsi: mpi3mr: struct mpi3_event_data_pcie_topology_change_list: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 08:56:34 -0700
Message-Id: <20240711155637.3757036-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711155446.work.681-kees@kernel.org>
References: <20240711155446.work.681-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2512; i=kees@kernel.org; h=from:subject; bh=SdBmAK4WejGwirzKCX1X04soOQzEtI+n5BTeCUSwg9s=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkAC0GRmeTbFMiK4EnJ9ReQW+qUVn5p7EksGrX 9fFFpP2sEiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAAtAAKCRCJcvTf3G3A Jr3ZD/9MS5VLvjrDTySiDG5PdGfa/Gu2iKahWUywl+qTltE785eeOnrWtOm0fKhqPgIxxhAgGXF llihInuUlVhH5l8d4UMVsrNabk7iSc3CCNrkgm4u4eW0m2xtrSRsJvfRoZvh7gpmyM+SGpeaAuu +PGymGgLtxEqRgOHFme+7ZNCFUkDvc4F0CcjOuPaS1yL+5QRahyzpPxbHe4P0anZmFvRCItZDO4 +h32JGXkwDA2ikqgjAMYT8u6WePlEIxFnMwQO8Rvsgu9nli9RuJVdosT79kTZr6i9t2auxSRP7h DE4DuSRY+T5V3NN30yO3JCSq5MsunFWAsgZaM1zURHgAcqQTPmBccdEnOwxvcpIzmcQSarzHkWm /plxqCU4SiRxRUX75ud4Z5DjlebFn+3YjxHVtxEkag76MHzOdObooigdTr+1kci3/gU47kcMKBH 8glhEi3LvnuvDAhV/yH52Ub14rigG8E7VqntZ51ElP01/+tTJSQTKj4+F4+a6ok5qtBIKFb1HgV OXa84h1AiBgUrkhgipQJhiNnpyYmlcso+0tmVnrZ6ne5E12qz6i0F5JlzKk6yfPp1c1vlfh5tMw CJ8P9uNkMtiOGDs9EzYqUAsoeEB8sRLfeQSPhsnQQ3Xgas6FFFyVO6d/78jGWQAWYWejjLg2LX9 F+nI//VyUrN/ajw==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct mpi3_event_data_pcie_topology_change_list with a modern
flexible array.

Additionally add __counted_by annotation since port_entry is only ever
accessed in loops controlled by num_entries. For example:

        for (i = 0; i < event_data->num_entries; i++) {
                handle =
                    le16_to_cpu(event_data->port_entry[i].attached_dev_handle);

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
---
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index ae74fccc65b8..c9fa0d69b75f 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -542,9 +542,6 @@ struct mpi3_event_data_pcie_enumeration {
 #define MPI3_EVENT_PCIE_ENUM_ES_MAX_SWITCHES_EXCEED         (0x40000000)
 #define MPI3_EVENT_PCIE_ENUM_ES_MAX_DEVICES_EXCEED          (0x20000000)
 #define MPI3_EVENT_PCIE_ENUM_ES_RESOURCES_EXHAUSTED         (0x10000000)
-#ifndef MPI3_EVENT_PCIE_TOPO_PORT_COUNT
-#define MPI3_EVENT_PCIE_TOPO_PORT_COUNT         (1)
-#endif
 struct mpi3_event_pcie_topo_port_entry {
 	__le16             attached_dev_handle;
 	u8                 port_status;
@@ -585,7 +582,7 @@ struct mpi3_event_data_pcie_topology_change_list {
 	u8                                     switch_status;
 	u8                                     io_unit_port;
 	__le32                                 reserved0c;
-	struct mpi3_event_pcie_topo_port_entry     port_entry[MPI3_EVENT_PCIE_TOPO_PORT_COUNT];
+	struct mpi3_event_pcie_topo_port_entry     port_entry[] __counted_by(num_entries);
 };
 
 #define MPI3_EVENT_PCIE_TOPO_SS_NO_PCIE_SWITCH          (0x00)
-- 
2.34.1

