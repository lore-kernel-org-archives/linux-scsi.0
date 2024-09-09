Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47CC1B29BE
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 09:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725872864; cv=none; b=KkXKnbPKwIXhqowY1dTjakVB8AO8bFbkoSQvZKBzA+m2+XqIZsIPznXqzMsCAbTmkvtKFtRUebOclQAJtVFTVF1UIpQDbeMR4gUuXp/QKM9IO46PRXbxixffT4EYiSzJ4D6DlFT1FOho3XchL6XlsFHGiPKz/aase4KOhlKefjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725872864; c=relaxed/simple;
	bh=R/DtaFei5vnLId95YCvQ3f7Sx9Vl27D0kfTW37XO49Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G0uKoDzEHk9MWa0mdWww0Obn9NZq19LqML9Am3jTl5qYK3rv5VBZ/7xaja5UES0e72WiUkQbsHlx0DVP8Cs2sj5x/9XYOn+TATeeO8i+83LUGvyTxSLB18aV21+xM7oRNRWxyX39qrpOPp6xPuurQ9KeIXCL57wx7O/IjZ5YPCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nMGQlBb7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nMGQlBb7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nMGQlBb7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nMGQlBb7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C9F5D1F7A6;
	Mon,  9 Sep 2024 09:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1725872860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/DtaFei5vnLId95YCvQ3f7Sx9Vl27D0kfTW37XO49Y=;
	b=nMGQlBb7eYiUShoPmMAyfept8/vuVkZjzVsgEF4of2bDsw9+zQWTKSEliHjkv+k8pY0N4z
	TiYLJbcJ+zCKXo8a0vdvEnRPoJrqCw5ceYLO0pVBM29Vz6aoqM1a5zPyYqiLEZGbDJrds5
	xuF27lKXeDLG1cXAyN0eboUUTD9zc0k=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1725872860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/DtaFei5vnLId95YCvQ3f7Sx9Vl27D0kfTW37XO49Y=;
	b=nMGQlBb7eYiUShoPmMAyfept8/vuVkZjzVsgEF4of2bDsw9+zQWTKSEliHjkv+k8pY0N4z
	TiYLJbcJ+zCKXo8a0vdvEnRPoJrqCw5ceYLO0pVBM29Vz6aoqM1a5zPyYqiLEZGbDJrds5
	xuF27lKXeDLG1cXAyN0eboUUTD9zc0k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A04813A3A;
	Mon,  9 Sep 2024 09:07:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xnYgINy63mYhfAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 09 Sep 2024 09:07:40 +0000
Message-ID: <d266c7827f3d95711d2237e070159c949d324d2f.camel@suse.com>
Subject: Re: [PATCH v3] ibmvfc: Add max_sectors module parameter
From: Martin Wilck <mwilck@suse.com>
To: martin.petersen@oracle.com, Brian King <brking@linux.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, 
	tyreld@linux.ibm.com, brking@pobox.com, Hannes Reinecke <hare@suse.com>
Date: Mon, 09 Sep 2024 11:07:40 +0200
In-Reply-To: <1be1baa5ee1c4dfca091fcaeb1fe5c237c76cc5a.camel@suse.com>
References: <6594529f81c043f25b74198958718c84be27be4a.camel@suse.com>
	 <20240903134708.139645-2-brking@linux.ibm.com>
	 <1be1baa5ee1c4dfca091fcaeb1fe5c237c76cc5a.camel@suse.com>
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
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Tue, 2024-09-03 at 16:42 +0200, Martin Wilck wrote:
> On Tue, 2024-09-03 at 08:47 -0500, Brian King wrote:
> > There are some scenarios that can occur, such as performing an
> > upgrade of the virtual I/O server, where the supported max transfer
> > of the backing device for an ibmvfc HBA can change. If the max
> > transfer of the backing device decreases, this can cause issues
> > with
> > previously discovered LUNs. This patch accomplishes two things.
> > First, it changes the default ibmvfc max transfer value to 1MB.
> > This is generally supported by all backing devices, which should
> > mitigate this issue out of the box. Secondly, it adds a module
> > parameter, enabling a user to increase the max transfer value to
> > values that are larger than 1MB, as long as they have configured
> > these larger values on the virtual I/O server as well.
> >=20
> > Signed-off-by: Brian King <brking@linux.ibm.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Martin P., do you need another review to merge this patch?

Martin W.

