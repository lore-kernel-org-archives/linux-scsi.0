Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458FF39FD4
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 00:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778407; cv=none; b=acJFL/bzjLBxkUGinXIyslqO8NPe28BzPXHQkofHjPbzReu0wSiSdeM2C7r3DqxPMqtJkEbnb+9GyVOSr44lFMQckQafbUtb3cQyzx+xq7RUJ8EMJzv/A6GctL/hf31u5nTZw9H+MebI4KmbBu2j9tHw3VVpTc3+qQDh+L0zZNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778407; c=relaxed/simple;
	bh=YzT6k0EGsst81hJuYFKjei7Dd3McRdeNasg42zktoT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4GQfyDZzgbx5w8oj40MMHY2AVmGzixoZv//IF+JWPYB8hxMbg+EMgpXOBMte20+6LkaEkiIv5CY/lcMCw+EsMeqyyeUQ/hzD1lyHI4sqSQI2SkK7vsIU9dKKQwp3McSyZ4n1OqF2CHRu9oK2lWaI1TIWrPU1Q7KdLzq1vqEa1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBZX1ppd; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBZX1ppd"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493b5d61302so279895e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 17:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782778405; x=1783383205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YzT6k0EGsst81hJuYFKjei7Dd3McRdeNasg42zktoT4=;
        b=VBZX1ppdv1Ch/ePVpn7n5kNNoV11fHwxBiIONMkZIpExZTIwcziaxr2qW/rWiZJd+5
         ImqUhRBxhLY6mfx3nxdG7JpLFhpPJ/hnOJ1BcCddLnx/J/S4wMwp1zlkPY/fQvEzeME4
         fB7HGSJKskBQYwNWqgUwahQp4czV5xd2uyP7EDV4/MkFUpouDxwsMYhXM+jGE89hlU4X
         2uHlsGi2ElLPMzyP24jogZXU/9/V8rd5iVkghd27DKPZA+G/jxEyFj+Cs6cje3mGSdJD
         aequTOK9d0obhsrbaWrrEYEhAfnur8ClLYBZQy1509a2+M9FJNdfXg0qB+kVT26l8DqQ
         QJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782778405; x=1783383205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzT6k0EGsst81hJuYFKjei7Dd3McRdeNasg42zktoT4=;
        b=HVDNepBpUP2pQZO/z99/KuJTcnKSry0SmmgRVq+milvCkp4p7o+dihTg+LC7B4jWjz
         wh4cWxeNeD1Nd1rk/tDyiHxZkgFLAF9uWQ8+Ous+gA8hvZZy8xmYLjAz9PduAdGVhmWh
         jxMuTb8zWvAvKh7j3J0SeIANQpmyIHILWv5Pdm53Zkt/hEdRGH8DNI3OXt5kpbM0emDy
         Q+EWghBbLq3A6QMPzkO0UWSiYdeaX5vNcuZo0DNHCWjf13z8Q+YJdwDanPBp0l4G2VLT
         Q+TDy0SCIc/e3LNqUiWjrsfUXpygaeGUrROIO8SVlzPFrPxiH84tqCX6nY51aaAKG0uT
         b1cA==
X-Forwarded-Encrypted: i=1; AFNElJ/S4EAwbQtCYluC+QkYsV1JYRmZvNNgthrLRgTp2MON6oIEQERW7SxxmWG19C6ppHkbkaT6tZIBV3Fy@vger.kernel.org
X-Gm-Message-State: AOJu0YzY5Xy4jObx+xnV456JjBjlDMClwJ8kdEHxP7zGiaBbJ4F5OFqu
	ZjXi6vshXcJyhF7wRw+JKI+gWtuh3sG5dN3KpWL7YdPhAMAsuZ0mcKM9
X-Gm-Gg: AfdE7cnQSH/Q6ApWWLCwg6dzTt6Fay8mnObgkc4W0UktDJrdF12L8S7UamywHFJp5OD
	aQMgAXPg1X0WSyH+bDWV0k/qkm0LsuvV6pWPic+vatd+3lEc63QMQebuDz/NeZUGz4+al+CywlB
	gyMvwnpFjBdXiHfnO+CBK+irSvoxc9IHRnJnabl7Qt1OqTYo5p2MllskA29SbKDMKV90zxHuxzP
	2luySdpl71d4aPG+01Dd9uAN1B6z4JEn3GotzGew0ul0YYabYChMtDJDqhb5ei5wZSsjjbSF1nW
	kdC/w59p6xaPVAtYPA35H3h6JpqxjmGPnUdowKH9zlFdC7OKCEKaYtHetjIJJgEdxVI/13LyYdw
	w+xiyfKI9hSOzG4n/H+Dx2rl98HkxGHRlz7db1YLpZwqJ+NoCDPG+5c6zEw7K/nj+NDZJnrfw
X-Received: by 2002:a05:600c:3485:b0:490:af63:2cb1 with SMTP id 5b1f17b1804b1-493b8d1bd68mr13488525e9.7.1782778404375;
        Mon, 29 Jun 2026 17:13:24 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b8ccc7casm25222505e9.1.2026.06.29.17.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 17:13:23 -0700 (PDT)
Date: Tue, 30 Jun 2026 02:13:22 +0200
From: Louis Sautier <sautier.louis@gmail.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
Message-ID: <akMKIk8JN8REuYVB@localhost>
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-3-sautier.louis@gmail.com>
 <93542109-2101-4d62-aae4-bbf058029663@kernel.org>
 <airk3Os03wPV0rvW@localhost>
 <fdea1a8b-d631-43d8-bcf0-1c79e635782c@kernel.org>
 <ajkaf0aa0TWXdRZW@localhost>
 <841e8ff7-12db-4ca4-aaa5-fb8accfc9df0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <841e8ff7-12db-4ca4-aaa5-fb8accfc9df0@kernel.org>

On Mon, 22 Jun 2026 20:28:48 +0900, Damien Le Moal wrote:
> I saw only patch 1/2... I was waiting for the new version of the full series.

Hi again Damien,

The whole series is there, including 2/2. I sent it all on June 13:
https://lore.kernel.org/linux-hwmon/20260613023833.3163507-3-sautier.louis@gmail.com/
