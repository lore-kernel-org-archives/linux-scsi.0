Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333C33998
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791035125; cv=none; b=YgiDfvSysjyUvU+qqFhAIMsvkiTg17xUPazg4fHVWTWLD7PCqFBL4MIANJ3OWvluGpwmvNaf89Prclrq5RhMRv6HTIQqWak75PPVuTYeIa03zWQbHaecVcoVzmO9JfeHpKHQE5wf7/t85S684pjcj/gm0jXqqy56stCKN/RsE90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791035125; c=relaxed/simple;
	bh=lNbiKMqcz82gNi0M1nRMUQwkUotWEOIYq4p2wK4qfFo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZzbo53PMPNFYh2b2NVT40SMwumjVsApGUTnf4AoOp/vGnsW/U4MtxnGwIjGSxxrExilj2a23Ie5IimuD9IRdx6S+VStmiQ//Wo0nK7oSYs6P1HSA9Y//H7wKGjSADCugWJMQfJtxA5G2hzYCcoKPSw1fkjBAEpK0CZxTThDQn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bf0AqGgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bf0AqGgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28561F0089B;
	Sat,  3 Oct 2026 13:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791035123;
	bh=uVVtsRGMDOmwQ/Yg0i3AHU+VbW5mMyQiWnBoI2zSzJg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Bf0AqGgGJDfT2df/4keMI6L5ovzm8jzr0dMOIHx4m9g42UC19aUF9xd7qPDYs0UF1
	 oArDa9WtYXxbGKADvavByyjAyG6lXWApIVi/YbS2wUMnL7bozMIaRBLcLejZe5wBKr
	 rTRWvBgj4GrQK2EyGw0a9yAmWTn3aQ/olqj6bfYclo8tv+CYZmsHvDqTUZKYvSSGNM
	 4xakNSc/CzA+NtVoaJuiS5jp7zIMVu7nD5+wFG13t0Kw6BeX7ouIPPxhKz4UICf7eO
	 Vd/P+BPwJlTm5kVC6PPTszWlCTNueku+Xi9/TDxg1zmKqAADnKZmCTDGnkKXwt66/A
	 Jf9TWWa5gQ/jw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2] scsi: fix additional sense code definition
Date: Sat,  3 Oct 2026 09:45:19 -0400
Message-ID: <179038630274.128504.8648247593552677386.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062959.2245533-1-dlemoal@kernel.org>
References: <20260918062959.2245533-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 18 Sep 2026 15:29:59 +0900, Damien Le Moal wrote:

> The ASC() macro used to define an additional sense code with no additional
> sense code qualifier conflicts with the ASC macro definition of the file
> arch/sparc/include/asm/ns87303.h, leading to compilation errors. Avoid
> this conflict by renaming the macro as SCSI_ASC() and the ASC_DEF() macro
> to SCSI_ASC_DEF() to be consistant.
> 
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: fix additional sense code definition
      https://git.kernel.org/mkp/scsi/c/3b7ccba37858

-- 
Martin K. Petersen
