Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CDF3AC0ED;
	Wed, 16 Sep 2026 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789524102; cv=none; b=kVYfdvsKmCQSyod0EEMqT9Kdwk2zVNjVLXMpXIoHrdeYQiV8N91TnevinY3MhCTR0P78H/WSiJnzXfy5/Yc3Ijgj1JKGbY5Jxt3mcVsSdWPwgFh1wzulDK0ZiTCKhHw8g46dW5epRu6mgaW+facgJyfkeWB7neR8ZGY4o1qfDVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789524102; c=relaxed/simple;
	bh=CXJfK6etui4TiBXgYCdN8ScM8cI596TwjEn8ECns7tc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=OosRD00JIdFa8oyBQW3uXhDOfudnuh5Okiv6k5CPtvvVxQGIdMVkYnHVJAAc3HzSX0ePmhI3CR95ROf0MncfhYQROkxL/gt0xfHy2EClEt9I57I7gCQXVZawZ0iROfOq82nL3H4LLh4zsnGsRImUmo+jBxt+kp2eNY+gxSH6+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jic5obL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jic5obL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74601F000FF;
	Wed, 16 Sep 2026 02:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789524083;
	bh=fDfNPHZO3x8dpGAaCN/R8DkmbDFw6clCnx9JRbiMMOM=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=jic5obL8NaXsPEipUexGY+VTT7No6k3tMecjDcdACQaTIH7yLl5VR+4dKrZhJVKmh
	 6PZrqerE2Ts6o/mAE1vGUYr5jw1NsvGmZtvERK/MajVoc+ATsAZHWWaMne3CB//NOR
	 N37lkomojUaaTdApykKmAp0G8BQOOCIQGcM2MuOP0yEBq/05l1YojDFOkijeBwmP0R
	 ehnqs/CSmFW0apKGOE+UkleXBuDLLRmBjlH93Ca/q1Hi+V0b61+fszNn91m6BpN4Kw
	 AYcIHix68KXeb5Zgj6YiEDBvnN5U4HpLX6PKP2ByFptmqJGELhnJXixtFffqzFocRB
	 BsqziDaR3A0bw==
To: Daniel Fernau <mail@danielfernau.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,  Sumit Saxena
 <sumit.saxena@broadcom.com>,  Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,  Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,  megaraidlinux.pdl@broadcom.com,
  Thomas Lamprecht <t.lamprecht@proxmox.com>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Damien Le Moal <dlemoal@kernel.org>,  Jens
 Axboe <axboe@kernel.dk>,  Keith Busch <kbusch@kernel.org>,  Ranjan Kumar
 <ranjan.kumar@broadcom.com>,  Thorsten Leemhuis
 <regressions@leemhuis.info>,  regressions@lists.linux.dev,  Lukasz Magiera
 <me@magik.net>,  Mira Limbeck <m.limbeck@proxmox.com>,  Mats Topstad
 <Mats.topstad@intility.no>,  stable@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: Limit NVMe request size to the PRP
 chain frame
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <k5_uJWSlVpSwhVugTUyBfaq9oFVqFfpeuk_765JDKLtq_vKNO8mXI6TznKe4bX9WisARpHFxQYZ6i7W8YBT02KYaHL5d3LKSfyfCkNAh1jc=@danielfernau.com>
Message-ID: <yq1tsnqvtsu.fsf@mail.kernel.org>
References: <20260827175743.734593-1-t.lamprecht@proxmox.com>
	<178840472610.670675.12272571379596581093.b4-ty@b4>
	<k5_uJWSlVpSwhVugTUyBfaq9oFVqFfpeuk_765JDKLtq_vKNO8mXI6TznKe4bX9WisARpHFxQYZ6i7W8YBT02KYaHL5d3LKSfyfCkNAh1jc=@danielfernau.com>
Date: Tue, 15 Sep 2026 22:01:22 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Daniel,

> On this hardware the cap is enough. We no longer need the
> max_sectors_kb udev workaround, and we do not see the page-boundary
> ptr_sgl fault (RAX=0x200 / 512th PRP slot) under production load.

Great, thanks for testing!

-- 
Martin K. Petersen
