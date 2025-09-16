Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4C634A33D
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 16:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758039554; cv=none; b=PP8bQwozcHfe3bwrOb1fCY+8AA7WNiPnkilpGLHfYivwIoq/A0S/emkiGCW7bHEvZNYhq8bvVoz1ZoWPv8AcmcXTe9jG6DhHlVCG3YmlQgAUz9bL5FsS86x4qfUoXpaMTdcekAoACOyI93OHycU7MN+bjcSd3yUR99UB9rGTUT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758039554; c=relaxed/simple;
	bh=yK/Ydl3etOzjTdRkXqTdWHtWEHYqCZ/j4b9gW0Qz+QY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hqi+n5KiXb2nR4fZ86reWtKLFYKkkoJdwTTUW32V/tGZOiKfr4v6zT0wqqRc0jOiryoAlgO6FjjoORA9oluLjMm1rAgMfyDyNxAzbvIrkVIYtBIGTiKdSKjzL6o1NmcmS9exyyNPlCMltpl7xaZxH4ycsmQHhKcIDIV+n51qYCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=fail (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=KNyRqtGW reason="signature verification failed"; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="KNyRqtGW"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id IfZtsNituApaZ9Fi; Tue, 16 Sep 2025 12:04:11 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=+j1F478vcj92uMdblBqQoeReNdWWKE441rh+Ff31m+U=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:Content-Language:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID; b=KNyRqtGWzpzZ7imU5qid
	jyCP3EEZsm/8CWiZ/NqDMwewWquo1A+KJMxS62NYet5Z28A0OLV32CZH9FbtNJrto4+LZzLLbuN8P
	+XBO94TsyVabILQsQXcYAmM6AmYyZGqrHkgF4vcMBWiUL38h/ogQxZrxvHtsgQRMc1g/4z5SlY=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14200077; Tue, 16 Sep 2025 12:04:11 -0400
Message-ID: <526d0d1b-79f1-47fd-bc44-6727898f381c@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Tue, 16 Sep 2025 12:04:11 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/15] scsi: qla2xxx: fix TMR failure handling
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
X-ASG-Orig-Subj: Re: [PATCH 10/15] scsi: qla2xxx: fix TMR failure handling
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <f7f93110-bd53-4ebc-9aed-abe5de82028d@cybernetics.com>
 <20250912143615.GB624@yadro.com>
Content-Language: en-US
From: Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <20250912143615.GB624@yadro.com>
Content-Type: text/plain; charset=UTF-8
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1758038651
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1482
Content-Transfer-Encoding: quoted-printable
X-ASG-Debug-ID: 1758038651-1cf43947df3553c0001-ziuLRu

On 9/12/25 10:36, Dmitry Bogdanov wrote:
> On Mon, Sep 08, 2025 at 03:02:49PM -0400, Tony Battersby wrote:
>> If handle_tmr() fails (e.g. -ENOMEM):
>> - qlt_send_busy() makes no sense because it sends a SCSI command
>>   response instead of a TMR response.
> There is not only -ENOMEM can be returned by handle_tmr.

Indeed.=C2=A0 I will remove mention of -ENOMEM since it isn't really rele=
vant.

>> +               mcmd->fc_tm_rsp =3D FCP_TMF_REJECTED;
>>
> FCP_TMF_REJECTED means that this TMF is not supported, FCP_TMF_FAILED i=
s
> more appretiate here.

I will make that change.

>> - Calling mempool_free() directly can lead to memory-use-after-free.
> No, it is a API contract between modules. If handle_tmr returned an err=
or,
> then the caller of handle_tmr is responsible to make a cleanup.
> Otherwise, target module (tcm_qla2xxx) is responsible. The same rule is
> for handle_cmd.
>> +               qlt_xmit_tm_rsp(mcmd);
> qlt_xmit_tm_rsp does not free mcmd for TMF ABORT. So you introduce a me=
mleak.

I just tested it, and there is no memleak.=C2=A0 qlt_build_abts_resp_iocb=
()
sets req->outstanding_cmds[h] to mcmd, and then
qlt_handle_abts_completion() calls ->free_mcmd after getting a response
from the ISP.

The original code had a memory-use-after-free by calling
qlt_build_abts_resp_iocb() and then mempool_free(), and
then=C2=A0qlt_handle_abts_completion() used the freed mcmd.=C2=A0 I can r=
eword the
commit message to make this clearer.

Tony

