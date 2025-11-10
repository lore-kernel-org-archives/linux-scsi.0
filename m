Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBC2274B51
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789616; cv=none; b=AQNMNwOp7HDqkIzpmbEKDM2Var/JfKWt/K//vI6a2mFc7yFhS1bOCtyCtj9hW7G4X9BQZ10H495CX4X7csky9SAd5Fh91TLGjWiH0hnfbehSjOGK9d3Dxq7O5ipz9arhvI2efgL6m4684dbcNr/kra5CcZJkYjtlvcf8FFY2veM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789616; c=relaxed/simple;
	bh=mN1i46vyX0iSsl9atR/Knr5i1iQbMqclvG3xYyw5+Ys=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PsLvdKGD6p32lIhvz4uw0cGa+pKa/uKklqTGixsUo0GkZ/kVO37YFYWIfjsdD/587gBPs++jmRmicGYj47vEi/Gown9IdxqsLqmF6mO7D2yaCq20CrY3sevQegivxraclkWuZJlEBZWEXe0R2RzIY8PyrcR4r9+KsjheODMKnY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=fail (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=MSA8YVGF reason="signature verification failed"; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="MSA8YVGF"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id IORz3udkoayMVWSV; Mon, 10 Nov 2025 10:46:45 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=t+N2BwW3BELCNTng+9yN+H0LpfMSIo+bvbJajYt2USY=;
	h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:Content-Language:
	MIME-Version:Date:Message-ID; b=MSA8YVGFLeGLkTDPTfeEvrCyfURgL7ro848ZdEHCLPtan
	vcA8l0vUUe5P48ce/ZtsBcXjdOU2N1nlcp6FLOTxidZjhfWhqhw18IMRQn2pjJES6bX0H8OVdl7sv
	LNz6ksAuY78dP/Z9hENMNexlYLsDhiuR3Iqw1iISNZaAPuIlo=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14272375; Mon, 10 Nov 2025 10:46:45 -0500
Message-ID: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 10 Nov 2025 10:46:45 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH v3 00/16] qla2xxx target mode improvements
Content-Type: text/plain; charset=UTF-8
X-ASG-Orig-Subj: [PATCH v3 00/16] qla2xxx target mode improvements
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1762789605
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 5667
Content-Transfer-Encoding: quoted-printable
X-ASG-Debug-ID: 1762789605-1cf439139110cb60001-ziuLRu

v2 -> v3
- Omit SCST patches as requested to work better with b4 and patchwork.=C2=
=A0
They can still be found at the v2 link below.
- Fix "scsi: qla2xxx: fix TMR failure handling" to check for mcmd =3D=3D =
NULL.

v2:
https://lore.kernel.org/linux-scsi/e95ee7d0-3580-4124-b854-7f73ca3a3a84@c=
ybernetics.com/

v1 -> v2
- Add new patch "scsi: qla2xxx: clear cmds after chip reset" suggested
by Dmitry Bogdanov.
- Rename "scsi: qla2xxx: fix oops during cmd abort" to "scsi: qla2xxx:
fix races with aborting commands" and make SCST reset the ISP on a HW
timeout instead of unmapping DMA that might still be in use.
- Fix "scsi: qla2xxx: fix TMR failure handling" to free mcmds properly
for LIO.
- In "scsi: qla2xxx: add back SRR support", detect more buggy HBA fw
versions based on the fw release notes.
- Shorten code comment in "scsi: qla2xxx: improve safety of cmd lookup
by handle" and improve patch description.
- Rebase other patches as needed.

v1:
https://lore.kernel.org/r/f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetic=
s.com/

This patch series improves the qla2xxx FC driver in target mode.=C2=A0 I
developed these patches using the out-of-tree SCST target-mode subsystem
(https://scst.sourceforge.net/), although most of the improvements will
also apply to the other target-mode subsystems such as the in-tree LIO.=C2=
=A0
Unfortunately qla2xxx+LIO does not pass all of my tests, but my patches
do not make it any worse (results below).=C2=A0 These patches have been
well-tested at my employer with qla2xxx+SCST in both initiator mode and
target mode and with a variety of FC HBAs and initiators.=C2=A0 Since SCS=
T is
out-of-tree, some of the patches have parts that apply in-tree and other
parts that apply out-of-tree to SCST.=C2=A0 The SCST patches can be found=
 in
the v2 posting linked above.

All patches apply to linux 6.17 and SCST 3.10 master branch.

Summary of patches:
- bugfixes
- cleanups
- improve handling of aborts and task management requests
- improve log message
- add back SLER / SRR support (removed in 2017)

Some of these patches improve handling of aborts and task management
requests.=C2=A0 This is some of the testing that I did:

Test 1: Use /dev/sg to queue random disk I/O with short timeouts; make
sure cmds are aborted successfully.
Test 2: Queue lots of disk I/O, then use "sg_reset -N -d /dev/sg" on
initiator to reset logical unit.
Test 3: Queue lots of disk I/O, then use "sg_reset -N -t /dev/sg" on
initiator to reset target.
Test 4: Queue lots of disk I/O, then use "sg_reset -N -b /dev/sg" on
initiator to reset bus.
Test 5: Queue lots of disk I/O, then use "sg_reset -N -H /dev/sg" on
initiator to reset host.
Test 6: Use fiber channel attenuator to trigger SRR during
write/read/compare test; check data integrity.

With my patches, SCST passes all of these tests.

Results with in-tree LIO target-mode subsystem:

Test 1: Seems to abort the same cmd multiple times (both
qlt_24xx_retry_term_exchange() and __qlt_send_term_exchange()).=C2=A0 But
cmds get aborted, so give it a pass?

Test 2: Seems to work; cmds are aborted.

Test 3: Target reset doesn't seem to abort cmds, instead, a few seconds
later:
qla2xxx [0000:04:00.0]-f058:9: qla_target(0): tag 1314312, op 2a: CTIO
with TIMEOUT status 0xb received (state 1, port 51:40:2e:c0:18:1d:9f:cc,
LUN 0)

Tests 4 and 5: The initiator is unable to log back in to the target; the
following messages are repeated over and over on the target:
qla2xxx [0000:04:00.0]-e01c:9: Sending TERM ELS CTIO (ha=3D00000000f88113=
90)
qla2xxx [0000:04:00.0]-f097:9: Linking sess 000000008df5aba8 [0] wwn
51:40:2e:c0:18:1d:9f:cc with PLOGI ACK to wwn 51:40:2e:c0:18:1d:9f:cc
s_id 00:00:01, ref=3D2 pla 00000000835a9271 link 0

Test 6: passes with my patches; SRR not supported previously.

So qla2xxx+LIO seems a bit flaky when handling exceptions, but my
patches do not make it any worse.=C2=A0 Perhaps someone who is more famil=
iar
with LIO can look at the difference between LIO and SCST and figure out
how to improve it.

Tony Battersby
https://www.cybernetics.com/

Tony Battersby (16):
  Revert "scsi: qla2xxx: Perform lockless command completion in abort
    path"
  scsi: qla2xxx: fix initiator mode with qlini_mode=3Dexclusive
  scsi: qla2xxx: fix lost interrupts with qlini_mode=3Ddisabled
  scsi: qla2xxx: use reinit_completion on mbx_intr_comp
  scsi: qla2xxx: remove code for unsupported hardware
  scsi: qla2xxx: improve debug output for term exchange
  scsi: qla2xxx: fix term exchange when cmd_sent_to_fw =3D=3D 1
  scsi: qla2xxx: clear cmds after chip reset
  scsi: qla2xxx: fix races with aborting commands
  scsi: qla2xxx: improve checks in qlt_xmit_response / qlt_rdy_to_xfer
  scsi: qla2xxx: fix TMR failure handling
  scsi: qla2xxx: fix invalid memory access with big CDBs
  scsi: qla2xxx: add cmd->rsp_sent
  scsi: qla2xxx: improve cmd logging
  scsi: qla2xxx: add back SRR support
  scsi: qla2xxx: improve safety of cmd lookup by handle

 drivers/scsi/qla2xxx/qla_dbg.c     |    3 +-
 drivers/scsi/qla2xxx/qla_def.h     |    1 -
 drivers/scsi/qla2xxx/qla_gbl.h     |    2 +-
 drivers/scsi/qla2xxx/qla_init.c    |    1 +
 drivers/scsi/qla2xxx/qla_isr.c     |   32 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |    2 +
 drivers/scsi/qla2xxx/qla_mid.c     |    4 +-
 drivers/scsi/qla2xxx/qla_os.c      |   35 +-
 drivers/scsi/qla2xxx/qla_target.c  | 1775 +++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_target.h  |  112 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   17 +
 11 files changed, 1646 insertions(+), 338 deletions(-)


base-commit: e5f0a698b34ed76002dc5cff3804a61c80233a7a
--=20
2.43.0

