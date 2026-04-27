Received: from mta-64-225.siemens.flowmailer.net (mta-64-225.siemens.flowmailer.net [185.136.64.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9249539FCBF
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 11:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.64.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777287937; cv=none; b=u/pBKRiGDtNiLRz+OQUyt7IC5rVo5n2WFM1CO2J8W2IAGal3K3EXeVas8Tip4e3N++6ewOWYOH+kNOwSs++FD5DA0fGd01rS692zBOqD5zW5ooukS6h8FheY7uxVCVbyTWvYYxTEowzbzv7b5Ie48vDe85j/iqqCsi5wbA/3zBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777287937; c=relaxed/simple;
	bh=nHVmscofyLUA3h72V3w4Wiw5weFIr3NDQQmiE8AdAxg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mkoHhxa8m0ZSko8zSjHvCYuSrKAEseylQPZujnU7AG+sPMiqGtBVtfXLQ7j3BeVwJVXOZjmZhHWUJ6HQ4HuekQIVraeLb6zC7D687uNcHfiPcCxtr+rq/Nq841adsEyMmPKD16XnUxEDSxdCj0JaeazroX1FjrGyaMruILpqY1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=florian.bezdeka@siemens.com header.b=EUbVq5FN; arc=none smtp.client-ip=185.136.64.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=florian.bezdeka@siemens.com header.b="EUbVq5FN"
Received: by mta-64-225.siemens.flowmailer.net with ESMTPSA id 202604271055213e4ffaee030002074d
        for <linux-scsi@vger.kernel.org>;
        Mon, 27 Apr 2026 12:55:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm2;
 d=siemens.com; i=florian.bezdeka@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=P3IMh9zc4XqQrfVWFOK5zzy46NlRww98MNLYe1Fx+BM=;
 b=EUbVq5FNeThmPDQSfh8aKo91HZYE8p7RF4AdjrWartcxXiwJzqu/NIjalCA0+Rqsdawjc+
 aTYLS9cvzoSjt2zhTEZENSfHleFO1n5O/PBYA+jAhakrksykqURhoUDlei7lUTD6ZMlPEc+l
 VPBC3Gbf4V/4y7e8PttGnbhSmf6DHbzGmsjuqFx8J8DB8JqRytDpCUw8cfg93ZtAEwB3Pe5M
 4e7OeJ3gdMnAvzs+wXn7Veo9wXdjTkYCno7jME9wpzSomoGCs/Rebx2eTvLPuTO0Wa0vTfnC
 ZKnXlXn5chALN5siZht7ggRS0nBgpTzJK998EecC3RhiQ7E/tgRofaTA==;
Message-ID: <e350389a5a635660267a7a13f06529da102a95d8.camel@siemens.com>
Subject: Re: [PATCH v12 00/13] blk: honor isolcpus configuration
From: Florian Bezdeka <florian.bezdeka@siemens.com>
To: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, kbusch@kernel.org, 
	hch@lst.de, sagi@grimberg.me, mst@redhat.com
Cc: aacraid@microsemi.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, liyihang9@h-partners.com,
 kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
 shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com,
 sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
 suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com,
 jinpu.wang@cloud.ionos.com, tglx@kernel.org, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
 bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
 frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
 hare@suse.de, kch@nvidia.com, ming.lei@redhat.com, tom.leiming@gmail.com,
 steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com,
 mproche@gmail.com, nick.lange@gmail.com, marco.crivellari@suse.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Date: Mon, 27 Apr 2026 12:55:20 +0200
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-68982:519-21489:flowmailer

Hi all,

On Wed, 2026-04-22 at 14:52 -0400, Aaron Tomlin wrote:
> Hi,
>=20
> I have decided to drive this series forward on behalf of Daniel Wagner, t=
he
> original author. The series has been rebased on v7.0-12635-g6596a02b2078.
>=20
> Building upon prior iterations, this series introduces critical
> architectural refinements to the mapping and affinity spreading algorithm=
s
> to guarantee thread safety and resilience against concurrent CPU-hotplug
> operations. Previously, the block layer relied on a shared global static
> mask (i.e., blk_hk_online_mask), which proved vulnerable to race conditio=
ns
> during rapid hotplug events. This vulnerability was highlighted by the
> kernel test robot, which encountered a NULL pointer dereference during
> rcutorture (cpuhotplug) stress testing due to concurrent mask modificatio=
n.
>=20
> To resolve this, the architecture has been fundamentally hardened. The
> global static state has been eradicated. Instead, the IRQ affinity core n=
ow
> employs a newly introduced irq_spread_hk_filter(), which safely intersect=
s
> the natively calculated affinity mask with the HK_TYPE_IO_QUEUE mask.
> Crucially, this is achieved using a local, hotplug-safe snapshot via
> data_race(cpu_online_mask). This approach circumvents the hotplug lock
> deadlocks previously identified by Thomas Gleixner, while explicitly
> avoiding CONFIG_CPUMASK_OFFSTACK stack bloat hazards on high-core-count
> systems. A robust fallback mechanism guarantees that should an interrupt
> vector be assigned exclusively to isolated cores, it is safely re-routed =
to
> the system's online housekeeping CPUs.
>=20
> Following rigorous testing of multiple queue maps (such as NVMe poll
> queues) alongside isolated CPUs, the tenth iteration resolved a critical
> page fault regression. The multi-queue mapping logic has been corrected t=
o
> strictly maintain absolute hardware queue indices, ensuring faultless que=
ue
> initialisation and preventing out-of-bounds memory access.
>=20
> Furthermore, following feedback from Ming Lei, the administrative
> documentation for isolcpus=3Dio_queue has undergone a comprehensive overh=
aul
> to reflect this architectural reality. Previous iterations lacked the
> required technical precision regarding subsystem impact. The expanded
> kernel-parameters.txt now explicitly details that this parameter applies
> strictly to managed IRQs. It thoroughly documents how the block layer
> intercepts multiqueue allocation to match the housekeeping mask, actively
> preventing MSI-X vector exhaustion on massive topologies and forcing queu=
e
> sharing. Most importantly, it cements the structural guarantee: while an
> application on an isolated CPU may freely submit I/O, the hardware
> completion interrupt is strictly and safely offloaded to a housekeeping
> core.
>=20
> Please let me know your thoughts.

This topic reminds me of a discussion started by Tobias [1] some time
ago about IRQ spreading of network drivers. The problem was (and still
is) that network drivers ignore any CPU isolation when spreading out
device IRQs.

In general we have two different CPU isolation mechanisms:
  - The static one, via isolcpus=3D cmdline parameter
  - The dynamic one, via cgroups(v2) cpuset controller

This series is only taking the static "world" into account, right? Are
there any plans to honor the CPU isolations configured the dynamic way?

It has been a while since the last investigations on my end. Last time I
went through the code, the IRQ core was completely decoupled from the
dynamic configuration via cgroups. Are there any plans to fix that gap?

Best regards,
Florian

[1] https://lore.kernel.org/all/a0cad8314124ca98d7c6763e3e08d7192598cf92.ca=
mel@siemens.com/
