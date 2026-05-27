Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB9643E9DC
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779900324; cv=none; b=PhkhdY0YY79+eaRYBevTDghTyuyS8UOvhDscKvSLTZOvllblNlHTtwZ6gtj9HoYdyq1lM6no93gHGc42HIkmfoB5RQoXqmYZ2BKx2YUBfinav8DmgQU8ckFB1kJhGLYFTInbWO8cix4l8rPGOQAExc2pd1I4nfu8N4ZcTdE2Wgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779900324; c=relaxed/simple;
	bh=Px96Koc+KE1Llq24SuFqyCNdFUV476yMaxYMtndJ/UA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enoSVPGQa0+xGZwUBPtnJOxnQ+G1ZkTXcIfTnX1/824oTyhHw7ootvS5YWeuS5aX5n+NfkWs7eODoTMo95O4gWYiqSfeoFQTIMhV8TE15Kfd66iYsL0oaHNlgd9Qh5kVxTX545eILJAYLzq41wqucwmsdbYEo7U7FXf8lUa7SOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PGmITyv1; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PGmITyv1"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7de4be15125so11402865a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779900318; x=1780505118; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dcORsZ+6RO+FQOhB2NjtCmUi3rJoywVrFL/YyMOnoJ8=;
        b=PGmITyv1gFtGOc+BOGJEcFusxaA/c4h6dxbQwwTmpfDOcZBsxTqSevpcLmm6/xYdqB
         NP755Jb4bgoPiLU7FQr956I1q4JJoTIl0YFdFHQUN0igabqpvBU5aOxItBS6yBi80Q+Q
         DU8tpq3GMEMM1QlvywC3ELldx918nVUFJ1TNdWvc54VyLcgiXbb4k4Wm3xSNlWkaHbS/
         16ak2tv9pEvqYtNB61CUod3/Y9xLD8rYqm6FUASZNBjtE1dBVint5GTw/s4f8cFclvO3
         UIFk0ODzBNcdesQHJ/ReEEcTAhK5CWW4QQk9QIZVqBkELkBVGzkKlAdXKEvXw5d3Vs7k
         yhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779900318; x=1780505118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dcORsZ+6RO+FQOhB2NjtCmUi3rJoywVrFL/YyMOnoJ8=;
        b=OjgZi95+9oJFhvBva7x27O6Zzqd0W80yfsEXUr8QzomXiP6fL43o3k7lx8bZ/lkyok
         a/2VeaoMNjjVB0hK1LDwH6V13O1c7YqduQD57MO4syM813Plw33eJkTiXym5hBja8HgY
         MfuPfFMKCxUInrYaf/utmzASklXOrl27TWfU34Gg1fFJESh2sH/uVJ9ucVodjBuoNCwS
         wlhanDOW8ZTn6wKtAQ4JhdHCTYpPTUQCESVLPsZGYy/CRcs/GFLJS22rh5DPWUQ/7C3T
         lBfZV4IEZCG+4WRdMwybaWKiv6PQAMimSauqNJQ19Jl8CE3RLvW40JBRrSdvvt9H7lbN
         4GnQ==
X-Forwarded-Encrypted: i=1; AFNElJ/seJXFwagX7n4ONaMkc4nvIHuAbnJ/qOO034y7cj1udUdiFooFJAmK/MrIdKa2x494kd3bcP9o+xyj@vger.kernel.org
X-Gm-Message-State: AOJu0YzUwX4DEtuL1p1vFfFdkSTGOrejjdXQFZrS7MlN3aX1yy3Fb8ov
	ATwZD6ql++g6oAaBMhXg3zkodv80W66Dmw50hkF1Jx1CM2lhNOXqHpIaoXI8Wiz/Wlc=
X-Gm-Gg: Acq92OHiTTg3RgfbNJaQHb0CfDD+E/21H4ICeIv1Y4CykWOEEVU0Ay6G4yMlT0nwrYj
	A3zPzEWyMCgNpVAPn1HgXYI6yxZtTeI4Wxzh7JLC5iIvAjk5Tb7HP8YFV2STWsAFP/qnbMZMbhg
	TjUlCI3BxfziSx31Eq2FoS/Fgbleb/jLLst5hVuLNBbQbMJ7wvEP4pxptOg3hobWJwb1Lyf1+bv
	zu0xL67980Q+HOnJQJewEuh8/ijXWdSov3WNFTQWq39K6lPJL/UHlJG5+R2d1azi6ax0pwxixrJ
	kFIPV6PEZyhqfeqa8UDT2pfgl+ZIvF+X2h3CuffvuHWaCZP82czgPR+m/w4RO+HZL5AcEXk+Ooe
	0lcGu3FmLyGcqO+7TyWCqjPzLaknIhOfEhJjTz5b42R18091qjmgL+YAN7yZIcBScvQfIjQaj9u
	xur7m/ii4pMg1K7wMiN8y8YeaVFIEqbtNSuqvKO8qv5ZJVb7sQUvCv9/uBwl0epz5Rz+JQtSq1V
	IeP8r8+T6/RWTL1MmQ=
X-Received: by 2002:a05:6830:270f:b0:7dd:e032:3ce5 with SMTP id 46e09a7af769-7e5feed03cemr14415624a34.17.1779900318314;
        Wed, 27 May 2026 09:45:18 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e606641114sm11987256a34.21.2026.05.27.09.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:45:17 -0700 (PDT)
Message-ID: <07c25a67-54b3-4ecd-bdf1-7ca0cefc8e38@kernel.dk>
Date: Wed, 27 May 2026 10:45:16 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch
 from shared SQE
To: Caleb Sander Mateos <csander@purestorage.com>,
 Rahul Chandelkar <rc@rexion.ai>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20260527105931.3950913-1-rc@rexion.ai>
 <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
 <20260527161926.4071110-1-rc@rexion.ai>
 <CADUfDZr6LJckoVt2NRfRt3Njs-WAqsg5-QnTDi6xbUDiO950Fw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr6LJckoVt2NRfRt3Njs-WAqsg5-QnTDi6xbUDiO950Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/27/26 10:27 AM, Caleb Sander Mateos wrote:
> On Wed, May 27, 2026 at 9:19 AM Rahul Chandelkar <rc@rexion.ai> wrote:
>>
>> On Wed, May 27, 2026 at 10:06:44AM -0600, Jens Axboe wrote:
>>> I don't think this is the right way to fix it, ->sqe should've been
>>> stable upfront if this ends up happening. Can you share your poc with
>>> me? Your trace has been trimmed down way too much to be useful.
>>
>> Agreed that a core-level copy before the inline callback would be the
>> right fix and would eliminate the entire class for every uring_cmd
>> driver. The per-driver copy was meant as a minimal backportable fix
>> for the immediate scsi_bsg path.
>>
>> PoC and full trace below.
>>
>> --- PoC (poc_bsg_toctou.c) ---
>>
>> Build:  gcc -O2 -pthread -static -o poc poc_bsg_toctou.c
>> Usage:  ./poc /dev/bsg/X
>> Needs:  2+ CPUs, io_uring, /dev/bsg/* access
>>
>> The racer thread flips request_len between 16 (passes the <=32 bounds
>> check) and 128 (used by copy_from_user, overflows scmd->cmnd[32]).
>> The overflow payload plants 0xdead000000001000 at the sense_buffer
>> pointer offset (+84 from cmnd[0]). When scsi_queue_rq() does
>> memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE) it faults on the
>> corrupted pointer.
> 
> Then the fix is to use READ_ONCE() to access the SQE fields, right?
> Copying the entire SQE seems like unnecessary overhead. See
> nvme_uring_cmd_io() for prior art.

That is indeed the correct fix.

-- 
Jens Axboe

