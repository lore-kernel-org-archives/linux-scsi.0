Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243DC1369B4
	for <linux-scsi@vger.kernel.org>; Wed,  3 Apr 2024 10:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712138909; cv=none; b=UxwDxlPtgCoBYcjhlZsdkaIVPQPH1dBsxsCmWuO0QAkl96BzHt0XqOUz/o97yioN0Yw0o0JOwEGC91rXM07eYLwXdzmgvbWDP1LlQUa1B8aeWe8M3krJp7tTmZkBXF+kNN8YSf/jF7rAilTUDWvX/1D38zj+qH2hDqxRSHdJiCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712138909; c=relaxed/simple;
	bh=tgcVhTYrRzmoTcflsh0VgF8L5H/W8bV8Kpysf+zQ2F0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jWdYAhSVbW9oUK9UJQSFGAAF/XKfenzGRoc59HxpqofezcLl+bRIyvVy3ot5hDI2tqNfsC6qkU8s/7cJ167Tg1RjquDWd4od8SWN2MjWc5A3qIhJNQh4u1cXn16xfKelILJYAadsQUu+P6rekCMIgQdDFgn7KZIqheDjv3etvLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mw/l7HRd; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mw/l7HRd"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a46a7208eedso801041366b.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Apr 2024 03:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712138906; x=1712743706; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ff6r0nM2jqve3wLbTBtxoKS5Lyh/O9KeiAcAQUgwEb4=;
        b=Mw/l7HRdpr/ADAFugczbF/N7GBblqPoGluNoddVAINeYx8+66JtLaqlUJ2+6epWgGv
         +CXsdsqVtwjoSiQzklW9+iELgwzlngrRXSpbeI+uaQcjfXVuD/vvQcvK9P9pTSCWUZxm
         E9ieLQ5i+igSG+onPbdI4nn9wY7IRAjGc8oxujKgGhPQdekYV8Dl/ml4ZiT4WN+UYzo6
         EcgU7mhB6Yb/CHfmyrbhgiAelZgpPs2K7IKRo/5IK/XKNQajr3BnvRogVyH22dAF9ALy
         dD+RTdBBVZpTu1WImikTO5ckwiW5cB+2J0nLXK6tNqH8KePuJlkDCVvlSLEJHYMTc9Zl
         Nh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712138906; x=1712743706;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ff6r0nM2jqve3wLbTBtxoKS5Lyh/O9KeiAcAQUgwEb4=;
        b=EBijzEyWRjKo3JB2KUWHPpToQRsgyAUnBSYdSXvzJ9akigeZhUprgDdNjqAHsx1Klz
         uIwp9dz+p2fZZIHMweMaJqdBN9bfPeMegwAZRvgeolm7tIT4Gqsb5V8qcWRauu+XelXU
         d6I8XejU3v0XBIJNGwlUz/UqkOEcz4MbYJQ7K61A41gb5P6Kvs+r0q8ffR7gMhntY69I
         8G41TOP+loifgT/ehYsFBIp0rMPfXWAUrLTnk+fKfh8jjjDY+AmSPAoPKZP57gaJu4AN
         SLzOId8CYjnlELHiwfoTN+fuLhvnEA09cD/mUgiWmcwFcwsYa2rq//9gIxxvu9lyO8VI
         tvUA==
X-Forwarded-Encrypted: i=1; AJvYcCU5m0KdqT9Flg4aVJRBkAyXUIpi8Kr7CSXOCP7SpC283DGUI/7FtJ+UzF9QILEBIDxAbFDfI6ow/CWllTzE3CFATyy0WOuc/8zw3g==
X-Gm-Message-State: AOJu0Yy3faAfUH56cFPn5stW0o+UJaKjY7Q+2gn9poJup3w2cNjQPON6
	oz22GFmu81Al+qBNzIDUiocJgRUcT44692pcG+Ful5gLtTd+n6LHCYva6485Auo=
X-Google-Smtp-Source: AGHT+IH96Iz8S2sFSzH2L9SvkpxTywwUjpqhvfVliMIcbHINwFXx7yS8sItGgjFrPgGR+RcjYi0cZA==
X-Received: by 2002:a17:906:af14:b0:a46:1cc2:3b8c with SMTP id lx20-20020a170906af1400b00a461cc23b8cmr1504783ejb.20.1712138906352;
        Wed, 03 Apr 2024 03:08:26 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id jx2-20020a170906ca4200b00a46d9966ff8sm7714871ejb.147.2024.04.03.03.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 03:08:26 -0700 (PDT)
Date: Wed, 3 Apr 2024 13:08:14 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: ranjan.kumar@broadcom.com
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpi3mr: Debug ability improvements
Message-ID: <dc419e70-2c08-42ed-be45-bc91e5f82170@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Ranjan Kumar,

Commit 0a2714b787b9 ("scsi: mpi3mr: Debug ability improvements") from
Mar 13, 2024 (linux-next), leads to the following Smatch static
checker warning:

	drivers/scsi/mpi3mr/mpi3mr_app.c:1609 mpi3mr_bsg_process_mpt_cmds()
	warn: inconsistent indenting

drivers/scsi/mpi3mr/mpi3mr_app.c
    1592         wait_for_completion_timeout(&mrioc->bsg_cmds.done,
    1593             (karg->timeout * HZ));
    1594         if (block_io && stgt_priv)
    1595                 atomic_dec(&stgt_priv->block_io);
    1596         if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
    1597                 mrioc->bsg_cmds.is_waiting = 0;
    1598                 rval = -EAGAIN;
    1599                 if (mrioc->bsg_cmds.state & MPI3MR_CMD_RESET)
    1600                         goto out_unlock;
    1601                 if (((mpi_header->function != MPI3_FUNCTION_SCSI_IO) &&
    1602                     (mpi_header->function != MPI3_FUNCTION_NVME_ENCAPSULATED))
    1603                     || (mrioc->logging_level & MPI3_DEBUG_BSG_ERROR)) {
    1604                         ioc_info(mrioc, "%s: bsg request timedout after %d seconds\n",
    1605                             __func__, karg->timeout);
    1606                         if (!(mrioc->logging_level & MPI3_DEBUG_BSG_INFO)) {
    1607                                 dprint_dump(mpi_req, MPI3MR_ADMIN_REQ_FRAME_SZ,
                                         ^^^^^^^^^^^^
    1608                             "bsg_mpi3_req");
--> 1609                         if (mpi_header->function ==
                                 ^^^^
Smatch complains because these aren't aligned.  The if statement should
be indented another tab.

    1610                             MPI3_FUNCTION_MGMT_PASSTHROUGH) {
    1611                                 drv_buf_iter = &drv_bufs[0];
    1612                                 dprint_dump(drv_buf_iter->kern_buf,
    1613                                     rmc_size, "mpi3_mgmt_req");
    1614                                 }
    1615                         }
    1616                 }
    1617                 if ((mpi_header->function == MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) ||
    1618                         (mpi_header->function == MPI3_BSG_FUNCTION_SCSI_IO)) {
    1619                         dprint_bsg_err(mrioc, "%s: bsg request timedout after %d seconds,\n"
    1620                                 "issuing target reset to (0x%04x)\n", __func__,
    1621                                 karg->timeout, mpi_header->function_dependent);
    1622                         mpi3mr_issue_tm(mrioc,
    1623                             MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
    1624                             mpi_header->function_dependent, 0,
    1625                             MPI3MR_HOSTTAG_BLK_TMS, MPI3MR_RESETTM_TIMEOUT,
    1626                             &mrioc->host_tm_cmds, &resp_code, NULL);
    1627                 }
    1628                 if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE) &&
    1629                     !(mrioc->bsg_cmds.state & MPI3MR_CMD_RESET))
    1630                         mpi3mr_soft_reset_handler(mrioc,
    1631                             MPI3MR_RESET_FROM_APP_TIMEOUT, 1);
    1632                 goto out_unlock;
    1633         }
    1634         dprint_bsg_info(mrioc, "%s: bsg request is completed\n", __func__);

regards,
dan carpenter
