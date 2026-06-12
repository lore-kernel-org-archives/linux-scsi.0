Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A2E38B13C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263349; cv=none; b=C3IO9gXDhAQgmTK75NBIcyhsH3X12h3S1rL3rEZoh2jsgdbPs5X9T1PkiKcDoxZUJTo5OkNwAFuqU1kVJb37jtnwhiwKqOgrVu2gD7yTnfcH+JgGfdJaHiTnzh95+WMs0TtTffCQghRfx0+qBXaCU4lXkM8wWvAjkhXzv5bo7Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263349; c=relaxed/simple;
	bh=GuV1H0IEHrRo+v3Ch6tLNA3gxvy+KGSn/r4gPa0YYAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SQYgzxrC+DhGxjb4dK1dipOcN/shCl9whoHpdrBjSjv9p/MKCyshIcXysj4P+nevyHv5SXlZrilpxaAUvCotCd2KpIsFkguoYSsyFtbBWvvb19+AEQgJW515Iv5ciq0NkyZr2wYZ06kMQpVyCyiPcWYNQO15PELP2bNoF2fT7D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AiKM308m; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AiKM308m"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490acbb0f89so5587495e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263342; x=1781868142; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DnHgK6okwKqvTys9E31IvEONtVGuXsYGgm60dYpgyTE=;
        b=AiKM308mf35K1j7aspFpziDdQBPvEgi8EiktYyXviCezzaHLPQXQCGde+KB/4zusMt
         Lh0AnHUBBGZ9Fdk3l1qlBk11lLAwLJc+MZXP7oth7yZKJ3JYA4EGVBMi3Zzd7cHGYiqA
         zDoN+Rp1iH25VyOYX1dXSQJ5ogXxhyh6noA8VcVYnxtJ5/pSbla6IrMIJx1lNIsdThvN
         BhfMVSRZ/f9twMX6/q9zcOaE3HkgewFbiNCwbspbEwUC4gEJYviXxy+uIU9COqVr2JyE
         GvIJds/ZQsCHzT8/j4hFDvvk2l3Tt+27QJ3y6QVe0Hn8CJsxApGrUii0PXBtoo6D+eF1
         oSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263342; x=1781868142;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DnHgK6okwKqvTys9E31IvEONtVGuXsYGgm60dYpgyTE=;
        b=HKs6CJI6UwGZafYpl2dFGxowicXwtd9RasxmvFN+eGd6sEJ58wNMFuLfgsovY0Oydz
         KiOVHn0OWR5iCHhtkly173OwSzCtzdXP2RjH7VtSGVVKJ1ikB6Wl3vsX0a0txTitrfhU
         6r/L1DABbe2ZGeL5EK5ZjyJfC089Ov1VTJ3YoE3keKWCsP8ML2kbvxYs1P1uhb0sTteh
         JA8buHSnudERCxoX6rW16SW7WJykIpIJfFDeacHMd8AwyAz5kxhBbX+QU3qbgE9WppHo
         NaFxcRXsPaDLZeNDMvusIUwVYu+FK3PwJVQP9ddlO0jn9EkKxyK68B48IU/gaPWj6XID
         fDfw==
X-Gm-Message-State: AOJu0YxOgUT0wzzSfr8UDEnJ1hIzm+3g/Dpcoo4VsxgTqtIe9FeD6eKH
	dUq20TaXYI6kSy+9PezNa1hE2YhMXlDI6ZwY9BllFtZnQ/TZsUOabvQMeQ8MQnZSUow=
X-Gm-Gg: Acq92OEqkEdYr5ZK2WA63STrGEbxeVHiLVVRGTLtoowUzEzs1LTo+6ozXd8Fx9NSe5r
	QnND7PUTlUuUQ7n+48PCprhbZUkeJqjgaz3w8KOLKmzROprxVkklyBrb+M4YNRBcIlSf9Cz+7iv
	L1PY+7JOBSLlclzFFJsQPZQzUKh1VGeDvOmq15QE1Fm3P3xiDVuhFvGCHz0qAEg4ut3CBzVKHOH
	yadvdP4IC6RXlKbqMhFjdEwqR/ZpUdkQ3pztAd5Z9LTlKklsCepysa9mtf8LV+mQxha0rYpl1jp
	w6cHuFiqfyF7Lh7VfoZ9YYX43e25lW0ksuDsUnn/j1MVZNPsUT8ksc1z6feev7weP9Q7rgL/tqn
	ZeTQjth/derUv7N3xXn7GA2a5QHqEyFrqQo41Q6kKM85A5KcgD4bcHq+Cl8QzRx+nL+rXfQ5/NV
	osYd65Kuhanbwd7fu+yk0Yeo5VytnYyrqne2S4dkhIB1We8UNI084nPOV0
X-Received: by 2002:a05:600c:1d09:b0:490:e1a6:45b6 with SMTP id 5b1f17b1804b1-490ec4df0c0mr28871095e9.20.1781263341793;
        Fri, 12 Jun 2026 04:22:21 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2cf5d9sm4291163f8f.32.2026.06.12.04.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:22:21 -0700 (PDT)
Message-ID: <8729ed4c-3b5a-4135-8ecf-38fe2f02a457@suse.com>
Date: Fri, 12 Jun 2026 13:22:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/60] scsi: qla2xxx: Add support for QLA29XX in memory
 allocation
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-27-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-27-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Enhance the qla2x00_mem_alloc function to include checks for
> QLA29XX adapters.  This modification updates the conditions for
> memory allocation and cleanup, ensuring proper handling of the
> new adapter series alongside existing QLA27XX and QLA28XX checks.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
