Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231508;
	b=y7DQ44+z+BCpxtghnQRJDyHMqDh3Cj36XCN6VWeL/0ytIKsdlSt9X0iIBLs4pF+hT/Wn
	 aYn640Y0V7sYUn7fq7ZUyp4HKS5SuBXnuuFLvkeL1VAbtaZu3RwMumsTBuAocpQJ2QaSD
	 HImN/LfxiKUBnbocb7YL/RVVU7R3Og+GHpWBxiU6e3RrzICpEokkdtJpxhqHm+oGFMH8D
	 YjlK0kK34Q/csQ+A22eJA0OeAFIch6up6prwto7zbjguWJXb/MyZdLT1a+qQjAuvzodMY
	 AfL2f6VYhTl2am0gEW2f12bXqXASos/u9p2UMwokFalB5AVyfKanSsu5FG9e9Qgcthg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ywvcXdEzMlpkXyBIr8U6P5Bs89wJlEBGndZBQ01hhDU=;
	b=ymaD1cRxzcJg7snkan1pqF+aH21E4o8mGkGhay9gCfhy0mJXorMmRdChlgPf5F4/P9cz
	 hmBNh+IVTHAHpaG/Udp/y29tzc6HyZL21+0kXf4IUV3jbccAjJzBc2gJMMlwQC/9tUb7q
	 ZgadvhF4H02tAkGgAmtwQClRcGf6tRE0hOXesdalPC8t47dzQv6N6V2fo/AWdyCXHeSHV
	 z7y8BkHaMOj9r5eFE1EHTBH2vWnGQ24CgoSaJN53JObAg+b5S3j17tZ0LK9H8KYy1SiEZ
	 OhEDHZrgqItNw6MrwhffpYK/FayyfLT8PcAGNqDlR0yB1MFZiALlNdHECmFz+QFYzQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RiwMZ6PT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777AA60A262D;
	Sat, 21 Nov 2026 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RiwMZ6PT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8BB1F000CA;
	Sat, 21 Nov 2026 03:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231508;
	bh=ywvcXdEzMlpkXyBIr8U6P5Bs89wJlEBGndZBQ01hhDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiwMZ6PTyy7rPgR1kvw6yGdXBOExU75JbBV+y7ysSpLaFr1ahk88FVRayf7d4Wkbd
	 TT0Mj2ONjcp981U0RvaHTF4nAvvCiHcS+Had42dRPNs2d6xaVWozBh7TG0IR71Xcic
	 j/vg9qfZBntkKlCZhAdVuWMphmXhbNp5am1zLsdPUfHXpofaZ5ozeca19DPwXsh2zw
	 9i74cVn7t54b76a7/wnEFzslKpgI497ZvYYapx1z/6HMxttSgnkd8o7LDMIDRoDGwh
	 JpLc1pJOhfcW/fy4frWQfk2gtlKpZDTNxSXeFBPg0MbaPW05V4U8ay6WE4JgdTN6jo
	 JO61mxCpu3f4g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Louis Sautier <sautier.louis@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix out-of-bounds cpu_msix_table read on CPU hotplug
Date: Fri, 20 Nov 2026 22:24:53 -0500
Message-ID: <179523145631.420187.8247268740882578143.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118201316.326943-1-sautier.louis@gmail.com>
References: <20261118201316.326943-1-sautier.louis@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 18 Nov 2026 21:13:16 +0100, Louis Sautier wrote:

> mpt3sas_base_attach() allocates cpu_msix_table based on the highest CPU
> online at probe time, but _base_get_msix_index() indexes it with
> raw_smp_processor_id() without a bounds check. Once a CPU with a higher
> id comes online, I/O submitted from it causes an out-of-bounds read of
> the table. The value read is sent to the firmware as the reply queue
> index. When it is not a valid queue, the IOC faults and I/O fails.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Fix out-of-bounds cpu_msix_table read on CPU hotplug
      https://git.kernel.org/mkp/scsi/c/14bc5d239ddd

-- 
Martin K. Petersen
