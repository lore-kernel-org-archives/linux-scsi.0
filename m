Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A435BAE0
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710803104; cv=none; b=OSN90TW8NU8zvQ9fE2onU/rxerNtNvFoVbiCMlPhHhiYlfY9q8Pvob/JQATkSEnp83mTy7QDF37suCJU/cIiXL9CgZQvzlcI6PVAJF2HzwUDQYxVQCmEsc+IqB7FTPu9iFLANYhtRFS0SNM1j6PFjstgdNypurFxGb3hKiOjaQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710803104; c=relaxed/simple;
	bh=knR8pGzHciTzdr9QSQyhOsFXKWWfeJtRj4qQ++TUEB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lbdLk8D6Q6ckgXCGz8laozKMyXxTLCz6JqDK6ZgHLDmTSQtwjTGfr5copiIuV5xqo8vUdWS5PTl1FjEac6ngbxc8P6RO6t5VpeC53wKGNDFXTeOlaWTn5GTZiups8Vt56riuZPpwzp2WkTzARJCaOubovBjVpYal3q5pvOeb44Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uewZYDCP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uewZYDCP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Tz9RV1z1rzlgVnf;
	Mon, 18 Mar 2024 23:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710803092; x=1713395093; bh=+k5qwVDaSVAaFOyDfVAC/R5i
	OL6nAqBoxMRXwONafx0=; b=uewZYDCPlA31wA6oHmwWDASSKH6gy8kPY+WomPxk
	+NGJCL70Lx0BnyZJP/wOxwMSatMRsXXvWu4hZ8StUQtUWwEagkJzcT5Zm7UCkJdQ
	XNtQrdcdTXU1SMdrpXvcGB8yJmTRSGKaGA8zKaPOo8vCtGeDDDyNbU/wrdsk6YRN
	tLx9QX9m3TnkMn78GIWIFHm38OKRJS2CZgi9t9zCCE6smHfw6nMv8AOgoCexI6dC
	WqsYbxlX5a0/nHZR1jv9aH+y0MGHhATSqgOxI+yN0bQEMfXlYGwQqVGaw7QKQqg+
	mtKMkojmza0h8GJV97OlUukWJH1E4ZxlYnIMCxYVIIUIcw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EVcs0l49dWO2; Mon, 18 Mar 2024 23:04:52 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Tz9RR0chWzlgVnW;
	Mon, 18 Mar 2024 23:04:50 +0000 (UTC)
Message-ID: <cd3c9461-c453-4843-a01a-1a602f6bdb5f@acm.org>
Date: Mon, 18 Mar 2024 16:04:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] scsi: scsi_debug: Remove a reference to in_use_bm
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240307203015.870254-1-bvanassche@acm.org>
 <20240307203015.870254-2-bvanassche@acm.org>
 <8c52f474-d157-4a68-a51a-9ccbe2352560@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8c52f474-d157-4a68-a51a-9ccbe2352560@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/8/24 03:46, John Garry wrote:
> On 07/03/2024 20:30, Bart Van Assche wrote:
>> Commit f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue") removed
>> the 'in_use_bm' struct member. Hence remove a reference to that struct
>> member from the procfs host info file.
>>
>> Cc: Douglas Gilbert<dgilbert@interlog.com>
>> Cc: John Garry<john.g.garry@oracle.com>
>> Fixes: f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue")
>> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
>=20
> Reviewed-by: John Garry <john.g.garry@oracle.com>
>=20
>> ---
>> =C2=A0 drivers/scsi/scsi_debug.c | 2 +-
>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index acf0592d63da..36368c71221b 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -6516,7 +6516,7 @@ static int scsi_debug_show_info(struct seq_file=20
>> *m, struct Scsi_Host *host)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_mq_tagset_b=
usy_iter(&host->tag_set,=20
>> sdebug_submit_queue_iter,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &data);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (f >=3D 0) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 se=
q_printf(m, "=C2=A0=C2=A0=C2=A0 in_use_bm BUSY: %s: %d,%d\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 se=
q_printf(m, "=C2=A0=C2=A0=C2=A0 BUSY: %s: %d,%d\n",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "first,last bits", f, l)=
;
>=20
> maybe this can fit on a single line now without exceeding 80 char (whic=
h=20
> some people still want - I don't mind).

The most compact version of this patch I can come up with is the
following:

@@ -6384,8 +6384,8 @@ static int scsi_debug_show_info(struct seq_file=20
*m, struct Scsi_Host *host)
  		blk_mq_tagset_busy_iter(&host->tag_set, sdebug_submit_queue_iter,
  					&data);
  		if (f >=3D 0) {
-			seq_printf(m, "    in_use_bm BUSY: %s: %d,%d\n",
-				   "first,last bits", f, l);
+			seq_printf(m, "    BUSY: first,last bits: %d,%d\n", f,
+				   l);
  		}
  	}

Thanks,

Bart.
