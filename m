Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FC8D53;
	Thu,  7 Dec 2023 09:42:58 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CBEFE21D95;
	Thu,  7 Dec 2023 17:42:55 +0000 (UTC)
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id CF8B413907;
	Thu,  7 Dec 2023 17:42:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id /uvBJx0EcmUeYwAAn2gu4w
	(envelope-from <lduncan@suse.com>); Thu, 07 Dec 2023 17:42:53 +0000
From: <lduncan@suse.com>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dbond@suse.com,
	hare@suse.de,
	cleech@redhat.com,
	michael.christie@oracle.com,
	Lee Duncan <lduncan@suse.com>
Subject: [PATCH 0/2] scsi: target: iscsi: Fix two protocol issues
Date: Thu,  7 Dec 2023 09:42:33 -0800
Message-Id: <cover.1701540918.git.lduncan@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.com (policy=quarantine);
	spf=fail (smtp-out1.suse.de: domain of lduncan@suse.com does not designate 2a07:de40:b281:104:10:150:64:98 as permitted sender) smtp.mailfrom=lduncan@suse.com
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [15.00 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_SPF_FAIL(1.00)[-all];
	 ARC_NA(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[mac.com];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 DMARC_POLICY_QUARANTINE(1.50)[suse.com : No valid SPF, No valid DKIM,quarantine];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_NO_DN(0.00)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[23.06%]
X-Spam-Score: 15.00
X-Rspamd-Queue-Id: CBEFE21D95
X-Spam: Yes

From: Lee Duncan <lduncan@suse.com>

Recent boot testing using the fastlinq qedi iSCSI Converged Network
Adapter and an LIO target uncovered a couple of issues with the
kernel iSCSI target driver. The first patch addresses an issue
with the handling of iSCSI "immediate commands", which are allowed
but not common, and the second patch lowers the noise level of the
driver when initiators send PDUs with the read and/or write bits
set but no data, which is also allowed. (See RFC 3720)

Lee Duncan (2):
  scsi: target: iscsi: handle SCSI immediate commands
  scsi: target: iscsi: don't warn of R/W when no data

 drivers/target/iscsi/iscsi_target.c      | 17 ++++++-----------
 drivers/target/iscsi/iscsi_target_util.c | 10 ++++++++--
 2 files changed, 14 insertions(+), 13 deletions(-)

-- 
2.43.0

