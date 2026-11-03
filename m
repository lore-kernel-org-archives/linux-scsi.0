Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711476;
	b=JS+81s0XVHXLTPNgKJyjaYlCCVbjuTUxYpuI5b9ZxrvKtqKC4bwlcRQa1Btwz0E4BF/1
	 YQI5pQyHJMFdrcEAVqhAAodmW+BnxDBn9lW/MmtpwM7XnyjE50uLjVQkSjB5NB89EFcd0
	 FSvPb9dxFQOL7UQLsFyU3x2958UiK7Hyn1P+GFgxPkBUlQXWtlXPHWco4SE5wGujp4wL6
	 0fjU/0bXzy2GVkMh8Ts4w4HEcvWjuOezOmqVtb27jpH0sC8KrIEGI2bjtLfZ+m/mrR2tA
	 84LMj6SI/BspyfFQxzpVoQUjiEOOFhGEuazfN45KIKaZ80clycxSj+1oUknFkiTVkTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711476;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=0smI/wkIKBhttmjun844YlQk8k5yNcKMLGY89LEOpsg=;
	b=cCQZpkSrtpIUsXHN4sceilnO6a3HMEJYUC0JABYPxGV8o5TUkup0g5t1uCf/hfk9eq63
	 02moASHgwkR/fFRaOLgSD3qqTgQD19+cJyfhpKVQlbGm5L5bIVURqErNPzFGyUZ1KNZBC
	 fqKL+LbnUAFTC1GEHhL74WjtGwa4BCO+wtaNSZS9ZGY0jS3kC0MrdKeRt2Kwm3V9taIPV
	 2Y/BqsFc2jysDzMmx1H095q7fBZl4gOSG4i+biv39UkdPY+OhtpkOjwFkTDFDwsfLDSzi
	 Z8wZo2o4SXuPIu6j7Qo9OFzqIfFkEpxh74s0J7+scS05w9A+XWxrgMHk5npNykDQn4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jEVz+2SP;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fD8ZqIgO;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A403606D83C
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 13:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A403606D83C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jEVz+2SP;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fD8ZqIgO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793711475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0smI/wkIKBhttmjun844YlQk8k5yNcKMLGY89LEOpsg=;
	b=jEVz+2SPYF/43d4+wuOT3mSF5a/phDPfKHDdPLlabriOiYFYua6HEGUWn829Op6aw33CRE
	Vg9dwTs5tSWUU+CueBSRC5TnDIXP/t1YwlIReqFCRn210oZPohZqOKlZIUIGZClKCb+kmS
	o6dTWKwuXqXye30+t2aJJnXZvoDvR4U=
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com
 [74.125.82.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-m5VvmvkrPpKHGIH1rurfKw-1; Tue, 03 Nov 2026 08:11:13 -0500
X-MC-Unique: m5VvmvkrPpKHGIH1rurfKw-1
X-Mimecast-MFC-AGG-ID: m5VvmvkrPpKHGIH1rurfKw_1793711473
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-154e9d2d94fso8001217c88.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2026 05:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793711472; x=1794316272; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0smI/wkIKBhttmjun844YlQk8k5yNcKMLGY89LEOpsg=;
        b=fD8ZqIgO0G0b2Ju40PEVvYrSFqpZOlwEibKAfpqYcfFqn/kuWRnTQHak3pgwM1+v7i
         NRsBBS5h8YBAU+VcfypsWQ2OEVG3t4IqR8MKG5V69KkHtRleyvwf1CBN9eLF3gTgZ0jh
         8lzZ/2h5X4Ez6xEM3QsMLcOjFd1rm8S/+HEdl1E5p4AWy/RHDNFEIidn7iRe4waEJD4Q
         O2tywSPzS5eFu0pXnEN+6lGItdqnP4jIEl5NLi48t6Lbh+7qb55chbdJYK/Lgz9ffA3u
         XwK3jukQLJ91HJPYy6riBnsH26A9fEZorb4aNY+JMhpFGFs4/fIYKw0AzMq8DcmIBZDS
         HE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793711472; x=1794316272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0smI/wkIKBhttmjun844YlQk8k5yNcKMLGY89LEOpsg=;
        b=qSLoFZ/1RBha2LBspYCl+tBGwDVu4w57sM/P+wcoOvQDeOoTh8qvoAoAomLcMCFr6X
         DDLPoddficjZMRLpGn4GrZDyE5WgK+mvxkteqVeFY/CB16vQKr2xSruRpX5SUztq7Eqk
         cobmMToPTXSpvmrzWrOFgr18x+/xLY3HRja4X3ToBT6rdU7FLZb9QMnwIaARdJ8LWwHJ
         PBL6IMR/2eNzUOniTslWBd5t4gXOnT0ijT5T1WBVL9qIEZhf2qlq89K7lDHzOXmEy6Dj
         c23YITGNdgSDhkQhLs6ZO+FPGz5whNfPGsdwx5b+xvNrhjRXds92W1Of7zgvYd+JApXP
         58Fw==
X-Gm-Message-State: APuU4Z/HkmqzltyE/Q0SmH7N01tUneFvi/sBsY2kiqT1XDl8KMZcDoyJ
	TjrscNQKXeSk0F/GN/XgTdkZLULNN5NXBWmGfHgNdUg/YRY13TNuDIZLw3E28YLsqx3kPFd2dTq
	QF+IO3OINuCUk89e9CKg45n06/cA7kwK3+S+dnSpEBWe99z3iyUStIBansQEEURg=
X-Gm-Gg: AYBFou0w1qzW5uwieqXsZq8fB74F+PR3ogtNN68h/TgPO9/tQJ6aSlS8+ft7sHDMHLc
	/3FE/CyGjiGoD1yVspHUg5ej0dYrAKLTFdIxK0X0JV9hpV2wisHnHSNTT7rAGjrJLf0Cn29vPyH
	/CWAtR+zHoGops6icNlmVP5zxm9/oPRKaE/Y2jr2CRkmCP3uh3UdIy7RVv/4IXYXx0a91QLGXBZ
	vK1zymexGjRM2GxflfnXKMg7Ul6u5BiZYzF9r3Oyzvk91gnNY9DtBdB4YOkKzUikTHfWxpFPXgL
	6VBVZi2lwniiCtH28mKLk7JrI1SQeJYbh8GIWozgzfO/hU4xvw1dTPjjWUBQNhjCxCFJEPF0kRC
	nEU6cqfS0w6MLYp4HRecAHXVcJ+Ob7xLCdG8a3fYR0Zo070UH0d/+/NFnMpXgsXjrqJYh/XPYlR
	XCTL1/HZeunCM9mqxfKqFfbzYMVKo0R/6PkAYjqiM=
X-Received: by 2002:a05:701b:454f:20b0:1a6:7a2:cfc3 with SMTP id a92af1059eb24-1ac59fbf8cfmr20574678c88.13.1793711472380;
        Tue, 03 Nov 2026 05:11:12 -0800 (PST)
X-Received: by 2002:a05:701b:454f:20b0:1a6:7a2:cfc3 with SMTP id a92af1059eb24-1ac59fbf8cfmr20574626c88.13.1793711471648;
        Tue, 03 Nov 2026 05:11:11 -0800 (PST)
Received: from mgandhi-thinkpadp16vgen1.punetw6.csb ([2401:4900:88f9:2014:83b2:887f:ed66:aa65])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1854d925sm76528079c88.7.2026.11.03.05.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:11:11 -0800 (PST)
Date: Tue, 3 Nov 2026 18:41:06 +0530
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com, martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: mpi3mr: Fix integer overflow in reply frame size
 calculation
Message-ID: <aundaviO6V5enLO-@mgandhi-thinkpadp16vgen1.punetw6.csb>
References: <20261103123316.223917-1-mgandhi@redhat.com>
 <sashiko-outbox-195282@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-195282@kernel.org>

On Tue, Nov 03, 2026 at 12:49:25PM +0000, sashiko-bot@kernel.org wrote:
> Should mpi3mr_issue_iocfacts() enforce a minimum reply_frame_size of at least
> 16 dwords (64 bytes, covering struct mpi3_iounit_control_reply and all other
> fixed reply structures) instead of only checking for zero?

Thanks for the detailed analysis. You are completely right.
A reply_frame_size below 16 dwords (64 bytes) breaks several downstream
consumers that assume a minimum reply frame size—most notably
mrioc->logdata_entry_sz underflowing or causing division-by-zero,
out-of-bounds writes in bsg_reply_buf, and truncating fixed completion
replies like struct mpi3_iounit_control_reply (64 bytes).

I will prepare and submit a v2 enforcing a minimum bound of 16 dwords
(64 bytes) along with the upper bound overflow check.

