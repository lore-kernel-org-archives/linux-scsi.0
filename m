Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C370C14D6E0
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 09:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715072985; cv=none; b=nEAc9Kig581CM2QGJs7l8IkSyBhnLd13mOLBwoNLr49UEXERR88SFRuJaEEfmu3odBe0GRoLAXUj8DGiMYcbRUWXmwrkyUZ2QtK5+79F+Uhw/6iRmRV7VnLHExbjNsnP9K/PAW4PwSUt0bN3KGsA6BfRsydeWiPqoLNc+sZ2zdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715072985; c=relaxed/simple;
	bh=whJPA77Upgybzwao4juZGXQgyaW7xXuaYKnLcolhv70=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nKx4yLPbIQfRsDtpofAKIYQIoD2VafyfuPCX9D347ZnGafmKUoY+tIWqne2iUzjUkCap+kqav+TI3CUhd+kYJ3Q4mhgZTd97rXRFajhTPLDzdX9nX9tYXRMT45/04FOoq2Ie19odcz54TXKivM4NQ8tKnwZ7jQZ1c+UFgLG59PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mXEOX3QR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mXEOX3QR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mXEOX3QR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mXEOX3QR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 10B8A33C14;
	Tue,  7 May 2024 09:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715072976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T/LIKssSktB1LS12hdl4XSSD+fY878XkFR6coVvNEMs=;
	b=mXEOX3QRR+UDVGejnFRN2GBPmkX8ayZRKAQ6GJl/G1hQInZFC+QY8WCfMW5KmVpvv832cE
	XK7PJjvkLIpMNeVIULFaQdHSGwUS4m5gkA6oVOT9rLDQ15A8VNIPTGjbemnwwVN9hx6JkJ
	gHYDLgJGCoCBV21Phsvt9k3G9zPANxI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715072976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T/LIKssSktB1LS12hdl4XSSD+fY878XkFR6coVvNEMs=;
	b=mXEOX3QRR+UDVGejnFRN2GBPmkX8ayZRKAQ6GJl/G1hQInZFC+QY8WCfMW5KmVpvv832cE
	XK7PJjvkLIpMNeVIULFaQdHSGwUS4m5gkA6oVOT9rLDQ15A8VNIPTGjbemnwwVN9hx6JkJ
	gHYDLgJGCoCBV21Phsvt9k3G9zPANxI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8092139CB;
	Tue,  7 May 2024 09:09:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KtVdK8/vOWYzSQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 07 May 2024 09:09:35 +0000
Message-ID: <5218e8573df2dae3337fe89107d766ece64c1c51.camel@suse.com>
Subject: Re: [PATCH v2] I/O errors for ALUA state transitions
From: Martin Wilck <mwilck@suse.com>
To: Mike Christie <michael.christie@oracle.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes
 Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Ewan
 Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, 
 Rajashekhar M A
	 <rajs@netapp.com>
Date: Tue, 07 May 2024 11:09:35 +0200
In-Reply-To: <de89ed94-1446-4e92-998e-ca00e9ed7562@oracle.com>
References: <20240503195606.13120-1-mwilck@suse.com>
	 <de89ed94-1446-4e92-998e-ca00e9ed7562@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -3.69
X-Spam-Level: 
X-Spamd-Result: default: False [-3.69 / 50.00];
	BAYES_HAM(-2.39)[97.20%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]

On Mon, 2024-05-06 at 16:48 -0500, Mike Christie wrote:
> On 5/3/24 2:56 PM, Martin Wilck wrote:
> > =C2=A0	case UNIT_ATTENTION:
> > +		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D
> > 0x0a)
>=20
> Do you need to add this check in alua_tur as well? We are checking
> for
> the NOT_READY case.

Good point. I'll add the check, I suppose it can't hurt. But I notice
that scsi_test_unit_ready() tries to "eat" UA conditions and alua_tur()
calls it with ALUA_FAILOVER_RETRIES (5) retries, so checking the sense
key in alua_tur() probably won't make much of a difference, either.

[Side note: I am wondering if it makes sense to have
scsi_test_unit_ready() retry on UA when called from alua_tur(). After
all, alua_tur() is only called to check whether another RTPG must be
scheduled. @Hannes?]

Regards,
Martin



