Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EC61E502
	for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 20:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710102150; cv=none; b=gS4dbL6IMH9f2kohWBFSxlJwO8k64Ir04vWRz3c6O14m7tSB5Jbi8xAVS9yw2vp5LnsCy0KLgf0UHugrqgQ2mhihYp19pu64b8hgvWQacLD+nuNZUQ1CL1jCmCmV8ogeVJ+ei5N+K11Syb7UtCc1lpgd/n7D695DannTwC/vxHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710102150; c=relaxed/simple;
	bh=5GLYdRBXYaPayInyNzyZCfA3bU2rYudYy1uIlup/UBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PhVOqzJFJN5w0bknMsoY/GCgcHBTWfoJLTRHJvvAQMNeFin/+wU6jU4g/cxlT80owzSwpLzOsLR6cglj8L3VrnVegBDGZaOfgqo1qs+YpKs4Qv2E6skjybOROa0jS+C1dgcrESQdfEgsf07r+o3mud7H1bB95b4oOxaxS1EQS0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N+C7r9KK; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N+C7r9KK"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c21a3120feso1201529b6e.3
        for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 13:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710102148; x=1710706948; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W5AZLhIKNippDeEefLWNHHg2oZa7XZ4n3TMBlTllJs0=;
        b=N+C7r9KK0ZRYCQqCUpCyxfHBfKWnmZVpK/h7Vo2BGgWlHqNhLInpsTxrJDkkpcyIs3
         qhoeiOH47zknskUiMOCigLNZhnsK3iOFUMOz6XAbm1h+BAzGEf3hK52AlDZYHQvbrzD+
         0zk/ENqL5F8ZuDRVM6ktv9WShMxXyK2USYLLnzvLLffCCVdlE0hW1rgrS6sQaXxVC4h4
         1kakuzae96T5DbDDDg7dBUc/QtJ4IQXmHtaTRX4X5XIJgkHWWBxj/tQwQNcit52bYEk2
         yfuB38G2++g5QNFsKaXeN0IrnF5uWUHgWIMQkkz9Oyxqa9ROV1vRKCrhVOWFlPt2/CL2
         Kt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710102148; x=1710706948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5AZLhIKNippDeEefLWNHHg2oZa7XZ4n3TMBlTllJs0=;
        b=GVkdBPGayUSo0lWF9M6rtUimJOrvUdATbRQDhfnH2rgsn573knm921+k0ryNoa1NyK
         HdSgNrttlvIhI9OTnUedV2tz6kx5Fm6l7KIGGpQpa4M5+mCtnZi3QhnN0rQGgcH9idO7
         C1U76aXyt5W3Eha90nShfB+kA0SCtgjsNZgLKoNno/N+S6ugG57uZ6ZdgNGXazl2X419
         z6R3VVSyC/LA+iT/Xp4L1Gjl+rGS4aXkKqgpO225vwu/AlgOAk3xnI2Hu3JBy5NDzMjt
         +dVGFZyvoXv7xHwwTDJuPXOdzkEpSt1uyJ/VQc9N70H10gOkYSyrG0gxDiPl10JuPGQ2
         TqtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMsc6Vq52KEZfeijdlgHewM1OoSe2BroOKekShiYF79wYvXmeyltYA/RDMivTv+qd4DnM0pUhus2UB6mLMM6RNls5FsuZDNl+k/Q==
X-Gm-Message-State: AOJu0YwzWdrR3uhcpnA5ARiWlOohJMepg32dVbECbH+t/i8p8rHGs4FX
	HjRdUq4JUj9Mf+hBflP6QUERT+Ivt4xefb61Hn34m7WCM+TgCx94zbd0At+sXQ==
X-Google-Smtp-Source: AGHT+IFg1GfHhAkHASKD+D3gSfJN7aBpfcaxljlZLX0vDpnI/Sqgb3HZDTICFWAA61tEVe6yGCDrCQ==
X-Received: by 2002:a05:6808:21a9:b0:3c1:effd:726f with SMTP id be41-20020a05680821a900b003c1effd726fmr6643959oib.43.1710102148130;
        Sun, 10 Mar 2024 13:22:28 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:13:d1de:e5bb:fcf:1314])
        by smtp.gmail.com with ESMTPSA id j25-20020aa78019000000b006e2301e702fsm2848532pfi.125.2024.03.10.13.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 13:22:27 -0700 (PDT)
Date: Sun, 10 Mar 2024 13:22:23 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: John Garry <john.g.garry@oracle.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com,
	chenxiang66@hisilicon.com, jinpu.wang@cloud.ionos.com,
	artur.paszkiewicz@intel.com, yanaijie@huawei.com,
	dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] scsi: aic94xx: Use LIBSAS_SHT_BASE
Message-ID: <Ze4Wf2Cw52ZXQxJV@google.com>
References: <20240308114339.1340549-1-john.g.garry@oracle.com>
 <20240308114339.1340549-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240308114339.1340549-5-john.g.garry@oracle.com>

On Fri, Mar 08, 2024 at 11:43:37AM +0000, John Garry wrote:
> Use standard template for scsi_host_template structure to reduce
> duplication.
> 
> Reviewed-by: Jason Yan <yanaijie@huawei.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/aic94xx/aic94xx_init.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Thanks,
Igor
