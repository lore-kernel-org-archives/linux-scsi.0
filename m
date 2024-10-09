Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2990E16C850
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 06:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455073; cv=none; b=O0btS762pcOeFPzrQFFxC0Vxpc85bpVptFIOxu300PhHP/3B5rNMUmDb2qm77axR8+AjM7LlZInyGGiNKnLJbPnjBl67RuDRN5K4szsHcMk8qpPTsbgF/dzp1STILwRZKP3beuc1ktv/qv5i5v/9cqs14gKWrCDZgk7FFqClA6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455073; c=relaxed/simple;
	bh=lh1W1mkFcVTqsqv1gSX90WBEy+OkaPGha+ONdUNkHM0=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=co32QrUr2PkH+scWPm8c0bLTj2fgOTeKvpn/yTuF3XVk4SyAF2ShrAKTSHmxM9OdYn/Nl/MKDFZyc7YqxrdXB/TeDyCZ5Hn9dcqVdHSRGDR4T4qrbr90uxXzpDTUi+f7H7csxaSvSesWjHFCuUrP5a6NlvcOd2yT8CEds7FUgxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMaKGvgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMaKGvgT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC0B5C4CED5
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 06:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728455072;
	bh=lh1W1mkFcVTqsqv1gSX90WBEy+OkaPGha+ONdUNkHM0=;
	h=From:To:Subject:Date:From;
	b=pMaKGvgT2lHA6PMfKfjwAM0f1c3SOZ6QwyXK/ypde+8+wFTZjePfQiThZR1fhODar
	 6sruyl7KT/4ON3IQyfYIZ/Spt5CTdUEe3IKH9EcDG1cNxETwj8EbbYx252j2iYh6OY
	 Cy/1rGrMlX+jTapE0WWlZHejCuB71gCzjBYe/KPepdyXfnsexdlmJNC7aTIZ3cXycu
	 w6Lf7eP9fN4SaCUcOEb6nmM6gCrPd+ip2bhKnDZi/2rdBaO1Wsh2OxGGLGElrTBG80
	 9wZB5pMWWfhYD05AUxoR8Vwb2Nqo7DEUt1dzuQ3cfOMs8S6oq/GWW5R23IAx+u0aha
	 gOgOl0+ioOsuQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B038DC53BC5; Wed,  9 Oct 2024 06:24:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219367] New: mpt3sas constant warnings and card resets on
 aarch64 Cortex-A72: _get_st_from_smid+0x54/0x70
Date: Wed, 09 Oct 2024 06:24:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: me@ndoo.sg
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219367-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219367

            Bug ID: 219367
           Summary: mpt3sas constant warnings and card resets on aarch64
                    Cortex-A72: _get_st_from_smid+0x54/0x70
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: me@ndoo.sg
        Regression: No

After LSI 9300-8e is initialized, dmesg constantly outputs below error, and
card keeps timing out and resetting and re-probing drives, making it unusab=
le.

WARNING: CPU: 3 PID: 0 at drivers/scsi/mpt3sas/mpt3sas_base.c:1532
_get_st_from_smid+0x54/0x70 [mpt3sas]

Observed on kernel versions:
6.10.0
6.10.11
6.10.12

Fedora 40 aarch64
Motherboard/SoC: SolidRun LX2160A CEx7 COM
Memory: 2x Micron 18ASF4G72HZ-3G2F1 (32GB each DDR4 3200MHz CL22 ECC SODIMM)

It may be an SoC/Cortex-A72 issue as there are several errata for memory/ca=
che
issues on this ARM core.

However seeing as CA72 cores are relatively common in prosumer and hypersca=
le,
I'm seeking comment from mptXsas developers on whether any workaround is
possible.

Other notes: Am running OpenZFS that's in the midst of a resilver operation,
however the errors occasionally do appear even before the ZFS pool is impor=
ted.

Attached is the full bootlog and buffer.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
