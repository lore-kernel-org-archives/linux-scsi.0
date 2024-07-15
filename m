Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E516F199A2;
	Mon, 15 Jul 2024 09:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721036230; cv=none; b=XQwyiepnLnKnlQJ/G2IsQkHrj7Zf1GKAChalfp5nXAqXqcNThyyMlG+oVryXlrdby6oPNPlTkdJNDSjemnjgYDA/1gSbWgUmTfmkE4KJpsJIcZsxqBO0tuvaP8XA9rGGXM7Dc+B5LjO0KsNxBwku2WNefuWpqn2So6OsfZRAjF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721036230; c=relaxed/simple;
	bh=HlxvjKSw37Exxqwv0WvuuxqcpniDdZENVsSWO+JV4Ms=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HSQqn65l7xZGPDwfXd/g9nm4ZcyGy95+Af6crBCByKmszooJiWMf6VroZfMWyVNkcPE3SMYahvxxPwUluCsNnOIsrPwhGbmYdCtwHmyP6IIM9mLD2Sj4M3kNvGaiV1zuM37/WiOy2YXdKaUAKVEhyOP1wb+hpIwq9Ij4K8EshB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqH4d4g5; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqH4d4g5"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58b447c5112so5461812a12.3;
        Mon, 15 Jul 2024 02:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721036227; x=1721641027; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HlxvjKSw37Exxqwv0WvuuxqcpniDdZENVsSWO+JV4Ms=;
        b=DqH4d4g5z9XMQGBsP+5olfNMHHcCtZwYR0zO+niEHw/F6VVDb1KeeFgDI+rUUgjtQk
         TN+XaeiNlsHGi0g6MF0qRId825yWBj1lDjqTMV179uZQlQk4oaQYSuy9Eg1JLXsuis8s
         yD5x/wX7gdmK3DybToizq9433TITXmNvt7y0HOIlkOvH9eo1nDUQ7DHxRKkigeS6ZxKR
         fZsWUTOcTC6lQ2OoQTLRQyy7g7dqIA9jeTGAG0Fz4FBx8ma7bjt2gIVNCYoIMZFJojUM
         3WykHTC018DtaSheV7484LsfLTO7FWod0IQG0YwZ5Mp8xDV7saTcJVBNbQvgla2Zm+0g
         aCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721036227; x=1721641027;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HlxvjKSw37Exxqwv0WvuuxqcpniDdZENVsSWO+JV4Ms=;
        b=YZJLv+kmSulIw+FnoJKv+VR9oO2bqNw4zS7BF54Bfy8j+VtZ6+4zwBaQiaWoUhfwVW
         mJNns7bVzNv+rJyutUc1OuaFb7X+Base4huepaJ+CHi5qn16IUI3KK8myP2BpO+0JquU
         v6CkXBsNv7uA1AIP2yn3dLm/REUk39JeTCt/YhKNTSSNCx+0SoK+uI9q320Ou7dJBCJK
         Zcpt5inMu2dtWYep7r16hTrEvXB6O7RmFT+LN64CyAYGP1jh37E9aEIqhNyAKYZP4/si
         BswrkYJVfM3H7dMLTygrP8CwTG0gG72Mr37HQdYSuHWDC8iLuVUjMFjE8aN1oix5FuVc
         01HA==
X-Forwarded-Encrypted: i=1; AJvYcCWaKE8KS1MXiKPy8qdQBE8PD1pXZfTHvf6CuWlC/0ANASmY2KfGmlDkooaTXgXhR2BNxidpl+9XzRaHUIR5cJ1STyLHBrkUAW6+AnAJzqGfWmhTq3p3HfT3p0Nka5G+lHbZBQ==
X-Gm-Message-State: AOJu0Yzo2L4x8O+egUVa6wm8lAXJlPAewHL+cSLDFqBBYfh5eQAq74eX
	A2o3BoulHc698B8hZzuBwLzbbdoXrnOTwUQLXUmcoAKyVa7ZZ/El
X-Google-Smtp-Source: AGHT+IEOrWpmly9UTC7vtn+qdLIa1iu+1Yk5P6cQKfgejLAj0rOHvN9wAOhDaWPYh7GNC7BHfEEyuQ==
X-Received: by 2002:a17:906:fa08:b0:a72:b811:4d43 with SMTP id a640c23a62f3a-a780b883462mr1076718966b.59.1721036226951;
        Mon, 15 Jul 2024 02:37:06 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5d1f57sm196384766b.72.2024.07.15.02.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 02:37:06 -0700 (PDT)
Message-ID: <b547225a0315f1729c07a5d59f0db91c33af8e51.camel@gmail.com>
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
From: Bean Huo <huobean@gmail.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, beanhuo@micron.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 powen.kao@mediatek.com,  qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com,  eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 chu.stanley@gmail.com,  stable@vger.kernel.org
Date: Mon, 15 Jul 2024 11:37:04 +0200
In-Reply-To: <20240715063831.29792-1-peter.wang@mediatek.com>
References: <20240715063831.29792-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-07-15 at 14:38 +0800, peter.wang@mediatek.com wrote:
> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> Cc: <stable@vger.kernel.org> 6.9.x
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

ignore my previous two emails, I saw you have just skipped update, not
skip schedule in this version.

Reviewed-by: Bean Huo <beanhuo@micron.com>
