Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D745467E
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2024 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707919858; cv=none; b=iWIUTW2fpaXueca1B06fj9S+3DGLHSHQ41oAtXsjfmOyOWhpCsJdz6FIcScsb8xwywSWjJ+dbozMKm1XZoubDmpBHITu+qx1B/TykouovmZ4UroMJDy/yjm0Apw0QvSIreU/aHO8W0x7Ml4GERJvMsd/eTsse5XHYbqeP6DucJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707919858; c=relaxed/simple;
	bh=lNN0guB13bYI2TH8/fYVHOTsM323IgNcd8/hTtPIywk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mv2MHQDkyxfBlcJzVbk6zRKAkFDf4vExpCjoQ6SDdjX3DMealunvLs/w6hSA8DPkFPhW8r/6A+KDP6+j2QIpHo5H5dMO9akXmgE2WG4yHGXqfb3gAdeV+aqZspcLiaHo/Uj1ufjnNs9Zj07qMTUBJBQoAPvM2GDti8MiWpeVRlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+m4Ehlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+m4Ehlr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBBF0C433F1
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2024 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707919858;
	bh=lNN0guB13bYI2TH8/fYVHOTsM323IgNcd8/hTtPIywk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=a+m4EhlrkjF/77GQFCY1TvqNHaG/1AuACqQ3ekhv77YCkdMAhi3ygKE3ZY8I1DG5J
	 f3dZu2UVuYfk2E4pl1s1iuR0BncIIUkksYhePZp+aH+79dICDSPxRfEdo/gruGitsL
	 kBeglK0URFvqqR3K9rQA+27baPQow6HfYjavHXBpcFdRYFQIyxSBRW0++SMoUxVYYq
	 /TbV8CehVw2R4dQFFGHoTg1TtkMSYioX2tB4xot719ALj2piNeT4dPfb9J3Em9C+s/
	 ELtXGupxB6MdsjMqm5YGZvvtBzx5nox8ZznSETz/nvxz4jDwQHiEf/KacV0CayibRq
	 1c+/4VKfQieVw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DC877C4332E; Wed, 14 Feb 2024 14:10:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Wed, 14 Feb 2024 14:10:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: joop.boonen@netapp.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-HTR86X8hhb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #63 from Joop Boonen (joop.boonen@netapp.com) ---
From Debians Bookworm linux-image-amd64 changelog [1]:
<q>
  * Revert "scsi: aacraid: Reply queue mapping to CPUs based on IRQ affinit=
y"
    (Closes: #1059624)
</q>


Debian Has reverted the Patch.=20
I've tested on a dual Intel Socket Server with a=20=20
RAID bus controller: Adaptec Series 8 12G SAS/PCIe 3 (rev 01)=20
Subsystem: Adaptec Series 8 - ASR-8805 - 8 internal 0 external 12G SAS
Port/PCIe 3.0

I didn't experience any Problems any more.

[1]
https://metadata.ftp-master.debian.org/changelogs//main/l/linux-signed-amd6=
4/linux-signed-amd64_6.1.76+1_changelog

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
