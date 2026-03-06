Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08673EDABE
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772815463; cv=none; b=SZ/m7xrt05F0aaOmZSKCQBchdYi+fvLMMTQtvqtTOqltDznnEMgLHOw4W18AdWR1Ja2eaJ50fDSjqGuW7wg9NZrVBooo+bSDjXDp90mLcxWLZpLHnX/973eY674IitsTu3WrrBdl26SjZSiCYtPVlP8Ze6LAQ0gKFhfEv/rSLmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772815463; c=relaxed/simple;
	bh=cOQutnMuWPDAVk3zo7eIzYx5aU00kd5NNsyvvZTBtjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5nM/hZriLudzOcMX5PUCq5GClmWLmNNUWgZeksRlqJmpur8U8HvFDnn2z+QuJYWQHhDrsI5eJoxuwmW7lllTAB7k21f5tT9Mh4PAJSV8XrndVr+UAxjx74C+VUjgYUZkxgdssevBM6WynQugAnUctEkMkASvDT1OZRGkmOzMKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=jS9FPzow; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="jS9FPzow"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id QaDvRB5Ucpny5hxR; Fri, 06 Mar 2026 11:32:57 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=8wEmeU1zB6chAGv2cB+8/88qXb3hAbn3QwMt0KRm3GY=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=jS9FPzowI2w9nRwmpVq3
	HNcQFr+HjOWoEy/4ijHxZCfXkUEjJZ19FSjFkK/3Uy6TNBCIEl1tWiN6BEY34UMVVUCpHlsNLQO3R
	NmXRSN/qnESzTPlCFy6yhmuwTn1NoOEuZEvScKyardUanESTTkBLlPH02irJmNSUv12njHjJdw=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14447498; Fri, 06 Mar 2026 11:32:57 -0500
Message-ID: <ac99d3b6-0537-49c2-826b-118694056b93@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Fri, 6 Mar 2026 11:32:57 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: Remove problematic BUILD_BUG_ON()
 assertion
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH] scsi: qla2xxx: Remove problematic BUILD_BUG_ON()
 assertion
To: Finn Thain <fthain@linux-m68k.org>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <550e7d7bb8c2620ca4f6c9e809a4f853bdfa4c67.1772751689.git.fthain@linux-m68k.org>
From: Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <550e7d7bb8c2620ca4f6c9e809a4f853bdfa4c67.1772751689.git.fthain@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1772814777
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 2423
X-ASG-Debug-ID: 1772814777-1cf43940a6a58f0001-ziuLRu

On 3/5/26 18:01, Finn Thain wrote:
> The LKP bot reported a build failure with CONFIG_COLDFIRE=y together with
> CONFIG_SCSI_QLA_FC=y, that's attributable to the BUILD_BUG_ON() in
> qlt_queue_unknown_atio().
>
> That function uses kzalloc() to obtain memory for the following struct,
> plus some extra bytes at the end.
>
> struct qla_tgt_sess_op {
>         struct scsi_qla_host *vha;
>         uint32_t chip_reset;
>         struct work_struct work;
>         struct list_head cmd_list;
>         bool aborted;
>         struct rsp_que *rsp;
>
>         struct atio_from_isp atio;
>         /* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
> };
>
> The location of the 'atio' member is subsequently used as the destination
> for a memcpy() that's expected to fill in the extra bytes beyond the end
> of the struct.
>
> That explains the loud warning in the comment above, which ought to be
> sufficient to prevent some newly-added member from accidentally getting
> clobbered. But, in case that warning was missed somehow, we also have the
> failing assertion,
>
> BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
>              sizeof(*u));
>
> Unfortunately, this size assertion doesn't guarantee that 'atio' is the
> last member. Indeed, adding a zero-length array member at the end does
> not increase the struct size.
>
> Moreover, this assertion can fail even when 'atio' really is the last
> member, and that's what happened with commit e428b013d9df ("atomic:
> specify alignment for atomic_t and atomic64_t"), which added 2 bytes of
> harmless padding to the end of the struct.
...
> I don't know of a good way to encode an invariant like "the last member of
> struct qla_tgt_sess_op is named atio" such that it might be statically
> checked. But perhaps there is a good way to do that (?)

It might work better to add a flex array:

struct qla_tgt_sess_op {
	...

	struct atio_from_isp atio;
	/*
	atio.u.isp24.fcp_cmnd.add_cdb may extend past end of atio;
	DO NOT DELETE; DO NOT ADD ANYTHING ELSE HERE.
	*/
	uint8_t atio_isp24_fcp_cmnd_add_cdb[];
};

/* atio_isp24_fcp_cmnd_add_cdb must come immediately after atio */
BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) +
             sizeof(struct atio_from_isp) !=
             offsetof(struct qla_tgt_sess_op, atio_isp24_fcp_cmnd_add_cdb));

Tony Battersby
