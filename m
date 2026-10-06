Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF5F3B6C00;
	Tue,  6 Oct 2026 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791280521; cv=none; b=ou7CuMtqBM781alJ2EDsrEb8OxTXp0xS8WGanBVYhCPg8+jKxyilDzUTX2iObZj/ZNHMYE/vCA52fgnriXW4b87FfaFzcHmYHUDHG7mhsDz36VEZ4yqGkHMkvWtbFkZaFKBZxfXOQImqtFxYj5/E8sFRVWKJr7wqR0/Nsd02BGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791280521; c=relaxed/simple;
	bh=r7dTzWnyb9LYxI9yO4JQVaNh1xZD+lxxhzUUxXuRi+U=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jMG+RgBgGQrilKKcoaTSkQ2hoyhTEsV+GBekxU54vgfnAWaUDYRGyYjn9XXTU/wNMdEdlWvb/9QLCHB1SFGEcb7Wiyxamw8FAsf8QVAZbMufMU8Rk9ysxgqKZVuRf4M6rRqVsfQjGeubVFfguh2v0V+c8VYDmgs8HOGTJ72demQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=m9c9hcc0; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="m9c9hcc0"
X-UUID: 01818932c16c11f18dc8c9802ae25ab1-20261006
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=tloYHaVbYNU0rRAf4/HuoJhNrp+JOWU7kTTUF5xT1v0=;
	b=m9c9hcc0s17okh7Ck/7RJruZyLI/v/3fxQZ8Bti9xWMalm7xQl0BWWA+brCXSdmv27vCHdZbvxGb19bUhkcCPRKfPCfCipvkIW6QzGOZlcg0kNYqmsk1v5GCXt29VNLV1PeQNX/i+c7DNretKj1d7yLGVWZVPLiRpSCAiAB7yus=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:725242db-c0c9-4cd5-81bb-bf7183273503,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:8e630795-3103-4fdb-b79c-08de0e281a5d,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 01818932c16c11f18dc8c9802ae25ab1-20261006
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <alice.chao@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 537123793; Tue, 06 Oct 2026 17:55:05 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Oct 2026 17:55:03 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 6 Oct 2026 17:55:03 +0800
Message-ID: <ac1b17147198b189e606083e181db8802b72fac1.camel@mediatek.com>
Subject: Re: [PATCH 6.18.y] scsi: ufs: core: Re-arm the device command
 completion before submitting
From: Alice Chao <alice.chao@mediatek.com>
To: Bean Huo <beanhuo@iokpp.de>, <stable@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<bvanassche@acm.org>, <avri.altman@sandisk.com>, <alim.akhtar@samsung.com>,
	<wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Date: Tue, 6 Oct 2026 17:55:03 +0800
In-Reply-To: <1912caf84d99bc2388960c907184f06689806ee6.camel@iokpp.de>
References: <20260915052638.459390-1-alice.chao@mediatek.com>
	 <1912caf84d99bc2388960c907184f06689806ee6.camel@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MTK: N

On Mon, 2026-10-05 at 13:54 +0200, Bean Huo wrote:
> The late CQE can come after the re-arm:
>=20
> timeout -> cleanup -> retry B -> re-arm -> send B -> A's CQE arrives,
> and then B
> is woken up early and fails, if B's own CQE in turn comes after C's
> re-arm, C
> fails the same way, and C may even read B's response as its own.
>=20
> Whether this stops depends on device latency against our retry path,
> not on the
> patch.
>=20

You are right. Re-arming only covers a late CQE that arrives while no
device command is in flight. The query retry wrappers resubmit right
away, so the next re-arm will usually happen before the previous CQE
lands, and the skew can cascade exactly as you describe. It is also
worse than an early wakeup: every device command shares the reserved
slot's response UPIU, so C can parse B's response as its own and
return a wrong value rather than an error.

> The root cause is that all device commands share hba->reserved_slot
> and the CQE
> carries only the tag. Since a successful SQ cleanup must post an
> ABORTED CQE,
> could the MCQ timeout path wait for and consume that CQE before
> returning -
> EAGAIN?
>=20

Agreed, that closes the window instead of narrowing it. In v2 the MCQ
timeout path will:

 - after the SQ cleanup, wait (bounded) for the reserved slot's CQE -
   the ABORTED one, or the regular one if the command completed
   anyway - before returning;
 - if no CQE shows up in time (e.g. cleanup failed, or
   UFSHCD_QUIRK_MCQ_BROKEN_RTC), force a host reset and refuse device
   commands outside the error handler until it has happened, so the
   slot is not reused while that CQE can still arrive;
 - keep reinit_completion() at submission time as a safety net.

> does this patch only covers a late CQE arriving while no device
> command is in
> flight. Did you test it with injected timeouts to see whether it
> recovers?
>=20

Yes, v1 only covers that case. And no, I have not tested it with
injected timeouts yet.

Before posting v2 I will run it with injected device command timeouts
in MCQ mode: periodic fake timeouts under a descriptor/attribute read
loop, with the values checked against known-good ones, and the case
where the CQE never arrives, to check that the host gets reset and
device commands recover. This will also show whether our controller
actually posts the ABORTED CQE after the SQ cleanup. I will run the
same injection on v1 and on the unpatched kernel for comparison and
put the results in the v2 changelog.

Thanks for the careful review.

Alice

