Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA9231A7F9
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 09:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767607005; cv=none; b=tipV0ZI7fR8W3jpezGlDpQQtrmNgIOX1D5dsF1zTSBs976mrniXlwj1z3/RA2/UjEs/KI/hv+Ky2cUQ5gvaJGJrph4gV3rHvkZB8VRsEmX3qsxg+kfdnZL65+0c/8DxuuNw2QYSwzIzra3YMwgT8Ij8ka2VoLlEa7RQGYprZ4iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767607005; c=relaxed/simple;
	bh=rZjxh3Wn02nv4g7CmE1kHurLp+PnR9Cdm3kl7iMoZIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/hH+nTFovh+6LWoK+ogjQiY3BZnTi5HjiQXzC4HAxfPVKvFRTccqrwVd38Yxpt45xnqbvMx5VO4vCdqG4sp1Ch3V2P2NJWLAQiARfUfG2JD+FbrSX0Uyh1si4AkQcXkPTPUrcvS0WEIM9DBC+dvZo6Lod6QbBSAkWA8xeFqAMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q5GZi9u1; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q5GZi9u1"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47d493a9b96so33657315e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 01:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767607001; x=1768211801; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oOISiHTmhQg6YjQ+FlgDDwgNgRtf5e53JrcB1Lnx1LM=;
        b=Q5GZi9u1NTbytX6+lD4pFyA3XY5JQHRFiygkKhZCxVx5iLohONIoFl5Csf+DgHoX4f
         3F0EdwtEWJI+ZDP4Ca6u4pqHnyHOm1FOSeCH+zT1bNVEsGx4AsQRb6VLwJlYqowFTssl
         SAF3hHa456UuM7UhsnXfZRYbJkfZrCI9NDUsn+zz7pir1YqHDPaFjlCDqbHaEy6bmyY2
         dEnk8+/V/l30ns8uSTT77eXlt1V8gXfmhqPYiRMeVGoMl++9gbda7Q1fkTVa0YrpomdB
         bA88n13+1djQzeg3qL93R678GFpeiRKLWmx4JfYhjmN89iIQ0Uh1hespVoCyt7BdpN9t
         8DhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767607001; x=1768211801;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oOISiHTmhQg6YjQ+FlgDDwgNgRtf5e53JrcB1Lnx1LM=;
        b=rMWjbj/IjRuUzjNYwU89duigQyPeL2wUAV79eRePtGHmofHYGNDuA1lSW9Qggalsfg
         uZfKQciy0C78uCe5j6Fx0JgWTxppDOGkTHTPQPZPR9eBkVIz2Bwc+RgN+qUyotQWXyB6
         n7223GcgcIZd2Fv0nBE3NgTxhgemsEThiXgIMBRJjtEY+9Dk0dUZNRvLmITB0y2+gjz4
         a7l7QXlctzTdyRhZuXA1IYuwWvAB5jWFcWbqSVv09XoLAmuOS3E1lP4Zbe6mm7DYhDZX
         Ck0RqzoxI2W+6esAORpiFeadvK1Lbomnk+GWMT3UOPV6EPVCQDfJDJTuI8dTfXqQ1ilq
         17uw==
X-Forwarded-Encrypted: i=1; AJvYcCUonkBrdtL6nOgZfb2Pu9qN3xEinohIpNt3a9wCbadBbOtcCa3cu+9abn0eeOVJBrULbZ27GISfeHXK@vger.kernel.org
X-Gm-Message-State: AOJu0YyDpe5SVX5GaV0NxlQQZv8CsyvcEv+lRgWN8mqsqG5Aou0aRmLo
	pgCWSoqpbqwsflGYgNcvs0VF8zO26BgK0b2lLgbt+76uDj7lMyLxbGQ5DEqozMAwDgs=
X-Gm-Gg: AY/fxX5LIuBNrMOHnJbNHBZHSg4iBpyJLpyp+lZMMKpnRb0RqWvyduaz9PtBjNnmN5X
	f2djCEZbGKvJatQWmQr/Mt2PwgWYDKag9/a0M46XINDGoBybeGGgl5xhuF8eTcn8rpFOkBOCIAv
	Uk3R+FqJfFhkYjyKyXPYHUFqyXHJKXb76FYnaX+QNVF8GO2vVlpmrpoIsv0R8FERx8WS7n9GnTE
	hEwPho4y98YHgFB5sP+icspmhN0wqIVtVvSzXmSRqtOyLkQyEv+uLXD/Luwa6qRg+VesJkE1SqG
	9TdVWeCfcc74YtOrQ0zpcXstSaA7cXxh8SY+Ma+slFN2XUg8keN0/r2raNTA6u0TRNH2cn9jBP5
	hJiz/gyQ2Pjkl+kGPYrEj35eBYDCQXUBj1QRMd1zoCJtaKTCM2Z7p0NihIvOEn7ahuk6MBqXWWa
	nPkFNgFwyxoVtH+iK9
X-Google-Smtp-Source: AGHT+IGCdMdctOj67IdQ9CQDuqYApAbTRscmm+Wg2KRDyrwDuJL73vJJVTl9kBYGs8DcfBnVfAGLMw==
X-Received: by 2002:a05:600c:8819:b0:471:1765:839c with SMTP id 5b1f17b1804b1-47d1957b7aamr524632785e9.20.1767607001222;
        Mon, 05 Jan 2026 01:56:41 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d13e2e0sm175667185e9.1.2026.01.05.01.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:56:40 -0800 (PST)
Date: Mon, 5 Jan 2026 12:56:38 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Justin Tee <justintee8345@gmail.com>
Cc: Zilin Guan <zilin@seu.edu.cn>, justin.tee@broadcom.com,
	paul.ely@broadcom.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
Subject: Re: [PATCH 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
Message-ID: <aVuK1oAoM1smyG8_@stanley.mountain>
References: <20251229071515.155412-1-zilin@seu.edu.cn>
 <CABPRKS8=__+4TcW9wjzHuVSZa7wKhJpzT4VGubBHet4TSc-u7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPRKS8=__+4TcW9wjzHuVSZa7wKhJpzT4VGubBHet4TSc-u7w@mail.gmail.com>

On Mon, Dec 29, 2025 at 06:04:01PM -0800, Justin Tee wrote:
> Hi Zilin,
> 
> For this patch set, please see and attend to Markus’ comments.

You should provide a link to lore because a lot of people have blocked
Markus so we don't see it in our inboxes.

regards,
dan carpenter

