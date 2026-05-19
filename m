Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E703B367B92
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779210615; cv=pass; b=QaiLEuDmjit2DZRU0xDMWyzKlwYKVKkPp58PbsDIZ3lnqYbwPHLPKVCk8Q3Se6uyjEOmEWZIO+txjQoBMae1FkvpxhVbwTGo3Qvd3P2mCgyJLTD+FPrtMJu5Pwihd/zXGkcWB7MNUn9mdqSIPpBh6xK8+ssEOkkmHKYsEVj1jgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779210615; c=relaxed/simple;
	bh=zeMpKmjnilzJ3uJp2jPn2DhDAOjS5UDXnCw47Sp6a4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Heg3b1Ag1pYPUOZX526SzIp4FlQO4rZakJMh8uWFj6xoNUH3NcB3k53N+1Y2X0rw3qRbPOvYSVARluMtCOVaR6KG0EPIN5Yc6eRW8PiE0u90M+6ugIgEg56bYWuri6eExJqaPAej5UHIjlzYNugt8bm9NAYTkpSvt6THuuFMDWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LTvPXJri; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=W9u11/6H; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTvPXJri";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9u11/6H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779210612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zeMpKmjnilzJ3uJp2jPn2DhDAOjS5UDXnCw47Sp6a4Y=;
	b=LTvPXJri0puGlp0vDzxdsBUfOeo2qYxw31ozuqbb7tcZtnem42H2CL/VDmGIqk5n30uZjT
	07hbRQ7AjQIn4T1qrTbOxqcMgBoAMpF9dmdguIhWEoAcIVgC6H8u/6xv9TeRfJU2UQuvAS
	Om6o8fykvx1qikyFAn9VSSujc97gO5Q=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-kU5mwZkCNAScVC19T7srrg-1; Tue, 19 May 2026 13:10:07 -0400
X-MC-Unique: kU5mwZkCNAScVC19T7srrg-1
X-Mimecast-MFC-AGG-ID: kU5mwZkCNAScVC19T7srrg_1779210607
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-960476ee6f5so1313292241.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 10:10:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779210607; cv=none;
        d=google.com; s=arc-20240605;
        b=FJxlvxIutvyb6bGZm2aqb4UfzfKw7VRqT59uAaKeuneo8RqXK7J4dZxTeTuwzPZW88
         OJSv+rII2VRfJQL/spyWhnuGGp3Qwhb2UMEWKzxHUykcfvVtwJCMvjp4h9UrmUpXlXWY
         Regq8HlwSwyo5LKxfvZjE75cDkKeDozrdpWNZ8LSAMq+gB33xLuP5VAiqj8m0XWLBDGg
         QT9Sy1KVWRQDAz1cw58gCWz+FeQBJlaJLz/0yXstDTXTGZsgYW5DA38CSzrz7tyK2eGA
         simfMIOB071C3KCSW8dhNRaEGLBKLuPDtKMndMDagIplcclQO50Nqzx+ADRsvITreoqK
         0SRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zeMpKmjnilzJ3uJp2jPn2DhDAOjS5UDXnCw47Sp6a4Y=;
        fh=tScm2eAN0HS9mCdl3iBYquTZsazadfL7sZDsu6+Quyk=;
        b=UiL55BceTX9pyZrrtEnso3rKtB5MGhkZachUQAHJunxHBUVjtxau6GCjHhiMSiJsF5
         Gj48X8Q+h816h0EGIILCFRm1CQ4beGWif+EMGELHjjZ7mZ4Vw8Ub9aB5gbtMJlnDBvcd
         8rxtjYF7+9+tols9qNqK0MMP81+c6SKo0EddcsktCE+IhttsgtFLCdPoP6XGnRePtwDO
         O+JYmPtds8bd8PpFrxBrb9SY2iJFKOGZtbNCQPjt7i+GPkcT5s+ZG/Cxrd6k0WmZ9x0P
         qwGkhp83pApsx6VeCE3+L9U9gKUdpYt8cmOmJpDeLgp1oKIETl0vYbETI4VjjkTeEH20
         +qVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779210607; x=1779815407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zeMpKmjnilzJ3uJp2jPn2DhDAOjS5UDXnCw47Sp6a4Y=;
        b=W9u11/6Hkek2bsj3BRks26bgagh6Vh0k4a/DRgAHLQRk0i6s7BqMZ+0rNOQndazh/d
         VHSk+zX9ew2Qe44hqly9G/F5sfOmbrRr4kQpDB0wgMgwi5RjSnSZH3JscruBSJlGj2j3
         PPRtMw2DnjG+zwBHSVGnFKoavC83dW6ZEKeaO/OOqCaEa60pCsrsgBoTKauF+jQx914M
         QTZlX4OCTP8W1IZ+0VydKQPSn1843RkhgzHYeb4ihkgzdbmefLc2UX0WpyM6xfqK7ZLF
         fCHQ7vs2Mv8Jm1vkW2TVzc0rjtEC4x9SbBptkQPEqymkmXQBZdAJG0RihVLp6Ub+rtES
         0qIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779210607; x=1779815407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zeMpKmjnilzJ3uJp2jPn2DhDAOjS5UDXnCw47Sp6a4Y=;
        b=ezG3uF86Js4AyZ+CLpnc4eoPCpDig8EwZOHGPLvPDArsee4eIL8qfk37TYk9eRvrpq
         45T4/sIK+xK4sKw8m0HUjbHEXnV4H/gLbIY4NLi2N27UgZW4F0e44LqCnJjdRAwLJUnS
         cwERjSltdey7CqYCrC1RCqWUNszuX9yBnsuIgyZ1/H+qn8TqhUFyIdi/5s4IWaYuJckb
         j6TY+I/SviJREavhOfTupWLj1xTu8N2gBNRmJc3T8/xP9gqoangEUSFYr9gKSyh2xsBX
         4CaDbcz/Q4VpNJ+z6C2FgjL3ZGPDjwxfyXBMsq5SGm10GeMrhl2aBInGiGa7qhFBhvTI
         7UEQ==
X-Gm-Message-State: AOJu0YysuY51Wm/UWtvt1XC08MM9q+VD1rU4H89FSA7ZUXe8sTF8YWic
	5QtYipwSrlJb9J+QzKmShgwrE7xhXtiz1WJvQQskBuaIVZkX0IZ/5bfx+JkBrirfKevq3l6+QcO
	/l7ZJ12eONIlz2wU1zV8sX54g5mpHjTdAiPstKtXvAp9/lZCN2Q6FngXYs7bzfu1BP6nVrjmR+O
	/I2SSEYFtt6q5oS1hjo80WBn38tk5JfRvuLwp6OOohYhp+Qj0T
X-Gm-Gg: Acq92OHoCUQnFigGLpcRiwGAerjDojSRT76F2jaj61aK1+omHECpcAViOa2vmPmYLx9
	LrejQ8YE5PcIf/z+P+wqPCehih6SvCdlpy9DL6nii7R6NZiU2tBYOP4/5LCuyBEcbEGhIRmulio
	dfx/yA3saTKX2Cve5hiXrU/VVo/antxdKiQEGvY2uCdqQsxfC7WVOg2kNSbsx9dn786M9DhV275
	1zfk+dFYglJ0qqn/utaxcGL4qctyxnPyDQDYzrON9xDXwVrYxWcRxm8SsLG
X-Received: by 2002:a05:6102:6051:b0:611:17bb:934a with SMTP id ada2fe7eead31-63a3f98ec5fmr9210434137.28.1779210606724;
        Tue, 19 May 2026 10:10:06 -0700 (PDT)
X-Received: by 2002:a05:6102:6051:b0:611:17bb:934a with SMTP id
 ada2fe7eead31-63a3f98ec5fmr9210349137.28.1779210606151; Tue, 19 May 2026
 10:10:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515181112.9758-1-djeffery@redhat.com> <b020a37b-ded6-4fd7-af4a-f4553a72717b@acm.org>
 <CA+-xHTEc=Q-tGLgvDBK=upzgqyiDuusBzNnw2-L+PftJs6ir2Q@mail.gmail.com> <577f9fbb-fd99-4aaa-976c-b217c2bc9711@acm.org>
In-Reply-To: <577f9fbb-fd99-4aaa-976c-b217c2bc9711@acm.org>
From: David Jeffery <djeffery@redhat.com>
Date: Tue, 19 May 2026 13:09:54 -0400
X-Gm-Features: AVHnY4JZOQQXLfViL0U43Kzd2ffB4cFrOrvoSAku2D8eWE2bCYKwcppkvI8DqWM
Message-ID: <CA+-xHTH0roAODU5gNaWYL2L-D-kP-ec=iBWp_NMt9JE=W_=anA@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: wake eh reliably when using scsi_schedule_eh
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 4:44=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 5/18/26 10:53 AM, David Jeffery wrote:
> > The scsi_dec_host_busy comment may not be completely clear from
> > condensing too many details on how and why it works, but the RCU usage
> > does cover this type of race. The rcu read lock combined with the rcu
> > callback will mean the execution of scsi_eh_inc_host_failed can only
> > happen at a point in time where any active call to scsi_dec_host_busy
> > is guaranteed to see the host as in recovery and take the error path.
> > And the error path's memory barrier and locking will then work with
> > scsi_eh_inc_host_failed's ordering to avoid a missed wakeup.
>
> Hmm ... I think there is an open issue. As the comment above
> scsi_dec_host_busy() explains, the implementation of that function is
> based on the assumption that scsi_dec_host_busy() and
> scsi_eh_inc_host_failed() are serialized. I don't think that the RCU
> API guarantees serialization of RCU callbacks and code guarded by an
> RCU reader lock.

I wouldn't say serialized. Synchronized is probably a better
description of what the code and comment are describing. The use of
RCU ensures that any scsi_dec_host_busy call which may race with
setting the host to in recovery will be complete before the rcu
callback runs. Another scsi_dec_host_busy can run in parallel to
scsi_eh_inc_host_failed, but it will see the host as in recovery and
take the error path because of the RCU synchronization and ordering.

This is getting a bit far afield from my proposed patch. My patch uses
synchronize_rcu() instead of an rcu callback as used with timed out
commands, but it's the same principle: use the synchronization effects
of RCU to ensure any scsi_dec_host_busy which may run in parallel will
use its error path, thus using the needed locks and ordering to avoid
missing a wakeup of the error handler.

David Jeffery

