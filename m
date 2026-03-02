Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6281A681D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485447; cv=none; b=hqSWc8ZkDDTWiSIKYKwxADkhbMcxnj/vAQraYWg4WszPgdXRTA/mCnsPrFh/ukgenOWxKAyLdWXqSiY5WgCwQWVR5mkmvBrKmDXRaF2LGsaLntIFghSN9cq6zUsVBKYkpA+4QyLMGlrPf6QGZ1p1eHhAW/+/KWZRfldgwW/rT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485447; c=relaxed/simple;
	bh=UwKN828bpYjsATwe/PFNfBBgDEwwJJjZ3GciXwnOP1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4CI/dRwgsGF7x056EeFixNJwbk9oty0C5VE5I1OnlM3vIT0y9FSy96Vbbx12Hci7ggHkUpQf9MdTjgR+smyeQrXcDDY6rV4/20Atvwym0BGYh4p0I5Nm0AW8q/RKADtkVL4dXT4ON8wG0nYeibyZtjPZ3XLkVCRVhdNTPtGCo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z4Bzo0Wf; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z4Bzo0Wf"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46392972257so4014364b6e.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 13:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485445; x=1773090245; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=Z4Bzo0Wf3G+d2z5kyswDxW3jW+NPZDiVyYZwCcqN83Y49dvLqgm1fj0D+2nh2e/7HK
         y8XgjjOFWG50GRCh2srXXbYtnH1gxt5oudR0awiokKqFJBqFV+75vqF0fXZcb9O37PzB
         ssP/XV05YlZsYh2QLF+rBPyBu9kralV3P1u67TnrC4Gq176kdbtB+q+Yzk7rNrtA2DyL
         JNxO+m04ssNNgDdJS5SdTjn5rlUQGzbyEPyhUWsMrh4R0eemKB2xMgXYGgCtad/ThjyD
         pZvO5pkjXBF07tjJWmuzdzaOoLCD/n7CQeuwzhnCm1zeTQbegrjQte7JAmiotc4r7I1y
         akRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485445; x=1773090245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=WIDcER75P/2yfNhQs8e246hAwDl+dFgbGaVjS8MsLIxg6WdIK/tFFUx4x7nDOvLBYy
         NgSP3tVkaS/kBx6g6vw1uV4mpPOafJgCDcXueh/RZth0JQDkvxXc79Wgt5FoYWcoF7uS
         5B/kr3WjUVwEEDFRijAgRiTN7mLBkhIFLm+VxOLGR8418tH7m77Lpl9BmoqstazJXHBQ
         8CiPL2s2SQxKvmwGcgVW636OoIltigjS9Jauy8tJj7v+0SGEemaJ0CDKFAaGwsq0z3Y0
         j8iuABmoJPQAdJb7hPkP13lsTgijTHOonIaM81u19/nGIvgGV4jpkk6rUu9c96oTfhN2
         EDhA==
X-Forwarded-Encrypted: i=1; AJvYcCUxmZyCpnVnJjoZ2wAyEc1YfaoPTlHSZnowhbZBNH/lUKuIrsyb/AZFc1KNnsTmE/hKxNZyU5rYpnIh@vger.kernel.org
X-Gm-Message-State: AOJu0YxHb0cpEurJW7qKO1X38oP/wdTG/9nfzN41K+jRcA/OBnvHFgLi
	KkS+HF65FqBZ+Wp82uNCIjtZlUJJauX9F18GGOXFvVEUl/q7nJie9OGnbIYWTrVOgGXRre7qVb+
	5RekH/Qs=
X-Gm-Gg: ATEYQzzoqzkDysqNJqLo8y4WIppOfLCrf944lOcxLjuC1tJAJrWkbVyiR6AuXTKLV1t
	/9awnfKWwcNbmv1PemxNp8/kh3Wl8P7GlWZl5dXMXq9955m7X4Do8s3b4xEwgjVgHoThDwmHEJn
	oCDr5ae+tvQv6jkt0Rxept+R5ICqLVEYyJK34Heh7PWWIZUezfibICBj3iS77HS6dYHkV95oBbj
	NFC9sIpA2YKhV4WEbUU0WTSzq5hUkbospQEvvwIWnMxnRv1lcDjiU9ftrmaCJpEB2jY32PUyZZe
	izxvyzsve4pYWX/bb0b1wE0vgihGL89e5DB1bD3HRackFymhadQPbxT8xrjAKlM+PVmv6fOTW5Q
	nrkY1aIVXUZwKEAgL4/xuS9g3lrqdtx1jqE2NC39ECsuY6DAtseqfF5LQlYgPKfEkQYNAicMvqU
	CyJxSupEV9rHH46b5m3DJoQuJCW5voNGqoRKLJhzyf4SBLmvUtdXr7hG57oiD9z3QUj5HrIAK32
	XD+seDgAMR05UKAbi2v
X-Received: by 2002:a05:6808:8281:b0:463:b4bd:5287 with SMTP id 5614622812f47-464be921973mr6434178b6e.11.1772485444663;
        Mon, 02 Mar 2026 13:04:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb3ab302sm8292175b6e.7.2026.03.02.13.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 13:04:03 -0800 (PST)
Message-ID: <40e13629-aa4c-45ba-a2da-b7614961def0@kernel.dk>
Date: Mon, 2 Mar 2026 14:04:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Damien Le Moal <dlemoal@kernel.org>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
References: <20260226075448.2229655-1-dlemoal@kernel.org>
 <5b8c1811-c9d9-469a-b8d0-992814a11b9a@molgen.mpg.de>
 <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/26 5:27 AM, Damien Le Moal wrote:
>   > Is it worth the change, as it looks quite subjective if you prefer the
>> one or the other way?
> 
> I think it is a nice cleanup, but I will let Jens and other
> maintainers decide on the worth of this patch.

It's a bit of pointless churn, but I kind of suspected this was coming
when we added the bdev_rot() helper and now had both of them. So I guess
we may as well finish it, as we're half-way there anyway.

-- 
Jens Axboe
