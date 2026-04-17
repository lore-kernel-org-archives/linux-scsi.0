Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FDF33F8B7
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776442292; cv=none; b=OZBdFXDvq5TFpUE/nJATYSJaN0WpWw0jXyWNFOKaY6DmNVmrosMl88b2jDNpqV8L7BshLUQ2DYVV4QFphvOZivPc0X/ldJ7818EV1ywgER99qrUVyFtiiX/09G8tuPcsuYlcnsxIJt3DAwDNWxkwuq7F7nzOCahs92oasWtcT2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776442292; c=relaxed/simple;
	bh=WF57saiDQPuLgei3ntL2rXLAGu55hVNv5gn2ybVfrAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9hNwESn1fk7nPMhNKkbUuDW3c/jNbgDgXnWQ3Fw9lc2GnU8JCPBCgeBiXxk/nSia6uVtfS/oYc28V5hNCsO53w7DvyFpwgrj1oahZlILT2qq3kVxxmSMdWgwwsowYjIC90DQY1Xs2VwBdcK6Sa7NX02GTbAj1YcAIxaw69Bmk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Si1Ttrv6; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Si1Ttrv6"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48897fd88ebso9260525e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 09:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776442289; x=1777047089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WF57saiDQPuLgei3ntL2rXLAGu55hVNv5gn2ybVfrAg=;
        b=Si1Ttrv6cEHTjA72bV+np4M6baGUM3CYgOs/WZPuLR0MuNnm5EmSq3fRBYqsMB8bTZ
         yXkZ0yzXw1uckNPZCtonfFfJZCiFW7Q1+c9Y6e2JOQ6u20qyicGzcpBHSCTroVVaVK74
         dnR9clhBIYHTSxe7W5V/r/i20/DDqfpFBqKgawA79uk3GNiS7Yg/r59UuzPDdD8UGyVX
         AZ6reanv/zGaAjFGN/qs60H/+SR7skXdupPFrivHWqyMSa5rRboyT3kH1MZlrPx9PF8k
         wFG3zxHuMGg4RRpUnhFQYT/YRSPvJAoFDLHXIJ3Jp07WNsrxHJPjOshysRBFaHd6A+sT
         z/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776442289; x=1777047089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WF57saiDQPuLgei3ntL2rXLAGu55hVNv5gn2ybVfrAg=;
        b=Kpn2YgoH3MILCIOvzYFZmE8M6SiazqPlNLQ1r/8Fw7LmTyaDUmVHoWig2GfqGYEWJH
         Pz1JYzILUInWlAwRNLn0Ot9WMqs+3gZ8UpyS10/UhDo1Ar4UJRluUnzQGaPr3Rbm4MS8
         /GTvlfA3X8N0u3X5etEcL9JuoJ+GH9PpX4lcW44ltZK6sq5d1CIkziIkVt3+/0Cf8rcu
         vpX9Ix7tqHn+MOQhVSkcpCzF8d3BOfjQ497xwhg03IFfqaXa/jNRDpX+2kIlNin5OYK5
         XbsouWxlSvp0N5K05vSVDxqhBWVCLOydZnVaOyygLt2EdVDBD19Z7yFdfY9iC6jHFv98
         7Xzw==
X-Forwarded-Encrypted: i=1; AFNElJ9N+zcLu5EqkS/D3JhH6a6QhUKUiZu62IQZJgbNuDcMdUAv44m2YhuyKcYZqQgeVdGXrAciltX7Gdj1@vger.kernel.org
X-Gm-Message-State: AOJu0Yya2x/icz2rDREjP2V1CaBuoTpXlrxZm6MDHd22r/JzlmRDqy2N
	ha1zy06DECYyNWiWRery+uVs+SL7LwOO0gvxjGfmvuRlslRPmvbq+RPFiys8pKQ4nHg=
X-Gm-Gg: AeBDievDN11wF4glS3F8MNA4y1vfPjsZu9GSfPLCHaeRFdu7Dxf2abZ0Wm/lQrFuJ7O
	7pidoP6s6k+3KmVFp/n0aEw0k43PJsqhSREa1s8BbZFXhwxjEu2XXx3DDkqjd67ldfRHWgzk8He
	uQYv/nMz72GJ8FxJG2YplLR+5byHRcdwvQy4CP/tBd2AHhJSURIHLV9M/8bkm+E1FAwT7i1IIkN
	8kNtfoxwGSKnNAQ03hZjq/C6sDQGHdbfUjbJXeKsMbyFlnoNGjWpbL080RMKfUs6l6gjAu27xDq
	kFVRssBWBjIJ+8zwM32PkHxZYkT90gZcUnBvuIqst9MkxXaJ6eDbiufAorz33O96B22+wTf2nB1
	qQw0IybOWXVpllPsbnqpP2CqW+DEpKh11KWRgV7WgCQ8jXsiuTHMiYjH33DEfrJdXQYYbBHhbSN
	5P8OclNp0mlsCu4giEye1iDBBpRfu9J8FGfJXppb3zB5szIpJKeHBsxRE3DQ==
X-Received: by 2002:a05:600c:6296:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-488fb73d764mr52764605e9.1.1776442289414;
        Fri, 17 Apr 2026 09:11:29 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1cfbf2sm54863625e9.15.2026.04.17.09.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 09:11:29 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: atomlin@atomlin.com
Cc: James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	aacraid@microsemi.com,
	akpm@linux-foundation.org,
	axboe@kernel.dk,
	bigeasy@linutronix.de,
	chandrakanth.patil@broadcom.com,
	chenridong@huawei.com,
	chjohnst@gmail.com,
	frederic@kernel.org,
	hare@suse.de,
	hch@lst.de,
	jinpu.wang@cloud.ionos.com,
	juri.lelli@redhat.com,
	kashyap.desai@broadcom.com,
	kbusch@kernel.org,
	kch@nvidia.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	liyihang9@h-partners.com,
	longman@redhat.com,
	martin.petersen@oracle.com,
	maz@kernel.org,
	megaraidlinux.pdl@broadcom.com,
	ming.lei@redhat.com,
	mingo@redhat.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	mproche@gmail.com,
	mst@redhat.com,
	neelx@suse.com,
	nick.lange@gmail.com,
	peterz@infradead.org,
	ranjan.kumar@broadcom.com,
	ruanjinjie@huawei.com,
	sagi@grimberg.me,
	sathya.prakash@broadcom.com,
	sean@ashe.io,
	shivasharan.srikanteshwara@broadcom.com,
	sreekanth.reddy@broadcom.com,
	steve@abita.co,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	tglx@kernel.org,
	tom.leiming@gmail.com,
	vincent.guittot@linaro.org,
	virtualization@lists.linux.dev,
	wagi@kernel.org,
	yphbchou0911@gmail.com,
	Marco Crivellari <marco.crivellari@suse.com>
Subject: Re: [PATCH v11 11/13] blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
Date: Fri, 17 Apr 2026 18:11:16 +0200
Message-ID: <20260417161116.373130-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416192942.1243421-12-atomlin@atomlin.com>
References: <20260416192942.1243421-12-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Seems like the commit log of this patch is duplicated, isn't it?
I noticed it's like this from v7.

Thanks!

--

Marco Crivellari

SUSE Labs

