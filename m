From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 03/23] bfa: PBC vport create
Date: Sun, 20 Jun 2010 09:51:53 -0500
Message-ID: <1277045513.5242.15.camel@mulgrave.site>
References: <1276626113-3102-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab0FTOv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2010 10:51:59 -0400
In-Reply-To: <1276626113-3102-1-git-send-email-huangj@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: linux-scsi@vger.kernel.org, vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com

On Tue, 2010-06-15 at 11:21 -0700, Jing Huang wrote:
> This patch enables creating PBC vport.
> During fcs init, fcs will read PBC vport using bfa iocfc API and invoke fcb
> callback to add the pbc vport entries into a list. The pbc vport list will be
> traversed in the subsequent pci probe process and vport will be created using
> fc transport provided vport create function.

This one's giving a single rejection:

patching file drivers/scsi/bfa/bfad_drv.h
Hunk #2 FAILED at 197.
1 out of 2 hunks FAILED -- saving rejects to file
drivers/scsi/bfa/bfad_drv.h.rej

But it looks to be serious:  then hunk is:

+++ drivers/scsi/bfa/bfad_drv.h
@@ -197,12 +199,18 @@
 	bfa_boolean_t	ipfc_enabled;
 	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
+	struct list_head pbc_pcfg_list;
 	u32 fwtrc_len;
 	char *fwtrc;
 	u32 reglen;
 	char *regdata;
 };

But the defined structure in the file is:

	bfa_boolean_t	ipfc_enabled;
	union bfad_tmp_buf tmp_buf;
	struct fc_host_statistics link_stats;
};

So there's quite a bit missing somewhere.

James


