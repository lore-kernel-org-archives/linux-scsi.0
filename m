Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175040;
	b=X0VnBTsPQdPQvbEMjox/8kwgw3qRsRtcdbglEaOjJvSrNsIngPp2QSeoItLX6IGF3V6I
	 uPxVfRASQk5YXi/LaKLt7zBDnBXTrkQZURnEfOvDCs3DnkiIdKlO6HPklz7RXh+zTX+pv
	 pAWZtJawT2T9rLvKNkhP1UHBdQUNtDsSPfhttwVSXLUaHm1DCk28vtoNoqePBRcmFKFY5
	 xrPjp/zQoGSjyxZ0SU0/kPx43UfvD8bgxdUBvzJ/PE7dwIAsuFuchpnGWG+sf2NQSGDvC
	 xIejIdbQMGIwvynU28GH47NE33bCPrJgkfHorqnqiTmQFTTfqfn/AC7her1bdHlSa/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175040;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
	b=oqU3GdWxqACOEQMRa623RZFrcZvcjMlLvd/puaBhwm4ADNkRG713O3sQCT1jhpZRc4hj
	 7fuovsPJTGD7uz6MZ1kCOmwYn+SqAJHwgqDO43EihHh7aRyBqo10xWtJJBZNbqxEzn8Um
	 TEnaF1v3kk0/xg9Np1POPAKlWBSMOMpNdyeMcoGOfX3liN4VSQh6Uhos7Od+Klkj5FmXE
	 IoFNAY+yqEeeMyt/7C4Ed3FbNn5gPDkDa3inEumfPJxfp26YMbCXjXe1pwMxLwL+odUJP
	 X4VsuDjzjXSA68FNCp2x4vQ3HBrur7FrDzs6Y2bXhLwxuuF5eEQ4fEhuIVGSfcH3t3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qEtHq4QY;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF25660A2616
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF25660A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qEtHq4QY
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b413997581so728345a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175039; x=1795779839; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=qEtHq4QYBKeddUlud3LHKlKlbuXs8UB6TG4Vb8wQdiPtwgFNkogRw72UYHUhxfAaou
         TaAuolbyaM8/7kAu0+ks4pOA6CG66/dgynvH90EKRuBsEWFrCHMwIiuAR9uOyH/o/W+M
         DVQ0MQjigtPd0SGmQn8yZpEJ+kCBZMBEK3uKV+/eU1UDt8zBX26nkmKFFHGFCrldFrVN
         U+yEna70seAivGA1i/13zwh0VYuu2sTGsJSLDmmUKkxDxbqMU++6hCMJXVkcGwlm3REV
         WtYtv/X7/S8F8nplDwL1+BE60y66VtbXQGLcIH0F82qS+ixBDE+ydd3GZrAWhYu/AwG1
         PKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175039; x=1795779839;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=ss+jcTvwBQmOBq9W/Ll45kgsRa+bEAPCrDXA2wgFhfTjVZFnpldBtgz+Ciz8Ndb2gd
         c8sWOZP+7golKeR3A71jtArUMpA/W9Ls9JNM3e97fkS6mxTmz3eG2+o77WSzPyo05ksj
         4BAiEvfrQxmZtklIhAuZ8bTMatppTnxzCyMaLfBGqrRoAsjjBoUAdZzppvAIm2wr88OD
         cgMIHgPBMUV7AUHdA8QGOX4zvK0NMbR83HdU2YAyh86kmWAqlKIazf9NCcxeAWYrRj/V
         eHR61pSPSAZyBDEUsNWJBDlsM+ygXX9mXzZnxFiBGLrd8WUSfwaoJqwWut/rS3IRli3M
         fszA==
X-Forwarded-Encrypted: i=1; AL+hErEwnxdeUFTbbQLer/2jTR+kOWVQDNi36FVbIfD5kLV6UBC+bL1Pg9Uh69mFtOc4DZR6aLT7icdscQPY@vger.kernel.org
X-Gm-Message-State: APuU4Z+gW25qYTyOza0xwpJXRz3h9uPpZBA867xPmr+j9wlS7GbfyQ3b
	1onsWXgbsk5viTh+85QxLpPrUgsOj8xp1vvIiADX0dWxH8ams9FbHakxsdsZcC1eLxk=
X-Gm-Gg: AZFdTZdjIz3klG+Cif9dlJdC0ChZbodhd8fPp2q12B2tu92Fwph9N4f+YwsZ9LY+BAo
	ss06o8VNYyw5/EE+sLNfP33Avr0yhll1f0wddoI9qL8VIoreK+2KEeyURJOZS4D7GmMMXv+deu5
	DYcPwlM3zPW9zR2Bnj9uL4gyQhxt5WGZ8XFaAuw9BmR/kfTMLdHu96qHG9OFBYx2Siu12uNnXsx
	V1tildEVOndXhYREU98a3Za6E/3g1+N2O1jPZN/X/AgTrCFzLP1LLmJVM7saNhwnLLSGkwnjvsE
	7YRzPLosdtXslT4o19+tMP+PghdUxbIo1CXJokT6HEd4wI5lc5Oj+Hu2r2KjVmFwz/IGFrxzv9k
	VO+jUyNMwxcVZekm0f34oo4q8EEexfPXGiKT1CwIGZWO0cnnLs4ipxvtooaIWwlmRqpUrke/40F
	g0p+R0cEuZMYsgJFkY+5A01hveesvrdIqF8ZZERBVD6RGrnyJNc4qVA75JPMKcb00jV8/50jxoT
	aUV5Bo04aBc3oWhPMthfskz1kKKd0QwyCoq8t0dZalfKacnDMRuiXsCHXcAGyBRMu21Dib9dkas
	ypa7EKKXMPzOsNYCmvsem0Bmm3CALyZvwKsTiljmxzqs4aNLejfHzcAGD5EPjvb6pnyebN7KGRm
	Bb91m0w7gXnMw2poRBccjJxEN4d+gS8VXnDTMOQ==
X-Received: by 2002:a17:90b:4ccb:b0:3b0:9183:23ef with SMTP id 98e67ed59e1d1-3b41c7b67femr2721462a91.3.1795175039135;
        Fri, 20 Nov 2026 03:43:59 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41d2253d0sm1846124a91.3.2026.11.20.03.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:58 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/5] scsi: mvumi: bound the values the firmware supplies
Date: Fri, 20 Nov 2026 20:43:54 +0900
Message-ID: <20261120114354.3072420-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
References: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
