Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F2D332ECB;
	Wed, 20 May 2026 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292972; cv=none; b=HMrjzPXTDaJXYIBucYeHtJbm75gXsRaidaSSBpKQ0pmkkA0+ag+er+w2FqIgoGD6aop/tBvlVzkrRG0ExX3DVgQgA6/U9NXdmgv9wXM0ZunaTVcgk2T2fDGSmdcsNIQRk2JiXLZaPxDnig+xWzv/1CYCg5N/O0Ol99ZmDQ2X8Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292972; c=relaxed/simple;
	bh=GaBbEc9uW+LfiXI2M88y+C80PeLZt/HAXzvHd5Boy+U=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=c5NsLbe9/F7rWNthnneH6zjb9H48umjoR0aINWUfaSInncvXNHPdHRNwjIXo64VUJAJ8sia4w9LZOvACzGTp1Q4U56t6SvTM1DICosRzm6KJRU5WneUEehGMZ3mRsGW4FUFd48hH1tudq6waKWKlHjtDQeIiI5z6pUFMgdv1a9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=MovymO1O; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="MovymO1O"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=GaBbEc9uW+LfiX
	I2M88y+C80PeLZt/HAXzvHd5Boy+U=; h=in-reply-to:references:subject:cc:
	to:from:date; d=arkamax.eu; b=MovymO1ObrkaEcz6X3fGcxgsmOwsOW6UUc5gIop2
	vcLpL4oNkQckWErXCbkw0iak04CIAb6Ldl7N2TyfnmZMHglBYLRig9qQk8Pu0PWr7IkE65
	ApewtpU8kVHxwUnVSlQbdGH7aPW7sP8/j3qMbpemy9/I9h4xjFvvk5t8FfzCglnhCH6diR
	+CRzjotYHGd6m29+k8sHwJ3yk4jdXszutDS2OVb6Z1uqtprFH9GzZaQxaWk+UXU+IkKt0f
	Np4B4XPJchbbmKS/H+Mnl41w4fFddeI3x3XqQRUv3ezGhmpf2r5JNho5DZgPlwMZjmyAk0
	aPaNw07ExBoK0gWz0dkq2A==
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 5e3afc91 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 20 May 2026 17:56:06 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 May 2026 17:56:05 +0200
Message-Id: <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu>
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Alexandru Hossu" <hossu.alexandru@gmail.com>,
 <martin.petersen@oracle.com>
Cc: <bvanassche@acm.org>, <target-devel@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
X-Mailer: aerc 0.21.0
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260518235040.48647-1-hossu.alexandru@gmail.com>
In-Reply-To: <20260518235040.48647-1-hossu.alexandru@gmail.com>

On Tue May 19, 2026 at 1:50 AM CEST, Alexandru Hossu wrote:
> chap_server_compute_hash() allocates client_digest as
> kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
> passes chap_r directly to chap_base64_decode() without checking whether
> the input length could produce more than digest_size bytes of output.
>
> chap_base64_decode() writes to the destination unconditionally as long
> as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
> the "0b" prefix stripped by extract_param(), up to 127 base64 characters
> can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
> (digest_size=3D32) this overflows client_digest by 63 bytes; for MD5
> (digest_size=3D16) the overflow is 79 bytes.
>
> The length check at line 344 fires after the write has already happened.
>
> The HEX branch in the same switch statement already validates the length
> up front. Apply the same approach to the BASE64 branch: reject any input
> whose maximum decoded length exceeds digest_size before calling the
> decoder.
>
> DIV_ROUND_UP(digest_size * 4, 3) is the maximum number of base64
> characters that can decode to exactly digest_size bytes, matching the
> convention used in base64.h BASE64_CHARS().
>
> Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
> ---
> v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp
>
>  drivers/target/iscsi/iscsi_target_auth.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/is=
csi/iscsi_target_auth.c
> index c46c69a..50eeded 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -341,6 +341,10 @@ static int chap_server_compute_hash(
>  		}
>  		break;
>  	case BASE64:
> +		if (strlen(chap_r) > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
> +			pr_err("Malformed CHAP_R: base64 payload too long\n");
> +			goto out;
> +		}


There is something that doesn't totally convince me about this length check=
.
Couldn't chap_r contain those Base64 padding '=3D' characters that
would make strlen(chap_r) too big to pass this check?

Maurizio

