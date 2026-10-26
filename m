Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792990013;
	b=rwEhiE65Z5pXnEVyrNAmbIiQOjNJlnF/IuJEUGKY0vepgLXoFuLjaLu0z8fuyu9JavJr
	 Fg8BsPgUb1T0ICvXGDCLJQOomtqdBfH2CpSNDwJct2hcOw6/hnYWL62NgVBHhSddJmDP+
	 66bTYKteettPpKNPZX3Go0Z0vtUxV91btlOz4ODPHnfCfLKDmdqKrofsvUr0H+mY8BX3+
	 pfxVN2vQEPymWJniEYF0GWqDvm/PAqzlVrVebn36Yly2l49DRYq5BSiGWjzzEDyeV+K7w
	 s+riPcyzD+bVQVneaZK6hKWLOluDmf0ZfIrHKtCP2qL33krATJAoy3rAZDPODaq0Zog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792990013;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F9we1B1BcqT0qfRF/FTS2JiiyttBbvpi5NbTu56uFe4=;
	b=tNXCAWacU4SBaCPcDFe/PH9VuC76opO6vRPOe8YJpK0Fr4k3KXXExK+QdiW+052a3QUK
	 1w0HRMtf+hBHD1MV71tekNC6I/Mtsf4StFgMJRWqDxylwGE67Z6/gAOSYffIYDa77gYvr
	 A/zXMxnbq6B9ttMfXk5bt7tQLqrlWUdG5oAnxmYvfvocU5gLoGi/c4SYifku2DDHLZYr5
	 8YJM6R15j+D15fEjd+YOaDSMXn2akiqFhst1LljQyHIK/hMpRAXAMhoeHAlTB1zncWwc2
	 eA3mvx1UK/DZEAen+Qq691454Ruti7Ml5BA/Fjw35gbvLkJmkFGaRXyZv03H7KyLADA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	arc=none smtp.remote-ip=115.124.30.130
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885DD606A322;
	Mon, 26 Oct 2026 04:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 885DD606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792990001; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=F9we1B1BcqT0qfRF/FTS2JiiyttBbvpi5NbTu56uFe4=;
	b=YcoQ/Xj+gi9ghd2kMZHQnBRw8PPh+mZUHAJVXKgkDVyAnpWQsvF3dMfDhhF49PVjpQqkFnAe+BfAZ6wb/uB5nVLhhaNjd/V0ctw7ekyytO4LigHHJH+y6hhqF0ZaSin2l7jTpVcbAbCys74qoGWQib/CbwHAElhDfmPUNFHXAFo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDRrqrG_1792989992;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDRrqrG_1792989992 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 12:46:40 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	David Disseldorp <ddiss@suse.de>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	xiangzao@linux.alibaba.com
Subject: [PATCH] scsi: target: Verify the iSCSI ISID is NUL-terminated
Date: Mon, 26 Oct 2026 12:46:32 +0800
Message-ID: <20261026044632.1738901-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iscsi_parse_pr_out_transport_id() returns the ISID of a FORMAT CODE 01b
TransportID as a pointer into the PERSISTENT RESERVE OUT parameter list.
The lower-case conversion loop only scans the ISID and never terminates
it, and while spc4r37 Table 508 requires the field to be null-terminated,
a non-conforming initiator can omit the NUL.  When the ISID ends at the
end of the received buffer, the pointer is not a C string.

The registration code still consumes it as one: strcmp(isid,
pr_reg->pr_reg_isid) in __core_scsi3_locate_pr_reg(), and snprintf("%s")
and strcmp() in __core_scsi3_do_alloc_registration() and in the REGISTER
AND MOVE path.

When the parameter list spans more than one page, transport_kmap_data_sg()
maps it with vmap(), and the over-read walks off the end of the mapping
into the vmalloc guard page and oopses.  Reproduced with a PR OUT
REGISTER + SPEC_I_PT parameter list of exactly 8192 bytes whose final
TransportID carries a 12-byte ISID without a terminating NUL:

  BUG: unable to handle page fault for address: ffffc9000138c000
  RIP: 0010:strcmp+0xc/0x30
  Call Trace:
   __core_scsi3_locate_pr_reg+0xd3/0x120 [target_core_mod]
   core_scsi3_decode_spec_i_port+0x8fc/0x13a0 [target_core_mod]
   core_scsi3_emulate_pro_register+0x73c/0x900 [target_core_mod]
   ...
   iscsi_target_rx_thread+0xef/0x1d0 [iscsi_target_mod]

With a single-page parameter list the buffer is a kmap() direct mapping,
so the over-read continues into the physically adjacent page instead of
faulting.  snprintf("%s") then copies whatever follows the ISID in
memory into pr_reg_isid, and PR IN READ FULL STATUS reports the
registration back to any initiator, turning the over-read into an
info leak of kernel heap contents.  Reproduced with a 4096-byte
parameter list whose last TransportID ends at the end of the buffer
with a 4-byte ISID and no NUL, interleaved with I/O to populate
adjacent pages: the READ FULL STATUS response returned the ISID as
"0xleak" followed by raw bytes that were not part of the parameter
list.  The snprintf() into pr_reg_isid[PR_REG_ISID_LEN] caps the echoed
ISID at 15 characters, so at most 11 bytes past the buffer are leaked
per command, but the PR OUT command is not rate limited.

Any initiator that can send PR OUT to an iSCSI-exported LUN can trigger
either variant, including a guest via vhost-scsi.

Require the TransportID to contain the terminating NUL before the ISID
pointer is returned, so neither reproducer reaches the registration
consumers.  REGISTER AND MOVE fails with TCM_INVALID_PARAMETER_LIST;
the SPEC_I_PT scan skips the entry.

Fixes: d04a179085c2 ("scsi: target: Bound PR-OUT TransportID parsing to the received buffer")
Reported-by: kitta <kitta@linux.alibaba.com>
Cc: stable@vger.kernel.org
Cc: Bryam Vargas <hexlabsecurity@proton.me>
Cc: John Garry <john.garry@linux.dev>
Assisted-by: LLM
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---
 drivers/target/target_core_fabric_lib.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 2853b95b2c59..e15f5118b209 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -371,6 +371,17 @@ static bool iscsi_parse_pr_out_transport_id(
 			pr_err("Missing ISID in iSCSI Initiator port TransportID\n");
 			return false;
 		}
+		/*
+		 * The conversion loop below only scans the ISID without
+		 * ever terminating it, but the registration code reads it
+		 * as a C string.  With no NUL inside the TransportID,
+		 * the reads run past the descriptor, and past the
+		 * mapped buffer when the descriptor ends the buffer.
+		 */
+		if (!memchr(p, '\0', buf + tid_len - p)) {
+			pr_err("Missing NUL terminator for ISID in iSCSI Initiator port TransportID\n");
+			return false;
+		}
 		*port_nexus_ptr = p;
 		/*
 		 * Go ahead and do the lower case conversion of the received
-- 
2.43.7

