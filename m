From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] lpfc 8.3.29: T10 Diff fixes and enhancements
Date: Mon, 20 Feb 2012 14:39:33 +0300
Message-ID: <20120220113933.GA28224@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:29649 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BTLjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 06:39:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch acd6859b084d: "[SCSI] lpfc 8.3.29: T10 Diff fixes and 
enhancements" from Jan 18, 2012, leads to the following Smatch 
complaint:

drivers/scsi/lpfc/lpfc_scsi.c:1592 lpfc_bg_err_inject()
	 error: we previously assumed 'apptag' could be null (see line 1430)

drivers/scsi/lpfc/lpfc_scsi.c
  1429		/* Should we change the Application Tag */
  1430		if (apptag) {
                    ^^^^^^
Old check.

  1431			if (phba->lpfc_injerr_wapp_cnt) {
  1432				switch (op) {
  1433				case SCSI_PROT_WRITE_PASS:
  1434					if (blockoff && src) {

[snip]

  1585				case SCSI_PROT_READ_STRIP:
  1586				case SCSI_PROT_READ_PASS:
  1587					/*
  1588					 * For READ_STRIP and READ_PASS, force the
  1589					 * error on data being read off the wire. It
  1590					 * should force an IO error to the driver.
  1591					 */
  1592					*apptag = 0xDEAD;
                                        ^^^^^^^
New dereference not checked.  Btw, apptag is always zero in the current
code.

  1593					phba->lpfc_injerr_rgrd_cnt--;
  1594					phba->lpfc_injerr_lba = LPFC_INJERR_LBA_OFF;

regards,
dan carpenter

