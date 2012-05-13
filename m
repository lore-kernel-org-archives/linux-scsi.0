From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] lpfc 8.3.19: Added support for ELS RRQ command
Date: Sun, 13 May 2012 21:50:06 +0300
Message-ID: <20120513185005.GD16541@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:38619 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2EMSuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2012 14:50:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

[ Hi, I've made some changes to Smatch so I'm sending bug reports for
  some old bugs.  Hope nobody minds and all. ]

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch 19ca760979e4: "[SCSI] lpfc 8.3.19: Added support for ELS 
RRQ command" from Nov 20, 2010, leads to the following Smatch 
complaint:

drivers/scsi/lpfc/lpfc_sli.c:15999 lpfc_drain_txq()
	 warn: variable dereferenced before check 'piocbq' (see line 15993)

drivers/scsi/lpfc/lpfc_sli.c
 15992			piocbq = lpfc_sli_ringtx_get(phba, pring);
 15993			sglq = __lpfc_sli_get_sglq(phba, piocbq);
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
New call to __lpfc_sli_get_sglq() dereferences "piocbq".

 15994			if (!sglq) {
 15995				__lpfc_sli_ringtx_put(phba, pring, piocbq);
 15996				spin_unlock_irqrestore(&phba->hbalock, iflags);
 15997				break;
 15998			} else {
 15999				if (!piocbq) {
                                    ^^^^^^^
Old check.

 16000					/* The txq_cnt out of sync. This should
 16001					 * never happen

regards,
dan carpenter

