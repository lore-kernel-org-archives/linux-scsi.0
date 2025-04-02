Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8428231A4D;
	Wed,  2 Apr 2025 08:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743583395; cv=none; b=ZCZDaHc9OYOxuZYuAi+d8Jz2WqMFZRjlv8+r6YmM0OJVxL4bISV+djpaVEp1dODILCLY6keMx5Oqz+M3wawoiAbdT6Ya8Armi3PpQyhbyzRRNZ97dHULcddgzFcu7+OyY4e7XwPudciH7wln94RmGzBx6LEvFJtyXx24+0uWo6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743583395; c=relaxed/simple;
	bh=z0s0q1o8XBTtQ1gx76sVhC4z1BhrlJUoq2EMeF1Nm20=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sQLGAn0huEZr2wBSk0DRT2648EhRz2msP4H0xAQm/HafH3yNw4W6P3gNPAzdHOU11jTx2MDY7W9L3mSMy5Rjw04heRue34e2wiwYjobc5WdjJQcLyT4yirJTPxK2d1qBZu8QSgR5ZoyQ0BKQJDUaUz4iPVvoxeqK/eS5TPGzOv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5C5a60h; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5C5a60h"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso1038883266b.3;
        Wed, 02 Apr 2025 01:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743583392; x=1744188192; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z0s0q1o8XBTtQ1gx76sVhC4z1BhrlJUoq2EMeF1Nm20=;
        b=m5C5a60hJ79TV+wuJu1pnYCJV+zh5XLDhTt9oXzeQK9tzn/GbkX84vRsMrqFzSVDME
         JP88hVCGhgj2ALWKgIsZwer5TdTggy48Tj2S1oXS+hOSCyUGZA5BedsG0VFqbt1B0yTw
         KsjosswtmX29bKaxE892vyTKUfm5hOVcViB9blgrYkqGvQWaMkrS4efYQ9EXPFtO+RrV
         6pO9BmhLDD1dMH8piaVvHtVRX0amuoG0LPwqPeWYVtdSE79/puFlm0aS9dUjJsxEMQVX
         KLvFCQvMkT5AhzfEMqR53rq17CRgZkBnEQuyi1kS4qEDA8/sXg2RID1FHmp29BqxzdkK
         YXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743583392; x=1744188192;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z0s0q1o8XBTtQ1gx76sVhC4z1BhrlJUoq2EMeF1Nm20=;
        b=owkKpjyS8XvwDDq1p6BZ8DNXDRELeS8OG6OeVOz6QNZpJdklEsQgLx9mr44LCth0Ax
         F92vENccbr43k8OXOxJgGxf+5rYgXiNW1CNDQuFi22VAvKkdGlNQoOV3nmv6sg68/8ub
         0ySFu8tGIHDsSFN4mopVGZAk20DpIdQ0286Cu2j3SqDijmSUUcrOShiRR50k2p3iP0OX
         MKs4FE9TnRcxWLwUQsNAIgObhJVHn+cEc7F4gQ/Q7tuuRDzRHbastQ2vG02lM7rBIhnU
         A7dNzOvcIpXo/IejvGO8pIjEgc51pQrivAMCb+U6Z2yBpSnLJCul7fgYxxlhG6WYa3lc
         gCSg==
X-Forwarded-Encrypted: i=1; AJvYcCUsBukMt9yqnar0BWFVqpqj1jojP9WWrJdNU7xR5AHOtmBfTYib2GWPW4QIGNV5d2FJa8nHYw+UeH2kra0=@vger.kernel.org, AJvYcCVEr8fF8Q2yXluoMSwf0O0ehYfym09o7UzHTy4VFA45VjClSh7ZmHSXrVnAQPoG/mcQWKn0xDl5gkF3TA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqHqg2Qpywe137irHP6pLv+ucGy6+bJCr8ZL2DMz/9NgfNCmxQ
	zQHuUZkiXjeTtf5U+rRTb3/JRljOdbqlc8CDhz1YS1QMBpw16Be8
X-Gm-Gg: ASbGncuOLMY0cVV35YrnJmC3CcvN5vKOUQxdPLiddFsMs7NS5L6iqLpeDZPEw137WUB
	qyan1EplVHm3lNAANyWUvOfkfcNFoN3lLykGL0lPO2uBP1c7tMjdootMcEqwrwAapM0WtbJ7Wc3
	SJYh7iVkspyXjHHfyh4obnCfiwWAGJb/0sd8cTdrh25G0ZFqh5LaQW92Ib3UnXnOiPGAEHen5JV
	IgL/dEZ94JcOjsJTKXN2ZkQXhz/TrzTnFrDvSxanBXco9x2YvzCr9KKx+g9WYx4ZyhczcfUxlZJ
	irMRVDYGUruRiFFj4gB0iAvmodnYLhLKVM5zXg+qVXMjjeg=
X-Google-Smtp-Source: AGHT+IFxMlcQMnVfYx9tq0G35jrvwe8KRLDT9YbeLD+Z15SzpzuOccTl2iw/As8mgwf751M0fMDKKQ==
X-Received: by 2002:a17:907:2d25:b0:ac2:a447:770b with SMTP id a640c23a62f3a-ac7a16c311fmr147758466b.21.1743583391928;
        Wed, 02 Apr 2025 01:43:11 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16ef7b2sm8609700a12.40.2025.04.02.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 01:43:11 -0700 (PDT)
Message-ID: <5e067f1eecb2098c9c2368dc8a2005c1567198b0.camel@gmail.com>
Subject: Re: [PATCH v8] ufs: core: Add WB buffer resize support
From: Bean Huo <huobean@gmail.com>
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com,  bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 beanhuo@micron.com, luhongfei@vivo.com,  quic_cang@quicinc.com,
 keosung.park@samsung.com, viro@zeniv.linux.org.uk, 
 quic_mnaresh@quicinc.com, peter.wang@mediatek.com, 
 manivannan.sadhasivam@linaro.org, quic_nguyenb@quicinc.com,
 linux@weissschuh.net,  ebiggers@google.com, minwoo.im@samsung.com,
 linux-kernel@vger.kernel.org,  linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com
Date: Wed, 02 Apr 2025 10:43:09 +0200
In-Reply-To: <20250402075710.224-1-tanghuan@vivo.com>
References: <20250402075710.224-1-tanghuan@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDE1OjU3ICswODAwLCBIdWFuIFRhbmcgd3JvdGU6Cj4gK3N0
YXRpYyBjb25zdCBjaGFyICp1ZnNfd2JfcmVzaXplX3N0YXR1c190b19zdHJpbmcoZW51bQo+IHdi
X3Jlc2l6ZV9zdGF0dXMgc3RhdHVzKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgc3dpdGNoIChzdGF0
dXMpIHsKPiArwqDCoMKgwqDCoMKgwqBjYXNlIFdCX1JFU0laRV9TVEFUVVNfSURMRToKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuICJpZGxlIjsKPiArwqDCoMKgwqDCoMKg
wqBjYXNlIFdCX1JFU0laRV9TVEFUVVNfSU5fUFJPR1JFU1M6Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybiAiaW5fcHJvZ3Jlc3MiOwo+ICvCoMKgwqDCoMKgwqDCoGNhc2Ug
V0JfUkVTSVpFX1NUQVRVU19DT01QTEVURV9TVUNDRVNTOgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gImNvbXBsZXRlX3N1Y2Nlc3MiOwo+ICvCoMKgwqDCoMKgwqDCoGNh
c2UgV0JfUkVTSVpFX1NUQVRVU19HRU5FUkFMX0ZBSUw6Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiAiZ2VybmVyYWxfZmFpbCI7CgoKVHlwbzogImdlcm5lcmFsX2ZhaWwi
ICAtLT4gZ2VuZXJhbF9mYWlsCg==

