Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26534233936
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 12:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790945480; cv=none; b=cSreGLOBJDCJdkAqZyCaTgLB00qWhqXCBJDmHuN8AzV3nIsRslEUCogh6dN9HmyXFTLSpmAG4AUBM76cZ3SCZQFj8q2TSH2hxzakOQjyLvG6ein59vlv4vvTpP8ueRUopitTKJFV27EXvR4swkwKzAQEElm5EiuNTgt5UNEQtpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790945480; c=relaxed/simple;
	bh=DN6/7ue80IksIhGOseKIaTQF5vAzBuWQWJAIhb2gigY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pty+vBz/ISc3CERSd+s0zlv5Ak+Vjfz+FSIO1aAu0mw8FUZvsXFQCjdWoIjbwMuAI2zjZ2dCx5WmJgCL5MS6uW5awM1wUvS9iTQ7kx/6H17t4q6o0oWjqov+KcfLG9rAIUUgtGoblJ+BI3URif9JtSAjHBqd2eT/jdFrIWfaYoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DMkaoAM6; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DMkaoAM6"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af4663da5so3168366f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 02 Oct 2026 05:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790945477; x=1791550277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rqy6pEqFoYmqvPw6OBjhCQ0EBbG6kK36+Qp0DgFgLS8=;
        b=DMkaoAM6GmoAt8hI+t7wqrwHgxmPhimZ6nn+DxUMD+/i8+QFk92p8mdNrR28ZOn9cG
         tDf9ok146VnXL6WWPaODUC3aLA2/p8ua2CDRaSrUshM12kYgS40nFauAxDE4nkSF+X03
         kAmefDb4z+uWW/9OPaHthro+MgOYwGMkKTEiVi8XNjjYHX6vR2ARfbgCUywh/HFkBmKE
         g8tVq9zBGY389cLOS7aaUq188HH9J6UWk5/VKgdRdolY+q+d1R9i4BUNmiJjb/FpQJ/C
         MZDizPF6Ll3p5gnkfs3BKGHS6yrTM4ViS+CglcvPQpc8ZZFzvj1AU28knoeLEn2Hm/IG
         rj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790945477; x=1791550277;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rqy6pEqFoYmqvPw6OBjhCQ0EBbG6kK36+Qp0DgFgLS8=;
        b=CTi+dwQHuaFvwBj+ddVkfStkl3T66+N97d6MubOc6vFFUH6TV1nWyYmZOg/vGqgTz8
         mBjUNcgbFGn/l2L7l/4+HhnsGpaJ3ngh6dyCeqDUFcnjMnvCtsrSZW6QYEFIC8zmH+bQ
         j1g5M4agHwJhoi7+auJ/oEkVDIk+rx5piLvcQJfw7v851ZBe/Z0fTCv5foqqwCoAALvk
         dWtGQU7Kg8aXCCJvHTHgsSxWzIWXssUwV9qcx9yT8OboCFdeWQd9afvxQ3g5mRr4gb2c
         DhVZ84Ya1Q89N9g1pHwxNe88ODj2eb6jhuCz3kOIzVRECLpI+Is742pU90DnE7B5STgi
         jHIg==
X-Forwarded-Encrypted: i=1; AKwUvBxLVt/lxAeZjvZFhJapSrMgeuzzw68XmMNk37i4tjLdghPLMlZzLcVQ4FSozv+UoPkc4YYQDYYmg3Cm@vger.kernel.org
X-Gm-Message-State: AFq9FYJicbCuVYx7R06W0B+k4koV/6zg+yf0jmpukwUDOf7pdbXC0EmC
	q+34jk0yxgy7r/D1y++I1dlYlH+Tq2YA4Ns5HQ6zHdNoFUDThsurXoq8
X-Gm-Gg: AYBFou2dWdfFBg3PILwpCWJfc1jUOQ64TpGWkaEpKpxasBZLyHK5pyGYok5sRbf7LYF
	DNzqrfyI3Vb2aDxC8HpjOYFxP9gpRlj0K38e+teyP1ySf1r7DncNmqIcKRAsmqFElQEqoLBaOJf
	vmB+pfc3dPODDQRWNXSGOMCx1V5NqKmiLhualCaGHKCSOJBqikgXxmsYp3toNpFFnoqrc5/OTvT
	nJG38Dvnd3BiPXffUWg7Lm/0/vUCMkKvOH2c44r2EQuRtWbfx+B/G//XLLv24POIRHUqmL4HmJ8
	gy7JYU8290Z/Hx3mtiw88ee2yP23BoJXXtzL9a3qAa7P8prTuL+Dtg2lP96GX/iPP+59cU+piBk
	9CuA1jkV813Y+D2sU0KxrahOzr5cBpuAwpyyZ62KOaD/ByL1wPhlDPV3X3F+pZSIli7pPATMVxL
	qhnHTwCZ3QxIhIPDMYCpjPbr9JiSBYD+tUq1JTph4EcVeWYVJanuVtnzsPsQvDOUB/7E61+MQqU
	TycUfH/2Q==
X-Received: by 2002:adf:e009:0:20b0:48b:1283:bb73 with SMTP id ffacd0b85a97d-48b1283bb81mr3702420f8f.26.1790945477275;
        Fri, 02 Oct 2026 05:51:17 -0700 (PDT)
Received: from foxbook (bfj133.neoplus.adsl.tpnet.pl. [83.28.47.133])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f04e2sm4861703f8f.15.2026.10.02.05.51.16
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 02 Oct 2026 05:51:17 -0700 (PDT)
Date: Fri, 2 Oct 2026 14:51:12 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: Oliver Neukum <oneukum@suse.com>
Cc: Jiayi Li <lijiayi@kylinos.cn>, Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on
 unbind
Message-ID: <20261002145112.3ee2b500.michal.pecio@gmail.com>
In-Reply-To: <813dcf3a-0615-4152-baa7-47b0046ca113@suse.com>
References: <d3639d68-0213-4b70-a771-aa5dc3ec9767@suse.com>
	<20260930013332.829717-1-lijiayi@kylinos.cn>
	<813dcf3a-0615-4152-baa7-47b0046ca113@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Sep 2026 09:22:49 +0200, Oliver Neukum wrote:
> > When URB submission or completion returns -ENODEV or -ESHUTDOWN,
> > it marks the transport dead, stops further submissions, clears  
> 
> Why this specific trigger?
> I am asking because -ENODEV comes relatively late in the process.
> URBs tend to fail long before that.

But it's sufficient, right? Apparently all we need is to detect
USB disconnection before disconnect() runs. This will do.
 
You may see -EPROTO earlier, but that's indistinguishable from
transient erros. -ENODEV specifically means "device is gone" and
-ESHUTDOWN is usb_disable_endpoint() etc or a fatal HC error.

These statuses should probably result in the SCSI command being
completed with error status right away so that scsi_remove_host()
called by disconnect() has nothing to wait for. Note that new
commands will be failing to queue due to usb_submit_urb() errors.

But UAS driver infamously has no URB error handling; if anything
goes wrong it just waits for SCSI core to abort the command. Not
sure why things are this way.

Regards,
Michal
