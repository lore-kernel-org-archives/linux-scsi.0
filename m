Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF73568E2
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758037467; cv=none; b=PwL3qTLJlz7JqYDx/VDUHl1zaWx5uFnRplncwNu7sN1jh1n9qFowcI6AHbn4XMApL5u91rb5PC5Q3UfsIM358ABi1rpI+LZOgLKT8dlFuqpHvtXtVpt9m78S25o8I4M0R03QsZFGUFOHK1k9/83bwNnrlgXQA1jqJnI2z5BhSsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758037467; c=relaxed/simple;
	bh=7LgoDnrAko0PCFrJ0SuXWKjfKcDWxtTxuwB35/+iXZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FWvw02m9ve7/Qo8oObevErqSTekaeyZ/ae222vCv2yRTlpIZPDizbKrrj+cmRvNh3CRrIdPueFbERTRqKCf2FAziiCNJq5elPI2pYcaRq3sTewsQAhTC4HW3/jCfF94mSthdviPI1oQglWZaL1/uXM32/Ni8Hi4uzhsOx/oUgyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PGkgXlbk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PGkgXlbk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cR5mm28RFzlgqVs;
	Tue, 16 Sep 2025 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758037462; x=1760629463; bh=7LgoDnrAko0PCFrJ0SuXWKjf
	KcDWxtTxuwB35/+iXZQ=; b=PGkgXlbkYc60rVX18ylG54VhAwyGSG2ON3lQMuc8
	etSKNrvmBRQyWrc9V13sk2kSGkPBEPdZkFeb7L15X8DICCFHwXGLYr8fhBQzs2OL
	gppAQjtUux7YSVAKuQEmGWYzTYhUuaWvHcGVsdVd1bGpHI/BM5ML6zf8AUgNnqO7
	tSfCzq6EtUx/UHCIAjZJb+SwOlsDes2rQQcDiZnO71fK13eD4XCgepq5qluJPsGh
	SsbDHJVmriAJTe6Lo/c2VuCIdEoML8/mOoEBzF9kJ+6mQDedbG2YL4bFI9GcuE5o
	g+WK4S5Cvss/6Hc2t0haYR0+P+DldcIDAIoqof7dS1F5zA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ct51TqEL_4GL; Tue, 16 Sep 2025 15:44:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cR5mf40Glzlfl2f;
	Tue, 16 Sep 2025 15:44:17 +0000 (UTC)
Message-ID: <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
Date: Tue, 16 Sep 2025 08:44:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/16/25 2:09 AM, John Garry wrote:
> On 12/09/2025 19:21, Bart Van Assche wrote:
>> Make the @cmd argument optional. Add .init_cmd() and .copy_result()
>> callbacks in struct scsi_exec_args. Support allocating from a specific
>> hardware queue. This patch prepares for submitting reserved commands
>> with scsi_execute_cmd().
>=20
> A comment: I did suggest trying to reuse scsi_execute_cmd() for this.=20
> However considering the code changes and the comments, below. Maybe it=20
> is not the best thing. Let's further investigate...

I followed your suggestion because I think it results in cleaner code.
This approach allowed me to drop the patch that introduces the
scsi_get_internal_cmd() and scsi_put_internal_cmd() functions. This
approach also eliminates some code duplication in the scsi_execute_cmd()
callers introduced by this patch series.

>> =C2=A0 retry:
>> -=C2=A0=C2=A0=C2=A0 req =3D scsi_alloc_request(sdev->request_queue, op=
f, args->req_flags);
>> +=C2=A0=C2=A0=C2=A0 req =3D args->specify_hctx ?
>=20
> Can you check args->hctx_idx is a specific queue or something like=20
> NVME_QID_ANY?

That would require explicit initialization of the .hctx_idx member by
all callers that don't care about which hardware queue a command is
allocated from. I think the current approach (only code that cares about
the hardware queue a command is allocated from has to specify
information related to the hardware queue) is more user friendly
because scsi_execute_cmd() callers won't forget by accident to set
.hctx_idx to e.g. ANY_HCTX.

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scsi_alloc_request_hctx(sd=
ev->request_queue, opf,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 args->req_flags, args->hctx=
_idx) :
>=20
> did you consider passing this hctx info to scsi_alloc_request() and=20
> allow scsi_alloc_request() contain the logic as to call=20
> blk_mq_alloc_request_hctx() or blk_mq_alloc_request()?

I'm open to this but I'm not sure this would be an improvement because
there is only one scsi_alloc_request_hctx() caller and there are nine
scsi_alloc_request() calls. An argument like ANY_HCTX would have to be
added to all nine calls. On the other hand, the code duplication that is
the result of the current approach is minimal.

>> @@ -318,8 +321,12 @@ int scsi_execute_cmd(struct scsi_device *sdev,=20
>> const unsigned char *cmd,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scmd =3D blk_mq_rq_to_pdu(req);
>> -=C2=A0=C2=A0=C2=A0 scmd->cmd_len =3D COMMAND_SIZE(cmd[0]);
>> -=C2=A0=C2=A0=C2=A0 memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>=20
>=20
>> +=C2=A0=C2=A0=C2=A0 if (cmd) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scmd->cmd_len =3D COMMAND_=
SIZE(cmd[0]);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(scmd->cmnd, cmd, sc=
md->cmd_len);
>> +=C2=A0=C2=A0=C2=A0 }
>=20
> you could just pass a dummy cmd instead of doing this

Sure, that's possible, but it would make some scsi_execute_cmd() calls=20
really confusing. Making the callers pass a CDB that is never used would
make the reader of the callers wonder why e.g. a TEST UNIT READY CDB is
passed to a scsi_execute_cmd() call that submits something that is not a
SCSI command.

>> +=C2=A0=C2=A0=C2=A0 if (args->init_cmd)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 args->init_cmd(scmd, args)=
;
>=20
> is it possible to do this in ufshcd_init_cmd_priv? Or too late?
>=20
> We could have a "is reserved command" check there (in=20
> ufshcd_init_cmd_priv), and do whatever processing is needed which is=20
> done in ufshcd_init_dev_cmd

This is not possible because the 'args' pointer is not passed to
ufshcd_init_cmd_priv(). See also the conversions of the 'arg' pointer
into a pointer to the surrounding data structure in the .init_cmd
functions in patch 29/29. Maybe I should rename .init_cmd into
.setup_cmd because all functions in the SCSI disk driver that have a
similar role have "_setup_" in their function name.

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scmd->allowed =3D ml_retries;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scmd->flags |=3D args->scmd_flags;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->timeout =3D timeout;
>> @@ -353,6 +360,9 @@ int scsi_execute_cmd(struct scsi_device *sdev,=20
>> const unsigned char *cmd,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 args->sshdr)=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D scmd->result;
>> +=C2=A0=C2=A0=C2=A0 if (ret =3D=3D 0 && args->copy_result)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 args->copy_result(scmd, ar=
gs);
>=20
> can this sort of thing be done in the LLD completion handler?
Only if the 'args' pointer would be stored in the SCSI command private
data. Do you perhaps prefer that the 'args' pointer would be stored in
the SCSI command private data instead of adding a .copy_result function
call in scsi_execute_cmd()? This approach is more risky because it may
result in scsi_execute_cmd() callers forgetting to clear the 'args'
pointer in the SCSI command private data after scsi_execute_cmd() has
finished.

Thanks,

Bart.
