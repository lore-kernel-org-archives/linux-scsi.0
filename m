Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCBE16C868;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713398; cv=none; b=Tt9svEWJIJt8DvRH50iEO2Rxau3qQpEGyYb8YRqjr92x3Lq1Fma0+P+Se5aAakrCB5lDzAsZlztmASxBumg4S7SmGsdUzwY074G0PafOViwsMPdDDjer4jMMOS0qAHm/E9drtNZ1slpjwp06azLVf7B5rHN+MbOOCeTKALxLV9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713398; c=relaxed/simple;
	bh=M0TaAX87c4MCbUoSFs6dg73+j59MTcKzey8Rq+WiyvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KcrgHiK5Z7xiXlnVt0CjOZagRgt7J/jmbKO/B/FCllISxMpkezm1dfMdqKeqcvu9CZ7sE/P41lHTq8uYqrHKD/EBr92DPWqW78NNkqQWjD1WIjvaK4TzOZRlTOEtWhAVb3+W7rcPoCVWrnx0KQ3R8aySCWGYqnYeKMg7Fs3zk7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onY5Rxkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onY5Rxkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F13C4AF0A;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720713398;
	bh=M0TaAX87c4MCbUoSFs6dg73+j59MTcKzey8Rq+WiyvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onY5RxkciUWaPQ1zlEcEk2UYj/7PQOo2VWIVVuA616HGjjoEd2NV1g7v9WQjHSai0
	 Z21OD947A7p3Kv0mBK8PuGbFcAy0uTC/nrZO+lSljWeWWLLlnEXgPFTDstmO/oQp1d
	 ws8dr7NIy56yNdcAwJ1B8pI3gzcj7OzRNwOJlQy/G1J5BmLI2i/laFk2uEpqh012mw
	 uKCxlv/cGV5zHTi0fPa56zKr0CBAs2SiMPaI9ci5cVp3j/ogcW4JcDaUH54vUtLdkc
	 DX45Dk/txdzbXi8f0u/RLCmMcWlU/R0nWIGBK5LEwFhGl8Q5BXW/sEDt8HoRZN1M3q
	 HTfPSYShxw5pA==
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
Subject: [PATCH 1/4] scsi: mpi3mr: struct mpi3_event_data_sas_topology_change_list: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 08:56:33 -0700
Message-Id: <20240711155637.3757036-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711155446.work.681-kees@kernel.org>
References: <20240711155446.work.681-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2444; i=kees@kernel.org; h=from:subject; bh=M0TaAX87c4MCbUoSFs6dg73+j59MTcKzey8Rq+WiyvA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkAC0gC9ATYg2hO2qEr19M3FsQgc+86AojP18P mAV5wRdhcqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAAtAAKCRCJcvTf3G3A JloZD/9GJ8L0SXq31DHkhsrmpqYcNmSB2lbfugqa7XniwodAjc+qMcyEOuXSGVSTgpPyvxSNhnU tkYUeWR3RTcj9VLEyTfW3YklwkLAYbJmHkjxLSysBZI4bboOlkOo6LcKW2GNSbvqaC9i77vmjJD 6x3hgZTwytK4zvaLdIR/oxmElgBurkn1+tN0IfRCEaUhKLCrgC2MOPv8+i7MfgFIzTEr2ZIXFzw dql4OoulganUccyLpD0nDCOxsGk3jvOaWSaX+ddKcEZBiZwQcMBZUL3yFy1NmK2CerO0UypCDC1 xRxtw1jrwJao2MW1rJnWskrTenJiIuXXKz6kj7grJBWBNTH3yYn1uSVET9FkTk5CNBuYc+KOO9X YHXhBn930vYVv9Jx2of6yNuhwIORL20wlHQElw/63AEAbpEjAa3FVgkV9nCAluwUGXW7Q0JWY+c 2YnJPBpAPpPeXHVihCR0ziX1yQposA4gciNs0Ffs2S6PXHLKnY4oGtAhrRzAfhoSRAhvEHudVss ilkPfg6U0o2Q+XG9l0Wop+gjwaOcA043H6dDNAlOXeFAh9Xafx8PZdpHSUYIsPlm9sUFDuVk8aY IoO10IImrIYXHUASFYmCw7QJKF/f/oJ1SmYNmcCm+/yWjNIUiU2r7J5s01hcKgw/8RbfOOIamKe 9IpYccz++Io21sg==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct mpi3_event_data_sas_topology_change_list with a modern
flexible array.

Additionally add __counted_by annotation since phy_entry is only ever
accessed in loops controlled by num_entries. For example:

        for (i = 0; i < event_data->num_entries; i++) {
		...
                handle = le16_to_cpu(event_data->phy_entry[i].attached_dev_handle);

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
index 028784949873..ae74fccc65b8 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -453,9 +453,6 @@ struct mpi3_event_data_sas_notify_primitive {
 #define MPI3_EVENT_NOTIFY_PRIMITIVE_POWER_LOSS_EXPECTED   (0x02)
 #define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED1             (0x03)
 #define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED2             (0x04)
-#ifndef MPI3_EVENT_SAS_TOPO_PHY_COUNT
-#define MPI3_EVENT_SAS_TOPO_PHY_COUNT           (1)
-#endif
 struct mpi3_event_sas_topo_phy_entry {
 	__le16             attached_dev_handle;
 	u8                 link_rate;
@@ -496,7 +493,7 @@ struct mpi3_event_data_sas_topology_change_list {
 	u8                                 start_phy_num;
 	u8                                 exp_status;
 	u8                                 io_unit_port;
-	struct mpi3_event_sas_topo_phy_entry   phy_entry[MPI3_EVENT_SAS_TOPO_PHY_COUNT];
+	struct mpi3_event_sas_topo_phy_entry   phy_entry[] __counted_by(num_entries);
 };
 
 #define MPI3_EVENT_SAS_TOPO_ES_NO_EXPANDER              (0x00)
-- 
2.34.1

