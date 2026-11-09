Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794194530;
	b=4Gvn0OQS1u1SfqptSrSZ+cX793UbLNWse/sl63q3euK7LgjgjSnRZ7T9ic7uF9V9sOEj
	 ZRmtNwogcaweyL8hANrTaCQPyyouinmY1wPXjZ9T+77tvhEXeT38lCObpnkihpkxByfdp
	 lofunbrWobJlz7EZVGt3/4eKY2rGWLoU8NQ00M5Xtger5G1mWtTt7noOapmgq1SfCEUhF
	 3oXNiYlS8uO8sRZ0fbpake4a0AE+KN/jEgEB6gy933clefBF4UZT/qmMbWd5+2VL+lb7W
	 yZw91kiHqfGe+fY8OsofDNF10oLmbBUq9TucW+UOItEQp54+o2PWPLlgKRAXXNiHQLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194530;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=vx8mcj44AHPyE5HDW+MoYkGD0cJb0NuGEUOkrkQvwv0=;
	b=2nDH/KIEBq/QNKmC9d6I2+JkjEPNLvFjVCKElnaxqRfP+mM2RV7Q6Ali0Jduae9Hjrg6
	 ZhlYuajl46KHT5iA8ztQIq7gKgu+AwREmN4RggKxrn9YxrwRnaheVlUH1SRpZcfhtiEGq
	 lNOFClfAiidhruknmPGxIf3Xoluwb9ALzrkTc+YtLWWuxOq2OgXQBmHclgNA2Vh+0PvCm
	 Eo7Y2rX39JxAgjM3KcP9OP9tRCTcN2Hg7/Zy7uFrfpfMxKQ9atyr/+eR0M7JYtMX/lfzD
	 sTqfEzpqqXQrLYgyVKK8cxSYMXXJDDZMTd8lcmZqIfRBgIKPOHx9YIe2mEQsrrliBDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FE75y4XA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAB2606A31C;
	Mon,  9 Nov 2026 03:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FE75y4XA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8BB1F0089F;
	Mon,  9 Nov 2026 03:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794194529;
	bh=vx8mcj44AHPyE5HDW+MoYkGD0cJb0NuGEUOkrkQvwv0=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=FE75y4XANq1WfpibV9hi2rolt0AkjQXsh32u4TnDU6p7eTQaRGwJG3DCmjyHpwRdj
	 o3jzG+x8i6FFCHPQ6nSjQx0gBG8zQ00qD43X5xf6J7805Jgm3mvQZTNrLK2IZLsf9y
	 y17HHqupW2qo7PVKvwa/FZ9U3MUUkQWPwV4xz6sTi050JMFbeetaUZj90D6wyvYRRT
	 X2OufbibXrvcFBk1l4deSEzX13JsWelDXSrO5myFyZEwK1MVs7/0OmmqM5KJ4pnQOG
	 NNeqTovr7R9DFdd5TCa1veMiaHi9OgJAUIqGKzUThAsatJ3Gy9Ff0vmScRsnRA2iRE
	 TOGql5Opjg/Ug==
To: <shao.mingyin@zte.com.cn>
Cc: <mkp@kernel.org>,  <james.bottomley@hansenpartnership.com>,
  <linux-scsi@vger.kernel.org>,  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: scsi_transport_fc: reject truncated FPIN payloads
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261031222243820vSs-SXTIpNSHpWeC2dJ38@zte.com.cn>
Message-ID: <yq1fqxawuy8.fsf@mail.kernel.org>
References: <20261031222243820vSs-SXTIpNSHpWeC2dJ38@zte.com.cn>
Date: Sun, 08 Nov 2026 22:22:08 -0500
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


> fc_host_fpin_rcv() computes the length of the TLV area as
>
> 	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
>
> without checking that the payload is at least as large as the fixed
> FC-ELS header.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
