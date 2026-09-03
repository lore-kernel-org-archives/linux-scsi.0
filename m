Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB536197D;
	Thu,  3 Sep 2026 03:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405038; cv=none; b=jlUn8Lq3drE1aVuFqqt2xhCrovk0gqjWd7rh6w5RE0cAQAJrUC4+lafXalSDZBPh9y8iBxSttS6Bwq42usyFL1X/Zg2IyhXBKgEZAL3wLp1SzY7gvf7I/+7PevoM51e0xZhKeByUKlyXRsYZKcKMuXNqUa4j3FJ5PkUTbaA8FgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405038; c=relaxed/simple;
	bh=O8ezuFnDP6L/5tg2uw+jNCQGLcmU08Nmf8heUOyLMjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFKmiKrxb3fCRRtwQUevJMQEmP2zGA+IGuwS8Ih1G/nxH5x+4mjcA+jmPhSWe5nrdOYkL7r4SOIDBl6NzWEGhlMniPTgqyhp+uxZXaq1+BB1q5JcTjfY9dJTL27pkDXgPM1LwLNau+2lxH8yySGl706ad19Z37mDJ8lZjMJUVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAFRIkNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAFRIkNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47311F000E9;
	Thu,  3 Sep 2026 03:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405037;
	bh=w5nwvG99pIjh48weOU+xAUMEJWc4NtELf8BdM/zlWxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAFRIkNzoHNJOqgHYshzy0QfM7pNt7fi9NV6m4QkjL5AcRzPJbZLHmP4YPEsYoyUd
	 6pQcxCdNflPphT1rIhw1/KM+eo9PLgUMqsmMWtyXoHy3DwfZjMbe2OcUvIopFsxbro
	 DDfJMyAauVnqKy8yGkU4A08pUFfaTfgNKIj1UbWJ+0PUihJ1u0vAGJdHlEk10+n1/K
	 nhrVQomD7WrVwNPQ8o8QOWcBdN5uMD/e973YDie82uurChgrdoSNTsthIEnJRt04xq
	 b4zXc/ouJYH/G2ogus+uDmRCrs+MR4isD2zybiogFlyHT384Md62TdhrfOs6T+j6Hh
	 GW9pRNvL091Kg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	Ivy Lopez <skunkolee@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	johannes.thumshirn@wdc.com,
	john.g.garry@oracle.com
Subject: Re: [PATCH v2] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()
Date: Wed,  2 Sep 2026 23:10:15 -0400
Message-ID: <178840472603.670675.6111450509404633801.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825190313.24013-1-skunkolee@gmail.com>
References: <20260825190313.24013-1-skunkolee@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 13:03:13 -0600, Ivy Lopez wrote:

> dev_to_node() can return NUMA_NO_NODE (-1) on systems without NUMA
> topology information for the PCI device, such as single-socket
> boards that don't expose device-to-node affinity. Passing -1
> directly into cpumask_of_node() indexes node_to_cpumask_map[-1],
> an out-of-bounds array read caught by UBSAN:
> 
>   UBSAN: array-index-out-of-bounds in arch/x86/include/asm/topology.h:72:28
>   index -1 is out of range for type 'cpumask *[1024]'
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()
      https://git.kernel.org/mkp/scsi/c/e0d26fe176a8

-- 
Martin K. Petersen
