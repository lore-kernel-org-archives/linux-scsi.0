From: Dan Carpenter <error27@gmail.com>
Subject: [patch] bfa: dereferencing before testing
Date: Sun, 8 Aug 2010 00:13:58 +0200
Message-ID: <20100807221358.GB9031@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65037 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0HGWO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2010 18:14:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Krishna Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

I moved the dereference of "port" after the check to verify it was
non-NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/bfa/lport_api.c b/drivers/scsi/bfa/lport_api.c
index 72b3f50..5cd356a 100644
--- a/drivers/scsi/bfa/lport_api.c
+++ b/drivers/scsi/bfa/lport_api.c
@@ -149,11 +149,12 @@ bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
 	enum bfa_pport_speed max_speed = 0;
 	struct bfa_pport_attr_s pport_attr;
 	enum bfa_pport_speed pport_speed, rport_speed;
-	bfa_boolean_t     trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
+	bfa_boolean_t trl_enabled;
 
 	if (port == NULL)
 		return 0;
 
+	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
 	fcs = port->fcs;
 
 	/*
