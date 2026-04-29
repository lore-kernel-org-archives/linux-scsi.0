Received: from mta-65-225.siemens.flowmailer.net (mta-65-225.siemens.flowmailer.net [185.136.65.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF079377006
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 21:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777496507; cv=none; b=Ec5lvTLXTiSQsmcjUG2G9qf7OQuWHBppjIMlIZSQbuku1jWeLiWAfBLfUNcPB6FU0isfVTMHiQPHkQZXDLstB9sut2LpMnUtFSO/MiGVrbVTRmujnPmn3opVaCKel4+40a5vM5h7nfP2Mdl3Nb5nO9Off2/dXaC4p6kaSTsX6zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777496507; c=relaxed/simple;
	bh=bA3q+aZyOQrT0FyDSNs/Uw/vG57DpeKjfZrlAyy96GI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ryp+cY1p8Ru+dI7FTeCK2bsqLJ+owGFMpAG1+8SfWgdFKbjS332Ixi+UhYAc9Vzq40MQwY4Ae96EUi1bTTUzwpX8vDBDeATob2iy7cIvfu/buCTO6pcWQ77gKsYuJG6fzxu+4HBoH3fdbkbg7bvFlvCFr0xP3bM66j2YfRXLTMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=florian.bezdeka@siemens.com header.b=LMH79o94; arc=none smtp.client-ip=185.136.65.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=florian.bezdeka@siemens.com header.b="LMH79o94"
Received: by mta-65-225.siemens.flowmailer.net with ESMTPSA id 20260429210134f092e4bc34000207e6
        for <linux-scsi@vger.kernel.org>;
        Wed, 29 Apr 2026 23:01:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm2;
 d=siemens.com; i=florian.bezdeka@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=lRg/MYq0K53L4Y4fGH1HiAxYK8CbmwlPUvmXGFjgSXI=;
 b=LMH79o94bSn6Qm6x/tkJ5jiJERzPLvvPw/we8hHv+HTjm97vH4jpJ/v4o17P+6f47ud8Jb
 WJfb/vPGNx0PT/+DoxppUmJ/WOqVr0PwpYa5zVNJZ1fWlGk+jddEiJ16OBun3WV+c8AvggSf
 pylkylj4BN/ZZaLTU25IqyQtHWmyHEsNa9ydjDEykJHJQ0tNVg99dkpcbb7gbZZOp+7rQFeV
 hXwJOqPW5wkAjLHyVQzIpIKAMyHDL/rVk6JIMTbjW9vCDfKt9ET0addeTDblLVB064IeAfWs
 J6UA4A6mkJN785K9LjzGIh7v+tDMe5y7piVIui6Spy4mlqOV5m/icNMw==;
Message-ID: <85415539137c61cdec145ac0ee299dbea7cdd2a1.camel@siemens.com>
Subject: Re: [PATCH v12 00/13] blk: honor isolcpus configuration
From: Florian Bezdeka <florian.bezdeka@siemens.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 liyihang9@h-partners.com, kashyap.desai@broadcom.com,
 sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
 chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
 sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
 ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, tglx@kernel.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org,
 ruanjinjie@huawei.com, bigeasy@linutronix.de, yphbchou0911@gmail.com,
 wagi@kernel.org, frederic@kernel.org, longman@redhat.com,
 chenridong@huawei.com, hare@suse.de, kch@nvidia.com, ming.lei@redhat.com,
 tom.leiming@gmail.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com,
 neelx@suse.com, mproche@gmail.com, nick.lange@gmail.com,
 marco.crivellari@suse.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 MPT-FusionLinux.pdl@broadcom.com, Jan Kiszka <jan.kiszka@siemens.com>
Date: Wed, 29 Apr 2026 23:01:33 +0200
In-Reply-To: <2d61b1f7-fc06-4fe1-8a6f-cc3a2f114ae1@flourine.local>
References: <20260422185215.100929-1-atomlin@atomlin.com>
	 <e350389a5a635660267a7a13f06529da102a95d8.camel@siemens.com>
	 <2d61b1f7-fc06-4fe1-8a6f-cc3a2f114ae1@flourine.local>
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

On Tue, 2026-04-28 at 15:08 +0200, Daniel Wagner wrote:
> On Mon, Apr 27, 2026 at 12:55:20PM +0200, Florian Bezdeka wrote:
> > This topic reminds me of a discussion started by Tobias [1] some time
> > ago about IRQ spreading of network drivers. The problem was (and still
> > is) that network drivers ignore any CPU isolation when spreading out
> > device IRQs.
> >=20
> > In general we have two different CPU isolation mechanisms:
> >   - The static one, via isolcpus=3D cmdline parameter
> >   - The dynamic one, via cgroups(v2) cpuset controller
> >=20
> > This series is only taking the static "world" into account, right? Are
> > there any plans to honor the CPU isolations configured the dynamic
> > way?
>=20
> Dynamic configuration would require every driver to fully support
> reconfiguration during runtime. Only a handful of drivers, such as
> nvme-pci, are currently able to handle this.
>=20
> The first task, teaching a wide range of drivers to honor CPU isolation
> at boot time, is already going to be a significant amount of work.
>=20
> > It has been a while since the last investigations on my end. Last time =
I
> > went through the code, the IRQ core was completely decoupled from the
> > dynamic configuration via cgroups. Are there any plans to fix that gap?
>=20
> Which use case are you actually aiming to support? While dynamic
> reconfiguration would be ideal, the amount of work to get there is
> significant. I won't be signing up for it.

The use case at hand is a RT enabled platform where the concrete RT
workload is not known at boot time. RT applications are deployed "on-
the-fly", nowadays using the existing container runtimes with some
extended resource management on top.

Applications can request certain resources like isolated CPU cores,
special IRQ affinities, PCI devices to pass through, ...,  so that the
resource management on the system can take care of proper system
configuration.

As you said, this requires that drivers are able to honor the system
configuration during runtime. We already identified IRQ spreading of the
network subsystem to be problematic. And yes, that will need some
efforts to fix that. We are still in phase of searching for similar
problems and a starting point for a discussion. Any input in that
direction is highly appreciated.
