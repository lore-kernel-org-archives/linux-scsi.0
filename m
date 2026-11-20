Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174965;
	b=LrKpXUb33MNiGT/uvu7vpmkdQug60rtg91yZCFdMHUBcz9GJQI6LdnAxcA8cRTsXKuTb
	 zqVr4OtV9AgRDVywJeP297efl8I7JlkRPLAx1k5nkmonPME6ybVePBkrY0vIiIjpsjNBa
	 kO2yor8oaMcshUVDTPLKUdKed2JePB1uAucaoQa2f3EgBVsEWUZjQtd1vv67DtLlTPrPw
	 1PGcCTNbWwzgbeil8zTPgIDa7MKCmwyWacgMy7bnw2Put7unNG6r4VhY3D3w+WhEWHYgT
	 t4WWH2Mo5uX8V0eCBD6zZ+h2ovUm+jY7fTlrhptcSBVJpOcKEploMIDLSGOzPWihVbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174965;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
	b=BUm3/7taVETYLK8hdSQTqIQGVAu9i+vk7Peko8CIDShNzltkjHX/pl6RxodmRw9GNO0g
	 xJf3LlEywZv3aJ67Ewj/CERNJMS3ZWA7UHOYmNCk+mCcD/qz9iQFRERhYw/dclvQgjGs6
	 DETwigiCay13lKILN9MmQ1YSKHsU+SnmJjZm+n+0VDUc3xRyE2lRLE28lMg51u5yHYdoc
	 hx9G6Yd/6TWSlSHpTzJ8Dtd2a2JPoR5H2e1dk7Jq60Cc0irvqdoQzROGInz54rJqdCfaU
	 D5R7TSW6PbEA706XC/1HaC/Pt08p5htPYVduYltwbYRNRGu9cGKGeZ+VKzR529F5tpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kNeamzDU;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58E606A325
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E58E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kNeamzDU
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so481489b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174965; x=1795779765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=kNeamzDUU1XYO5AzU/64+NDNni5olDNCAb0Uw96PRYvVvZTyVFOa5fEGis5AvVX+gg
         9/VzKj8YgnbII0NwtM2QicSVUiiBH2MTRzIWFs+Gk0eiG802b3mCuPl6E4zCEUUhcOyM
         PQn3SCIwSGnldj8Au0MKZ++hD/r2P1d58zCJC5reNeYusOaWI9vd2q+pc0qP4VrMyjaM
         yhUYOdpOQt3p7CYSXQtaWaTq7fcEBXPtFnipXh7VZp2m5j6s78cNaMMTXKNON6NHKpY4
         TCQI9m/eHyZvwZo2MA6sDgZKKXOemWXKNM0W/FrL4r2ARKV4TdS1e8/fpihG4w6xH035
         mhyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174965; x=1795779765;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=JHMhqDoDV8Dn0+OoQ70U5CalBqfc/1eXJY6tYjq7k28BbVsfkYUPu/kaOtLMlC/+G+
         EOMRODJl6c52DAmE996CStgSpdPkOcKgTuW1oEvuwQUmzLXLrR2nxi3mCojdqVWOX5/s
         ZWy5IZTF41DTtfqwHLsYxWrzSi+myPtaeNqnLALGwu9hZV+akuvCpZyN1FDkbwwXzXlg
         WfceciyIVY1Sg2+XNPtiqHgThnlkBLogqm0oV01AxC8Vuvx2sIT9yKb/D0t+bU4wmEts
         KkFsL56pEkd4qQNRrQUEI39ZJOlyl3OZeZexboUPvJEiaV00qvsmvFYQOco72QoH1Z06
         sLRw==
X-Forwarded-Encrypted: i=1; AL+hErF9UDsotGjMi7vAPCQBPA9+A57mDmLx7Tzlx6xKKh1J0JBnnoJXw+E6roeRsKk4Q4nefP4FicK2xLuV@vger.kernel.org
X-Gm-Message-State: APuU4Z84o7FclLqXAumQPFtoqie8h5X+Z6lG29a0FdWDRVf3vd7VYfiD
	cOJEhk5kiCshL0qqw30iLKSd0a7mLZsgfNBfGSFKB4yrscB7blkjs+2ZkMazFnXXE0CYEQA4neV
	d4nin7dM=
X-Gm-Gg: AZFdTZc2WHPgprqA30ajVtNR49lDnsp0F2wnyJCKOfuCVUPRXlzwA6j467175WXRY/X
	07zD+zgGJ4lqcSyLwOU0/4C+mr2Kz8L5jcPh1AMW6nSSmO2Koj7gbz1Z11Nm/6JP1+NwlgMw8dp
	wFmlX1+4Z1uot2gsUoR5znvasFjKjNsQtfXMVLXQA0Gj0GFD2YTf+oxk62ltK52D5ccTYMVbVtQ
	RTlLh+NZE1HVMGyhyTgecWeqCPHmrSF+knXNrUIn0DQl4ivNNsLWv4xKT0//V6GwaA004KV+XQ1
	Km1ffTGjh//TLOgXdzOdltqEalaCkw9D/+HLw1ShmqxuothMKOxbVhI58itO1Y9qIuvMWAB0jID
	JGKckJ/gcdwgdnb4kHjxClnHkSO9KJGrz5fdjNC+hKteZu0w+OzH/sosraKtzu2MuHj17Mlao/l
	HFB229xSPCYCKOKypbreY1TZ3ILfhrVzKle9bPrc8jjiSRJ7Oiw76bB6bpRhS5mQErkJt7tGp/y
	tnVr+cplLP2yq8V222x8GWQIr0sLMx+rzSxIy6/X4EGrdwCA5HGQ7RmFTQyOJCPxwNIq1fb314l
	YavGVFZH+EuVbgTpmYswn3scXZCLNDio0xmEvGZ1hqbixoAWT6iAe7MtWFcUacHNploATrPFOBU
	ZFVIcmfaH3dWiOELhMs3L41YGT864cQkKcpsx
X-Received: by 2002:a05:6a00:1794:b0:8b6:2333:54a3 with SMTP id d2e1a72fcca58-8c7de584caamr2966934b3a.39.1795174964688;
        Fri, 20 Nov 2026 03:42:44 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c219sm1415137b3a.18.2026.11.20.03.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:44 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] scsi: libiscsi_tcp: zero the unsent part of a short read
Date: Fri, 20 Nov 2026 20:42:38 +0900
Message-ID: <20261120114239.3072188-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008040129.747538-1-yhlee@isslab.korea.ac.kr>
References: <20261008040129.747538-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
