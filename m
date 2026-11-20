Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186852;
	b=qMJ0wtl4W+4HOsuQ7QalNNmXmkvIfZhF/pLlxpD9eawrPEu3K6Ypfu4aRYcFyF13WYm/
	 xnBjV5rS9QJU1iJLgDZZqi1q0b3xMXi619AnBy1MzEv2bqibJ2j5YPReLILC2qIQPf+2r
	 iYIQ2dHqjaLWuIhBwCN+DAgIPiJzc1y+vIccDRXdaIHRiHcg5/0ux7gDYnMFzzTjr9GE8
	 2Ta3ocAJ5dt4pWAWlYnixhSj2UNCQV4zeMoxWfaA7Ek9bN4bxDh8g8EFKMM1khZKOm0yQ
	 w0Skqv4uzfF1z7wD5q9QKSsSsGYFqYzuBShGsvtWm+N+sficlG49DO91JjVUHL6wP4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186852;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aEIDLWIG06GGygaJWYMA11748d4IQUnj+aASfTl/5Fg=;
	b=ysUb3AyvuvbFqpU0+XMT60D28fgFdV4L3DGi72MkTZnvrR1XG16/7aMq9Saa5YuLXM8j
	 /4Rni3xSF9xCswXY+Vm4HF5tOHKt/pyD7uxbc+0u/DjQxQbzXBP+fur9M9MToSNDzT+hN
	 Oz/qiQSLCydvwZTKtZUdheaECUQkNHzaGaTB678aa24cyL4ikrYkVE/cSC5kfspeloTRL
	 gUN4o4UiJY5Jb0XocxckWPAT3ivvtAbjeUbEbzdPhd9+iKMmqMGiiS9+fhqAScPpfAL2m
	 YWw64I/NLLxLMkyZ6TRf0BjLvbgsiEiZrHIOUi3FlWlaX00hQBRBGprkTndlYCJFrKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QUDunFs0;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC61B60A2639
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC61B60A2639
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QUDunFs0
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ccca948203aso1085233a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186851; x=1795791651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aEIDLWIG06GGygaJWYMA11748d4IQUnj+aASfTl/5Fg=;
        b=QUDunFs0KamSWnwyJFH5knzO3n1xxKSxhvkC2qRlQ0ARVdXMuJazwD8Add1l9UUaO8
         RHWqFwuI6AQWiW5iEgwh39f0JzFjVJ5gDSfcshwX1t51hK5+00kOLQ+R+xkFczBpHnqJ
         JqfnQv2bvUdI66PdyHVxIbCeiHqEJbHzA6lL3lHDPlSWMjO9AlBXu3oKE/VIX/Biq348
         u9E/IcG02CEC9VkseJtHYTAOizk6X1F9NC+vfiAxgdRoYhgJVBiYad7SBQojGhAF/Dmm
         T7Ql8Ypmz/L/bPraYOB9jEahLtC7JjrfOEiSXwDDqMvQAAWhrSE+huf84up3ajAxDcHb
         o44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186851; x=1795791651;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aEIDLWIG06GGygaJWYMA11748d4IQUnj+aASfTl/5Fg=;
        b=W6PxbOT/g9cXS6yPZ9joy4yD4rtlTD+BSB8U2HQTa+6bCq/B6pjPVIZK+BV+SBcaDa
         KCArLfWUEp5xnbWczUXNCEfTypKScwPl1WOfNW5zoVwDa9VVS2ACPDvQtVI8SZ4TZ1ww
         8l4ssvVdGm287VaoBB4I5j4wp+e4JQ8d1mxhOZqaISVMiLA7Y2TJ/SHTc+w/G+KoR5F2
         v342NtKZw8zWPCSYLdP8VLlW+sADtKG/8uR81C8bVU2jsJOVrOwBKYc+OWOAfQ00g6oZ
         XmToPlgfVB0cR4CwzddnWv7kDSrsHQBUxAXOG8FqCYjGWSvTKF4QPikJ2bxiRNcl94ko
         RRNw==
X-Forwarded-Encrypted: i=1; AL+hErHi3fEn8kvIIXsS6ifyA2us49mk6ZIMY2ocPoT0J9b2sPmdiegQ8pYw5AhHYch253xLcbzQgrV+GPow@vger.kernel.org
X-Gm-Message-State: APuU4Z8HqAKMsych4JjD9wRgdjnzm/oYcJv+iaVUw0n/2DcdolbPuKre
	B1XHj/Txx4vL5KOvpagNeOPwrbUu1j7LTqfupvMFfgLKhAu1xuQoyDYHL5vPS1OFWJk=
X-Gm-Gg: AYBFou2EnH/1O060WS8bMZT07geWumCtSsYLzA/CbdraGIua9LFIP4F962KCZ7hWF7L
	uX09A2+6VZyDuPyf8D/RxCKVwGPYZs1uMrQVeD6qQh7j/CwCpo/5C8aY+LeEogWvU4bwdt6yRcf
	BdekuXQMxjr+ucwMDAYfdsP+RE+4CoPEL7/rbDjkAgcy42ftZkdROj0BhAsMDOk8CoDwrlo5eLM
	J6qHWm6CBopCUkbu+k3ubo9xXghxXOW+eXLXPb4lXyIpDWapWXGacIm4XV9ZBkZNiWsL7lBX8J4
	18ZkIJLPFoOlRUzCOETQktLL8eZmZ8itd5W14pA7jybxXyFt5rkJCQHbH+e5kheD83w1wL6+ojO
	MgHTl5wiHgkkq4ikzsOi338o7tRlSwSGpKPQJmV+ZoKZjcwShQJ+PjhXPLYSvDo0ccOtLKzFSsv
	oZZKnQhpBVo961HrGciS/RwBDRSUK9eylfE91Cib6dol9otIJFmUUXHR3nfh/0NcEIMtY22eES+
	HFZTuOm4ic2M6MSCZa+DT0MoQUIC4Tp7HAKoFc52hzAqFQtvunXYYDGiaOuhmpa1rVGs0XdjxWS
	kx6IycOhUuLDgKTNpoNBf7uKA7M8xzv3QKzYKO5sswxq0Fu3xuLG9gW98eqCXngL+fphNw3XguG
	PaSRg8/Ex+2e82f9MSijFZvy9v/3d3mCknNhu
X-Received: by 2002:a05:6a21:48f:b0:3f9:3f64:9b99 with SMTP id adf61e73a8af0-4014d7630camr3111850637.58.1795186851128;
        Fri, 20 Nov 2026 07:00:51 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c14fsm1640477b3a.15.2026.11.20.07.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:50 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: aic94xx: validate the indices the sequencer supplies
Date: Sat, 21 Nov 2026 00:00:46 +0900
Message-ID: <20261120150046.3128242-1-yhlee@isslab.korea.ac.kr>
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

On Thu, Oct 15, 2026 at 05:19:29PM +0900, Yehyeong Lee wrote:
> This supersedes

This is superseded by v3:
  https://lore.kernel.org/all/20261015091747.4184349-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
