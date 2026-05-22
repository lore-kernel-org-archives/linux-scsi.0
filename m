Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520E3090D9;
	Fri, 22 May 2026 03:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779419593; cv=none; b=Cd5a72iAftPhkrEsTaEfvKxWWqAPAogkpg30DutN6EkI/F4O3wTdmGqOodnEGwCIlTaj9h94SWUwU6JhNNsDDfmOjvFWeS6naRcLwOcJc5q+HZ7pGzUUNlxpRLbMaC4nDH/yVkK5nw3rcNtyW3iwrolml5Z54rXhzaLgAzMrhiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779419593; c=relaxed/simple;
	bh=/61dKCQsNXfQTrcIXspHCHPqrkHzg8ZI5b4gO8VUF6E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ap7eEEMxlC4lNgV089SNmGM4W1Ai3EjRBqtLrWDnfL73z7QKUBbPmZej+Gkw8/EuNIsWKsfrgNYB7BA0JBxBcF2A8vpIBzZ5Kwr+KRglvr/dSjq4xSHLMoNGKhMlhRokruOcqQsMGj7bj8LRbw1vyEUDW5zKBX5LjVHyTFsWB5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nq8XROVi; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nq8XROVi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=rGhhkZ31Tac738LHOJgvPbLoPgSzeZGoYWdhYAmVw9g=; b=nq8XROVi6gwS6a7xGJL2uPJY7W
	u92a2Hqdkq09S5sVb5xKhU5FPsIJ+ZDLnqximbfoB3Nj9vHzZ5Y59YEKqeiy46gwv9UYXk2BThbLs
	AdVIPWUe/RgDD0SEXcCcEr3PkB4Kdf/oqBFrpR0XvEm+q64QNp/wIlhtAHtoJDInjswKSyXa7WyCF
	VFBuWJnCXY+yw9n20Ekpw+PmZ1ZJXYnJs+VF1nMIh1Bhc+tskvGxuWygx3LrICY+7MNAkhHJin4ZM
	Z4VVRnBVvnxloAB8KNbnMVTijipEes6YSexC19s5T6SaekAf9sXL15ry2uWxVs684B/NI4BDVVVwT
	Ssswjkp856KzaAw2+6Oe9OWoP1ISF4kq1GRVQ0v7EEkaD+I+TzR+1EKnSpoFgJdEXbQJ/mEOHnD7A
	9g6ei7dmBCAVt23WYwKyzS5XcbEQeOe39Ul7L1ZrZrrWRBc5Om5TCVSFzK5IY161Unb5o9ArVBQjL
	hbvAYIzRaEN7MpjIt/Hnr8g1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wQGJq-0000000AqWk-0fhk;
	Fri, 22 May 2026 03:13:02 +0000
Date: Fri, 22 May 2026 13:12:55 +1000
From: David Disseldorp <ddiss@samba.org>
To: Alexandru Hossu <hossu.alexandru@gmail.com>
Cc: martin.petersen@oracle.com, bvanassche@acm.org, mlombard@arkamax.eu,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v4] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
Message-ID: <20260522131255.317946f2.ddiss@samba.org>
In-Reply-To: <20260521151121.808477-1-hossu.alexandru@gmail.com>
References: <20260521151121.808477-1-hossu.alexandru@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 21 May 2026 17:11:21 +0200, Alexandru Hossu wrote:

> chap_server_compute_hash() allocates client_digest as
> kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
> passes chap_r directly to chap_base64_decode() without checking whether
> the input length could produce more than digest_size bytes of output.
> 
> chap_base64_decode() writes to the destination unconditionally as long
> as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
> the "0b" prefix stripped by extract_param(), up to 127 base64 characters
> can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
> (digest_size=32) this overflows client_digest by 63 bytes; for MD5
> (digest_size=16) the overflow is 79 bytes.
> 
> The length check at line 344 fires after the write has already happened.
> 
> The HEX branch in the same switch statement already validates the length
> up front. Apply the same approach to the BASE64 branch: strip trailing
> base64 padding characters, then reject any input whose data length
> exceeds DIV_ROUND_UP(digest_size * 4, 3) before calling the decoder.
> 
> Stripping trailing '=' before the comparison handles both padded and
> unpadded encodings. chap_base64_decode() already returns early on '=',
> so the full original string is still passed to the decoder unchanged.
> 
> The mutual CHAP path decodes CHAP_C into initiatorchg_binhex, which is
> kzalloc(CHAP_CHALLENGE_STR_LEN). extract_param() caps initiatorchg at
> CHAP_CHALLENGE_STR_LEN characters, so at most CHAP_CHALLENGE_STR_LEN-1
> base64 characters reach the decoder. The maximum decoded size,
> DIV_ROUND_UP((CHAP_CHALLENGE_STR_LEN-1) * 3, 4), is less than
> CHAP_CHALLENGE_STR_LEN, so no overflow is possible there. A comment is
> added at the call site to document this.
> 
> Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>

Reviewed-by: David Disseldorp <ddiss@suse.de>
