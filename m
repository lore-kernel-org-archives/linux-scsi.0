Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AB31D61BC
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 08:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770885512; cv=none; b=k7SRWw9kwlw2COAOXpJi0Cyzvn64kGsA2lYqmZmVk1z02nSonJwIvyeiI9oOVSj7jbdiAqaih4Cz+oyiw0cpozb5HsTeKs9UyYeIDNOwwB4eU56JRiApwNzTKFGl+A23Krv87V7ywyZsNVKYRRK5/UWcNjSbtFxdFIaSZQi3bV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770885512; c=relaxed/simple;
	bh=KMLLpzrdJekqFStk19wKmwaOUMApCpjv22EIeOh7Wjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=njj82T2NBJtHIJnSM0f2VSVSIhoI5cqgWqcZhe5zkSy1cTiiD8gyhYbSjoibeYVE6HbHmk+pD5bGUIMt+bUYnrlcScqL/fMoC4e/yTMjQF4tpU6t6R/RpEbn8IgkaVHq2tth8lMKdHcngf7diK4T7SEMRj1gceCMLql6khbsL1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lzyphsLO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lzyphsLO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lzyphsLO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lzyphsLO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 633153E6C2;
	Thu, 12 Feb 2026 08:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770885509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cg0lfHNLzOa86C9goVRT4Xy+ihFyb7RvSBqibZQ3pAc=;
	b=lzyphsLO0wfPGC/c7CNXE8WJNAh+YzVpYhWXqpX5zPZGahN1cMVeBrhCH0LRCxj4NOqlws
	7TIYX5K+G0U2OjVHhxkXh1GDuPcV84YGSPTJZm7CXOXH+JX4+dcToQgqFH2SIzfFev7u68
	SkWA3wJSFbnKiYDvU5Txh8Go5e5z3oE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770885509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cg0lfHNLzOa86C9goVRT4Xy+ihFyb7RvSBqibZQ3pAc=;
	b=lzyphsLO0wfPGC/c7CNXE8WJNAh+YzVpYhWXqpX5zPZGahN1cMVeBrhCH0LRCxj4NOqlws
	7TIYX5K+G0U2OjVHhxkXh1GDuPcV84YGSPTJZm7CXOXH+JX4+dcToQgqFH2SIzfFev7u68
	SkWA3wJSFbnKiYDvU5Txh8Go5e5z3oE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E95C63EA62;
	Thu, 12 Feb 2026 08:38:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I/3JN4SRjWkRMgAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 12 Feb 2026 08:38:28 +0000
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
Subject: [PATCH 0/2] xen/xenbus: better handle backend crash
Date: Thu, 12 Feb 2026 09:38:24 +0100
Message-ID: <20260212083826.136221-1-jgross@suse.com>
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
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -1.80
X-Spam-Level: 

This small series fixes PV-device frontend side handling in case the
backend crashed and has come up again.

The old device will be discarded and the replacement can be used
instead. 

Juergen Gross (2):
  xenbus: add xenbus_device parameter to xenbus_read_driver_state()
  xen/xenbus: better handle backend crash

 drivers/net/xen-netfront.c                 | 34 +++++++++---------
 drivers/pci/xen-pcifront.c                 |  8 ++---
 drivers/scsi/xen-scsifront.c               |  2 +-
 drivers/xen/xen-pciback/xenbus.c           | 10 +++---
 drivers/xen/xenbus/xenbus_client.c         | 16 +++++++--
 drivers/xen/xenbus/xenbus_probe.c          | 42 ++++++++++++++++++++--
 drivers/xen/xenbus/xenbus_probe_frontend.c |  2 +-
 include/xen/xenbus.h                       |  4 ++-
 8 files changed, 83 insertions(+), 35 deletions(-)

-- 
2.53.0

