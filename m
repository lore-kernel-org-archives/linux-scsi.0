Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED1D257447
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2025 07:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742802093; cv=none; b=TH6obbmvinAcjj9MKJ5VnA1ZnjN+k8RJf1HW7o4YaFAgQKvgnYb600JDfhk3agx00ojTSMxSj2qyBb0VP78Y61wgQkDaElDxZKtpkaic2yUlytZuhoks6XNib0ThRzuDd9mub/4+SNEMxyAKxRGK42LyRWqVwVMunb2dXAksQlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742802093; c=relaxed/simple;
	bh=t9LuTuSgB7oSIWQS+74CbsdvDwfuBsZQt9ORVAh6Xmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBybfZLDNtjnxbLGz+RrQtqYTQFAsVexeN+EF8Cuw7KmVdJoQSTUAW3ksmy7zjGYf1MWH9/QTbhI0qvqU8I31y8w4Npz9/MTTQ29B6g4BljAzMPkMjrLJ3aVe8EgJ/p+Em+YvguLf6UVsNjVoTS5PhR2L7ejqoE3UvP41UHBpr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F7pw4lje; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F7pw4lje"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff4a4f901fso7296780a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2025 00:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742802091; x=1743406891; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=txguX40hwxFqsph9jZ0ZY6Gsn7G7EapqsYPb05Nyq5Q=;
        b=F7pw4ljeuoQHAhhfW6A0Ut4AXy7WNI0IRZlxxyOs+Aqwwp+eLM7KVwGO2tzE/wB9IZ
         nkibdzZKhyMB2tb1NC+BKu+f38ZhpFEl2buos21qw0j+68oPv1Ngpp9LVoientd/7gYr
         vl2q4Hu0e95GOdav1BKGKZLRqZ5Vyif4OHfxR5XsmtpxPL3Aqi+tXbEuT+w6eEWfO6cX
         qv55CEd2nJOzeDmh3F+qXvyPEmeHm2GVwPrW/DsY3Z5QNPqMX9M2VRREPdbNRr06HzVZ
         5NaAesqh7ht9bs/DjehM5Cue7H1MYOlt/cq+t5vlSUy5yBD/ltqb7pQ9O52+yMSnwqF1
         QVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742802091; x=1743406891;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txguX40hwxFqsph9jZ0ZY6Gsn7G7EapqsYPb05Nyq5Q=;
        b=bgFRM19blbXEy5JiwfJoNc5LXtAdKkrFWvhllLiKJCo9cuuRvvkolUMVWTjbME2DMg
         K/gemeNDA/W2mXhRuenqhTDTuHKrtWyAI+eEftOC45yt4nAQorbxJb9xOrg3+NJzOXyr
         deF3XOTHMFAKmxYhvcwvdKN84TqBN0G2w0QqzJSt4+/SeZ+lupozq6C5z9saK74FEDvz
         Z7bIXRn/Hy2voms+7HPl92gURtH28IV7KHjblbFtYOniNq3vg7e2o4OyCodoqzvGmaMK
         G6Ce6JtZ+0DyMFLmx8ELmPgUHhRXJS65REokWDTKGCcyxlDncsbP/8cP/g+C/b4hDTS2
         6aIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV4N5DtLwwTjYtYLtAs3PbvbRFjAbLVKFOsXpOv7U4k2r9ZoUzRICOP/1nL9UdKcpF+hUZF9UI+76y@vger.kernel.org
X-Gm-Message-State: AOJu0YzgvNXkAYN7puYAH78sN+Z5ilkiqk0GMorCdUTc2N8dK1tctUs4
	u+p5MFX7V/A4qc4pFMFz5sK4mHwkigiz5ZvVYsh6Cu4bMMVmpWYWVdRXh+Ycfw==
X-Gm-Gg: ASbGnctn/c4L50YbzXBrTOxIE4ik3HSeXTy/UaUViY+2rPUslQVEwa0Vf/91rk409Yx
	eTwJenwHiKNaS4hlDXxp4xUN58rtlKAaEki0suvQueAXvUJOoY9RX1SdvOxSW2+qkcRoHjVLJZM
	N3N1dOR/VXgkdMGjkOBMjIcAjhVJRJGuVLFumjShxbztDHkUNkaTlMTd6pupKzumcYHtcdtTyvg
	IJmgQDZOuoAkHBvnqgpZoO0z4ZT5Xv94g/FDiZpNC+Ic9zmtCHTtr92WIpvDDSz9prKAm5mUPHO
	1MaqZIG6POnK917fSW0oIM9DbzbEJG+zIKrowLY2Fma31IMYwyfU39XO
X-Google-Smtp-Source: AGHT+IEaSKdVHKBTcyVQUTB8pbjahi6HmIfbAfkDhwtDzh9LW/kbNeuedlIsscVIJH8s5eGwIkSKBQ==
X-Received: by 2002:a17:90a:e70d:b0:2ff:698d:ef7c with SMTP id 98e67ed59e1d1-3030ff230b5mr19236244a91.29.1742802091423;
        Mon, 24 Mar 2025 00:41:31 -0700 (PDT)
Received: from thinkpad ([220.158.156.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf61b34dsm11460804a91.30.2025.03.24.00.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 00:41:30 -0700 (PDT)
Date: Mon, 24 Mar 2025 13:11:26 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com, quic_cang@quicinc.com, 
	quic_nguyenb@quicinc.com
Subject: Re: [PATCH V4 0/3] scsi: ufs-qcom: Enable Hibern8, MCQ, and Testbus
 registers Dump
Message-ID: <icdzzhtobv6i3pporxca3bf4j3stomni756vuonekdmne2uk4i@wfkk7egdajy5>
References: <20250319063043.15236-1-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250319063043.15236-1-quic_mapa@quicinc.com>

On Wed, Mar 19, 2025 at 12:00:40PM +0530, Manish Pandey wrote:
> Adding support to enhance the debugging capabilities of the Qualcomm UFS
> Host Controller, including HW and SW Hibern8 counts, MCQ registers, and
> testbus registers dump.

Why are you sending next version without concluding the comments from previous
one? This is not going to help and just adds revisions churn.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
