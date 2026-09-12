Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ADE32D7C7
	for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 13:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221190; cv=none; b=KjT4mInz3AfOWjCnHkTslztx+KpHwh+kY5OiIph5vMdZUgQgxEJ5xgSY/vJZTfXhirQM88D0Gdj94oOKpJ+uETseObxGlqc9la+0fTHiexoi0xKeu5ovmg7bqf01xPzwDZLzxgBgX/1Ubx7LvfnnNBzQXyXtJdFB09BgNy5kH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221190; c=relaxed/simple;
	bh=pWCPBJc6T8fniLVcwXFEVxhbqki/n4fRVPggM3lSSGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nSyf3DBBTjq7V08ixDcKcdeBxWn/MCTtepTN87DqbARCK1+4LoHGRRDQXYCGhIS47UupzTxHQ3BKRD42Gn9XuEcC6z/IHScAAd7yp4ubS3d3g0w4HnCcCAH1d5EBy9lkS+c8tmo37N0Enb8nqnc/3JbwcHVtI1YhueM3SS3Erc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VMTT/EZY; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VMTT/EZY"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398fe469aa0so3255885a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 06:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789221188; x=1789825988; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yHvWcSHAlHOowIhqJT7+ry07TiDGlYeryl5wy+uutgg=;
        b=VMTT/EZYAuKpvDI3YHZielR4IEJoFGGOd5pkQk3Wm+DS1JuOTQSZb/nXx+jc2UnMBy
         ZkUdIQ9/IhxC39lMrIdECH3Ub1xrptCy9zJqIZwyL7+a8x4xNr9GavFkr2+lGvb4EL5e
         CPW5kjB4Of3abnTwPxx9/T7QYy0GpoH1RH1v2pJOmt/WjEWZ+wm0zwb3m5ubFVtxJfun
         nbpQKGpYBv2lEaCuLDfdfXcFifTwDOl8xe3PIKtZ61rhfejxEWzWvwy5vEeEAY74yYIs
         u2UGjCEcPvBS+YvTdSwi/B+PscNpWF7s3do9py5vPj77BhKH+eAh/TC6ii+MYvryVQah
         /KDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789221188; x=1789825988;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yHvWcSHAlHOowIhqJT7+ry07TiDGlYeryl5wy+uutgg=;
        b=S+ll/WVrPYk+e6eOhGh1Lgn45VTTdhSmoIU3+E1spomtSCxE9FyeWPlq0rKpk8gIWh
         2WdkQXBq7KpHos8FkLd+XZowP1v+3zNe1TfDOBSQxM4XtcoO4ma2qzmrKct6oa/vPGOl
         GOvqfj0O3mRnxyt2e/zdik2B4koxtknqI6/sL+EoWdmqtvI9mpX6Zpi99vQWsif82oH7
         D8C0tY7KSpjIAXlQv2ZjtsR4Fjv9iFYmB3dWmidAnoblVBd3w2aIYVzBixU3Qw8ZBQVQ
         CREbea00R8rOmVmQSLSxrqJT/XVcH1lwDtoksLS+xow7QbnjU/jQlcsafYBMUqrI+gL/
         4lLQ==
X-Gm-Message-State: AFuF++lMzvIKqujt4UOISb0w3kK5DVrSXy+jyHYygmJpKM28tuMXEnX+
	wth5FMWI0aPHiWcnhn1UNvtcirIhXGJmTmm/xF2H/tT/4nw0VDnweXDRPHIUk75o9+sgFTXJpy4
	FXy+FRnO0Ilks5nL/8Akx7Q==
X-Received: from pjkv9.prod.google.com ([2002:a17:90a:7789:b0:39d:a230:1b72])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28d0:b0:398:9bd4:d18 with SMTP id 98e67ed59e1d1-39d9c3f2ba7mr17193393a91.23.1789221187744;
 Sat, 12 Sep 2026 06:53:07 -0700 (PDT)
Date: Sat, 12 Sep 2026 21:53:06 +0800
In-Reply-To: <20260912133739.826361F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260912133739.826361F00893@smtp.kernel.org>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260912135306.2324266-1-stanleyjhu@google.com>
Subject: Re: [PATCH v3] scsi: ufs: core: Keep internal commands dispatchable
 during error handling
From: Stanley Jhu <stanleyjhu@google.com>
To: sashiko-bot@kernel.org
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, 
	Brian Kao <powenkao@google.com>, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 12 Sep 2026 13:37:39 +0000, sashiko-bot@kernel.org wrote:
> Is it possible for hba->host->pseudo_sdev and its request_queue to be freed
> before we access it here?

If that race is reachable, it is not reachable through the code this patch
adds. The same function already dereferences a pointer that teardown frees
earlier than pseudo_sdev, and it does so before the new code runs:

drivers/ufs/core/ufshcd.c:ufshcd_err_handling_prepare() {
	pm_runtime_get_sync(hba->dev);
	ufshcd_rpm_get_sync(hba);
	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||   <-- existing
	    hba->is_sys_suspended) {
	...
	blk_mq_quiesce_tagset(&hba->host->tag_set);
	blk_mq_unquiesce_queue(hba->host->pseudo_sdev->request_queue);          <-- added here
}

And the pseudo device is freed last, by design:

drivers/scsi/scsi_scan.c:scsi_forget_host() {
	list_for_each_entry(sdev, &shost->__devices, siblings) {
		if (scsi_device_is_pseudo_dev(sdev) ||
		    sdev->sdev_state == SDEV_DEL)
			continue;
		__scsi_remove_device(sdev);            /* the UFS Device WLUN goes here */
		...
	}
	/*
	 * Remove the pseudo device last since it may be needed during removal
	 * of other SCSI devices.
	 */
	if (shost->pseudo_sdev)
		__scsi_remove_device(shost->pseudo_sdev);
}

So any error handler run that reaches the new line has already dereferenced
ufs_device_wlun, which was freed first. The same holds for
ufshcd_err_handling_unprepare(), which only runs after prepare().

Thanks,
Stanley Jhu
