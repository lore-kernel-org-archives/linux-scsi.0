Received: from mail-10627.protonmail.ch (mail-10627.protonmail.ch [79.135.106.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8342C285061
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2025 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178108; cv=none; b=jySszCq9H6l8pDpawjy2CXZlrVujN57MkFfLTmQMYyCnlJor1gavRr2uR0VBe9B/3I1XyQoeQxyIufD7eaUurFuXia4bJNm7OzpoNwzA1ChPiou0Nw+nLLxsmdAFcYLY5CPISRQ1OQFyuINcCyy/ESy2ARYygbBy1FjvGqZ3b6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178108; c=relaxed/simple;
	bh=aADlZ16iPb4JlaQWfs+94eC38upeNt6R9aA4PtN5LFg=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=WHLHLedHgxvaDxiebBZd534X2NHnw1M8j+bDt4Up9MT0Om7/K82IBZY4SUhcnHmFpU6iFPWZpQrz36kbJc+tq+I+J/nBjCnDLVBHVfzRduBXVGzCn2EMHRxMMxKCCrugyt8YZkW0+4GDv/AROdzBY8wq965kwA6iNMkGB641/BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ashe.io; spf=pass smtp.mailfrom=ashe.io; dkim=pass (2048-bit key) header.d=ashe.io header.i=@ashe.io header.b=Kc0SWpLX; arc=none smtp.client-ip=79.135.106.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ashe.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ashe.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ashe.io header.i=@ashe.io header.b="Kc0SWpLX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ashe.io;
	s=protonmail2; t=1750178096; x=1750437296;
	bh=aADlZ16iPb4JlaQWfs+94eC38upeNt6R9aA4PtN5LFg=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=Kc0SWpLXomx7DUg9JOqYbrXAVvl1EP/HF8/UJJ68DEwLefYa0a7L1d/9eWSNfBHcX
	 uMMha4wiLQSSbyMVNPC0iCGsbDseYWoYaanaYknwWBIzA9o3WnSmzVZn5Yk/yY1fKY
	 0gGJYlwDdAiEmyejnz8OpW1qKvIsqVIYwsqnVa7Jdi3G/niZy/dlcsIbLdbrtWdIEG
	 gjH2G8fR9cEpKrRXYCu5/bYXcggm1WY+r/ue3M3rTfxhJsE9hJ1l22TXbeAF0e1TXV
	 TskM77FnUijYI+nCvdQLRwUPUDHlwjyiw8RHp7D0SA6udCOwP/Ta5qlYihUZZyENp/
	 TBsZzXOV6wMhQ==
Date: Tue, 17 Jun 2025 16:34:52 +0000
To: "john.g.garry@oracle.com" <john.g.garry@oracle.com>
From: "Sean A." <sean@ashe.io>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>, "atomlin@atomlin.com" <atomlin@atomlin.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable module parameter
Message-ID: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
Feedback-ID: 119619660:user:proton
X-Pm-Message-ID: 66632c2760772bcd62fe3f5db77cf6364e199897
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Le 17 Jun 2025, John Garry a =C3=A9crit :
> You have given no substantial motivation for this change

From my perspective, workloads exist (defense, telecom, finance, RT etc) th=
at prefer not to be interrupted and developers may opt to utilize CPU isola=
tion and other mechanisms to reduce the likelihood of being pre-empted, evi=
cted, etc. This includes steering interrupts away from an isolated set of c=
ores. Also while this doesn't result from any actual benchmarking, it would=
 seem that forcing your way on to every core in a 192 core system and refus=
ing to move might be needlessly greedy or even detrimental to performance i=
f most of the core set is NUMA-foreign to the storage controller. One shoul=
d be able to make placement decisions to protect app threads from interrupt=
ion and to ensure the interrupt handler has a sleepy, local core to play wi=
th without lighting up a bunch of interconnect paths on the way.

Generically, I believe interfaces like /proc/$pid/smp_affinity[_list] shoul=
d be allowed to work as expected, and things like irqbalance should also be=
 able to do their jobs unless there's a good (documented) reason they shoul=
d not.
SA
