Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E773C3F75
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785182185; cv=none; b=G1dOl+cqiABPCqOEsgs3Vhai+gNiiej7wpCtEr7/i4OPj0fCRuUE+Uww1B2MjouYUY8hSnwPFj13bNj1y1Cn45Mpy1zaL89yLxMod09yBo6In3zHsRJUo3/NQl2JvKB3zB05frpYPhN55xztq2uXjzB8dlLdF3dV+ailVBKQ7EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785182185; c=relaxed/simple;
	bh=tlz+s6XvC9e0CtTQwA5Kfu0aKVy65+gAtc5bOhFrryc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l009NUwGSnDny3RrH7Wq742OOCNgpDqzqshOnwBN5r/jjlGYSxm3Ox1KwjcSrMxNxQ+LWgM/JrXMYifRVHLWquFNTNnLkHrs/j62dWfBlzzg9YMSps9c2Dp7QAwwUpU1veHnNpcRy6AvTZDM3NyPk6LFcSN93KPfOUgDtxBmlrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=I3Wfx63L; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="I3Wfx63L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1785182183; x=1816718183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tlz+s6XvC9e0CtTQwA5Kfu0aKVy65+gAtc5bOhFrryc=;
  b=I3Wfx63LJWSfRMkjZMfRM8ISZHn4BcetFLk4FgJD437AWhuD3b1h0KGo
   15FYk5olyQcntEDaf/1BCr/f5FkMF+WccPLr3z7gOGsU1yenRyqUrmSOA
   wyQaU+FeolcBmdNrM8X899e/+5fh7vz8akxzZuRUu/i4MpTVdvqV4C31R
   k5kvxLjTXoulLXHmqc5LcbJe0CwkW8/yxJLJ7Mb3nstpNG33uaZjsPiNy
   gDbAhIPAK3saKhn19tNkFlcZsO8go0l5uBejNqcq+co6C3d0gMezrZ+v4
   +FS2am+j9v6PM1fTSN+RkVkYpmKCSuS7efaFvSTJXd957kTEjQBTgutwA
   w==;
X-CSE-ConnectionGUID: d07qJ3tuTnG3EJLcXktOhA==
X-CSE-MsgGUID: eToCZrLsT1uVhYgsNeFXMA==
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="61246291"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jul 2026 12:56:22 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Mon, 27 Jul 2026 12:56:20 -0700
From: David Strahan <david.strahan@microchip.com>
To: <sashiko-bot@kernel.org>
CC: <linux-scsi@vger.kernel.org>, David Strahan <david.strahan@microchip.com>
Subject: Re: [PATCH v1 1/4] smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.
Date: Mon, 27 Jul 2026 14:55:47 -0500
Message-ID: <20260727195547.19480-1-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722220401.6357-1-david.strahan@microchip.com>
References: <20260722220401.6357-1-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex01.mchp-main.com (10.10.85.143) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

Re: commit 594ef5db683084e131dde7930f0e556c7584b609
    [PATCH v1 1/4] smartpqi: Fix AIO retry marker cleared by SCSI core
    between dispatches.

Link: https://lore.kernel.org/linux-scsi/20260722220401.6357-1-david.strahan@microchip.com/

Sashiko AI review (https://sashiko.dev/#/patchset/20260722220401.6357-1-david.strahan@microchip.com?part=1):

> [Severity: High]
> State leakage across blk-mq tag reuse leads to erroneous drive
> offlining. [...] If a command is aborted via the SCSI error handler,
> it can be terminated directly by the SCSI midlayer via
> scsi_finish_command(), which bypasses pqi_prep_for_scsi_done().

This driver registers its own .eh_abort_handler (pqi_eh_abort_handler())
and reset handlers, and never calls scsi_finish_command(). Every
completion path -- normal I/O, AIO retry, RAID error info, and the
controller-offline failure sweep -- goes through one choke point,
pqi_scsi_done(), which always calls pqi_prep_for_scsi_done() before
scsi_done():

    static inline void pqi_scsi_done(struct scsi_cmnd *scmd)
    {
            pqi_prep_for_scsi_done(scmd);
            scsi_done(scmd);
    }

pqi_eh_abort_handler() doesn't complete the command itself. It blocks
until pqi_prep_for_scsi_done() runs for that command. So by the time
the abort handler is allowed to return SUCCESS, the marker has already
been handled. There's no window for the bypass this review assumes.
