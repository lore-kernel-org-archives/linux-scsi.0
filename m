From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 7644] New: Race: host lock is not acquired
 before calling ql_icmd
Date: Wed, 6 Dec 2006 16:28:06 -0800
Message-ID: <20061206162806.12cb1196.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937836AbWLGA2I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Dec 2006 19:28:08 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kB70S7ID012074
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 6 Dec 2006 16:28:07 -0800
Received: from akpm.corp.google.com (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id kB70S7wV022497
	for <linux-scsi@vger.kernel.org>; Wed, 6 Dec 2006 16:28:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Does drivers/scsi/qlogicfas408.c have a maintainer?


Begin forwarded message:

Date: Wed, 6 Dec 2006 16:14:31 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 7644] New: Race: host lock is not acquired before calling ql_icmd


http://bugzilla.kernel.org/show_bug.cgi?id=7644

           Summary: Race: host lock is not acquired before calling ql_icmd
    Kernel Version: 2.6.19
            Status: NEW
          Severity: normal
             Owner: drivers_parallel@kernel-bugs.osdl.org
         Submitter: tammy000@gmail.com


The caller of ql_icmd() should hold the host lock (from the head comments of
ql_icmd() shown below). But, the lock is not acquired in function
qlogicfas408_queuecommand(). All of these code is in file
drivers/scsi/qlogicfas408.c

/*
 *      Initiate scsi command - queueing handler 
 *      caller must hold host lock
 */

static void ql_icmd(struct scsi_cmnd *cmd)
{
        struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
        int     qbase = priv->qbase;
        int     int_type = priv->int_type;
        unsigned int i;

        priv->qabort = 0;

        REG0;
        /* clearing of interrupts and the fifo is needed */

 ...

------------------------------------------------------

int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
                              void (*done) (struct scsi_cmnd *))
{
        struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
        if (scmd_id(cmd) == priv->qinitid) {
                cmd->result = DID_BAD_TARGET << 16;
                done(cmd);
                return 0;
        }

        cmd->scsi_done = done;
        /* wait for the last command's interrupt to finish */
        while (priv->qlcmd != NULL) {
                barrier();
                cpu_relax();
        }
        ql_icmd(cmd);
        return 0;
}

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
