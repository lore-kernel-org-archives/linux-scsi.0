Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735CE481BA
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 20:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710535517; cv=none; b=FzBXjkiukE9WJpvDM1kuh0CtkCoD9a146iglxt2fA8ly1VODGAXIGrjrN6NsEgUqSwCd+t4gK/lIr96ITB3GLgJCGeZqjeEms0bzsLsOefDVdwtHe/yH0uGVzeYVbC77yjT/DG6pz/5A5q0s6OHhIZNoU54D2tmrhuFl69JHTfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710535517; c=relaxed/simple;
	bh=jd6WQpIZWl+beTPUw6k06XcB17/d+Hl4Q/cBaxhByE8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bw8aSXoxVG33zZs9OnbX0fMSl7Rgg0vFtJQa5XNDHR/EMZNYY8sv9Mt4rrU+WXbxF8hG1xUBk7/gEVns9kNX3wIyfecgA4fiErnLFG9+R7SQ6TfijauVz76qsJqq8EqZDEgJQZr67okPCHVIa97vdC+AXy4pHZTBJrMZNvXzbBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O+WNRT5E; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O+WNRT5E; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O+WNRT5E";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O+WNRT5E"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 746F921E03;
	Fri, 15 Mar 2024 20:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1710535510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jd6WQpIZWl+beTPUw6k06XcB17/d+Hl4Q/cBaxhByE8=;
	b=O+WNRT5ErbaU+MgryAkb1c4fotKsx4D3yAkduCxVUBi8gRRVMH52n+tsBOftC3Pbv859Ji
	hzw47cfK30ybRd9qrvWji+7nFy8FAJO/JL63LF4oCodHJwGCjSXnnGqnvDyI4z0VROBVXJ
	4DQavpCC9ZSnXIctJ+Qa6qWrrUATMjs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1710535510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jd6WQpIZWl+beTPUw6k06XcB17/d+Hl4Q/cBaxhByE8=;
	b=O+WNRT5ErbaU+MgryAkb1c4fotKsx4D3yAkduCxVUBi8gRRVMH52n+tsBOftC3Pbv859Ji
	hzw47cfK30ybRd9qrvWji+7nFy8FAJO/JL63LF4oCodHJwGCjSXnnGqnvDyI4z0VROBVXJ
	4DQavpCC9ZSnXIctJ+Qa6qWrrUATMjs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4112013460;
	Fri, 15 Mar 2024 20:45:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +/jgDVaz9GXEMAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 15 Mar 2024 20:45:10 +0000
Message-ID: <e3cfb8bc22402874b1984bec3ccfd5141c49704c.camel@suse.com>
Subject: Re: [PATCH 0/3] qedf misc bug fixes
From: Martin Wilck <mwilck@suse.com>
To: Saurav Kashyap <skashyap@marvell.com>, martin.petersen@oracle.com
Cc: GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Date: Fri, 15 Mar 2024 21:45:09 +0100
In-Reply-To: <20240315100600.19568-1-skashyap@marvell.com>
References: <20240315100600.19568-1-skashyap@marvell.com>
Autocrypt: addr=mwilck@suse.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.21
X-Spamd-Result: default: False [-3.21 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-1.91)[94.53%];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-0.20)[-0.999];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On Fri, 2024-03-15 at 15:35 +0530, Saurav Kashyap wrote:
> Hi Martin,
>=20
> Please apply the qedf driver fixes to the
> scsi tree at your earliest convenience.
>=20
> Thanks,
> Saurav
>=20
> Saurav Kashyap (3):
> =C2=A0 qedf: Don't process stag work during unload and recovery.
> =C2=A0 qedf: Wait for stag work during unload.
> =C2=A0 qedf: Memset qed_slowpath_params to zero before use.
>=20
> =C2=A0drivers/scsi/qedf/qedf.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0drivers/scsi/qedf/qedf_main.c | 43
> ++++++++++++++++++++++++++++++++++-
> =C2=A02 files changed, 43 insertions(+), 1 deletion(-)
>=20

This series fixed a well-reproducible kernel crash on one of our
hardware partner's systems.

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

