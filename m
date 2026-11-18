Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977381;
	b=Lk4BWFN5XfWajuxAe0z5BdsQpRJOhi+qvlw+idIaedZ5o3XFiDHGAUppiI3AHx1mUnCf
	 /zYZ724kuzUe1ag7XnjYJOsGWJY1RgiEIFliwPzbbXo2uiZAwhBC6lhSSERjfMUM603ro
	 Iebqp/kyNXRLnd6UxNcogKVyBi6N3HdooGrr6zAVmzfMHEs+MNM2yXVFn56RjW2jc1YvN
	 2ecohVXIVAquMOvNQbIYnvEwyWSlKSMrimXe+h53WSTOQSL5KrjLSRP95b4PtHKY5f9vM
	 7nFuP+9UldvYF/Fsl75wlkpnJKMeb1FgkfAEe/cT9ChyxKwvnUJ7KNBscNmfjizgrgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=RufmPLEdOt93I5T5TQq0x49BntHV1EhlC0gK8d0OVmc=;
	b=aqowsXNKN7PxktArqCjctSNmtXsm3njduuX1j2wHRaqnqna1s7a9AH7NzI86aSvxQ4Uv
	 oDNKoIlTQnDzk+EyEIDr7bitz5O7NKRJ6Ik/2Fx8Ji5f6DLQCTWBUM3AE3eo6xJiJqCP3
	 NgWhTR0Jk+3T7/wIlOULyEIDHLCtgW4bROz92nWjSazYWkbe1yGOe1RtyhvqKnfUMgE5+
	 Mqf2zeyPjs8ZtbTmdeimh9RWMWyiw9+bMM4kb9LvS+IpELFXtnqbZi1jYwiDF+Ec3ABXe
	 3e3G+/2a9rC9TECdB+CCuMqgGVDvWjgSt6h1TxdKnEdXzbk9FB338FqVPpnONN8mIcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n017AukS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD61606A880;
	Wed, 18 Nov 2026 04:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n017AukS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27361F000C7;
	Wed, 18 Nov 2026 04:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977380;
	bh=RufmPLEdOt93I5T5TQq0x49BntHV1EhlC0gK8d0OVmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n017AukS5pWtxW3mEbmTAkdEnkqiRwcaGLLEUhmXkBAlCxyWMg7LhDgphG/aSSdh3
	 C6A8uBkNgrmVwggWDJuTobWuxGpnFeJFoPt6vLNCFC4JNXR9a2yJrbwbmi7Cso2raI
	 r2U/fHAIvIKEc/u8aPGPVk5/ZdaRaiENyJhwuGi1mr31T6m265i1jjUnevy1bvycxS
	 gZxH0pKMRCKLXhoAugvLFUCafP+44kIzu8/WtLsb8/cHZloY60PNOk9eP+INMa/4EQ
	 GCFLUS+x7esq5iAl6jYht0eGV1Dq8hfiyw9q4xf6lGwfcN0hE237cgDfai5NFBMdPt
	 0UTJlkvT1orsw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Jens Wiklander <jenswi@kernel.org>,
	linux-scsi@vger.kernel.org,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bean Huo <beanhuo@iokpp.de>,
	Bean Huo <beanhuo@micron.com>,
	Alexey Charkov <alchark@flipper.net>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] rpmb: Fix request serialisation and teardown races
Date: Tue, 17 Nov 2026 23:49:26 -0500
Message-ID: <179497726098.2093762.2793506457468994473.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261112004112.3059801-1-stanleyjhu@google.com>
References: <20261112004112.3059801-1-stanleyjhu@google.com>
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

On Thu, 12 Nov 2026 08:41:09 +0800, Stanley Jhu wrote:

> Jens, Martin,
> 
> Patch 1/3 serializes requests and provider unregistration in
> drivers/misc/rpmb-core.c. Patches 2/3 and 3/3 fix UFS RPMB device
> lifetime and drop the unregistered bus in drivers/ufs/core/ufs-rpmb.c so
> regions register again after commit 36f35b8df697 ("driver core: reject
> devices with unregistered buses").
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/3] rpmb: core: Guard frame requests and teardown with mutex
      https://git.kernel.org/mkp/scsi/c/e0696bf65006
[2/3] scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF
      https://git.kernel.org/mkp/scsi/c/7bc9b854cd68
[3/3] scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus
      https://git.kernel.org/mkp/scsi/c/b1de2bd5a4d6

-- 
Martin K. Petersen
