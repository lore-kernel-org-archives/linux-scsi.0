Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A371494B3
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726900155; cv=none; b=i+44RK/5zYejLzdqDgg7ShHSdny5vbP4qYjswC/Z6EbS8Q/xH8UUEecXtkxYxe29cxzzAq218cN7gZMq4oelqsKXlIfxkCjBn6UPK2ej4JCzRC1y6slE2Mp9Jwk7AbbacnC8BeDLK16pm8vV5ALAPZLKV6g7o9f8Cvc3yxjLh5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726900155; c=relaxed/simple;
	bh=dk1iyBzzdeSwCDSodnnX0lzyE71uWX5l8I4zqs+OnAs=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jpy3DjYK61DqoXJ4jIs2L3Dvdrr8OUTV6eu0RjpYXNqxYGUriu4+BVH5Ck7s5cXSTDkJFYHX7QbwbUI1bvbf9C6JtDqYMdbX/T28DEpCcdloen1/dJhndsfjs7qIF0ItoIn470Sx4jQD0okQJJpoE/2JhvQ5y6hmytJTkaTKsnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQOLLqsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQOLLqsb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DA61C4CEC6
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726900155;
	bh=dk1iyBzzdeSwCDSodnnX0lzyE71uWX5l8I4zqs+OnAs=;
	h=From:To:Subject:Date:From;
	b=CQOLLqsb0GGYCGpoGPUOdMGtyM0d6KnQc7HqpAyOCIBmy79pzhamAUklBQqnh5oad
	 ncKb0AgcakgVXVoD0+GMYZzUg9LD5iF+eKODm4kH3oXnvumVMBBVsBe8yYJquOmIk5
	 Jc2Xj/IQLCw6geNAmk9bMUyM1iqkJ35brAt2OMuE4QEoM6Eao6hWtQcBAkdgFSknvr
	 VR/CWsh2gSr/mr3QjvvceeGVJfUexY3Ke9ZkFpFHX6pRYBMNaj7yQqLg7cx41lR+5v
	 7vGKLSkyen7+8RuEoFNPE5knjoDvy/nUsYjpt26pwi41hwtGnkEXGtgOckZqTi+J6h
	 yqm4wJkRThh8w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1F1B4C53BC5; Sat, 21 Sep 2024 06:29:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] New: libahci driver and power switching HDD on newer
 kernels
Date: Sat, 21 Sep 2024 06:29:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linuxcdeveloper@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219296-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219296

            Bug ID: 219296
           Summary: libahci driver and power switching HDD on newer
                    kernels
           Product: SCSI Drivers
           Version: 2.5
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: linuxcdeveloper@gmail.com
        Regression: No

Hi,

I've got some problems with newer kernels during hibernation and
waking up from hibernation.
The symptom of the issue is that there is HDD power switching executed
after I run pm-hibernate command and the same HDD power switching
during the wake up process from hibernation.

As the HDD power switch process I mean: powering off my HDD and
immediately after that powering on the HDD. This process in my case
takes about 1 second.

Here there are more details about both operations: hibernation and waking u=
p:

Hibernation process:
1. in shell I type: "pm-hibernate"
2. kernel is preparing system to hibernation
3. hdd is powered off and immediately powered on - it takes about one
second or less to do the power switch
4. kernel is saving mem image to swap partition with printing progress
in percentage
5. PC and HDD are powered off

Waking up process:
1. my PC and HDD are powered off, I'm pressing any key on my keyboard
so it is powering up my PC
2. kernel is starting, recognizes that there is mem image on swap and
starting to load it - printing progress percentage
3. hdd is powered off and immediately powered on - it takes about one
second or less to do the power switch
4. system is ready to use and working fine

So to sum up - in both processes described above the problematic step
is the step 3.

I noticed some errors in dmesg coming from ahci driver like these:
Sep 11 15:49:30 localhost kernel: ahci 0000:00:17.0: port does not
support device sleep

and ACPI BIOS errors like these:
Sep 11 15:49:30 localhost kernel: ACPI BIOS Error (bug): Could not
resolve symbol [\_SB.PCI0.SAT0.PRT0._GTF.DSSP], AE_NOT_FOUND
(20240322/psargs-330)

The mainboard I use is: Gigabyte Z370 HD3P with the newest available
BIOS update F14.

I bisected this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
and here is the log from bisection:

git bisect start
# status: waiting for both good and bad commits
# good: [05d8970cca014b96c06c3730ae084f08087f13dd] Linux 6.4.12
git bisect good 05d8970cca014b96c06c3730ae084f08087f13dd
# status: waiting for bad commit, 1 good commit known
# bad: [004dcea13dc10acaf1486d9939be4c793834c13c] Linux 6.7.5
git bisect bad 004dcea13dc10acaf1486d9939be4c793834c13c
# good: [6995e2de6891c724bfeb2db33d7b87775f913ad1] Linux 6.4
git bisect good 6995e2de6891c724bfeb2db33d7b87775f913ad1
# good: [b84acc11b1c9552c9ca3a099b1610a6018619332] Merge tag
'fbdev-for-6.6-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/deller/linux-fbdev
git bisect good b84acc11b1c9552c9ca3a099b1610a6018619332
# bad: [8bc9e6515183935fa0cccaf67455c439afe4982b] Merge tag
'devicetree-for-6.7' of
git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux
git bisect bad 8bc9e6515183935fa0cccaf67455c439afe4982b
# bad: [1002f8171d966f73e3d97b05fc0178e115fb5dca] wifi: ray_cs: Remove
unnecessary (void*) conversions
git bisect bad 1002f8171d966f73e3d97b05fc0178e115fb5dca
# good: [535a265d7f0dd50d8c3a4f8b4f3a452d56bd160f] Merge tag
'perf-tools-for-v6.6-1-2023-09-05' of
git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools
git bisect good 535a265d7f0dd50d8c3a4f8b4f3a452d56bd160f
# bad: [e8c127b0576660da9195504fe8393fe9da3de9ce] Merge tag 'net-6.6-rc6' of
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
git bisect bad e8c127b0576660da9195504fe8393fe9da3de9ce
# good: [c7bd8a1f45bada7725d11266df7fd5cb549b3098] iommu/apple-dart: Handle
DMA_FQ domains in attach_dev()
git bisect good c7bd8a1f45bada7725d11266df7fd5cb549b3098
# bad: [cb84fb87f325ecd46be586b62623db5b2c0a792e] Merge tag
'integrity-v6.6-fix' of
git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity
git bisect bad cb84fb87f325ecd46be586b62623db5b2c0a792e
# bad: [ba77f7a63f4e4d4ffa5ad8c6665a104822992538] Merge tag
'6.6-rc3-smb3-client-fix' of git://git.samba.org/sfrench/cifs-2.6
git bisect bad ba77f7a63f4e4d4ffa5ad8c6665a104822992538
# good: [b02afe1df518369dd322f48b49e50efc49250575] Merge tag 'xtensa-202309=
28'
of https://github.com/jcmvbkbc/linux-xtensa
git bisect good b02afe1df518369dd322f48b49e50efc49250575
# good: [6edc84bc3f8aceae74eb63684d53c17553382ec0] Merge tag
'drm-fixes-2023-09-29' of git://anongit.freedesktop.org/drm/drm
git bisect good 6edc84bc3f8aceae74eb63684d53c17553382ec0
# bad: [95289e49f0a05f729a9ff86243c9aff4f34d4041] Merge tag 'ata-6.6-rc4' of
git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
git bisect bad 95289e49f0a05f729a9ff86243c9aff4f34d4041
# bad: [75e2bd5f1ede42a2bc88aa34b431e1ace8e0bea0] ata: libata-core: Do not
register PM operations for SAS ports
git bisect bad 75e2bd5f1ede42a2bc88aa34b431e1ace8e0bea0
# good: [84d76529c650f887f1e18caee72d6f0589e1baf9] ata: libata-core: Fix po=
rt
and device removal
git bisect good 84d76529c650f887f1e18caee72d6f0589e1baf9
# bad: [aa3998dbeb3abce63653b7f6d4542e7dcd022590] ata: libata-scsi: Disable
scsi device manage_system_start_stop
git bisect bad aa3998dbeb3abce63653b7f6d4542e7dcd022590
# good: [3cc2ffe5c16dc65dfac354bc5b5bc98d3b397567] scsi: sd: Differentiate
system and runtime start/stop management
git bisect good 3cc2ffe5c16dc65dfac354bc5b5bc98d3b397567
# first bad commit: [aa3998dbeb3abce63653b7f6d4542e7dcd022590] ata:
libata-scsi: Disable scsi device manage_system_start_stop

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
