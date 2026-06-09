Received: from mail-43100.protonmail.ch (mail-43100.protonmail.ch [185.70.43.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E20282F2E;
	Tue,  9 Jun 2026 00:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780966752; cv=none; b=LQ1Teg8puGTM7KJUOxXZt3lfTrmWji882/1dJpFYai8VML6qXmcY1rt5d97z8fdShHJO6JGINAd7EOu6mfZkmHSQnsOWT4zsMZOGffldj0XL9odSqpbTV/olJpd+zeK71Ije9W6GL/Ll6tpUPNac0z4NgfsoW6Zyid/3e+AYFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780966752; c=relaxed/simple;
	bh=emQColVb5JpepEtvSSs2I/M5bZIgI2CRo6RNk23HyJU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDugGpRcxw84+Bt6AcAgPpXN2gnlgIEW0Hb/5IqLdMq0kjoISeUWKQ1LXezKw4wFD9V7Mt6VI48lkf0wmoV7D3LuOqcJIuV4R5tMYA8M7svOB+zkd2PIp5QjRP5s7BqH3ysgDK8PILIuENmobFDTwRF+Nhdu8hZmpf07hZzfFvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=elJquuNt; arc=none smtp.client-ip=185.70.43.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="elJquuNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1780966740; x=1781225940;
	bh=3P35bW1gmmV3dnEbB9b86VqbPSQKXQsWFLxm1PJz68s=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=elJquuNtDwupmaPJfPS/+7pZl9uF+f7LpRBb3Bab6ybJtTcEM6fgXMpyr4l7V+uma
	 5U9lM4Iff/V+GJGA86fluRrSEdypRaMFAUsPdIdvY43CyI38PbAxMweOJHIrbNIFh1
	 gz9duLIa2fXc3G5SeTU0GaAKtgNMCK/3D/w9uYKltuv2r0jg/2ahwZzWZn5DlRiVMl
	 JTQkLRKN4KOThf4lHa2V9ilBw/ELxCKDwsvh3naCa8F1VwtXw2nYzYbsaPGAtNPnNc
	 f8MeW4y0CwGSC5RWgq+7PqjhO4WSEjH8prihroHuogQGd2jh2wySxhGqe7IePR196d
	 dpnRfck2Gj7Qg==
Date: Tue, 09 Jun 2026 00:58:57 +0000
To: "Martin K . Petersen" <martin.petersen@oracle.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mike Christie <michael.christie@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>, John Garry <john.g.garry@oracle.com>, David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: copy iSCSI ISID before unmapping the PR OUT buffer
Message-ID: <20260609005851.17484-1-hexlabsecurity@proton.me>
In-Reply-To: <43ed2b6f-5b84-4a3d-b185-4275c9bb69f0@oracle.com>
References: <20260606015359.181724-1-hexlabsecurity@proton.me> <43ed2b6f-5b84-4a3d-b185-4275c9bb69f0@oracle.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 96bf9b84640b6bfe34f2997174b9be027c812ed3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/06/2026, John Garry wrote:
> It's not so nice to re-assign the pointer like this or have it even
> pointing at a local array.
>
> Is it really messy for iscsi_parse_pr_out_transport_id() to do something
> like kstrdup and then the caller has the job of later free'ing it?

You are right -- v2 moves the copy into iscsi_parse_pr_out_transport_id()
so the parser returns an owned allocation via *port_nexus_ptr and callers
kfree() it.

We use kzalloc(PR_REG_ISID_LEN) + strscpy_pad() rather than plain kstrdup()
because __core_scsi3_do_alloc_registration() reads the ISID with a fixed
8-byte get_unaligned_be64(isid).  A malformed TransportID with an ISID
shorter than 8 characters would give a kstrdup allocation smaller than 8
bytes, turning that read into a heap out-of-bounds.  kzalloc zero-fills the
full PR_REG_ISID_LEN (16) bytes so the be64 read is always in-bounds and
returns a deterministic value; strscpy_pad() copies the lowercased ISID and
NUL-fills the tail.

core_scsi3_decode_spec_i_port() also receives the allocated pointer and
needs to kfree() it.  The inner list_for_each_entry iterates over multiple
TPGs per TransportID, calling the parser at each; we kfree(iport_ptr) befor=
e
the reset at the top of each inner-loop iteration so a failed ACL match tha=
t
triggers a continue does not leak the previous parse's allocation.
kfree(iport_ptr) is also added at out_unmap: (error exit) and before
return 0 (success exit).

[PATCH v2] follows.

