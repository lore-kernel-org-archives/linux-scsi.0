Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043413;
	b=OyDwywEiuMCyDZpDUecW7gRPBf5ti91LPk1g3jsZ0/QVplHnMpLxyFrGO80HYdOFqzr4
	 YXP3x7kZg9A4R8Gu2NEOO4BxHcHq5nIhCMbTH7AYvBV2pI1Tx7HNyjdEyx/xWuVLHhUmy
	 H7W8iikAOBGeiFPQpmzrc4albGxwCNv5gWQQmcNF/M+YCtEoM1AdXZTHvNc0MCPgrQivo
	 NDoce+PPVT78vi4QmlLc4uldtwc9qe1U6qIXsIoBmwNLuAOqFfuGxooeWqibkZ/W+1hZp
	 6+kVJRAFUsAD9G7V0bx6k4TbBPyYdljyDzaTvI4gVNLY7H66j9ZmXo4yFAePCAOzZfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043413;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=MG+gW1EVMSKvb4NfoIrlm9cuiPMNVKfTsf1BhG8ibl4=;
	b=p4S4om6AFgyXgUXererWfn+bjKj+F9zt0AB1zdubPCSWcujiz5o6nhRebXzocl4asTx+
	 j5ee+EGR+LvOPccVxjLF5yLrcR4cnJ1ReO+/UpX7KQJ2PJJj6/xbTPTi02LgtpgaZ4GyT
	 9QJlhyWmQX6c68bAnI2q7t3JxR76bZ/+23HjzWubaE8FI3Dix3hoKLc4J6hh9NquagQYA
	 YNZmH+f9Ly5ocZIuyXzXj/iYw2iexj3cJu60RDqetie+Fy+D4NglI8hrIeXnmPnq82B/F
	 Of3BCeG2JUHsFnczQW/YFbRtZmEjAASMU4xTqn9Bgs61gUqP1KOLtUpB8vEr1t+wO3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VWTvd1yA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C70660A2622;
	Wed, 18 Nov 2026 23:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VWTvd1yA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F9B1F000C4;
	Wed, 18 Nov 2026 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043413;
	bh=MG+gW1EVMSKvb4NfoIrlm9cuiPMNVKfTsf1BhG8ibl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VWTvd1yAnLq2Q/+3oHCac0u9wTguZc/cda/+svA65RQllGDP5e/NPteEpYKb4t0ba
	 DhaskKXQDecA1MD9/VsydjaTw59EUzbTk9+2vN7suTjFrS4Dv7Ywg7lyiWXqGMQ6xY
	 0CRjnB9jt5N3TETs02hEOjDh3v05KLf1u2989+uc0vjwRmHrJWztu8xiYmKWijlXp8
	 gBb9MCW+58k+KF2oViAEpzjVVkLKvTmmxHemdbAjUyE5M2OTWc92n1DzFkiytLU+jj
	 aVYWg3ovAATHvSW1fDJHGpVkvW9l3z2jb1DhZ7DmHEppybyOp+2FfPf0JwT2c8sSyN
	 SxzyTNkRnpxzw==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:01 -0800
Subject: [PATCH v3 04/11] scsi: mpt3sas: Fix pcie_device leak in
 _scsih_ublock_io_device_wait()
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-sas-abba-v3-4-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1833; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=+aNnIbQIALjy/ci901sXJi/VmWzbCUg9vUt/h27aZJs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBQmExxfmufsizEKy1m474Cb0iWp3A8NjQTV
 xt16g3PcgqJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUAAKCRAADmhBGVaC
 FZGPD/9afVqmuQszpdzHnV+cAJiy79dY6vFVUSVI+nCBs5Kv71tlMjSDP8OgZmlF54KejhKqP2V
 Pbm6UJ1E5qUTel8P40xuDX4BuIx1ibpqLhjRXOboDrRDQqPsfjj/nBe/j6kvl7Yy1eCMccGEbjt
 y0n1z0uqQdN+v8ooIn/Kh9T3faY85TTxwwQEOubxhZvAq7g27sJvgGTPzfnI2uUc6rgPoiexyEh
 4S8LZnY8HRsaRMuyop2aR8lgzpwmI/OEoK8yefjMLGiQrb9Xo3mb8cG/elTOhjQiuzJM4ELfQQj
 ZXXIlRSmVDzZnU9VXmuKugxRLn5AntXctOYZRxelu4c+yg628XsVUOpE4hdQFbB1QKDFCSmOkV0
 4hQcFApUpe9GBsJcHsjtVTr+0GcdP3in5Yv+EFDbKBtBhqIy0ml6F5+1egA0nWCIxg3SaT9yCKM
 EPmfXcmMqg84Tef7osIgsCC0PHiiE9qmUpa4u+vS80nx603GpZ5p1h84AX7b9Ixk6qrzGsKRgR2
 2Js2KO6fvClR1nv46zLEvjVqRu+zQeo9zl32GBNm2TFGTydlB4qp55rS2OhVDfSVH4ddCXxVXKN
 CsmkhSfJQmfyc9fZML0ZlS3aJ7+SmQZ0sX4Z545zVADygvl16+ml1dTuQSh8hIFmoMIG89GzmJV
 KJF6n5CWDPEZ3Sw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

_scsih_ublock_io_device_wait() gets the pcie_device on each pass of its
TEST UNIT READY retry loop. But it puts the pcie_device only at the
bottom of the loop. The DEVICE_RETRY/START_UNIT/STOP_UNIT/RETRY_UA
branch ends in a continue, which skips the put. Thus each retry of an
NVMe device leaks a reference, and the driver can never free the
_pcie_device.

The function needs the pcie_device only for the reset timeout and the
reset method. Put the pcie_device immediately after the function reads
these values.

Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and readiness handling for slow devices")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2d98fcb8e135..45419f0ebedc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4220,6 +4220,8 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 				tr_timeout = pcie_device->reset_timeout;
 				tr_method = MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE;
 			}
+			if (pcie_device)
+				pcie_device_put(pcie_device);
 			rc = _scsih_wait_for_device_to_become_ready(ioc,
 			      sas_target->handle, 0, (sas_target->flags &
 			      MPT_TARGET_FLAGS_RAID_COMPONENT), sdev->lun, tr_timeout, tr_method);
@@ -4241,8 +4243,6 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 				}
 				continue;
 			}
-			if (pcie_device)
-				pcie_device_put(pcie_device);
 		} while ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
 		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
 			&& count++ <= command_retry_count);

-- 
2.56.1

