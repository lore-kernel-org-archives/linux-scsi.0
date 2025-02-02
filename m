Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C371F9F68;
	Sun,  2 Feb 2025 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738506644; cv=none; b=K7hAVqn0Xg44a4futEjGH19KTuYEhM4ZCOK76MdCjyMjGdWbR/57wfviORDrhbe99Egc68NkoPZ12GjNgoZqn6nlx5cTeSiXu4hKO6X5b8RIC1iO1EJmbBkN2M5JxKtb4rnfjsvFNTA4aag8Ni421E9161PCl3et/BX2F7l60eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738506644; c=relaxed/simple;
	bh=1h3OHYyY/TPIl8KYA0WVIzluNRpcrCIuf4FdBioEcHU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NmmLYujjQkuduQSA62DKaVPV0SRLbDLBjnZwtCsXRFSKtzAp1ydCV3QVOvuDe9a0SpmrCGxRCqTC0xT4XlznNrceiOtWlxm4WyEtLAG3MBOE/v5OYNnK5lNWojrRPMs6t1wZ93QKbZJRQWX5fhUmrM4yym/Q01KsLJzhpljStXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=HI7huCX+; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="HI7huCX+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1738506643; x=1770042643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qhQPSGxU0HcUIVmXEF+NupvtcVymNP0+jyzgNy1AV+o=;
  b=HI7huCX+KUXrPGn9MQ0oA5bP6+EA5/mdXJef3LQ/sfUeezvvJir+JOC4
   QV+Xvr35VEYyGITWi+w8VhuHPAAdq/zxfNR4ovq2swfludrr0YZETgHuV
   geq55s/5So5cuV/e7o2DwQYCR0SrkRYPt3KWm2b3xZ/mDpg1Jrq2S67OR
   I=;
X-IronPort-AV: E=Sophos;i="6.13,254,1732579200"; 
   d="scan'208";a="62449868"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2025 14:30:40 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:7088]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.183:2525] with esmtp (Farcaster)
 id 943600d9-e87f-42b7-b53d-e81430bb2a90; Sun, 2 Feb 2025 14:30:39 +0000 (UTC)
X-Farcaster-Flow-ID: 943600d9-e87f-42b7-b53d-e81430bb2a90
Received: from EX19D003ANC003.ant.amazon.com (10.37.240.197) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Sun, 2 Feb 2025 14:30:39 +0000
Received: from b0be8375a521.amazon.com (10.37.244.8) by
 EX19D003ANC003.ant.amazon.com (10.37.240.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Sun, 2 Feb 2025 14:30:35 +0000
From: Kohei Enju <enjuk@amazon.com>
To: <markus.elfring@web.de>
CC: <enjuk@amazon.com>, <kohei.enju@gmail.com>,
	<linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH] scsi: target: remove unnecessary null checking for bio allocation
Date: Sun, 2 Feb 2025 23:30:27 +0900
Message-ID: <20250202143027.9824-1-enjuk@amazon.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <5b946d09-f67c-4a49-bba7-d73a549969b6@web.de>
References: <5b946d09-f67c-4a49-bba7-d73a549969b6@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D003ANC003.ant.amazon.com (10.37.240.197)

> > When __GFP_DIRECT_RECLAIM (included in GFP_NOIO) is specified,
> > bio_alloc_bioset() never fails to allocate a bio. For more details, see
> > the comment in bio_alloc_bioset() in block/bio.c
> 
> See also:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.13#n94

Thanks. I'll modify the commit message into imperative mood.

> Can a blank line be also omitted together with the mentioned compound statement?

Sure, I think so. 
I'll submit a v2 patch with the modified commit message and without the blank line.

Regards,
Kohei
