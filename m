Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812306;
	b=Tn9s679oAZ11auCIk26IhefbV1ah5GtKlnXwdwFMn+e3X7NjCyB4tCHoMZtdMmtKEpkj
	 uhdj7cRHuhv8Fnkc5Ig5mCGzcZT+Vg+DpW7e7je/6XwF8rDddYVqcGcEc07IBsST/e0dN
	 3Hqxcqi729w2MlQGcCS3nku7bRChS0h3kPLrocc98VJ+UpfuhQ1oDQTpUPGitrfBl04Gh
	 KUDwk50CE40JWTZaQhN/ERPihygdAjkk9b0gGWAvgnSwPj9OOZnrlBb4V02QZK6X7TjL8
	 Vs9ThO4ULsb1mGLhg5bjhE6sbT6CS1v7KbzJDOIU1Y8dz62Wx1zi+Y6eZKIaJ0l+VzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=I1+D8Xn1GxoNpJnTs1lnFP6TD5MdBz3XzG74ZRNUKJc=;
	b=CoeoKl28k+6VpqJdvBeN3+pOH4pPEML8X/kA9ryrLcsYtL5FCy9ll/o+8ax49yu70cP+
	 smTZihnXeASEzWfS2qJq8If+G3uEUTlLxuC79YICVbgQaQ5hXVX5pxQU/sO56wK0Dz/gJ
	 prEHp+CalWfpimWLtQoW7E+msZUbVuyD/NIZddLPVyUHut/S6fk+GnwAnI+SrCUDEPQ3M
	 GPdC7vNuLX+KfvyukFdGW0cP9f+pW8d14w66gjNKJlXKdeZI1FADH2hsTyONusgsBnK7y
	 HTTD02VCi0e0AiFxZJbdVPvqryT9mklf5F2/cUFRGM4fF5gOmzLKdsARBB7eeJnnulw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iERf0Mb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A514606A327;
	Sat, 24 Oct 2026 03:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iERf0Mb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269781F031E1;
	Sat, 24 Oct 2026 03:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812306;
	bh=I1+D8Xn1GxoNpJnTs1lnFP6TD5MdBz3XzG74ZRNUKJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iERf0Mb7C05MjTgdEtSJyQGQU8lyedubW+8xduFCmDiOOrYw+EcGX+enwvrEmGPlr
	 Uvk9bbAglbb7g6/f2fhAblTGlec1qq8Zp1WMGB68vNHxSEjq7v4rk7QBVbLCIpSPd5
	 W6EJseuNu8/h5zZgP2rk8p4AvgUI9HjSNK1K9BaomkePkiiEYAqrZndQ641GD7p2Nv
	 ebHQnFqDGcdyIMRow+rxouyjP/gdwqJVDZ015p/B0LgS/KRDj8qslET7bqW/yW4tH6
	 69Z3C2ocS0DdKBGdz0tYarJyAVRE5Ic1O5ueNQ3rF58Gd1m3vlRh8xsr08Z2f1fgWX
	 k1NLceaNl0puQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use crypto library API
Date: Fri, 23 Oct 2026 23:24:54 -0400
Message-ID: <179280384859.3823844.8121472859000206793.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001044857.169487-1-ebiggers@kernel.org>
References: <20261001044857.169487-1-ebiggers@kernel.org>
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

On Wed, 30 Sep 2026 21:48:57 -0700, Eric Biggers wrote:

> Make iscsi_target_auth.c call into the crypto library directly instead
> of going through crypto_shash.  This is simpler and much more efficient,
> as it avoids overhead of the crypto_shash layer.  The hash computation
> itself also no longer has error codes that need to be checked.
> 
> For simplicity, still do a memory allocation per operation to buffer the
> data (which is typically less than 50 bytes here) so that the one-shot
> digest functions can be used.  It's still much more efficient than doing
> the super slow crypto_alloc_shash().
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: target: iscsi: Use crypto library API
      https://git.kernel.org/mkp/scsi/c/b633249f5883

-- 
Martin K. Petersen
