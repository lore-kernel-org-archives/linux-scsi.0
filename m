Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C56E8838
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2024 08:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="mrJr1WKx"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50e67e37661so11560373e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2024 00:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1705308412; x=1705913212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=af0c4qw0ceHWmNUQwBLGyaQWzbBLs0yH9j68AMi/ymM=;
        b=mrJr1WKxJ7BRhwXIMQlAIDZhNNwh6HPwY8oGKhaTMNgYoZQM8k3E6VV3EYGkWy9wsh
         bg7vzl0vQ5NrFT34yRUsWKs1bSgktjeShsLP4sn7/SWXSuQ8EtYD5HkDQLgQzYSl3fCd
         wUnCH4TU80jTvjKkUDDB+QbXafgneqkyNM9jCWvyG9pRjbY6utZivtaou320oYL99nzt
         jOIRK8VKBvqVQQUd2NcMna7i4NtBYaX9/GbChAn4NvAw1SckAaQNLwch22Hg2pB1JTYc
         7Jxyjw17LugKrNVoO7e4u8yQTOSolQChKBXLP+Yxih04UgfVLjllbITJOpikAODpx1Q0
         nUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705308412; x=1705913212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=af0c4qw0ceHWmNUQwBLGyaQWzbBLs0yH9j68AMi/ymM=;
        b=DN+lD8HzEoRrgD+hdwtc+dhoHitkkqF10U941nmN/zWZ4aXAeG0Nml1fj9CU3BBgH5
         g6eOuxAnX8bbfL32yCZZZpkFxz2mt3IBUwCiYnRJvq/Gky0vNVjQtIMeRjXhzLldNdHn
         kEjrQBPYcIzOjw6SbuHTeX/qKm9Il67BLj0C3WrV5S6Ge89x23q187EnBJ6YgeGgB4xx
         RpDqM/aFjAGnxI9IeUqKGQ7mc2zXmZBojk/9CnIZDcKBwCkOx4Xfqev6LmpQwtj7Cg16
         /aaiPcgAPvPy+gFwLTainse9ujkPtPw/yKfBySmTM1dUuFf90XXwwd4mVNiV+FkseWGc
         9Hhg==
X-Gm-Message-State: AOJu0YxVVOoDiD3c6xy4vmj4CEsAkK7l3T2HBoDKzMUHggSp6iCBzq1+
	TNo4ywaB5LMJGVrRL592mvYTeHqDvZfuLg==
X-Google-Smtp-Source: AGHT+IGK8MH+CazDutDh5KhUA91iPm2QS3HgOT+gj3DZbv72Ccmc46G2CeN6HPpan13U+rWLqo9+kg==
X-Received: by 2002:a05:6512:234e:b0:50e:6457:2bc2 with SMTP id p14-20020a056512234e00b0050e64572bc2mr3307332lfu.71.1705308411949;
        Mon, 15 Jan 2024 00:46:51 -0800 (PST)
Received: from system76-pc.. ([2a00:1370:81a4:169c:b283:d681:9baf:afcf])
        by smtp.gmail.com with ESMTPSA id y22-20020a056512335600b0050eea9541casm970160lfd.44.2024.01.15.00.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 00:46:51 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: lsf-pc@lists.linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	javier.gonz@samsung.com
Cc: a.manzanares@samsung.com,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org,
	slava@dubeiko.com,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [LSF/MM/BPF TOPIC] : Flexible Data Placement (FDP) availability for kernel space file systems
Date: Mon, 15 Jan 2024 11:46:31 +0300
Message-Id: <20240115084631.152835-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Javier,

Samsung introduced Flexible Data Placement (FDP) technology
pretty recently. As far as I know, currently, this technology
is available for user-space solutions only. I assume it will be
good to have discussion how kernel-space file systems could
work with SSDs that support FDP technology by employing
FDP benefits.

How soon FDP API will be available for kernel-space file systems?
How kernel-space file systems can adopt FDP technology?
How FDP technology can improve efficiency and reliability of
kernel-space file system?
Which new challenges FDP technology introduces for kernel-space
file systems?

Could we have such discussion leading from Samsung side?

Thanks,
Slava
