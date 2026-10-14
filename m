Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A76A412264;
	Wed, 14 Oct 2026 03:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950256; cv=none; b=Xoyc6llUIVD5mGzXBLjfjWXMQMqzErxcHVSHzuk26uw5XDrzZKn3DqsLRdvgrbtH/MccnAaPQZko/xHEOhawnem16eKxtXEvCj5DLoceio7L37cbEVXP9FawmT41ZiWhtJ5yZfdqekOImuuXu0h5kTEYBvnau4x2zNrWLGkKmrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950256; c=relaxed/simple;
	bh=IM4oxNTK0d5wuZibI3TCIKKcrCOCps4eEwFUEqgH4Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ucd/r7fw62sGqjecDTtXgxAAbxvhnoZiNcDov1OqSKytF+5DXDzhpRVXNEf9UamdKdj4oQPNi7s0wQR4LTYyoHDoonBvtdH8Ot/qx5q9ZPChf91+DZyXseUSSz4ecxaXJcE3goTf1iaT7AC/7dxH7jvZjS8GbHVcunCevDMTKwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/XTwn4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/XTwn4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33E51F00898;
	Wed, 14 Oct 2026 03:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950254;
	bh=rwJPH0bUXcBLnCG4R/MZ9TBJHGIsrlEMfuDlB3v1zTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/XTwn4ZbQc4Iv4ApUmv4bh0AKQ/2Trw1s8nQ3bIkKiupW0unBFsFME4JcFdic7kB
	 MMuhSQ/Xd0q7al83l+0qkwpr6qZMBcrRMK3FZCWxhvWrFSsceCyZGdpciwwjcNlLZx
	 qglYucKjaeGwFSSrEDq2l3cK2KhiFjjIacln5GPO8A3/iaYkAFdchjXlQ6nq/8YBfv
	 S0IweHSmLNjJ7PupUVi/Bs68bz8tyHiZYHdhwV46S9XuBRKHG2sybV2h6i8p/ryjV1
	 mFHQKvNyxGCZNWYrYlVhB4BcW/8PlSBb2Y8YVFWKDfsnxG/nPUnVI4R3pch+1aXXDw
	 684m8nSoP2dEw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: michael.christie@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 0/3] scsi: libiscsi: validate task lookups driven by target-supplied ITTs
Date: Tue, 13 Oct 2026 23:57:25 -0400
Message-ID: <179194999408.3016381.4915889756552793867.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
References: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 07 Oct 2026 10:58:39 +0900, Yehyeong Lee wrote:

> Three places where an ITT taken from a target-supplied PDU reaches a task
> without being checked. Each is reachable from the wire with one injected
> PDU and each is independently useful, but they share one lookup helper so
> they are sent together.
> 
> 1/3 bounds the index from below. A transport that implements
> parse_pdu_itt can produce a negative one; be2iscsi does, and forwards an
> unsolicited NOP-In from the hardware with the target's ITT intact. I
> have no be2iscsi hardware, so this one is argued from source.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/3] scsi: libiscsi: reject a negative task index from parse_pdu_itt
      https://git.kernel.org/mkp/scsi/c/8ee2a09a1dbb
[2/3] scsi: libiscsi: validate the ITT reflected in a Reject PDU
      https://git.kernel.org/mkp/scsi/c/c5958c770b2a
[3/3] scsi: libiscsi: validate the task named by a management response
      https://git.kernel.org/mkp/scsi/c/11bffcd9cb34

-- 
Martin K. Petersen
