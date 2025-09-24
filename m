Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DBF27381B
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758744301; cv=none; b=HknNyd5NCSG4s7p1GgKB51qKgB13V09vmRhwVV+5TrPKFtbaiCh6Hlp4bW/tXjiukq21w+qUGTQ/Z/ZLuMEJuBq0Mr+Rxlya05o23mhpFWH3NfXc2G1KCMa8+iXT/c3PqFhhslbYPc2ok+kSENDnyi72KxclJpea9Ac/r0rf+cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758744301; c=relaxed/simple;
	bh=K0CDb32hp0Heh8eOEHKLcUb6TfnUoQd8pmOqex07dWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8G0kToUTz0Frgl3iCgBXoZNTJ4kpV1mdwlt+/AVioffOkQalVtklG6htO+0NEJ2NILXH050WG/waV7pg8qinMCZwRT/vsYnqd3QM4mygANeWrvV47D34OiEYUMV8ERFc8U0DL0AWbEKf/CSX5Usm6I1X4K2VHhvLqFcpEqbgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=fail (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=J94tTKfv reason="signature verification failed"; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="J94tTKfv"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id h8wBzLCq34zbGkxj; Wed, 24 Sep 2025 16:04:58 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=CUA3uqa8t5oExLzrxO8pfdSivJnkyG39efMVHVZVhqw=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=J94tTKfvM2oUKItSFUXd
	fpr2chLHa6RAWMdOKdrRCtaZt2wgKk9R0hjGMBfTFsreRD98eByNGADG+sHoGM+AJkNmK8K5yUGRp
	KSKPgyyAODGH2o8n7mH2molINogip8do1txXW8TO84LY/0A1E+H6wMVwqctNzQsmnIyzLv2tSk=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14211720; Wed, 24 Sep 2025 16:04:58 -0400
Message-ID: <c95de97f-2cf4-429c-b4d4-86f285f3c43e@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Wed, 24 Sep 2025 16:04:58 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/15] scsi: qla2xxx: add cmd->rsp_sent
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH 12/15] scsi: qla2xxx: add cmd->rsp_sent
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <366f8fb5-376d-4426-9f27-6bef23a624b2@cybernetics.com>
 <20250915134725.GC624@yadro.com>
From: Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <20250915134725.GC624@yadro.com>
Content-Type: text/plain; charset=UTF-8
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1758744298
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1423
Content-Transfer-Encoding: quoted-printable
X-ASG-Debug-ID: 1758744298-1cf43947df39db10001-ziuLRu

On 9/15/25 09:47, Dmitry Bogdanov wrote:
> On Mon, Sep 08, 2025 at 03:07:04PM -0400, Tony Battersby wrote:
>> (target mode)
>>
>> Add cmd->rsp_sent to indicate that the SCSI status has been sent
>> successfully, so that SCST can be informed of any transport errors.
>> This will also be used for logging in later patches.
>>
>> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_target.c | 4 ++++
>>  drivers/scsi/qla2xxx/qla_target.h | 4 ++++
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/=
qla_target.c
>> index eabb891a5528..0ddbf02ebe79 100644
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -4067,6 +4067,10 @@ static void qlt_do_ctio_completion(struct scsi_=
qla_host *vha,
>>
>>         if (cmd->state =3D=3D QLA_TGT_STATE_PROCESSED) {
>>                 cmd->trc_flags |=3D TRC_CTIO_DONE;
>> +
>> +               if (likely(status =3D=3D CTIO_SUCCESS))
>> +                       cmd->rsp_sent =3D 1;
> Looks like TRC_CTIO_DONE without TRC_DIF_ERR and TRC_CTIO_ERR means
> exactly that CTIO was completed successfully.

That may be true, but I still prefer to add the separate rsp_sent
field.=C2=A0 trc_flags is a debug feature, and I expect that relying on
specific meanings of debug flags in non-debug code would make the code
more fragile.

Tony

