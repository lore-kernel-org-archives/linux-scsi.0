Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414F733D4FF
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 09:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771408330; cv=none; b=fbMfUgXkJ3sZGmKVKmpbL7RsyVwvBPLZg4f8x6Gd8c0r0enUiXkzfw0JapfHfUWaylVJlVTwnfCDH/R17x0cdEvnwvNT+UDRM+EFAEvAFESODvPxbIr0I74sdPXiZWrP7rcv6w97vIF+INcRgrnLln5IVmWocXLj4McxSnU//OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771408330; c=relaxed/simple;
	bh=RJN7VwLgRbysX/GaZnO21V0s1Gnlb8jQMZYhR3neSFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fRVqpdTmPfZ/bQpgcrsQIrZ9ZRNENlXOdxogcnkAC24olpCaXoQJxDLusn/2oMh15ngnLQ0yIIg/qs2V0C3J1Map8xr1cwh1c2qM7x9stcI5wuumJmGNUACPuE6bj3sSSpfRJhAlbrw2YykjGVvIzXBw49st8bqh7K2YlgBVYg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VA1AwakW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VA1AwakW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VA1AwakW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VA1AwakW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 90C8F5BCC9;
	Wed, 18 Feb 2026 09:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771408327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1qq8z/OXjLb7Vbssw0MTizM/EphKSCRXKSLOblBdcEE=;
	b=VA1AwakW+XiAmozxbE8J7qZrQuEf0+n6ib1+6fbubOke3wbODuvMeCOcD64nyd4vCS+6j/
	2cqA+2yIJ/JmEB55zUFcMfEL2AhvclSOmRZa1zIUUrbxNkD5jNvcTBFALY11162rdDspf9
	3hse2FjaMAWXjosrHWAfF8m3bSEH1VI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771408327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1qq8z/OXjLb7Vbssw0MTizM/EphKSCRXKSLOblBdcEE=;
	b=VA1AwakW+XiAmozxbE8J7qZrQuEf0+n6ib1+6fbubOke3wbODuvMeCOcD64nyd4vCS+6j/
	2cqA+2yIJ/JmEB55zUFcMfEL2AhvclSOmRZa1zIUUrbxNkD5jNvcTBFALY11162rdDspf9
	3hse2FjaMAWXjosrHWAfF8m3bSEH1VI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C1E53EA65;
	Wed, 18 Feb 2026 09:52:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +Y2iCceLlWnjfQAAD6G6ig
	(envelope-from <jgross@suse.com>); Wed, 18 Feb 2026 09:52:07 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 0/2]  xen/xenbus: better handle backend crash
Date: Wed, 18 Feb 2026 10:52:03 +0100
Message-ID: <20260218095205.453657-1-jgross@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[16];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -1.80
X-Spam-Level: 

This small series fixes PV-device frontend side handling in case the
backend crashed and has come up again.

The old device will be discarded and the replacement can be used
instead.

Changes in V2:
- fixed one comment related build warning

Juergen Gross (2):
  xenbus: add xenbus_device parameter to xenbus_read_driver_state()
  xen/xenbus: better handle backend crash

 drivers/net/xen-netfront.c                 | 34 +++++++++---------
 drivers/pci/xen-pcifront.c                 |  8 ++---
 drivers/scsi/xen-scsifront.c               |  2 +-
 drivers/xen/xen-pciback/xenbus.c           | 10 +++---
 drivers/xen/xenbus/xenbus_client.c         | 17 +++++++--
 drivers/xen/xenbus/xenbus_probe.c          | 42 ++++++++++++++++++++--
 drivers/xen/xenbus/xenbus_probe_frontend.c |  2 +-
 include/xen/xenbus.h                       |  4 ++-
 8 files changed, 84 insertions(+), 35 deletions(-)

-- 
2.53.0

