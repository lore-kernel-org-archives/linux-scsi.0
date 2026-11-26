Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664110;
	b=xxmI22LKa5rR1XbZCiNNaJJyJa5XlezL2UmPW3GTmSTCdpDigYVgGKNiqPVf45hSAfmf
	 CnXeHJJltpVIKoJ9+LtjxmHHyb82wudrD4qOWFXQkIUmwdVYn+x84WRKsSkmI73gq6HOv
	 vmRHQaP1lhNHVKruz5vPSWVLIB4ko9gYU5T9Jyp3bv7iTkpMSEoR0vz11iSEo9/dMa5ok
	 daCMvqt+smwXwym35fIOGPMteJNqfyaXtTK5a9iEARB5Erpr4TEFHApcfR8fGXyCTkXlq
	 Drzh9JXYbq5XC7dpwSaSgONfcWt96pSyKL5TsVJyBBnydrwm2gaSYKGybBCe87zzO2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Hu0gzJsXujTx+Rp0yJWGyVH4M6mSE/v+OQLTsPeY52o=;
	b=NTHEGuGjKalZVLhRx5n8faG68h15kQ+V11MYcVzALGbG94LIORKnfqVpp/Uc0Pm+OiCd
	 hS+HN9VicmV1ky+DuzY+Bv87cDBmVMr9s4E+NyfNjzsU2clKGgYKt6UD2+EbGFVJo/jkx
	 PC3EzGR8lgoC+NlthbaUrlodsXh4r3vOztXBTYzljafVfZDXKhuAtci70/ONB+eu5QUfE
	 xalmsS2gJJbZCT5YyE80+tY4byyGQsxyW5kHVx0sEQZwy+MoFkNb7ydDsDwKxvxjlaVn+
	 I3slFu83VFmjs6ZldduoMl76CaJNfZ6Yqy087h7T2L8B08NQcsuIBaO4a1km2YUc6GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hIf2EEne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB7C606A686;
	Thu, 26 Nov 2026 03:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hIf2EEne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344CD1F000C6;
	Thu, 26 Nov 2026 03:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664109;
	bh=Hu0gzJsXujTx+Rp0yJWGyVH4M6mSE/v+OQLTsPeY52o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIf2EEnepoWQ0pQtDst4Ubv7jl+ruGue2V0tscPFclz0TDdRtI8dBhRzqNQaRTi3q
	 PLBbdZPwWpcDiTBohgsfJnPbSJr8TnAVjzpKlUWXw+fu4yBEnfbhJGINDTonm7Ifu9
	 xKR3bV+lcSPEZhL3QRE66hpH1ATpX7bpER1mTr+mJPCOG/ZrxUnfHXsn4Wl8/BDArt
	 LYSOfMw7aeP0M5qi+CZsEfyakb/VPTunec0M2+hR9XteIg4UbcNHrcJTRyo4fCljg5
	 5fwc4OcwcKkyLSTnboKzp0CpOYIGaZ+BF8Ek5kxJkVv7xULBmEzl8YLkxqrUz8BrzS
	 PdOMXG2AeM9nQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	shao.mingyin@zte.com.cn
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: proc: use snprintf() for the host name
Date: Wed, 25 Nov 2026 22:34:52 -0500
Message-ID: <179566062797.467514.8844922842529784457.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261110231126279OKrUUjTUMgoJ1kpbNZrCV@zte.com.cn>
References: <20261110231126279OKrUUjTUMgoJ1kpbNZrCV@zte.com.cn>
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

On Tue, 10 Nov 2026 23:11:26 +0800, shao.mingyin@zte.com.cn wrote:

> scsi_proc_host_add() and scsi_proc_host_rm() format shost->host_no into
> a 10-byte buffer with sprintf().  host_no is an unsigned int and can
> reach ten digits.  The %d output plus the terminator then overflows the
> buffer, and a bounded format would truncate a ten-digit number to nine
> digits, colliding with an existing procfs entry.
> 
> Widen the buffer to 11 bytes, use snprintf(), and print with %u to
> match the type.  Ten-digit host numbers are written in full, the
> overflow is gone, and W=1 no longer reports -Wformat-truncation.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: proc: use snprintf() for the host name
      https://git.kernel.org/mkp/scsi/c/f505b951db60

-- 
Martin K. Petersen
