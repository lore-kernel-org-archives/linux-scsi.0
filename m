Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CB33ACA42
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 19:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779220437; cv=none; b=d9/F2akRfb1W+pVFmzffHpNhvDQoxoL0a8BB3MKtlc1DFbJ+mdU7nGqTGbv/uMjtoJG3q/zo/U3H1sfNm1JKRfKj62fICX9rJ9VLSe4//y85HWlvm4MB5ZvNSkG3cS3QEWme55G2U4w7L79qqjTRugnheBvdR6vPFT8qCCk8CVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779220437; c=relaxed/simple;
	bh=/yTXDUcSInNPHQIymKXgDkqeJ6bUbDCeIiKyGSieagQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=llBYDvds6yFfZ/d4juzf+iZfTwnc9j/5ZhnlVNxRzEoJ1y8gt3gLlBUbIAr4H+bBbXA2HLYbeau5zdhKD6Htpwy9Uy/61d1bp92MC+dwkvokuBs7sDkQWJUuYjyowdOjA/2alkEhisIkCbwxAF2GKNmuZjhBmCOF8hyit9s8/+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUK2cafY; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUK2cafY"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2f0ad52830cso5016182eec.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 12:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779220435; x=1779825235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LBJpoz9+FDWyOZgmi5e6eowXrSWpVTMQLtjKWJI9K/w=;
        b=CUK2cafYarBHtR233nBcJ46qJEPUFZpr+AOUBxHFGSxbnGsdnWl0+yPx0xs+V3KPk+
         uZPg/UfIglkF2sHEMMltqQ7Oa4JlyWMTWmc9aSejgYSdkJ/5fv4EZJNXvhr6VuJfwKC6
         OwrPj3t9kWpDUuP+ZmDmcyILzK9HBkpAovEn2c6KxYc70uQLnLnInDGxRlJTOybm6OQT
         nj4i4MC8Da0j2PxS8VPVWmcqvGzMgATm3g+I+zNXWPBLleufCsHnbp0BmZi+9u7aE0jI
         ijNf/c4qp0/8LYmpzxKGNC7JOPasZoqBxxgdFZyfKXytuulTQ+N/CTWdjYGuvJXqwJ9S
         ifVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779220435; x=1779825235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBJpoz9+FDWyOZgmi5e6eowXrSWpVTMQLtjKWJI9K/w=;
        b=b3neGBoSwgrDBgocYZi028f+XCRNWZEZd8Zc9xS8FktWQroaYUOeN56/ob5gHFkRkJ
         +R6y+oYU2dbsQ0CHOgxr1yLlEN9EPtgPfzdn0MSHLjyYf7U64tNiaxSZs7ysTz4FyuHV
         TkUUDJW0w4hy9h+cfKp7RX/CiKt5D9eE4H5FV7kEjTS79Ne2iShT8RvTmbbRuECKHwGf
         IEEwUOxbW4WXKMEqscYpK90f+hyvSwBYAGpmmhKLBmQTlo+UDefjxNuSvHAkZ1jQYYha
         67r5Ox4yioeb0bTR/GwjSTz40ZuWTnHPZ6pOsyOtOJL5heI+6Dh08AXUfl2KJcFWCZVW
         roAA==
X-Forwarded-Encrypted: i=1; AFNElJ/UdiUJObw9aU+hRpqeDBrqVj3JwOSZ2RFAJP8QQt0LnqwBjIQWQlOFZ3UJhQxLFwgK9gXv1GLZmMAI@vger.kernel.org
X-Gm-Message-State: AOJu0YyowFgNJahL2EnAfK+qCRAsgDggaD2jwv/ZxC++/1lNN7duBs8o
	yGG8Gu+43SqBLVLejp509InrlNhRi5P+WqftVQYJqTdncfWy9RN5ex/Gew5+4YpJ
X-Gm-Gg: Acq92OEK44i3UKixG5z6OMGqB+NuJ6PzyyhcvP0WfboQfoVGb1thLVAmfgyYtYMxHtv
	/p5X4VJMpvakyu3rKJ5psV2NDnyM3BbqpxuV7JsBog2K7/J7eG9ll3872B209TDdbETBqa9P+l9
	VkGL+jMSc8gZ21RHI2l5YsStgByfoclU0PyYavkewHazyjTjrnN9dvkcXc0wa38klFpC+E2OSLy
	a9Bkv8IQLlUqAg1euH+xbIwBad8q3FScq2WW/FZ796a3IU6/MJt6Yi2qTCPFHqd4fdpg6VbPfzm
	EqTWYvTfNI2eSOMKlZ9wCAtCOcaPhgGHApSoleSlVLxF+rXVSp1hmFJO8X5CrG7lDgUxjxAl4/3
	p6PvtenOfNHkj7uEGBEAZEP2GrAPtVR5ztQebkoja3FFBIHAz9W5mY/C+QQWZ+wK3gInDqCsk1P
	ZZ1p77t9NBdQHVVG84k3wh5gh+BT773d46LDD+4xEViChW24pTYmkDCnKNcz4JMLFkyrg3h8pdt
	JY0LlS+zhoUzfQ=
X-Received: by 2002:a05:7300:a94b:b0:2ed:a64:a457 with SMTP id 5a478bee46e88-303986552f6mr9519696eec.20.1779220435225;
        Tue, 19 May 2026 12:53:55 -0700 (PDT)
Received: from [10.69.76.71] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30296dcb6e9sm20827669eec.16.2026.05.19.12.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 12:53:54 -0700 (PDT)
Message-ID: <67ad1039-b6e7-4507-a9be-12600a5fe385@gmail.com>
Date: Tue, 19 May 2026 12:52:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: fix potential memory leak in
 lpfc_read_object()
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: justin.tee@broadcom.com, paul.ely@broadcom.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 jsmart2021@gmail.com, stable@vger.kernel.org
References: <20260519074230.110624-1-nihaal@cse.iitm.ac.in>
Content-Language: en-US
From: Justin Tee <justintee8345@gmail.com>
In-Reply-To: <20260519074230.110624-1-nihaal@cse.iitm.ac.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Abdun,

 > The memory allocated for sge_array inside lpfc_sli4_config() which is
 > attached to mbox, is not freed in one of the error path in
 > lpfc_read_object(). Fix that by calling lpfc_sli4_mbox_cmd_free()
 > instead of directly freeing the mbox.

I don’t believe this is true because in lpfc_read_object(), 
lpfc_sli4_config() is called with LPFC_SLI4_MBX_EMBED.  So, sge_array is 
not kzalloc’ed.  The code as it is today seems already correct without 
this patch.

Regards,
Justin
