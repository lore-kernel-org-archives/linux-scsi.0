Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09C1219E0
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2025 06:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750921062; cv=none; b=TAKC0o4Xcb/5uRjb2tIXKiKQUAQMUSTiJxPnCytQDu32lDwnkbRHMqDQVrcLEFwCysXDRfsZqOGb8GXncziYnJeDT5cOM99k2UdQ/oRVHvgl5fQko0bGfwVaKNw0DKXBpZmYSNehl+9jkuJHQQN9dETPyGhpLPn9TftcRtFGguY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750921062; c=relaxed/simple;
	bh=ON4pHfZjOHNvXFY9QPZUPYoUfbFKnygBHaZeZsDwMzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGo+Y4g5/WA//Whr3GRVG4DZjQqTkx8Ga1xODsf6AKkUuEg/MrBqHNCxsIYqBYV39xuQ5JUqsP373ZHjtoztkyDWF/HpOmGqV1rANBD0Q+zAp4wtU4SlWVEMKYNWTG5ODvSSGgzfOL2SnGyJCpDrp+Qt9ZI9Y5oWbaB/jA8VEHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JEw6xsk0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JEw6xsk0"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2366e5e4dbaso16914975ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 23:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750921060; x=1751525860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4Vig7M7ZvV+14zfziAcuZo4feguXVoSCTQV8AryWNE=;
        b=JEw6xsk0EeYhrKZOAAo6WnL5dGGNCnYh8VZn/Y6jj8yIJ10AnuypDpMqU4ssk3cAjk
         dtXw0RgQa6Hh4WZ+uzb9cddthMhakcUSTPu7p+nQ/uhbMHmZmDRxA56h7tDYodJ00cNQ
         /hHXG0g4aDKCqAAMAA3+1y4/1ELBVVnGLSsv2KbD/t1Z7XrHZkVkHPtivYYAoTh6Qqqp
         snJbiJfe4KBrcqB6a666dl8Ocuq/26EdnHC0M9Te5CA7UkTO/ETUXnuN8Rf6i+lKYMRr
         idf/CluESRFfxKE+VI//7Mx9K5AaWMK50TyI4wwG2226mZcPx/O5mfSs+8pPV/tVv5Wh
         M5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750921060; x=1751525860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y4Vig7M7ZvV+14zfziAcuZo4feguXVoSCTQV8AryWNE=;
        b=xC+I6SSZ/dyz6repdchyyLaTx9LdO8KE9e1nPSEbwF1v8QR+of/+I6RCW/LkJ029O+
         csjVmdkV1ME1chUvlisGiLeXiIs+Qu//jeZ4CiCGJe24boLGsr83vvewfGYlVo6r9izB
         ShsyBUaz30My79W4LZZ/1rC42GLCPj9uDimFWAF5bkXXDYyGkzmn8YJTUpXnKcxwlrEJ
         tAxmyWEPXahCfyNpBnEwAKvdwNjEIuD9oPNnm2d1tgLWo/hIm/0ebFMLMeuqxxT9dWu1
         uXgJDPGNFBme/BbBFlOCoHk/ZzxJNzVW5cvqJfid8RbMUrTqt545w2ZkpAdWkBR6gimW
         ro9w==
X-Forwarded-Encrypted: i=1; AJvYcCV2KN0c7CS8IH1jaE8FRBiVdFgOogRkUTBCG6Y+tj7OjOipard95gfM+l61Yz6Xrnw2o+UBk5vMbqWc@vger.kernel.org
X-Gm-Message-State: AOJu0YxIkjBFlTYbOstQKzHTIy9Q1zA9CJpjcGRJyzG343d+MmacPL12
	lHTsCB+8fR9RzHuCFdPNNFJ+Z/kzSrGvxN6Gy6zKf/aEH6yowoPq6zS3EUNStt2YuRY=
X-Gm-Gg: ASbGncuFeLV6tlMJFl8EGaC3WB5BsOt6mU8Y0RsFkOPwzH755ipFP7M35KychyS/Chh
	e5QLTiIbSzRAWnjr05vup/1lgwSTjMP0wHPHUrVca1TBQlWsFCbw3+be0p9EVCCqqtEl/aGNr0l
	XADNJiw8I/hY/CLC5+JTN0pB3U45goaVNEdEvI8Lk91PdRYfqc8/GzxeBcwVHl2S7RtmzlMnM5a
	hdFeMOEy3nJ8YACZV2lHDWJsvn/0AryEk6GqHhU2V6ObfIZhP+aARURtG0Ae3VSErdtmhBZPKDj
	02PDprMwB+ExpZgZkSNCkWvdk/KZRUiev6rWQHmvGmSI0B4g826Hi3KX9Ic+lOpVeXcj2Psl1lm
	L7b0=
X-Google-Smtp-Source: AGHT+IFMQohfiMG4tbP85u+fzwYzq9uXFaqf1k6qgiVNQ4h+jQ2TyJdVgYw1OL5lP+mJ4i6rhpCWHg==
X-Received: by 2002:a17:903:2450:b0:234:71c1:d34f with SMTP id d9443c01a7336-238e9e1ab43mr34039265ad.8.1750921059733;
        Wed, 25 Jun 2025 23:57:39 -0700 (PDT)
Received: from H7GWF0W104 ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23807231407sm54685805ad.54.2025.06.25.23.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 23:57:39 -0700 (PDT)
Date: Thu, 26 Jun 2025 14:57:33 +0800
From: Diangang Li <lidiangang@bytedance.com>
To: JiangJianJun <jiangjianjun3@huawei.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, hare@suse.de,
	linux-kernel@vger.kernel.org, lixiaokeng@huawei.com,
	hewenliang4@huawei.com, yangkunlin7@huawei.com,
	changfengnan@bytedance.com
Subject: Re: [External] Re: [RFC PATCH v3 04/19] scsi: scsi_error: Add helper
 scsi_eh_sdev_stu to do START_UNIT
Message-ID: <20250626065733.GA13649@bytedance.com>
References: <0088ad17-37cd-4425-bfca-d03595c91cd2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0088ad17-37cd-4425-bfca-d03595c91cd2@huawei.com>

On Wed, Jun 25, 2025 at 11:37:09AM +0800, JiangJianJun wrote:
> > From: Wenchao Hao <haowenchao2@huawei.com>
> >
> > Add helper function scsi_eh_sdev_stu() to perform START_UNIT and check
> > if to finish some error commands.
> >
> > > This is preparation for a genernal LUN/target based error handle
> > > strategy and did not change original logic.
> > >
> > > Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
> > > ---
> > >  drivers/scsi/scsi_error.c | 50 +++++++++++++++++++++++----------------
> > >  1 file changed, 29 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > > index cc3a5adb9daa..3b55642fb585 100644
> > > --- a/drivers/scsi/scsi_error.c
> > > +++ b/drivers/scsi/scsi_error.c
> > > @@ -1567,6 +1567,31 @@ static int scsi_eh_try_stu(struct scsi_cmnd
> *scmd)
> > >  	return 1;
> > >  }
> > >
> > > +static int scsi_eh_sdev_stu(struct scsi_cmnd *scmd,
> > > +			      struct list_head *work_q,
> > > +			      struct list_head *done_q)
> > > +{
> > > +	struct scsi_device *sdev = scmd->device;
> > > +	struct scsi_cmnd *next;
> > > +
> > > +	SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, sdev,
> > > +				"%s: Sending START_UNIT\n", current->comm));
> > > +
> >
> > As in the scsi_eh_stu, SCSI_SENSE_VALID and scsi_check_sense is required
> > before calling scsi_eh_try_stu.
> 
> But the SCSI_SENSE_VALID and scsi_check_sense has been called before calling
> scsi_eh_try_stu, see in loop devices in scsi_eh_stu, do you means re-call at
> here?

No, I meant that SCSI_SENSE_VALID and scsi_check_sense are required in
scsi_eh_sdev_stu, or perhaps we could move them into scsi_eh_sdev_stu.
