Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC3816C862;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713398; cv=none; b=lBNUQl7XyivBindY3g8BfDdzqVAj3pr7aJ54Nn6bPlhs/6LKOj+WzEkvuODka6H37Z1CztG0Bo/xVQ/i6PrsGRBtxhj28Joz5x3f2YRCb168o0qfncy3sK7AESx9Lhv0GJCPhholULyIQuwOws88DUk5nuWlENaepCRDLLUKJbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713398; c=relaxed/simple;
	bh=ceKGGnTAjklHaSz4gxNIGaCk5r6S+F8c24F+nByrLnE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GsvTtVfF+aeP+in+Ys4MsrZyzLvyzr6DqY1O13vygNR0GxXqULjU5cUMyVwteKzRlLVf9tZYC40ozCGxTrJQAgtivCg6/jIWPoYsFmRPr46qI6CXls4k3jtBgI/VdQ+xWv1QK2nZakcvw86lzYm7p7EV0N+w2XzwRma9msN/83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wfp8im0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wfp8im0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E4DC116B1;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720713398;
	bh=ceKGGnTAjklHaSz4gxNIGaCk5r6S+F8c24F+nByrLnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wfp8im0T9VRl45D84VFEUVg2z5/nwHo24V8RzMbxHAW//OMcSetn9aEb26AoP8fr/
	 qajCrv3786itkDOauCha0EyN/tX0OjBcqzpDgcmWbkD59UkRWbZA9QWs0OlYxozq/5
	 moRL9RRHdGb2Crdg5KFEKPl9tbAzBji8tSW+UXYGKdqdt8Fvb/EHR5lOL753t1n+Ia
	 BN/6q72+6Y6jOQxztr6x3ELArul/X7Qnn4kkn4EtXGAYmMmiGzuSkx6y5YMydiZKc+
	 zMYVW6RaWXX5+uNNPaPCzDs7cZ2vNas9UUBzxT75FcH7h3EW/XHAZwQyEkdfcZwENd
	 kZq4WcgaSXAoA==
From: Kees Cook <kees@kernel.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 4/4] scsi: mpi3mr: struct mpi3_sas_io_unit_page1: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 08:56:36 -0700
Message-Id: <20240711155637.3757036-4-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711155446.work.681-kees@kernel.org>
References: <20240711155446.work.681-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1822; i=kees@kernel.org; h=from:subject; bh=ceKGGnTAjklHaSz4gxNIGaCk5r6S+F8c24F+nByrLnE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkAC02Oddyp8Zvw0b2ehDDaawKDA18u5S0Eslw mHCmnFcXyGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAAtAAKCRCJcvTf3G3A JnHzD/9d7UyLj25sOOXsPkCARYfig3p2RzO61wwr9ujTHHLKO2SDfGS3zHhnQY+JdQ8qNO05Wbt 3M374yju6zCnzeLFmhKoEjJmqOxz+V4QPDBXA0od3l4W9+YTMRNRCciUbUjCDjGq7Snn6itPquT o9rXVLyBx7cHe72T2WjqeuNg7BfoZtxX4CgE+itax5z5OKr5rCeCGK35rr27UTv5hqmbwtyQJD1 DkPW2vRKQ0348BrHm/+Lh3iSmIklMFM9n+JEv1aS2XFkhCYPZ7JO/+UScjklaP+8YovxhasAp/i 7sGfL+2kZ5QJaRJm2M8iu3n60S3ZzBBg/MiIO+0yqDv9Q+sa3EYmJGYkLz/RKLqShBFa0PTqod+ mzLy2oFy3JNgDdHU36nM+682kKsS6D+5R7wDQ5GrLLskG7D80zapMKeFwaW5hdWo9Rade7iF9iZ OckAjsOGexYyYCHvlJ8zgB+PJnOcqbslGf4kgG/lYE8tLOHNXZKFqqrQDGho2XE89p6fhRWN4wv /Ki80M5Qi/dg+fKXOIWKcfilSXA8/wDuvV03UduGfW5ckOUc0PU9Wpf+I3Qc5CVvulE3FmwP5Ji b9K0gGQhXsergufZrU0ciBc1ATyFV++lFhqEreD49rv3upRY3gLTqh2m/qgLFD80VhI/+CVEg7m 52UcOasjDkS4xaw==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct mpi3_sas_io_unit_page1 with a modern flexible array.

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
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 66cca35d8e52..4b7a8f6314a3 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -1603,9 +1603,6 @@ struct mpi3_sas_io_unit1_phy_data {
 	__le32             reserved08;
 };
 
-#ifndef MPI3_SAS_IO_UNIT1_PHY_MAX
-#define MPI3_SAS_IO_UNIT1_PHY_MAX           (1)
-#endif
 struct mpi3_sas_io_unit_page1 {
 	struct mpi3_config_page_header         header;
 	__le16                             control_flags;
@@ -1615,7 +1612,7 @@ struct mpi3_sas_io_unit_page1 {
 	u8                                 num_phys;
 	u8                                 sata_max_q_depth;
 	__le16                             reserved12;
-	struct mpi3_sas_io_unit1_phy_data      phy_data[MPI3_SAS_IO_UNIT1_PHY_MAX];
+	struct mpi3_sas_io_unit1_phy_data      phy_data[];
 };
 
 #define MPI3_SASIOUNIT1_PAGEVERSION                                 (0x00)
-- 
2.34.1

