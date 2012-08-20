From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] bfa: avoid buffer overrun for 12-byte model name
Date: Mon, 20 Aug 2012 18:55:23 +0200
Message-ID: <1345481724-30108-5-git-send-email-jim@meyering.net>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.meyering.net ([88.168.87.75]:44792 "EHLO hx.meyering.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755466Ab2HTR3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2012 13:29:46 -0400
In-Reply-To: <1345481724-30108-1-git-send-email-jim@meyering.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jim Meyering <meyering@redhat.com>, Jing Huang <huangj@brocade.com>, Krishna C Gudipati <kgudipat@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

From: Jim Meyering <meyering@redhat.com>

we use strncpy to copy a model name of length up to 15 (16, if you count
the NUL), into a buffer of size 12 (BFA_FCS_PORT_SYMBNAME_MODEL_SZ).
However, strncpy does not always NUL-terminate, so whenever the original
model string has strlen >= 12, the following strncat reads beyond end
of the ->sym_name buffer as it attempts to find end of string.

bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
{
	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
	...
	strncpy((char *)&port_cfg->sym_name, model,
		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
	...

bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
{
	struct bfi_ioc_attr_s	*ioc_attr;

	WARN_ON(!model);
	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);

BFA_ADAPTER_MODEL_NAME_LEN = 16

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 drivers/scsi/bfa/bfa_fcs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index eaac57e..3329493 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -713,6 +713,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 	/* Model name/number */
 	strncpy((char *)&port_cfg->sym_name, model,
 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
+	port_cfg->sym_name[BFA_FCS_PORT_SYMBNAME_MODEL_SZ - 1] = 0;
 	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));

-- 
1.7.12

