Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735357;
	b=q3v+Lps3c2IKuUX1KwC+tJktWNvi5exYfFYQG+IwnCJQ2yQyShlM7vMPPQqK+Hzhpz37
	 rNFTWbHuRKJcjqSj5sj4ubl0Hvtgi3BgyOQeA0f6LN9zkrvakOg758TUQM24gyZe5oKs5
	 I9S5JPgIsgbRLGhLcIsVQnWNn3oRy658wwLEPLUU2Dp6di7oKVH5yUhYeIPJ7cNdGtb03
	 +Qd6u5Kz2F3Fp1LwE+kwMJP3qDR5971hOvaIYzyja4cRWJGaz360+6q6lLk7INdlbpbLV
	 GXPocsemBFtHnLoNcou7b506tV8yRWpL+VP298Mv8UbWRBnX9tCn/6Up6yPSs+nYtNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=P0AC+ymgXYnQmZ+rTAXF3fAS8FaKmkjFTCnbuMJ/sUM=;
	b=XzEh+fdanC/3/eLQOyajeBlYiRXvY4f3LJbvmb7V4j/ZmbNxghXiwoKk3JKiO2/1sCdC
	 VyYQFzikfEBLEDlqkZiKH8I2TMO+eBBVleEs27XPFRbJAtZHpJi/7iZcPJpTwwzLfGI7b
	 STO57cDeb6hE7U9rOhxC3N9H2i7jzVxTDFOS/0Hsd/m5HHzHZeOsakdEShtX2P20ccvik
	 nLysWXtooLz3d+mHKowQuzHE576T0/nwjVRBF1F7fbT7tn/xwVjyhxRWC4N8HmcC7BrF5
	 ziYVEY41L+LgcJS+ewtOGeArzKAuOK3BLARR9czbE+mC1ai3kbAC9P0uLeZdhdmIABA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=aGZ2Et9X;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D86606A32D
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 19:49:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9D86606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=aGZ2Et9X
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36a1947498bso5137872eec.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2026 11:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793735351; x=1794340151; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P0AC+ymgXYnQmZ+rTAXF3fAS8FaKmkjFTCnbuMJ/sUM=;
        b=aGZ2Et9XRSoW7cbdfG5lGqV1+6xNkMS1R5B1w4VS3Ui4cwG+dA7ZizFdMHeq/+0/U2
         BilbKO1Fm20PtDD+HMuAm41zwNmvgYD1/eu5ZYOqs0KvvAzMehsm4uvfUZwfY7oaLBib
         FeozBa5ngKAi8pE181aL5qQbAJrKKuOySBVyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735351; x=1794340151;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P0AC+ymgXYnQmZ+rTAXF3fAS8FaKmkjFTCnbuMJ/sUM=;
        b=RaZmrBcLBu/a+prCF2NbOa7lc3PBE62VGmgBUk7RoJhpWxltsGwSZPhZbwVbvz1CEz
         9IHmZJC/6NMwv5uk3MwAwfXnsrAhhhcT9fiOMSl8xg3Mgp5wcncJye/aQqR4K1nkN/Ie
         GmLFtO1ZOQWST8nIoL39jIxu9Aq9V8SJc6BaHqtvqqJZcTXo/M0ijfrDDao01KWECPSE
         kheGRMb4lneWt0rA3dy74CZwKeMevBzpVwkXMwSMhibKJsciwHAaIoWX7Up+3e/enBhe
         lHunLDiBCC+MgmYSUc6ilFCxMfIWvete8odSyqRvB/G1Fnc/hF11ddSe0Xmv8Jx4cazN
         TuRw==
X-Forwarded-Encrypted: i=1; AKwUvBzLaE3fOpv2PVeGmWcFk6uPHUC0AdpB5wwS+MQrEAexyC7hHa0gOgXV9rXJmVeooLc5nGJRiSTkctlZ@vger.kernel.org
X-Gm-Message-State: APuU4Z9RqU9qYkInLzdXcGw9g5fzVY37jNWWczzEoEKpaxvpbWweGUAK
	w65wVquVAM0vKB7p2Yp0Tj9aatQUMrnWzgRViugOjzZDK4nVIGNOQ0D10KlQ78sYaQ==
X-Gm-Gg: AYBFou0F5MSUSO3c9r3CRaSIlhY7EQ48Nf4j94CgB9smyx8XNFnJfalfdSUzKql8YA+
	e2QFzd04OLvSQmKK7BkYedgxMQ16jDYAziHVzoycnhs15R/kIzMUmUodgQvJaOepm6fU7BT2hhg
	UCkUEg99nryyRRzaI84b6D1tppkbzs2EVf1GVo5eihiZ0Vk8bgv8BxLCEhO5Fb9fBTpCmgxjAdF
	whCDuG7jiBeChFo5kLSu1UOqjk+o56PPjdWXGACyZr8k1XXhMjqE5tMREZLIITroUghhpvkfoUe
	08Px8jRZP4o/ffNXFYFcGSJprdY+K5yu1swW0skEMGX9R46WPfpNbcx/i/FTHVsIKxFMOz3Q2eA
	FJ4xDCHmejeS8A6oxr1o4hsAxsjIfr4hbiRyvHxbL/sy5CXpznase4Slg6x8M8+3dfkTGRpDJG9
	q5rQM0E/YzbuzstSx78eKsxyzn84YR7tD9Eju/QEK090PwYlu2SLjVDURgqgUzC+8TkLcPRdAHL
	mUp7hZhRet+As/JfirjaJ+0yl9+waQLLmKfEq01kJ6xfL/lB1SP5VERZB76R01bV1z2MolEj/gB
	hROPKhjbwNVGg20cwmy8KGzzqI2DsgvKzC+nKB13+Yw4pz6f8D2dplLSdB4Mtc9EYlD6
X-Received: by 2002:a05:7301:4203:b0:36a:50f4:ed0d with SMTP id 5a478bee46e88-36a50f4ef92mr16355856eec.25.1793735350827;
        Tue, 03 Nov 2026 11:49:10 -0800 (PST)
Received: from localhost ([2a00:79e0:2e7c:8:ab71:b3df:693a:fbf2])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-36ca38a54ccsm382104eec.4.2026.11.03.11.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 11:49:10 -0800 (PST)
Date: Tue, 3 Nov 2026 11:49:08 -0800
From: Brian Norris <briannorris@chromium.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Stanley Jhu <stanleyjhu@google.com>, Jens Axboe <axboe@kernel.dk>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] block: Keep RPM_ACTIVE in blk_pre_runtime_resume() when
 already active
Message-ID: <auo6tLmH0R4_TRG6@google.com>
References: <20261029040001.2100001-1-stanleyjhu@google.com>
 <8125a75a-ea47-49f8-90e4-7f7c83db90e2@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8125a75a-ea47-49f8-90e4-7f7c83db90e2@acm.org>

Hi Bart,

On Thu, Oct 29, 2026 at 09:22:23AM -0700, Bart Van Assche wrote:
> On 10/29/26 12:08 AM, Stanley Jhu wrote:
> > 2. The first runtime resume fails in the driver callback, and
> >     blk_post_runtime_resume() sets q->rpm_status to RPM_ACTIVE and calls
> >     blk_clear_pm_only(), decrementing q->pm_only from 1 to 0 so recovery
> >     commands can enter the queue (intended since
> >     commit 6e1fcab00a23 ("scsi: block: pm: Always set request queue
> >     runtime active in blk_post_runtime_resume()")).
> 
> q->rpm_status should be changed back to RPM_SUSPENDED if a runtime
> resume fails. The changes made my this patch don't look right to me.

Pardon me if I'm misreading/misunderstanding, but I believe your
suggestion is essentially to unwind the quoted commit 6e1fcab00a23,
which might reintroduce a deadlock.

Brian
