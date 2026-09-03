Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6673D361976
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 03:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405031; cv=none; b=GLvO2uajeg7ST629WwGUkFkYd2bR4c31vR0d8WwVZ/q1/l1+UwwsPqHq4F3Y03Ujz2UKT1cNxeQsapYwjlSaa3nT08B7Dbr2OXWdOpJ/V1KMK8146wiULLkZZTqKUYzY1T17BRIUFRps0eF/G8+x6Zcy2FQAgL4Z/8n2cD581oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405031; c=relaxed/simple;
	bh=ppN+AA9RoMDmQN0OnusM6e+twye9gzevwnd4PpAk67M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kntTq4tz7KrOn04sUI26oQczobLKS4skeCnskxU+Y34Mr6+QftPrfYad/cGl/pMiL7OsRuZwYH+9PiS9D5HWmn9yMKqQKDxeZplRAf2/C07proUTEDMAGMQ92Hh/rT6KdqZ3vW3hxYTL36MTBxhNCLn7S6L1/xH7QJV3yYbd6Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiOyC8m6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiOyC8m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A993D1F00A3E;
	Thu,  3 Sep 2026 03:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405030;
	bh=kF07EpDxnZ5+1Mi+Bsse1OteTvybi7s5pKRZ8G5s2ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiOyC8m6e3VUtEbbfv4JWoE3QLlrjTxGEt6H+xzRzJOjYh67QQGq8vp0MtQtNyMPc
	 OlKpl85osIEFbGp/Cf2TjP3apKEvXOn2n/VVpbYFqvpCqdW5UyHyERbmM3MvLgjtpQ
	 iR+9OouZOP/HYlFu9whX+A2mWsSVKKVKOk2yhMuY1kEWJtkHEvom96oAxi6y3c4BDb
	 rhbUbHP6300Y95iZksxw0AXMWMRg4rVtv1tgQ62b2kl3/CnOYQ/CmWhiJdrPmre8t5
	 EAO1NorAorCm2QxMH0giMVAlElUpe1VJwIptOoBIwyuqh/oahRpBgV7OeCXoL8k5SM
	 zy+sV8/07cZzg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Milan P. Gandhi" <mgandhi@redhat.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>
Subject: Re: [PATCH 0/2] scsi: mpi3mr: Fix error handling and resource leak in mpi3mr_sas_port_add()
Date: Wed,  2 Sep 2026 23:10:09 -0400
Message-ID: <178840472587.670675.4679083574169753199.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812103344.174247-1-mgandhi@redhat.com>
References: <20260812103344.174247-1-mgandhi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 12 Aug 2026 16:03:42 +0530, Milan P. Gandhi wrote:

> This series fixes resource leaks and potential crashes in the
> mpi3mr_sas_port_add() error path:
> 
> - Patch 1 adds a missing NULL check on sas_port_alloc_num() failure
>   and ensures allocated ports are released via sas_port_free() if
>   sas_port_add() fails.
> - Patch 2 releases the target device reference acquired via
>   mpi3mr_get_tgtdev_by_addr() if subsequent allocation errors occur.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/2] scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
      https://git.kernel.org/mkp/scsi/c/dba9e2181ca5
[2/2] scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()
      https://git.kernel.org/mkp/scsi/c/419d129f970a

-- 
Martin K. Petersen
