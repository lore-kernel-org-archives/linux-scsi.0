From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/6] scsi: clean up S/G table freeing
Date: Tue, 18 Nov 2014 18:14:30 +0000 (UTC)
Message-ID: <loom.20141118T190348-558@post.gmane.org>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58459 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbaKRSkI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2014 13:40:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1Xqnh6-00074u-77
	for linux-scsi@vger.kernel.org; Tue, 18 Nov 2014 19:40:06 +0100
Received: from 63.163.107.100 ([63.163.107.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2014 19:40:04 +0100
Received: from bvanassche by 63.163.107.100 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2014 19:40:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Christoph Hellwig <hch <at> lst.de> writes:
> -static void scsi_release_buffers(struct scsi_cmnd *cmd)
> -{
> -	if (cmd->sdb.table.nents)
> -		scsi_free_sgtable(&cmd->sdb, false);
> -
> -	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
> -
> -	if (scsi_prot_sg_count(cmd))
> -		scsi_free_sgtable(cmd->prot_sdb, false);
> -}

Hello Christoph,

Since I'm traveling I'm using a laptop with a small screen so I might be
missing some context information. What is not clear to me about this patch
is whether it changes a scsi_free_sgtable(cmd->prot_sdb, false) call into a
scsi_free_sgtable(cmd->prot_sdb, true) call for the non-mq path ?

Thanks,

Bart.

