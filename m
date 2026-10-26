Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018521;
	b=X2nr8llT+pTsn3IwtZ1Zm1Zmz9o23t8RJ/8C09ydFo1cCfy4Gx5lzn9xPr0LLO2QuS1w
	 DKPpjQ6FuumxfNMcDbIzdHa56MbQUbO5r6G/mjfGjqA/8k6ZpXua45rtyIGVvzU3XDK1A
	 MDHHIbjwqsaYiLMdyqjqqNe4Iv8oxS0JAFOvR7CVijvtDJviKkHAv7K8wMIJcpo0GK4LS
	 Dgb5l/KE8hYeLo9jmfPOFUzKVrrsbhep7CZLynmieTOsJVliqfjFIlItkA+J3BfwBgOTI
	 GaAWrSGp+Lg8qZ2nBu/B2Js2nBF5TDD4k64fZlLcsyVULm86TzWpKYguQ5pf7BQBv3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018521;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ee86deft2EMqHNTG/W7vHwCtD/2Z0I69U91PpChuFCg=;
	b=WefeNDmaVEydSA3MIl9HEFdCMtg8IRCz3RTJRU0r9aLwqyBuG0yZgGFN3cZbJGyLDfgx
	 /AvnRcPkYRDlZA8ullQY1yx7ZagIwMKsxTCCG/rqey8q2sLcn2kwqSZVeUp8FGVhc8Sd7
	 pbhCjjyFQeDf/LHD2be/nGs8UYOkZQdnD+6KMzvw2WzC9acql5tdLfFSaabQU/SYQUkXW
	 pXjDvY8ByDkCwan1zD4gIsbkaMASzf7ckMTphgKAQnJgirPEVibdRSaQVJI/dGAWHUFrk
	 Z9WCNjFHfZgxjM5ilFl6OrcliVzctIvVWtMvvsjnEMJ02zTSjsSYsPn8iYCXm+LhspA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=czYhut9M;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D65606A31A;
	Mon, 26 Oct 2026 12:41:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84D65606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=czYhut9M
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793018514; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Ee86deft2EMqHNTG/W7vHwCtD/2Z0I69U91PpChuFCg=;
	b=czYhut9Mn3uCKRErVmS2N3KjU2pExzeIVFhMsrHWYlWRSIUU0q7ZABdRGpm6P8Kv4/rUikkktMD/4W2iTQ3H6Pn2XdmDB4O2Ab1ldhZ4qxkC2xdRkTMfs8QoBGECe0t1BtQXKDQj+spAVwm7FhZnGDMWzmpgwwk6BbxnEzksSKc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDYkNph_1793018498;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDYkNph_1793018498 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 20:41:54 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	john.garry@linux.dev,
	ddiss@suse.de,
	hexlabsecurity@proton.me,
	xiangzao@linux.alibaba.com
Subject: [PATCH v2] scsi: target: Verify the iSCSI ISID is NUL-terminated
Date: Mon, 26 Oct 2026 20:41:38 +0800
Message-ID: <20261026124138.2708365-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261026044632.1738901-1-xiangzao@linux.alibaba.com>
References: <20261026044632.1738901-1-xiangzao@linux.alibaba.com>
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
TransportID as a pointer into the PERSISTENT RESERVE OUT parameter list,
lowercased in place and never NUL-terminated.  spc4r37 Table 508
requires the field to be null-terminated, but a non-conforming
initiator can omit the NUL; when the ISID ends at the end of the
received buffer, the pointer is not a C string.

The registration code still consumes it as one: strcmp() in
__core_scsi3_locate_pr_reg() and in the REGISTER AND MOVE path, and
snprintf("%s") in __core_scsi3_do_alloc_registration(), which also
reads its first 8 bytes unconditionally with get_unaligned_be64() -
a NUL check does not bound that read.

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

Require 8 bytes to remain after the ",i,0x" separator, and a NUL
inside the rest of the descriptor, before the ISID pointer is
returned.  REGISTER AND MOVE fails with TCM_INVALID_PARAMETER_LIST;
on SPEC_I_PT no target port claims the malformed TransportID, and the
command fails the same way.

Fixes: d04a179085c2 ("scsi: target: Bound PR-OUT TransportID parsing to the received buffer")
Reported-by: kitta <kitta@linux.alibaba.com>
Reported-by: sashiko AI review <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/sashiko-outbox-184760@kernel.org/
Cc: stable@vger.kernel.org
Cc: Bryam Vargas <hexlabsecurity@proton.me>
Cc: John Garry <john.garry@linux.dev>
Assisted-by: LLM
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---

Changes since v1:

- Bound the 8-byte get_unaligned_be64() read in
  __core_scsi3_do_alloc_registration() as well (sashiko review).
- Corrected the SPEC_I_PT outcome: the command fails, the scan does
  not skip the entry.

 drivers/target/target_core_fabric_lib.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 2853b95b2c59..ad024009df56 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -371,6 +371,16 @@ static bool iscsi_parse_pr_out_transport_id(
 			pr_err("Missing ISID in iSCSI Initiator port TransportID\n");
 			return false;
 		}
+		/*
+		 * The registration code reads the ISID as a C string,
+		 * and its first 8 bytes with get_unaligned_be64(), so
+		 * require 8 bytes after the separator and a NUL inside
+		 * the rest of the descriptor.
+		 */
+		if (buf + tid_len - p < 8 || !memchr(p, '\0', buf + tid_len - p)) {
+			pr_err("Incomplete or unterminated ISID in iSCSI Initiator port TransportID\n");
+			return false;
+		}
 		*port_nexus_ptr = p;
 		/*
 		 * Go ahead and do the lower case conversion of the received
-- 
2.43.7

