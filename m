Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C311A0BE0
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736325094; cv=none; b=V7MdAJn5Wl7P+kUv1DCEAAd5PzPJL6p20vOattf2ySyTWTvqtHZcmVONiA9IuhtiRBESmYqUgJY+Zncmj9FDnO2LhwqcFoYkNghe1u5lvGPCa8KRzSKnyU0FAtPgpyPVlEYayEcTit0BZFkHGHHQywulfotCmg5eRgxw3Juvrt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736325094; c=relaxed/simple;
	bh=Bzs2e7QsDs9RDz4VMTIhWKcqMJcsFXSu+5fSQyNjB1c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=W9wYUFmUFW1NzP5PvgAzIkg483vhPJYgn4QSlgY5wQCz4ZAToG3PbKjVfNkkE+LIQWZlFUOWte3LoFpKJ8YyQ1is3OGmutlZ5wlmHfhdJuFUf4bH6yWtnLXuUulfvj5xvlw/Sw/PFAbPZmTXhactf/L1vksZD2wP4wczuFDfj6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EC28b59P; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EC28b59P"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38634c35129so12634566f8f.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2025 00:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736325091; x=1736929891; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AFs1K43243tx/gfO7cqwcr3K80lvlfp/e4fzp8mtSNo=;
        b=EC28b59P1upr5Ayxv5DgWfR2uIEA/nH4tyuEBflJwKfwGN49j1NIJEhUbWwPTTsipq
         IGh/an46q6VAuXoOuRSXjp31pLQhgwDpbkdeh7OtvZmuqBl2tmm1bdp4gDjIqY1l/R58
         J86rWCpmTE+k1Yx+6lak1vGj2mek/ugVYG42P3XcxdrWWs2hVD0k5qRRBob8368abWWx
         ivAlrRLDLWGBiLkcwY5Keez6vJrU4esTFWuPfduY5LXdUw86lRpaipXQie5wT4/CmKrA
         loqbrCNZyUoB2lB6JzgmX4YsPbRgCilRlwErJSF0CzT7nR63qJ9u4UIxTA/h4pYJNUi0
         R0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736325091; x=1736929891;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AFs1K43243tx/gfO7cqwcr3K80lvlfp/e4fzp8mtSNo=;
        b=Xm7neQt/LtPTDrD6YPqzylfiSr/QYomMEgHk04X0bAOqdmz3W+GS+R1SXWjblYX5uv
         AhSrqtKYb4JzN0qKK2JS9XaTS2sbb+XORkOEFY9JpGcf24oZtB7m3heAbrL0/HERmCvC
         8V75JeTPwwYNqbMDnlTaI2DS6xQnGlT1SshP7E8R1w4c2r8XpO0Rf8cNak/nAFS9XicK
         W/1HhwuUn1Onx/nsJGouCONChAhDVTK1FxHYmdWbl4bbyFTcrxe3XN57z3k5NwtbsT0C
         Ls6c2HKbE1fDAtZ05nbXdqiw7wmI0VDPy950TWL0VerZ1N42SLFfEgzxJJSXWQSIWIjj
         RBLQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9ouCIiwf7WBP87z0Jlt1F8dzuKCWZtZInX+xob9TLynhPxTZwA02tUjkzmrh+HanOtcc/6CEGhLWo@vger.kernel.org
X-Gm-Message-State: AOJu0YxEKiZP1dUXhQIr352RJUH/Abfdu1iDTWli4hz0ZCufjKjMlHfp
	tlKB2/wTrcbWJTamV8EuOdjeEd6QFkgPqUnLn92TtdwjwP5y1fS8zUftvxs+A/s=
X-Gm-Gg: ASbGncuMv+Q4eMgfjx25GRx29LuHRyOTe7agFXPr2Y2xg/auGQnOAmE+5lNex/SCJ42
	mQk0R5M+g9EMptQu68h+fBFp+4VoFVmZJR8xRMRmJTwbWfpgynr1I96YUyMCxelNbx6qywmncKM
	N8zaBlKiALJc8BVs44rq+Y7crddLT0jDehZ9mZb8bPyrbOmwwb7/TT8ZFeMKt3G5XpQOES+oOyT
	uywzShgMTaqEb5o/yAKDPRl9X83SBO8TEw5t+ECwfezbwHmhevnAIIgAPGuSQ==
X-Google-Smtp-Source: AGHT+IEekKhcfmrJWcNCSKBuwIyEUsxTaZ+SAH7WrlV1pES8bLej52b4bGfmsZ0376cXImzObKpeYQ==
X-Received: by 2002:a05:6000:1f82:b0:385:f560:7924 with SMTP id ffacd0b85a97d-38a872fc5cbmr1155953f8f.4.1736325090766;
        Wed, 08 Jan 2025 00:31:30 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2df3610sm12801015e9.20.2025.01.08.00.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 00:31:30 -0800 (PST)
Date: Wed, 8 Jan 2025 11:31:27 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpi3mr: Add support for recovering controller
Message-ID: <83f63c99-0964-4572-852c-aa01b015b994@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kashyap Desai,

Commit fb9b04574f14 ("scsi: mpi3mr: Add support for recovering
controller") from May 20, 2021 (linux-next), leads to the following
Smatch static checker warning:

drivers/scsi/mpi3mr/mpi3mr_fw.c:4605 mpi3mr_memset_buffers() warn: sizeof(void)
drivers/scsi/mpi3mr/mpi3mr_fw.c:4606 mpi3mr_memset_buffers() warn: sizeof(void)
drivers/scsi/mpi3mr/mpi3mr_fw.c:4608 mpi3mr_memset_buffers() warn: sizeof(void)
drivers/scsi/mpi3mr/mpi3mr_fw.c:4610 mpi3mr_memset_buffers() warn: sizeof(void)
drivers/scsi/mpi3mr/mpi3mr_fw.c:4612 mpi3mr_memset_buffers() warn: sizeof(void)
drivers/scsi/mpi3mr/mpi3mr_fw.c:4614 mpi3mr_memset_buffers() warn: sizeof(void)
drivers/scsi/mpi3mr/mpi3mr_fw.c:4617 mpi3mr_memset_buffers() warn: sizeof(void)
drivers/scsi/mpi3mr/mpi3mr_fw.c:4620 mpi3mr_memset_buffers() warn: sizeof(void)

drivers/scsi/mpi3mr/mpi3mr_fw.c
    4590 void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
    4591 {
    4592         u16 i;
    4593         struct mpi3mr_throttle_group_info *tg;
    4594 
    4595         mrioc->change_count = 0;
    4596         mrioc->active_poll_qcount = 0;
    4597         mrioc->default_qcount = 0;
    4598         if (mrioc->admin_req_base)
    4599                 memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
    4600         if (mrioc->admin_reply_base)
    4601                 memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
    4602         atomic_set(&mrioc->admin_reply_q_in_use, 0);
    4603 
    4604         if (mrioc->init_cmds.reply) {
--> 4605                 memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));

This one should probably be:

	memset(mrioc->init_cmds.reply, 0, mrioc->reply_sz);

sizeof() a void is 1.

    4606                 memset(mrioc->bsg_cmds.reply, 0,
    4607                     sizeof(*mrioc->bsg_cmds.reply));
    4608                 memset(mrioc->host_tm_cmds.reply, 0,
    4609                     sizeof(*mrioc->host_tm_cmds.reply));
    4610                 memset(mrioc->pel_cmds.reply, 0,
    4611                     sizeof(*mrioc->pel_cmds.reply));
    4612                 memset(mrioc->pel_abort_cmd.reply, 0,
    4613                     sizeof(*mrioc->pel_abort_cmd.reply));
    4614                 memset(mrioc->transport_cmds.reply, 0,
    4615                     sizeof(*mrioc->transport_cmds.reply));
    4616                 for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
    4617                         memset(mrioc->dev_rmhs_cmds[i].reply, 0,
    4618                             sizeof(*mrioc->dev_rmhs_cmds[i].reply));
    4619                 for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
    4620                         memset(mrioc->evtack_cmds[i].reply, 0,
    4621                             sizeof(*mrioc->evtack_cmds[i].reply));
    4622                 bitmap_clear(mrioc->removepend_bitmap, 0,
    4623                              mrioc->dev_handle_bitmap_bits);
    4624                 bitmap_clear(mrioc->devrem_bitmap, 0, MPI3MR_NUM_DEVRMCMD);
    4625                 bitmap_clear(mrioc->evtack_cmds_bitmap, 0,
    4626                              MPI3MR_NUM_EVTACKCMD);
    4627         }
    4628 
    4629         for (i = 0; i < mrioc->num_queues; i++) {
    4630                 mrioc->op_reply_qinfo[i].qid = 0;
    4631                 mrioc->op_reply_qinfo[i].ci = 0;
    4632                 mrioc->op_reply_qinfo[i].num_replies = 0;
    4633                 mrioc->op_reply_qinfo[i].ephase = 0;
    4634                 atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
    4635                 atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
    4636                 mpi3mr_memset_op_reply_q_buffers(mrioc, i);
    4637 
    4638                 mrioc->req_qinfo[i].ci = 0;
    4639                 mrioc->req_qinfo[i].pi = 0;
    4640                 mrioc->req_qinfo[i].num_requests = 0;
    4641                 mrioc->req_qinfo[i].qid = 0;
    4642                 mrioc->req_qinfo[i].reply_qid = 0;
    4643                 spin_lock_init(&mrioc->req_qinfo[i].q_lock);
    4644                 mpi3mr_memset_op_req_q_buffers(mrioc, i);
    4645         }
    4646 
    4647         atomic_set(&mrioc->pend_large_data_sz, 0);
    4648         if (mrioc->throttle_groups) {
    4649                 tg = mrioc->throttle_groups;
    4650                 for (i = 0; i < mrioc->num_io_throttle_group; i++, tg++) {
    4651                         tg->id = 0;
    4652                         tg->fw_qd = 0;
    4653                         tg->modified_qd = 0;
    4654                         tg->io_divert = 0;
    4655                         tg->need_qd_reduction = 0;
    4656                         tg->high = 0;
    4657                         tg->low = 0;
    4658                         tg->qd_reduction = 0;
    4659                         atomic_set(&tg->pend_large_data_sz, 0);
    4660                 }
    4661         }
    4662 }

regards,
dan carpenter
