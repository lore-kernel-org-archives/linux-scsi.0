Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36682EEE91;
	Sat, 29 Aug 2026 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787967420; cv=none; b=RCv59uczLBl/jqe+Q/Yi3gIvmfmPqYi0DS5TDkfCnnhp6s5O0Qa7QN60ZwK4TUgVkizNqM7GnurTsk7D4fsYZYauPR3O5E7PoBSIEaPoC9f0eeZM8iU36xmboi9VOH0ErWSL/Ij7bLx8lB32k+wHBluxWK6Z3le3+BSsnUYkRd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787967420; c=relaxed/simple;
	bh=katZUr6+yF7b2HTv2jkIb7ULQbV16Nnzg5UU5WHdbfw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=qzsuO9jUpDm32qBw9RlJQhafq1HZY+iOjpgQs2XudmMwHWMgqn/3+SHhFIZJXNANYZhuTfjaq7X8kt54WSRSJdhxpZ87ykifFQVs2cEml8VvVlxVGclg2QEhapIxVeVO9dqA6G0RDzsSAlHp8FsmIrcNKfybciOIzH/ofvk9tUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gt4f3IOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gt4f3IOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C2F1F000E9;
	Sat, 29 Aug 2026 01:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787967419;
	bh=oCbFk4XmjAKOD7UIbVFDdzWsCAjhAN7hz6x9575oE1s=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=gt4f3IOD4IuwUVuw6mVnQuY2s4yMXsjAC/HAtJobBotIzqQ4VS5PbIKErIfMiI5/J
	 BvamN3m+EtkapmP5opnd5r49QeqG8DqUIZqRg9mZONFQE+U23vKemBjYI15ThNXi3J
	 uyDGiUQQnskKj/8tx/ECPec7hSkR6StbrxIbeJrblfnQ9ETSxoz23NUI0qu5LnbQxq
	 pZ8q5EQTL2SEFHuLSXJWw0yIsYDdzpR6a3SN83zB5bLEHaz+nTM4z4zxYTSVNHJgyg
	 Hp192B+Ddkd79NBjuajBeB7xhMDgNOm0+lCSj0RBr6CYfEBz9RY3wrsS+YmUFPLzv+
	 tJda+9BxNCtiQ==
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K . Petersen"
 <martin.petersen@oracle.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  stable@vger.kernel.org,  Jianhao Xu
 <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH] scsi: pm8001: use rollback index when freeing MSI-X
 vectors
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn> (Runyu Xiao's
	message of "Mon, 24 Aug 2026 19:36:18 +0800")
Message-ID: <yq1ik4tk8r6.fsf@mail.kernel.org>
References: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
Date: Fri, 28 Aug 2026 21:36:57 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Runyu,

> pm8001_request_msix() unwinds previously registered handlers with
> free_irq() when request_irq() fails. The rollback loop uses the
> failing index i for every iteration instead of the already registered
> vector index j.
>
> That passes the wrong IRQ/dev_id pair to free_irq() and leaves the
> earlier handlers installed. Use j for both pci_irq_vector() and the
> matching irq_vector entry in the rollback loop.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
