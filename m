Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275822BB09
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2024 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725374576; cv=none; b=u8SFCk7cXhfsAuZLzFGeSr5x4Zi1YcZ3eJX7QgikNL9cGcac9AgOyBpwp6LMwqrbZjjlLJfbNKxnWMl3HrTFL7iGN75Y0N/0p1GSEPkhMBhn+mzZ0roBNOtug3Lbg2Wh+pB4artXBBZm19dxAL1VrCxIUlAK/TWXAsLZ49hls6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725374576; c=relaxed/simple;
	bh=dNtKdTJelZbM/TXGoipRDOBBxmSJrk9t+FFX4tZGLzw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q9xJkvVRqXddUuPXBB023wWAgToq3POPk/kg2AY6NZ3yhOqrKKly/Juyco86ro+sTm2s25krvnscrf6Zkq6JTCBwyHVMsqEeacnnh93kMaAGkl6WrtjxILTlvUPbEw8SOlriOoT8bh7SD7V3juA3ShKdCNHCOfhEiRgOf4KD+ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=G2iO8CYc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=G2iO8CYc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="G2iO8CYc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="G2iO8CYc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4056321A53;
	Tue,  3 Sep 2024 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1725374572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNtKdTJelZbM/TXGoipRDOBBxmSJrk9t+FFX4tZGLzw=;
	b=G2iO8CYcG6HfjqwxrUd/nwAfkwuTMMFyBBdORELra1BxfD5WnzU410cKbVOPuFa+Vv+QSh
	btQ332n4WoDuE8qDHCZvpj2SY/1n5v+05lMiiXoyQf9Wh+69eMBYhRsPn6No9T+CANAYuN
	ksjSvXvwCVqDMwfb5NaxYTTyu8KjYXY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1725374572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNtKdTJelZbM/TXGoipRDOBBxmSJrk9t+FFX4tZGLzw=;
	b=G2iO8CYcG6HfjqwxrUd/nwAfkwuTMMFyBBdORELra1BxfD5WnzU410cKbVOPuFa+Vv+QSh
	btQ332n4WoDuE8qDHCZvpj2SY/1n5v+05lMiiXoyQf9Wh+69eMBYhRsPn6No9T+CANAYuN
	ksjSvXvwCVqDMwfb5NaxYTTyu8KjYXY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0895F13A80;
	Tue,  3 Sep 2024 14:42:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3DV+AGwg12brXwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 03 Sep 2024 14:42:52 +0000
Message-ID: <1be1baa5ee1c4dfca091fcaeb1fe5c237c76cc5a.camel@suse.com>
Subject: Re: [PATCH v3] ibmvfc: Add max_sectors module parameter
From: Martin Wilck <mwilck@suse.com>
To: Brian King <brking@linux.ibm.com>, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, 
	tyreld@linux.ibm.com, brking@pobox.com
Date: Tue, 03 Sep 2024 16:42:51 +0200
In-Reply-To: <20240903134708.139645-2-brking@linux.ibm.com>
References: <6594529f81c043f25b74198958718c84be27be4a.camel@suse.com>
	 <20240903134708.139645-2-brking@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Tue, 2024-09-03 at 08:47 -0500, Brian King wrote:
> There are some scenarios that can occur, such as performing an
> upgrade of the virtual I/O server, where the supported max transfer
> of the backing device for an ibmvfc HBA can change. If the max
> transfer of the backing device decreases, this can cause issues with
> previously discovered LUNs. This patch accomplishes two things.
> First, it changes the default ibmvfc max transfer value to 1MB.
> This is generally supported by all backing devices, which should
> mitigate this issue out of the box. Secondly, it adds a module
> parameter, enabling a user to increase the max transfer value to
> values that are larger than 1MB, as long as they have configured
> these larger values on the virtual I/O server as well.
>=20
> Signed-off-by: Brian King <brking@linux.ibm.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


