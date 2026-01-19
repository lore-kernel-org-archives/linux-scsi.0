Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F235306D3D
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841470; cv=pass; b=TKAX/c31gYn9CbMmGLKGVHu8IvefKWIG+knNye590r4jZ5PycfazrVYCJROJDSMmgmfB4AZsB/lqFznsyE2zRt8V/Ehat5krxOyaqD2qsl/rDzhsUuYenoZKr+1tk242jGxsydbJkIaQ/i2gc9i6s5UPDPYgQvT7rPYdshSto88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841470; c=relaxed/simple;
	bh=pvp+jxSQwZ4HBQ0yp7kSkSUhjc00s/5R+BiVGREofQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sbQIqd6grIp4i1G8C2doUQxVA/Hp7cFSMsw9r48rXmHvduAKBUPDSRX65YZjI03qcP2c13TKBcFIlAZ4umh3i/qqzlP4xMB9TAZn8EUcKK+CjcDHs/dyXYYLSQsavWTlTpTVqPCpeYy+6ZKVxd/pOxMPwj9796QRy1vBnjzP+4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kY+dVQwu; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kY+dVQwu"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64d0da6019fso440867a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 08:51:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768841467; cv=none;
        d=google.com; s=arc-20240605;
        b=SCUpFOPKwb3HZBry63CUUOmaC2BqAYCoT+cKaZCzEPLnDrL81irCa7+NEyHgO9TkSM
         4qlIn0deO1sh3wpAMOX5n9OsKXWiseErU9wA90Ya/zjZM+yuZVwbMtOD5ohWyJNOK014
         L0/OTwMPXJQnzqIY5ApWa9rT0jeh84MCPV8SCg+/OZL+H+s2JU1VFIdRdu0WeAtNP/69
         e5loz6Q4Xvf5xxCMmSb5svRWvx/L+mAsoVVzZVHENkT7OXp+JqZyKmOX/yc9HZfDogMw
         1pZ5HxJn7iEJoRuGB8tb+lzVigkRTsHVCJ414dz61YWSN6oHSlGpBULGlec7eHmJ4KDx
         hnsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=W8oNMubzTRoYWlt8OutXiwC9V+hzb0JjxSQ9x8OoYzE=;
        fh=CjfIfX1+zsX+qx3Q4uOONzBGcWj18fArYj8YfWdH5Ys=;
        b=bcQRaFmAmkxl9d2FtGUOs63XWr9SS0KDCOjQidD2jc+8rd7f2mv2hvePcJQd2+AmMb
         +FM/caczI56tZ/1kEF6vzanMmUYzpEl3fGu8G5lszn9nzFRFOSXkKznDx81Ga5I3IQwO
         hHD5bQvBc9xTHgloUGMwGJIdZTPlm8VxzNrMehur+42L/UdpnI5/DYNsN0DAhZyy1qIg
         H6f06AUn1nVMoV4ZXBzNxSZCdO77r76RHHsxslwO3kGNS4XoQXKgEeo1KVBiA1H46HEr
         sjIARzBJbrd4yjFdBvWbud5Mbr6uli3zcPfDL6CKNgRLMSJp+PYyDA2E1WGBGEhbZgBK
         Brhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768841467; x=1769446267; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W8oNMubzTRoYWlt8OutXiwC9V+hzb0JjxSQ9x8OoYzE=;
        b=kY+dVQwuz48Ewpr2wnGyzlWF/xS3E/zAepd2eM4GGNc2RRj6uAtoIWhAgR4FwzvRZu
         nXvchqIeyE0whtC8veKw0XvgKt1l9D8QQlWTv1H+ZYYC1t8/CGbWGdafWqFt4fInCOLU
         mVkZl6GNGeu2+uWNacfTUZrCHLLN8TIHCbwTpUDi+fPJQ8niWvtcvI5EbfwRYNL0MTiS
         f1b00U8ZRgowqF+IkcBuiDuYN3G1WjlJhliu18tnLYtM/ipACTkZB9FRLBzBQ8KKo2US
         jVNkKisf2zgoSWuO6+nScaDdYoWdApq1eJWX7rTRZJVI4jo5jIZJ7kpol3swgVSrheuE
         C/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841467; x=1769446267;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8oNMubzTRoYWlt8OutXiwC9V+hzb0JjxSQ9x8OoYzE=;
        b=OFVZw9zV29ygnoR4rVVFEpoMHJO+fxLRa/ptfCIQUJFhGiHq/mjCUm0VOcjQCVC/MD
         VKDtyCN/BnWFfVDboWsqHFIqFhWle7z5SIRglV7ZTp6hmwNvHRSO/jVvVVw8gRBQUjJC
         zDRu82Hvbs4YJHhVa/6L3aRuAVnDXZ+febcLoKoearzxlOQLLeKl4gT9rHR53lAq4Zrd
         mjSXxa+/CgOmt1oRYG3zEwbMt5HGcWGPjfv5D4hFcdbMMQAaSam08vwHYL5+wM6boY7j
         2FuVmvvTk3QPdZIN5j/DmQdi6N9e8u4zM4y8mkO6i6d/SYkpHuWCBMdVebof9kzyPuO+
         st+A==
X-Forwarded-Encrypted: i=1; AJvYcCXP8aiwCZycQqYNN9iGvi70ZRG0t41oPDcX0boXPzdAcmqKo0ehce7pSTvgx81gUg5Qwx693v8b6FP6@vger.kernel.org
X-Gm-Message-State: AOJu0YyDXZZg02+v9ZwI356OYDm+dsv9f1wwmdW8YO0Bnvs3r+/gtXKY
	7xbmW9mfBrbN6ygkWV0/wjc1jzV7xH2uo2JdTsK2GVJwAYDmMQZ09AAf7lg4uOBMUUWcP3LqJko
	7cf75G/iG2Ju1J+ctC/1DVGg67ogkNqDKURMexx3YTw==
X-Gm-Gg: AZuq6aI4Gr6I1vqqtHt2gdfRrG0lERfTwDE0xqafZhR72O0P+tNUj0F2rOmn1m56k4+
	yNRSRAZ2rjUqlAC57MlmxIXdWt4HWqzZYbhvvBXt8jFbNEWP5UwbpN4bBtGfv/ca6wusZnYETxr
	ChB7Q/z8l9iyLe6oNPGBwWPF/iFZerUDPbGX7DSYuPFzm1P7MTyD6DcByHrY79GygWr9ID4pDrT
	JNjm1U7p+lqsSwVTS4xpQjF0b9alOJiJQpSMx7inoLjJqA5F7jRtAxaE7bbBwwVHyG0qLvjKiaX
	/vO/Ww==
X-Received: by 2002:a05:6402:27cf:b0:64d:4623:8475 with SMTP id
 4fb4d7f45d1cf-654524cf67cmr5269517a12.2.1768841466536; Mon, 19 Jan 2026
 08:51:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117101948.297411-1-dg573847474@gmail.com> <ae5cae8b3c4e71cf23b6f48453797ac48bea5914.camel@HansenPartnership.com>
In-Reply-To: <ae5cae8b3c4e71cf23b6f48453797ac48bea5914.camel@HansenPartnership.com>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Tue, 20 Jan 2026 00:50:55 +0800
X-Gm-Features: AZwV_QhlNe_k9yU_8d2tiktJUfAzvF_8RmabmYQuMREHTIF-e2Stim5mQi8Yhas
Message-ID: <CAAo+4rUkmuOruVVVNYePyfqu5OgxUxWupEBwvJg7Aus3g7WDqA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix potential TOCTOU race in pm8001_find_tag
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I don't get how a race is possible here.  Before the query function
> begins, the sas logic calls abort task on the tag, which means the
> controller should ensure there are no further completion functions for
> it regardless of whether the abort succeeds or not.

Thanks a lot for looking into it!

Sorry that I might miss something as I am not very familiar with the
code. But I also notice the find_tag() function is also invoked inside
the abort function (and invoked before the completion).  For the
find_tag() invoked inside the abort path will it be a race?
https://github.com/torvalds/linux/blob/master/drivers/scsi/pm8001/pm8001_sas.c#L1085

Best regards,
Chengfeng
