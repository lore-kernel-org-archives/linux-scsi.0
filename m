Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823F5328DB
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 05:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713934843; cv=none; b=CylJaCaOsU+/17W/bxdEvltCjxMCkcM4S7nG/4tOEvqUB3bxm5kQxUGZL89m59nn1puT8zv7QEfMkVmpTWrnJYvhvxLZyxVgUw4myhAC4j61jldNXnTwUXUOgriPkHDkAOTKn8Yu86PfSZMvOVWJu0QkVAG6EnFmfS1084JYAcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713934843; c=relaxed/simple;
	bh=ao7OQcZmdLwMtq0LXrStUfPWeIy5vwwYewymO8xOfGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gt0OhjQ9tPNoZDLZunIl6oPqXkfMfNXq71D+9scCVRUb/A94+1N1QcotzfhlYeMbQls/2nJS9x1yuV+sFPwHYJXHpMsyASeyVVaejWbYB3PATjXznBh/3/XQmpkoNX/sZPq1JGunDZzp4LcL/N5L4maSvgvP35hoDttgj22RlaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4V1nInOZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4V1nInOZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=a8bRH9wZdl8Jspq814n02nI4lzQI3ApiT0uTFUVXPeA=; b=4V1nInOZfrcXr1uW2Sjuj+tikP
	IkLvz5eMEYR45jHHWPORZ13qVE1I9ylS/OrKvgVufEDXbwKvQL2KI8odAHVTMawNGc+k0S7bjW4Lu
	4mLOzOt+6m8Vi2TGpLNfUiYibr/mYX9aHfOlciTYLc4HdeyB4m08TByCXq+G+hYKHA6wkV5obFUDR
	KOJmzzJDMUU3gcw/y3KrE02hYAxQTOsHLxnOtiXG0iXEDD1w4uhlwjuzcbagtioNLCiqo/1VOXV/N
	/wIc23XDEcfCQPldJN4/cV9hqVfbMTvxfTzlUOSuLlconiVdP2PUGFQ8nnDWhu5ssQXSuOEMeSjPs
	gZ3Q4/4g==;
Received: from [50.53.4.147] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzUkI-00000002bkb-3yjO;
	Wed, 24 Apr 2024 05:00:39 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: libfc.h: add some kernel-doc comments
Date: Tue, 23 Apr 2024 22:00:38 -0700
Message-ID: <20240424050038.31403-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complete the kernel-doc notation for enum fc_lport_state. This fixes
7 kernel-doc warnings.
In struct fc_rport_priv, change 'event_callback' to 'lld_event_callback'
to match the struct member name.
In struct fc_fcp_pkt, add a description for 'timer_delay' to eliminate
one kernel-doc warning.
Add return value notation for 3 functions. This fixes 3 kernel-doc
warnings.

There are still 12 warnings for struct members not described in struct
fc_rport_priv and struct fc_lport, e.g:

libfc.h:218: warning: Function parameter or struct member 'event' not described in 'fc_rport_priv'
libfc.h:760: warning: Function parameter or struct member 'vlan' not described in 'fc_lport'

Warnings that are fixed in this patch:

libfc.h:75: warning: Enum value 'LPORT_ST_RNN_ID' not described in enum 'fc_lport_state'
libfc.h:75: warning: Enum value 'LPORT_ST_RSNN_NN' not described in enum 'fc_lport_state'
libfc.h:75: warning: Enum value 'LPORT_ST_RSPN_ID' not described in enum 'fc_lport_state'
libfc.h:75: warning: Enum value 'LPORT_ST_RPA' not described in enum 'fc_lport_state'
libfc.h:75: warning: Enum value 'LPORT_ST_DHBA' not described in enum 'fc_lport_state'
libfc.h:75: warning: Enum value 'LPORT_ST_DPRT' not described in enum 'fc_lport_state'
libfc.h:75: warning: Excess enum value 'LPORT_ST_RPN_ID' description in 'fc_lport_state'

libfc.h:218: warning: Excess struct member 'event_callback' description in 'fc_rport_priv'

libfc.h:793: warning: No description found for return value of 'fc_lport_test_ready'
libfc.h:835: warning: No description found for return value of 'fc_lport_init_stats'
libfc.h:856: warning: No description found for return value of 'lport_priv'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 include/scsi/libfc.h |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -- a/include/scsi/libfc.h b/include/scsi/libfc.h
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -44,11 +44,16 @@
  * @LPORT_ST_DISABLED: Disabled
  * @LPORT_ST_FLOGI:    Fabric login (FLOGI) sent
  * @LPORT_ST_DNS:      Waiting for name server remote port to become ready
- * @LPORT_ST_RPN_ID:   Register port name by ID (RPN_ID) sent
+ * @LPORT_ST_RNN_ID:   Register port name by ID (RNN_ID) sent
+ * @LPORT_ST_RSNN_NN:  Waiting for host symbolic node name
+ * @LPORT_ST_RSPN_ID:  Waiting for host symbolic port name
  * @LPORT_ST_RFT_ID:   Register Fibre Channel types by ID (RFT_ID) sent
  * @LPORT_ST_RFF_ID:   Register FC-4 Features by ID (RFF_ID) sent
  * @LPORT_ST_FDMI:     Waiting for mgmt server rport to become ready
- * @LPORT_ST_RHBA:
+ * @LPORT_ST_RHBA:     Register HBA
+ * @LPORT_ST_RPA:      Register Port Attributes
+ * @LPORT_ST_DHBA:     Deregister HBA
+ * @LPORT_ST_DPRT:     Deregister Port
  * @LPORT_ST_SCR:      State Change Register (SCR) sent
  * @LPORT_ST_READY:    Ready for use
  * @LPORT_ST_LOGO:     Local port logout (LOGO) sent
@@ -183,7 +188,7 @@ struct fc_rport_libfc_priv {
  * @r_a_tov:        Resource allocation timeout value (in msec)
  * @rp_mutex:       The mutex that protects the remote port
  * @retry_work:     Handle for retries
- * @event_callback: Callback when READY, FAILED or LOGO states complete
+ * @lld_event_callback: Callback when READY, FAILED or LOGO states complete
  * @prli_count:     Count of open PRLI sessions in providers
  * @rcu:	    Structure used for freeing in an RCU-safe manner
  */
@@ -289,6 +294,7 @@ struct fc_seq_els_data {
  * @timer:           The command timer
  * @tm_done:         Completion indicator
  * @wait_for_comp:   Indicator to wait for completion of the I/O (in jiffies)
+ * @timer_delay:     FCP packet timer delay in jiffies
  * @data_len:        The length of the data
  * @cdb_cmd:         The CDB command
  * @xfer_len:        The transfer length
@@ -788,6 +794,8 @@ void fc_fc4_deregister_provider(enum fc_
 /**
  * fc_lport_test_ready() - Determine if a local port is in the READY state
  * @lport: The local port to test
+ *
+ * Returns: %true if local port is in the READY state, %false otherwise
  */
 static inline int fc_lport_test_ready(struct fc_lport *lport)
 {
@@ -830,6 +838,8 @@ static inline void fc_lport_state_enter(
 /**
  * fc_lport_init_stats() - Allocate per-CPU statistics for a local port
  * @lport: The local port whose statistics are to be initialized
+ *
+ * Returns: %0 on success, %-ENOMEM on failure
  */
 static inline int fc_lport_init_stats(struct fc_lport *lport)
 {
@@ -851,6 +861,8 @@ static inline void fc_lport_free_stats(s
 /**
  * lport_priv() - Return the private data from a local port
  * @lport: The local port whose private data is to be retrieved
+ *
+ * Returns: the local port's private data pointer
  */
 static inline void *lport_priv(const struct fc_lport *lport)
 {
