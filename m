Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175060;
	b=zCtM3iSoNdb8SonGdUAqNQFpJX2wIQ281jHoyD7PfmzecG7To1wgsqhd+Gqu50nyUt4m
	 ZVKU1O8arlw45ePYMhwgucACAhk9RO1BhH3NRMEB0e4cOVbcPx38/dVQNZkYqkaIYo6MU
	 WNly9wf6ub+VHdF/Ftwkt8Z9DMeuavGzO+dfPwRrT5ag02u+E9aDhUoHeDIDkyjGFUEQn
	 kPzsRih+rbp0lkoQxOynlYCpBNJwmuqfd4ddYBotjD4GuMAvAJDQGQjKwHy1lWWbRoQfl
	 swIj0A0T0HGtZwvVFSNsXrDPQAU/2vlsMK7TrNOoIDlwCxNyoTtuyXNdLdeHyowEUkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175060;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QkFRpq+JqVl3CgqxrgMexsAA7SJ5z2muFrI47UuRcq4=;
	b=TfoizJGvNmurq11/4SYtZpgnXUUkbH17YJ9/kpldFclSdJTFTJtWCo/qaKPwLlDCX4Zc
	 BXqfd3+qU0l7FTi1YeWCFLv0xjfZ4OfWf4axGXFlF7VgeLg6UqoF0orUj9fPraIPRBPtM
	 ODE/3q9ek48J7YpY6tYDfUPj0bxb13/wsDPLUs5c/Vma9idw8Gcgj/ci1S1Yl7FW3WOJt
	 eavUYt5PrXBL1z7qpQeHO7B4ANaTqGuUGxov2ZZFCvXJohOIkb1VH8Dk3xrLTsrYhKLuj
	 2lD+Zb3Tnoge2TXloUP7DdfysjQgz6sD3ARcvJyBWsSu3/dHEWCLA5Dy0hidUitEkdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="o/gBGgC8";
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B8A60A2602
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41B8A60A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=o/gBGgC8
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b41188c8b9so643590a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175060; x=1795779860; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QkFRpq+JqVl3CgqxrgMexsAA7SJ5z2muFrI47UuRcq4=;
        b=o/gBGgC8Lzuc9gh4fq96uHZkN7m4MpasjT+ETjgkIxxlwvU0Dddf4TCQ0DZubwVN0Y
         AAMbaQ9/O+JykOkkFA5weEJwP0ZPL0m72JMrhhT2MIssvKhl5rJD/Frkq9XdUg04MpKJ
         0zoKKpj81fgmfT6BkF2c6TuB1oGYsnaMduO/sRxBGooFRwvO8pLpC1L6avkoueQpMRn5
         g48kD6k9DAcdoFZIwspVHeKUXIzPOl073uib18GmZkRF9/VpzwH+R7wttXMxrRHBRS+A
         p9THGYDu6JpdwiqOcGor8D9QA5ICLUuMLP3aM2IJnKEQb/TLp0iJbeliY/YHu0F1CphA
         5cDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175060; x=1795779860;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QkFRpq+JqVl3CgqxrgMexsAA7SJ5z2muFrI47UuRcq4=;
        b=Ad+cn/rSjhM/N2uo9qOkTir6PjjAfGWvIE8WDb3RyueTIzWvcSb0zWwEN7GV1YTcL+
         KJbU1wSzc1BjcssimtvHWDXDtw/KCtqlk2iHZ4/XOQOc+wy1bQEdP+fr8uecLR7Ft/Ea
         64oV1tZlvW1BbmPLWDcCyizyYcVYe4Ubh7Oq2DPCgotry6lBnN/G8lbWLfH/pFkZjAfL
         bUosksAJcqSBLCbHESO5CcOqH1dMDdNXRI7Ix1KcPj0LSKC5wgxi1k7FMIfyWYEPwSo4
         2qRcG6MeBZ6Xaz+5xZHMXyZhzpL7wIZIh2ZHbotX+Kukpwn52RGsI7G+RqD21tCfZX5w
         JJFQ==
X-Forwarded-Encrypted: i=1; AL+hErEY3gLLpU2faXgZjyg99jc6xF1DPktKish0Z1EelTACKKeX7/XCDQNcQYy3hvc8NcGV+lH7ssmJeWkp@vger.kernel.org
X-Gm-Message-State: APuU4Z9BLTJB79lcTp7UUBcL4pOoJWVbd6JC/sqZKkMIH3NC17n/hljj
	UEnsRbf5rxmgqf+50yQ6uvU9v7aNnY+PnaAsG5HvuNvWxksDLqhdyrBO+plltUzLC7s=
X-Gm-Gg: AZFdTZezsDZhBymygJANL8kMbTF2r9ohxCW1YSZnpaP1W5JVBPhmXFiYspj3IumNWYf
	vaVhe9wpfM1yD9RKK7Ozt4PNX99nvy5hyQoxVZW6WTRoQbT3feGPC5xyRYG0/cw+jfRuIlK4tDr
	8P0AkLgRNDtzdlVbdnrTZdTaCoXdv94OexGG2lr4Z9qvf/P+k4NJ/Id+tKDT0+vjXWjMX6yyyok
	HOOt/8gZryC4cw+Qt8Z5UbzKPjBb1Df6TPI9/Ukw4J3SL1DRKR3cBZclhsqd7YI5eDBXwphkXrr
	Tcbf2hAzGAZeQT7JuvKoGaMQMhrAJw8JQJ3Xb/7bXHdN5oSPAmGbiaSxpX7B+G+nVwDbad/ShtO
	QClbKGmfHhTbrYkOEPQtwoqtipOd2W9dzSCCzve7cjY2P+Gg6/4pKaRfLAcuUa+k5yn49KDvixC
	mn4wiGuxAOhnEGHESCvwLQ1myv5CbPKQ0aBiR8uNhLQp8O6a+kmnsRfOUl7OEpT+AAjyX3ooe6M
	uC9BVceUO1NiCQYmSkQdHBmSuAhVPBwEzeZCkjOKdYPvUBkJ4lEJbzhaBSL3Yw32X5qPFRNHK4s
	jEzblg13i99M4lOXG1qT9Y28rCwCgOPOi1gUVuI20J5qHPaM1cZQrfqMkR1gpyfvWqRiLzwf5jZ
	UH5pbEIgZnpAps4AB23Moi7LtQqL+AwK9bDClfCDlxqK7w58BSaFSFqUPgQ==
X-Received: by 2002:a17:90a:ec88:b0:3b4:127a:2bb9 with SMTP id 98e67ed59e1d1-3b41c8d9275mr2608546a91.13.1795175059819;
        Fri, 20 Nov 2026 03:44:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40578dca0sm7448439a91.2.2026.11.20.03.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: aic94xx: validate the indices the sequencer supplies
Date: Fri, 20 Nov 2026 20:44:14 +0900
Message-ID: <20261120114414.3072572-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
References: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v3:
  https://lore.kernel.org/all/20261015091747.4184349-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
