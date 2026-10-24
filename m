Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792811394;
	b=HlflsbC/0FhO+qaU7dhnfvwVdooW8Z6IdVppQqOQfg//m7voqryTAeH4HJqbXyr2Z1lP
	 iDPzKIBpUCeOjpixsNeubRoUzdUV//4+g7wUqnYO9JCqQdOURuVais0o9JzmVwVqD3MdM
	 HYBDNJQVhN8Wjd7htwxFekkmdRfUWi3QRG3AlPQESsaqgvLma1gFObHF0mJp9Nik6Uycy
	 aLInmkWW7xq8qs8Ut9vA1FtlEdD7ffvQma++Py+EoYqfbqEcrsZ8aDY2Z7wwXvupw1axK
	 eNWHrD5KUD23RTkAu3zf062JIwPlSEnBEJPxivtUCBnV0eA7VzX53HYLdbazVN4iqPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792811394;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=jeDtFxMmARx/BEdwf0rsWaK5rXrSn2uSaZplamu0Wm4=;
	b=eyNHBLWPa7GbxUt60j/Cnq0QkbjuLjRBKKB/CF+6vgj18IUr1cPq9EEpzZyBFP/TQytL
	 djaQT6uYjAdBpxFf0aTIMk2VZ7maevoihiCYZdzRLfnF4+nE9UMrlEQtETE1g87ujvmcp
	 nt+fNISAGIh17/h2KfWF1qNZ/5nL+fQJ/M2vLUoxhAuaLJT9LKVl7mYrrNyBzUSaDLScd
	 TU6cQu48HUYW/SRIikAiefPVD+rPXOI4mKN0CJyZp/yWVpe94e45MwaYHws9buYHSBjqj
	 DvxVaoeek+AQEG1bDjrOJorw+tUIOSMYR4PY/gbn2NZCnVHx6GKDcH2TGwwdMoIr5HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QmY5HTP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B8E606A31B;
	Sat, 24 Oct 2026 03:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QmY5HTP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2181F01825;
	Sat, 24 Oct 2026 03:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792811394;
	bh=jeDtFxMmARx/BEdwf0rsWaK5rXrSn2uSaZplamu0Wm4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=QmY5HTP4rrzTk/iBQnergo1aqKE0JSeQdhTStfWGD7+7PSYGGmgGpl6Y80Ea6v6wW
	 OhEaSyjn6qqT4bOfE+Baf9cWDdg7yIbfF+U5WyOUpyEuYvo2fYr+Ofyneh33zQVr3S
	 Ym5uKWLyQxUt95545UcgBx0YYpCLNQ+b5FXYZF1h+gj+B7Ezj9CsSh0xz1Yo78ZqJU
	 ziCPTh6SJGjvINHAHWkuPrtlm/c6HkpD77bErkyncJcWvoUZJ8eomkauSJEiUpfm+G
	 GXUHpsuoMxo042YuZ6DMIr3eNCMkzg2mE6gvQP+WPsSqpj72SmgO8YQ2dvmeezzjrh
	 9tnuvKqXIeruQ==
To: Alexander Koskovich <akoskovich@pm.me>
Cc: Manivannan Sadhasivam <mani@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  Abel Vesa <abel.vesa@oss.qualcomm.com>,  Konrad Dybcio
 <konrad.dybcio@oss.qualcomm.com>,  Luca Weiss <luca.weiss@fairphone.com>,
  Bjorn Andersson <andersson@kernel.org>,  Dmitry Baryshkov
 <dmitry.baryshkov@oss.qualcomm.com>,  linux-arm-msm@vger.kernel.org,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: Power down UFS during system suspend
 on Milos
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261005-milos-ufs-suspend-v1-1-a6f8b89d5b63@pm.me>
Message-ID: <yq1mrs37q19.fsf@mail.kernel.org>
References: <20261005-milos-ufs-suspend-v1-1-a6f8b89d5b63@pm.me>
Date: Fri, 23 Oct 2026 23:09:52 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Alexander,

> On Milos the UFS PHY GDSC is turned off on every system suspend and
> the PHY loses its register state, so exiting hibern8 on resume fails:

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
