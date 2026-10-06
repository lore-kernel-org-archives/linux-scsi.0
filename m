Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1EB2D1931;
	Tue,  6 Oct 2026 02:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254686; cv=none; b=sd1eUbQI0CJlVI7x2q9POnilWppOp0rWBqWRAGpNMw0yDc6pkse6ENeWRBNXbD7alBb0DFR+p4FChaZkJ03R4BRY2o5GfwGCNBCMLttb6txzm9qcNXVFdnClj4LvY/ThY2eduJiIL8dAt1yb1lmSsaWdQQojZSMh15Dgwvk6TY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254686; c=relaxed/simple;
	bh=T/5uZ8BRftlfGu+2XV0rdkssFMo/aMckb6bcISTjMTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E8ZQSxLYUpuFUymaRRG6EWWG6qTUIJE0XJgpZdQU4kWkQB1hABgsw7hypNzFgvAFIGtwWDidBbhArHcESdfGAgOxWxnK4Xd3khW7QidEw4zD1O74f/o6uWEv+lOm7GH8F3593kDXwM7nunP3IIeDmSeDtjvxwkEhZm2g+iCX3wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuhKWn99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuhKWn99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2A61F00898;
	Tue,  6 Oct 2026 02:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254684;
	bh=fX8L83CTKBsxmR8Lqmre/O7Lq7wMgqQA1XZIcssKUQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuhKWn99xiM3QVgMgpwZ3d50Ym5HzHjSO9XRPA0QnWNyJ0ARAtyI9luAa8eubXlvy
	 uNhwEk2jjjbz+6IvGhcRaH0xroToJfj0L8FUSc8WAq1tdov3kYoJA/fElT4ZQiIIai
	 ynuSHlC3BBeuwy8AXUT1Zk476uIlXBTw2YLBa/mH0IHnQT/aw9I0GthiQBk2Di59hZ
	 7OEgvRW9x7QE3mC8dqPRO6wEq8EDaTTl7YGqm15W8uBcWlaHnub8vv7aLM7WPCPUki
	 shqxN/ynuLZBCBD9q9PTNHzn1MfvJw5CHgQ/bJ/4UKI+IdWS/bCA5/hFYkozQ4UcE0
	 wOM6hUlBJqiIA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Don Brace <don.brace@microchip.com>,
	Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Kees Cook <kees+treewide@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: hpsa: Make buff allocation type unsigned
Date: Mon,  5 Oct 2026 22:44:36 -0400
Message-ID: <179103513135.923653.18301149949175889189.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917211137.i.357-kees@kernel.org>
References: <20260917211137.i.357-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 17 Sep 2026 14:11:38 -0700, Kees Cook wrote:

> In preparation for converting the kmalloc family of allocators to the
> type-aware kmalloc_obj family, we need to make sure that the returned
> type from the allocation matches the type of the variable being
> assigned. (The kmalloc family returns "void *", which can be implicitly
> cast to any pointer type.)
> 
> The assigned type is "unsigned char **", but the converted allocation
> type would be "char **", whose elements point to a character type of a
> different signedness, so the two pointer types are not compatible. Take
> the size from the assignment target instead. No change in allocation
> size results.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: hpsa: Make buff allocation type unsigned
      https://git.kernel.org/mkp/scsi/c/d0105247ca7e

-- 
Martin K. Petersen
