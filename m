Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAD0287268
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 00:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780966757; cv=none; b=hGxrTAGAvp9dZXRhNrD3HmJRemCFS+Dsrkm8qCeQTIFYFSLHC5R2l/+zII5Hy0p3Pei8u+PTcztPRT3BnM2keXMCNX4w84Fp/oaaE+jXqxXreff681pGZyE3jMJnqKbHFF8NAAcOixxWIGjbATNIZzIVj0kcxSgT1d61HKKGhg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780966757; c=relaxed/simple;
	bh=+txlVYQbhsLzrI9YU7PRiOxabLp6hvZFkfWWN8zM2E4=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=QTW6hYZS4vEFYq6QI64jOt/Gf7ESkzUeWRNMnMGPq+Mefnx2l4HIe5l/pMgnnS033gZ1cnx9OGQmqCHIzBxhMLTkNYLjL5mwCxvvkvKxQEzXemB8CcvH/z50E6AoElBVzoSyyhnKMU2qpISEAhOeEUjALAVMyZ1rJmQ2x0N4FMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=hX/thsH+; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="hX/thsH+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=f2hwi3ugajfh5axgiob3jjz4mq.protonmail; t=1780966750; x=1781225950;
	bh=myZ3rdE4X5AVoe65V2Wzw7Ke2123lNyv2WQqkiW/qe4=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=hX/thsH+PBDKacqnjsyAc69SG1wmN3xK3WrIaH7u47KAu80RBE+jwCAD45GBfMbEz
	 T2CRaVyMU4oXdXu4BtaUQMT0thDLk3Co2xHO3aup/I4yaJ8eprOBIh9ZJPS8kbD03s
	 Po3rfW2Txd7qofwIT/FMcJQsn2cNvxFVMKxq3GYM0eOGG0XJPz3ZQfzTSDIxvvwxMI
	 eDJkL8jA6iur/1tZ8SEUzCZc4a4h6KZbGsfIS9H8dAdYdoA43P/kVH9z2DTUtPu0uP
	 OIhFn7Eefvp6zrB5zTEMbdFPgkXB8wdkmrgt0wwDKkI3HPqbI4nr6jjxsUqUPqwNCO
	 c0Li2b+cKiYig==
Date: Tue, 09 Jun 2026 00:59:02 +0000
To: "Martin K . Petersen" <martin.petersen@oracle.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mike Christie <michael.christie@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>, John Garry <john.g.garry@oracle.com>, David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: target: copy iSCSI ISID before unmapping the PR OUT buffer
Message-ID: <20260609005858.17504-1-hexlabsecurity@proton.me>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 39c6ba65783eb5f4a6d54da329088cb70627707d
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

core_scsi3_emulate_pro_register_and_move() maps the PERSISTENT RESERVE OUT
parameter list with transport_kmap_data_sg() and parses the destination
TransportID with target_parse_pr_out_transport_id(). For an iSCSI
TransportID (FORMAT CODE 01b) iscsi_parse_pr_out_transport_id() returns
the ISID as a raw pointer into that mapped buffer (the bytes following the
",i,0x" separator).

The function then unmaps the buffer with transport_kunmap_data_sg() before
dereferencing iport_ptr in strcmp(), __core_scsi3_locate_pr_reg() and
core_scsi3_alloc_registration() (the last reads 8 bytes via
get_unaligned_be64() and copies the string with snprintf()). When the
parameter list spans more than one page (PARAMETER LIST LENGTH > 4096),
transport_kmap_data_sg() uses vmap() and transport_kunmap_data_sg() does
vunmap(), so the kernel virtual address backing iport_ptr is torn down on
all architectures and every subsequent dereference is a use-after-free of
the unmapped region.

initiator_str does not have this problem because the parser strscpy()s it
into a caller-owned buffer; iport_ptr is the only output left as a borrowed
alias. core_scsi3_decode_spec_i_port() consumes the same alias safely
because it unmaps only after all uses.

Move ownership of the ISID string into the parser: after lowercasing the
ISID in-place, allocate a private copy with kzalloc(PR_REG_ISID_LEN) and
return that instead of the raw buffer pointer. kzalloc() zero-fills the
allocation to PR_REG_ISID_LEN bytes so the fixed 8-byte
get_unaligned_be64() read in __core_scsi3_do_alloc_registration() stays
in-bounds and returns deterministic results even for an ISID shorter than
8 characters (plain kstrdup() would give an allocation shorter than 8 bytes
for a malformed short ISID, turning the be64 read into a heap out-of-bounds=
).

Both callers now own the returned pointer and must kfree() it when done.
core_scsi3_decode_spec_i_port() frees before each inner-loop parse
iteration (so that a failed ACL match that continues the search does not
leak the previous parse's allocation) and at the error and success exit
paths. core_scsi3_emulate_pro_register_and_move() frees at both the
success return and the error label.

Fixes: 4949314c7283 ("target: Allow control CDBs with data > 1 page")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
v2 (review of v1 by John Garry):
 - Move the ISID copy into iscsi_parse_pr_out_transport_id() so the parser
   returns an owned allocation via *port_nexus_ptr; callers kfree() it.
   v1's stack-buffer approach (isid_buf[] + iport_ptr =3D isid_buf) is gone=
.
 - Use kzalloc(PR_REG_ISID_LEN) + strscpy_pad() rather than plain kstrdup()=
:
   __core_scsi3_do_alloc_registration() reads the ISID with a fixed 8-byte
   get_unaligned_be64(isid); a malformed ISID shorter than 8 chars would
   give a kstrdup allocation smaller than 8 bytes, causing a heap OOB on
   that read.  kzalloc zero-fills to PR_REG_ISID_LEN (16) bytes.
 - core_scsi3_decode_spec_i_port(): add kfree(iport_ptr) before each
   inner-loop reset (line ~1574), at out_unmap:, and before return 0.

Class / impact: CWE-416 use-after-free (use-after-vunmap) in the LIO SCSI
target. Triggerable by an authenticated iSCSI initiator that is a current
Persistent Reservation registrant on the LUN: it sends PERSISTENT RESERVE
OUT / REGISTER AND MOVE with an iSCSI (FORMAT CODE 01b) TransportID and a
PARAMETER LIST LENGTH > 4096 so the parameter list spans >1 page and is
mapped with vmap(). After transport_kunmap_data_sg() vunmap()s that region,
the retained iport_ptr is dereferenced -> kernel read of an unmapped
vmalloc address (oops / DoS; memory-safety corruption confirmed by KASAN).
Primarily a remotely-reachable authenticated denial of service.

Affected: all maintained trees -- it became a destructive dangling
dereference with 4949314c7283 (v3.3, 2012), which introduced the
multi-page vmap() path. Verified present at mainline v7.1-rc6 and
stable v6.12.92.

Reproducer (authenticated iSCSI initiator, current PR reservation holder):
  1. PERSISTENT RESERVE OUT / REGISTER a key from the iSCSI nexus.
  2. PERSISTENT RESERVE OUT / REGISTER AND MOVE, FORMAT CODE 01b TransportI=
D
     (IQN + ",i,0x" + 12-char ISID), RELATIVE TARGET PORT IDENTIFIER of an
     existing target port, with PARAMETER LIST LENGTH =3D 8192 (two pages -=
>
     vmap()/vunmap()), the inner ADDITIONAL LENGTH set so tid_len + 24 =3D=
=3D
     data_length, the remainder zero padding.

A/B verification (CONFIG_KASAN_VMALLOC=3Dy, kasan.fault=3Dreport, x86-64,
6.12.90; reproduced with both a 64-bit and a 32-bit initiator):
  - Without this patch (8192-byte, two-page request):
      BUG: KASAN: vmalloc-out-of-bounds in strcmp+0xa7/0xb0
        strcmp
        core_scsi3_emulate_pro_register_and_move [target_core]
        ? remove_vm_area
        target_scsi3_emulate_pr_out [target_core]
        __target_execute_cmd / iscsit_execute_cmd / iscsi_target_rx_thread
      The buggy address belongs to a vmalloc virtual mapping
      BUG: unable to handle page fault for address ... (PTE 0)
  - Control (56/128-byte, single-page request): no report (kunmap is a
    no-op on 64-bit !HIGHMEM).
  - With this patch (same 8192-byte request): no report, command completes.

drivers/target/target_core_fabric_lib.c | 16 ++++++++++++++++
 drivers/target/target_core_pr.c         |  5 +++++
 2 files changed, 21 insertions(+)
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/targe=
t_core_fabric_lib.c
index 87c5d26a5089..b5ad45f072bd 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -19,6 +19,7 @@
 #include <linux/hex.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
@@ -367,6 +368,21 @@ static bool iscsi_parse_pr_out_transport_id(
 =09=09=09*p =3D tolower(*p);
 =09=09=09p++;
 =09=09}
+=09=09/*
+=09=09 * The loop above advanced p past the ISID; *port_nexus_ptr still
+=09=09 * holds the ISID start.  Replace the borrowed buffer alias with an
+=09=09 * owned heap copy so callers can safely use the ISID past the
+=09=09 * buffer lifetime (e.g. after transport_kunmap_data_sg() in
+=09=09 * register_and_move).  kzalloc() zero-fills to PR_REG_ISID_LEN
+=09=09 * bytes so the 8-byte get_unaligned_be64() read in
+=09=09 * __core_scsi3_do_alloc_registration() stays in-bounds even for
+=09=09 * an ISID shorter than 8 characters.
+=09=09 */
+=09=09p =3D *port_nexus_ptr;
+=09=09*port_nexus_ptr =3D kzalloc(PR_REG_ISID_LEN, GFP_KERNEL);
+=09=09if (!*port_nexus_ptr)
+=09=09=09return false;
+=09=09strscpy_pad(*port_nexus_ptr, p, PR_REG_ISID_LEN);
 =09} else
 =09=09*port_nexus_ptr =3D NULL;

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_p=
r.c
index 11790f2c5d80..d7340c4fbd07 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1571,6 +1571,7 @@ core_scsi3_decode_spec_i_port(
 =09=09=09=09continue;
 =09=09=09dest_rtpi =3D tmp_lun->lun_tpg->tpg_rtpi;

+=09=09=09kfree(iport_ptr);
 =09=09=09iport_ptr =3D NULL;
 =09=09=09tid_found =3D target_parse_pr_out_transport_id(tmp_tpg,
 =09=09=09=09=09ptr, &tid_len, &iport_ptr, i_str);
@@ -1808,9 +1809,11 @@ core_scsi3_decode_spec_i_port(
 =09=09core_scsi3_tpg_undepend_item(dest_tpg);
 =09}

+=09kfree(iport_ptr);
 =09return 0;
 out_unmap:
 =09transport_kunmap_data_sg(cmd);
+=09kfree(iport_ptr);
 out:
 =09/*
 =09 * For the failure case, release everything from tid_dest_list
@@ -3532,10 +3535,12 @@ core_scsi3_emulate_pro_register_and_move(struct se_=
cmd *cmd, u64 res_key,
 =09core_scsi3_update_and_write_aptpl(cmd->se_dev, aptpl);

 =09core_scsi3_put_pr_reg(dest_pr_reg);
+=09kfree(iport_ptr);
 =09return 0;
 out:
 =09if (buf)
 =09=09transport_kunmap_data_sg(cmd);
+=09kfree(iport_ptr);
 =09if (dest_se_deve)
 =09=09core_scsi3_lunacl_undepend_item(dest_se_deve);
 =09if (dest_node_acl)

base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66
--=20
2.43.0

