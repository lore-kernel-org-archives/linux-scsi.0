Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A3E24A07C
	for <linux-scsi@vger.kernel.org>; Sat,  6 Jun 2026 01:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780710867; cv=none; b=kIWuZyeU84USiLYrLQeD00i+4vVLt6iiOnoruI7ZOTM6qLlh/xEwWah5EHDhO1+feq77LRaqS0z3c4ubbnQ83y4VnhdfOVSJ1Xv0H/gNiWZ6RPDkA0gECc/xxh1gyfNXMDB/XU7Z7gSRN4g/J1AAPI5YXUuKQfpMc3wcN8ckau8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780710867; c=relaxed/simple;
	bh=4xCBLXpZkQ5ZWF7wgaJ0bFA7lqdW6pE50xsoulFbMl4=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=keqUv2lO8n3AedcLWMUji1WEmutp0OockyXgvok/2Xe4c/lsg/kNqxhvdwNomKLCHSSAkp0mHRifmQZCO9RbDUf6JGU1pajmKyAQPLKpUXEP1NXgZ8DWYwupii4GtgYIM4JnlhOwG9oS18XkBslQyiG2YVf9WHIyIkbOeG20qOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=SBJNoV1g; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="SBJNoV1g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1780710848; x=1780970048;
	bh=MDDqlyl1man/oMNqafLv44XpGatzizLBqYeIOfvJ4D8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=SBJNoV1gMqqpLWWezaOF3WdpT+ZC9zx3hszc9duGrSAUoMzVmhpccyyee0YMSoNIl
	 hyxhUKMvDrRDGQRuYcHBQV1y3A0zqtUWYZwG+MjV78fnF3IgiuKUHE/bujwSApkMVv
	 6SYnIkQZqrjinCPctbHiEflXgE3ZY45yPqEvr9WzHFR/mqek50zT+kHzez+oR7H298
	 L91Ekw4zmIjN3d8yssePM9RXA8flnYcfdHZ2PS9wKUu072zvZ7P6ANpm428GpqL/Oo
	 SodomwA05SoVA+Mrj/Q2ieaSIbqTvp9eXEnVr76bJvGSn/oY+lHC/I1/wL5PzuGzII
	 I/SGcV7/YYb0g==
Date: Sat, 06 Jun 2026 01:54:02 +0000
To: "Martin K . Petersen" <martin.petersen@oracle.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mike Christie <michael.christie@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>, John Garry <john.g.garry@oracle.com>, David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: copy iSCSI ISID before unmapping the PR OUT buffer
Message-ID: <20260606015359.181724-1-hexlabsecurity@proton.me>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 4f9147923b14bc3da58aadef374b0d7517c97506
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
iport_ptr as a raw pointer into that mapped buffer (the ISID following the
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

Copy the ISID into a caller-owned stack buffer while the mapping is still
live and repoint iport_ptr at it, mirroring the existing initiator_str
handling. strscpy_pad() NUL-terminates and zero-fills the tail so the fixed
8-byte get_unaligned_be64() read stays in-bounds and deterministic even for
an ISID shorter than 8 bytes. The NULL (device-format / non-iSCSI) case is
preserved by copying only when iport_ptr is non-NULL.

Fixes: 4949314c7283 ("target: Allow control CDBs with data > 1 page")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Everything below the --- is dropped by git am.

Class / impact: CWE-416 use-after-free (use-after-vunmap) in the LIO SCSI
target. Triggerable by an authenticated iSCSI initiator that is a current
Persistent Reservation registrant on the LUN: it sends PERSISTENT RESERVE
OUT / REGISTER AND MOVE with an iSCSI (FORMAT CODE 01b) TransportID and a
PARAMETER LIST LENGTH > 4096 so the parameter list spans >1 page and is
mapped with vmap(). After transport_kunmap_data_sg() vunmap()s that region,
the retained iport_ptr is dereferenced -> kernel read of an unmapped
vmalloc address (oops / DoS; memory-safety corruption confirmed by KASAN).
Primarily a remotely-reachable authenticated denial of service.

Affected: all maintained trees -- the bug predates the git history reachabl=
e
here; it became a destructive dangling dereference with 4949314c7283 (v3.3,
2012), which introduced the multi-page vmap() path. Verified present at
mainline v7.1-rc6 and stable v6.12.92.

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
    no-op on 64-bit !HIGHMEM, so the alias stays valid) -- confirming the
    multi-page vmap()/vunmap() path is what makes iport_ptr dangle.
  - With this patch (same 8192-byte request): no report, command completes.

 drivers/target/target_core_pr.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_p=
r.c
index 11790f2c5d80..b102f5f67793 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3160,6 +3160,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cm=
d *cmd, u64 res_key,
 =09unsigned char *buf;
 =09unsigned char initiator_str[TRANSPORT_IQN_LEN];
 =09char *iport_ptr =3D NULL, i_buf[PR_REG_ISID_ID_LEN] =3D { };
+=09char isid_buf[PR_REG_ISID_LEN] =3D { };
 =09u32 tid_len, tmp_tid_len;
 =09int new_reg =3D 0, type, scope, matching_iname;
 =09sense_reason_t ret;
@@ -3293,6 +3294,22 @@ core_scsi3_emulate_pro_register_and_move(struct se_c=
md *cmd, u64 res_key,
 =09=09goto out;
 =09}

+=09/*
+=09 * For an iSCSI TransportID, iport_ptr aliases directly into the data
+=09 * buffer mapped above.  When that buffer spans more than one page it i=
s
+=09 * a vmap() region that transport_kunmap_data_sg() is about to vunmap()=
,
+=09 * tearing down the kernel mapping and leaving iport_ptr dangling for
+=09 * every consumer below.  Copy the ISID into caller-owned storage now,
+=09 * while the mapping is still live.  strscpy_pad() NUL-terminates and
+=09 * zero-fills the tail so the later 8-byte get_unaligned_be64() read in
+=09 * __core_scsi3_do_alloc_registration() stays in-bounds and determinist=
ic
+=09 * even for an ISID shorter than 8 bytes.
+=09 */
+=09if (iport_ptr) {
+=09=09strscpy_pad(isid_buf, iport_ptr, sizeof(isid_buf));
+=09=09iport_ptr =3D isid_buf;
+=09}
+
 =09transport_kunmap_data_sg(cmd);
 =09buf =3D NULL;


