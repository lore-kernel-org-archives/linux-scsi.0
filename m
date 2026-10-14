Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4100740B364
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950233; cv=none; b=B0UI2+vm3Q1F3i386XsZ8jxMKVVmQl8bKLHnsRfEPX5N1QWTPETjN0gCHDlandjvPmI3snoZuFhq1pFFAT6ewjFxjRcYz+WhbTCNeUUOUwpfjzp892xnASh6ztnmsKoTUw0IKl9z/jLkbUi9gT+SK/LBPovbQ5hPovYQ/LiQjs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950233; c=relaxed/simple;
	bh=LvqNAEcQrBxueW5Y00xRJXFLnAd2GKlB4LQs/KENZeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DvPy0xi0i/5GUa1CROcybvK3iifYu/fGF7W7Ayfr9E9Y4IIHd+GyTtqETmY2G1YgXdYSa3kPfu5adtD5hgz42h6CeGuy2EuI1xkiIKeh9f0IpRiLqS503ZJn+PuOqXjCugXf7KRuq/d/jmKOD4MROashz3jKLytQsxnQXt9fRhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gP35/hJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP35/hJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723991F0089A;
	Wed, 14 Oct 2026 03:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950232;
	bh=iUUryP3UJt1+M+gnZCOtWW4Oed5gkyGN4xdQ3RW0o6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gP35/hJZPDkF4rp36ZmG0Hnk9LZPmc+O8pwoQSXoXJ5KqsQuH0TLP4sQbdKevf8BM
	 97F+Q8orOpBi4YeofVfSaR8uA9Umx0ulveHRQRT1r0OKbG2hCoFekLwmP1bHXZMuJA
	 u9HgtKjP+8dAXzOX5NPpP+9s+n1JiMxob6stbauDjDVJTuNl5E4baJCklZBqP8Jdfb
	 eLsMncVIZVmYGWjy+jrBtjvF2qCaw7VUgtaRVCYjCOmHayBnz/KggJDeUhLSYtnImJ
	 8N8MxGd5861Fbyfa3/wUsswm+HvcD9Lk+G/5GxrM3whxsMJinOFedR4TdXkjV/lsvj
	 vyY4raJIyY8BQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Niklas Cassel <cassel@kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>
Subject: Re: [PATCH v11 00/13] scsi: scsi_debug: fix zoned write validation
Date: Tue, 13 Oct 2026 23:56:47 -0400
Message-ID: <179159633701.2229379.9795795593308335652.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026 10:24:57 +0200, Niklas Cassel wrote:

> This series fixes scsi_debug with regards to writes to a ZBC drive, and
> to WRITE ATOMIC (16). Each patch describes the problem that it fixes.
> 
> Two configurations are refused rather than emulated, and those two
> patches come first, as the rest of the series relies on what they
> exclude: a zoned device whose lowest aligned LBA is not zero, which no
> host writing in units of the reported zone write granularity could ever
> write, and atomic writes on a zoned device, which no drive supports.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[01/13] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
        https://git.kernel.org/mkp/scsi/c/45ce384be0cd
[02/13] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
        https://git.kernel.org/mkp/scsi/c/e5ebe632be40
[03/13] scsi: scsi_debug: Refuse a negative physblk_exp
        https://git.kernel.org/mkp/scsi/c/a349876633f7
[04/13] scsi: scsi_debug: Take the zone metadata lock before the data lock
        https://git.kernel.org/mkp/scsi/c/c9aedbcbff0f
[05/13] scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
        https://git.kernel.org/mkp/scsi/c/1809f9bf3da2
[06/13] scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
        https://git.kernel.org/mkp/scsi/c/92feb036a2d3
[07/13] scsi: scsi_debug: Report the residual of a write
        https://git.kernel.org/mkp/scsi/c/7c000c4ad2c0
[08/13] scsi: scsi_debug: Enforce physical block alignment of zoned writes
        https://git.kernel.org/mkp/scsi/c/63cb3900be26
[09/13] scsi: scsi_debug: Do not write a partial physical block to a zoned device
        https://git.kernel.org/mkp/scsi/c/b8fad9f02485
[10/13] scsi: scsi_debug: Advance the write pointer over the data written
        https://git.kernel.org/mkp/scsi/c/cb2d2a7c80c6
[11/13] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
        https://git.kernel.org/mkp/scsi/c/b81608b17c5d
[12/13] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
        https://git.kernel.org/mkp/scsi/c/491bd55c35cb
[13/13] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
        https://git.kernel.org/mkp/scsi/c/a6c339feb830

-- 
Martin K. Petersen
