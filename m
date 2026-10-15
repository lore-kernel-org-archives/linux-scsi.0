Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC9B346E51;
	Thu, 15 Oct 2026 03:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792033382; cv=none; b=dKJCEGMCPhFH0z/g8AqgwCcwdnpNvPYlO6DkZfcOIxqel2xNoRqo8VTeXxhA3/6+aACR/s5JoNspldzTRXi+ClvMF+57BJWfczbTj9gDxfcTniQe3Nuyj0JWyo0TrUxkYjBcF0xhoQxiAajydjTH7+PTSX4+kvAVEHfiK4VSH4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792033382; c=relaxed/simple;
	bh=2DSJliZ2WJNhJ5U8Z+h/mh7rB3CbVA5k6pJpjApNNhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KvWIWNAQEYMr9JWdcCI+HQ6TMwzLkwabV4xQInFdDid9VgJUpR6j9Z6rk/AnYjsR/1vhDh5kfT7W50KFWF0yetvjgvVlzFWw8rbhNdrg3H6hdLhykPzrHAJuT4HuXpZ4OuhF0x5C1DBWffIeUt/M3IihpaiQbM9kRkqBXeX6q6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZm4oIoc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZm4oIoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7381F000C4;
	Thu, 15 Oct 2026 03:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792033381;
	bh=9g0CccAGi0XDioW3x8oL3CXZLvnZR6B+PmPnb1/u+7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZm4oIocdAGKZulkwYeD7XG2GalPR4oq59QYYB+qw75WGNYILnh3SBRilMVcIE87A
	 iXb2Lgk406mT9i2ycmYpgTzQ8+cQWQcbLOQH0tLAQJ7R20hnIA6xmOY+aA1a25CX7f
	 avTHfa5WCiGibhJW/H0jKFP3yo9WcA7O/e1nM8d1sFca7etdQUvQemXPiB7lsDM2b/
	 PkfI7c2YCRLBof4dnXr+nDPoivIdXplVewYeEe77Xh6jzKNi/zXpxM/t3pJ2giA7pL
	 OTSH0fi+Zko6Dpb4xK3lSMKu7OAUmdflmwdHRKRUKWcBNkVm5Je6fzV5d+FIEgmBSM
	 HMgX58d7DvR7g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bean Huo <beanhuo@micron.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	open-iscsi@googlegroups.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB replies
Date: Wed, 14 Oct 2026 23:02:55 -0400
Message-ID: <179203336212.3648956.1414727087539071939.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013132708.1669415-1-stanleyjhu@google.com>
References: <20261013132708.1669415-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 21:27:08 +0800, Stanley Jhu wrote:

> bsg-lib allocates a 96-byte (SCSI_SENSE_BUFFERSIZE) reply buffer per
> job, but struct ufs_rpmb_reply is 104 bytes: a 40-byte struct
> ufs_bsg_reply followed by a 64-byte EHS. When an Advanced RPMB command
> returns an EHS, ufshcd_advanced_rpmb_req_handler() copies it right
> after the 40-byte header and writes 8 bytes past the end of the buffer.
> 
> Let each BSG transport pass its reply buffer size to bsg_setup_queue()
> and have ufs_bsg request sizeof(struct ufs_rpmb_reply), so the full
> reply reaches user space. Other transports keep SCSI_SENSE_BUFFERSIZE.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB replies
      https://git.kernel.org/mkp/scsi/c/ec6b083915e8

-- 
Martin K. Petersen
