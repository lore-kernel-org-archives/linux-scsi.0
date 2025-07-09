Received: from bsdbackstore.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2533221FDE;
	Wed,  9 Jul 2025 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080652; cv=none; b=ssZ72U12/swFnIFWPTJGCbkW4zN0ATbCOkDaLeZbIU3oSqbA7VU9boPUZSXlkqmq0H29hQUUW6gf02itH1p1r9LdEPp4kPkiZMu21VL3sBwmdGyLn80uL9Pm2+HeooYPrs3YEy9SAxPBMbznswl0JY/K9njXgfqV9febvgLNAYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080652; c=relaxed/simple;
	bh=P4zl1FYTqvm3+wkrp90Wu1wpFqSmTxy0lDzLyJWAJjg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=tIGP/i34XyDxqEZlRovLVcQtQv03gIAhI9vXlCMyaXrsBWGdK2+ELnY2ECz0MB8+Hn9nxpjn1evXffHaZtTWXvzdIFzYTijc53Aecx9RnPrQJNSu1rFCFtdg88e4PA1aMSgJCGW1OfoXsZRRk6pgFnckwEoHeiLMUAzBCVYjLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu; spf=pass smtp.mailfrom=bsdbackstore.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsdbackstore.eu
Received: from [127.0.0.1] (<unknown> [193.207.219.135])
	by bsdbackstore.eu (OpenSMTPD) with ESMTPSA id 3e7f9af4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 9 Jul 2025 18:57:27 +0200 (CEST)
Date: Wed, 09 Jul 2025 18:57:21 +0200
From: Maurizio Lombardi <mlombard@bsdbackstore.eu>
To: Bart Van Assche <bvanassche@acm.org>, Maurizio Lombardi <mlombard@redhat.com>,
 martin.petersen@oracle.com
CC: michael.christie@oracle.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, d.bogdanov@yadro.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_V2=5D_target=3A_generate_correct_s?=
 =?US-ASCII?Q?tring_identifiers_for_PR_OUT_transport_IDs?=
User-Agent: Thunderbird for Android
In-Reply-To: <ceabaefd-6df5-4d08-9b6c-6ce75611ebef@acm.org>
References: <20250703081224.115865-1-mlombard@redhat.com> <ceabaefd-6df5-4d08-9b6c-6ce75611ebef@acm.org>
Message-ID: <EC59242B-7537-4D37-AC2E-97064A70209B@bsdbackstore.eu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



7=2E =C4=8Dervence 2025 19:28:39 SEL=C4=8C, Bart Van Assche <bvanassche@ac=
m=2Eorg> napsal:
>On 7/3/25 1:12 AM, Maurizio Lombardi wrote:
>> -static char *iscsi_parse_pr_out_transport_id(
>> +static void sas_parse_pr_out_transport_id(char *buf, char *i_str)
>> +{
>> +	char hex[17] =3D {0};
>
>Isn't "{}" the preferred way to zero-initialize arrays and data
>structures? "{}" has the advantage over "{0}" that it doesn't trigger
>any compiler warnings when initializing a data structure in which the
>first member is a pointer=2E

Ok, if this is the preferred way then I will replace it=2E I am going to s=
end a V3 anyway because I want to replace the strncpy() with strscpy ()=2E

Maurizio

