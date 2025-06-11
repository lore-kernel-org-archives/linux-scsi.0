Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB07380
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749667466; cv=none; b=TOSgbJO4+H/0IZdHx2y++HwAKpU6TaBk+nTWWtSvL39dU/6FpkpbDf0lGTXEJLm+9+jdBjUU0ZswrFosjQG5axcgEihpOupmLfymfm2lyAzeV65mARgcuQN5oZUeGyksCwYan1bg3fzkmVIfBqQil+IFoD1QSSI6GI2NwNyhQeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749667466; c=relaxed/simple;
	bh=rW9AYnao7epI6DSNNsNbXeG46uk1hDnvTmVoKXHljtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNViUKyV8s58yYg5cHE/I4E15P0QXLseolk6J1JxqL9fFCGfQnf5bNixTs3B8pcA/1QyPIrRLD13DcqTbrAXjsZwd2XybxXmsKYM1H72u0yYNZICPl8mhqWOmwe3lif189fXasBxhscn2mQZinEt8CJnd6F0OKf+2XGu8v4A06s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mfZDiv2f; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mfZDiv2f"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-442e9c00bf4so694065e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 11:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749667463; x=1750272263; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b8Z7wa9sbPXA5dzp8SGUkYWXsK6DxzHA1Tojy5Vy9ow=;
        b=mfZDiv2fFm+ACiWLDuOXvI4+iJQJBIWPo7yKU8UK55o0P+Xd8iven6WI7No0EW91AS
         2FaJc3OxwU6D7sd7wZt2A962Ge77twubdXeBMYTBC87tYVNp+OjmSr9sQnK/K5Ask+gx
         fZon7+vZaIcJFJ07ZOoHbJ12/1ifHsUSHpSX45h6agTn9jDnr+QOiahuwlw36kVGyGeZ
         7WpIAY2z4Wv/+vKPIwHPjTyyOAoPKp7MBpgxQ4x5bA1iXn/y8GkFhAZ088oL5T1xnqPX
         WrfpelGwhWRTVMtPCWiSpVkS1SAiUXFNKRo+aLW0Mc+Xj+ac7B7QeDPA6vn4V3xTTqw3
         6jDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749667463; x=1750272263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8Z7wa9sbPXA5dzp8SGUkYWXsK6DxzHA1Tojy5Vy9ow=;
        b=WijW5+FQh5wdntAWonuJKnWKBVAT8s8Fe4QHZS9kJM3sLuWHy3D1xXpyzKfmNOBeaQ
         SSe5CBDVgwhKD6MSuS6ZlgUXz1Cd05a3lRXDx4onFtaEX9hA3VsypASjf/ZhTeiqp4ZY
         EvPrt/wr1nDLJmCkUVfDQgKljQbeeWvRkDfcN17APY2vXyoYPYT71WPkHuj1q5wehVWW
         /VJxIHZeWgnBim1S8M9DZmvv00OF+YheBNSf1kpU5hdHbCud3wk/ncAlHU+Ts/Gfj9BD
         Rz0ZrVN7/f9nIjbHR9pc55fL7uCtUgufXpEx6lfNUCiiF3uxZbOmB8m0+Y1PnAuNmlzb
         OzLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYUQtwyi9cajaEVO74GSfH/ge0ZRi9lyhWYApPkxRunZEOF/LABSXdMj3MNPVdXvhFFhllJswqQ+Rn@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9pdFyY7+x1S6TWaMywD5Dp8YOgAkHK/FidHYHYpp1NhkgKnxY
	jfRr7/i4UHQqnNYrnBSavBaFMPBC954CQqyaYLu2f/Jwt0uTPhfCUodf3inZU6Kibdc=
X-Gm-Gg: ASbGncs8VpQu5VN8w15l6/NYxvmihTXTH4SbHn8VOgpv37+O6f/cmwvynBJC0Iask7k
	6ajZWZ1NLytzzMWy88Zkr+jHc+F33L8W2QSZAquO3fJ/kQZJoDNikTvwfSdtZme7pt2ZkuEOek5
	1BO83P3KTiNm00/UlTBZvVYZT8vC3OUtGxj0c0lgbt5bni7OSweLw1JMEn16EvAMWngT53W+xAd
	yMOg+8/iQfFp+iOINZI94GR7yZyfut5k3AdRbK2dOAH31518idDXR7yICifV4Gkmq+wRe1r2YRR
	owMhDbQTLUssiWJ1BoDVpyIggv2wwUl35ITeGjiNJogVH7nXA8DTeKzocU+bZw+1fCc=
X-Google-Smtp-Source: AGHT+IFG5n+JZ+POBoHmw+qc3E80yBwZHeBiwkYm45+ICWtt0Wje2BpvjDKUU1DHUI4PN2DGbGjVOw==
X-Received: by 2002:a05:600c:8b26:b0:450:d367:c385 with SMTP id 5b1f17b1804b1-4532b9079cdmr10409495e9.16.1749667462950;
        Wed, 11 Jun 2025 11:44:22 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4532513e27fsm29150025e9.1.2025.06.11.11.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 11:44:22 -0700 (PDT)
Date: Wed, 11 Jun 2025 21:44:19 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com, revers@redhat.com
Subject: Re: [PATCH 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Message-ID: <aEnOg5B0tYOQIuME@stanley.mountain>
References: <20250611183033.4205-1-kartilak@cisco.com>
 <20250611183033.4205-4-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611183033.4205-4-kartilak@cisco.com>

On Wed, Jun 11, 2025 at 11:30:32AM -0700, Karan Tilak Kumar wrote:
> When the link goes down and comes up, FDMI requests are not sent out
> anymore.
> Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Arun Easi <aeasi@cisco.com>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---

Fixes tag etc.

regards,
dan carpenter

