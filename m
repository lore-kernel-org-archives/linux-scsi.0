From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/7] iscsi-target: Fix iscsit_alloc_buffs() breakage
	with offset_in_page
Date: Sat, 4 Jun 2011 16:21:38 +0200
Message-ID: <20110604142138.GB13579@lst.de>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org> <1307150298-23921-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59612 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216Ab1FDOVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Jun 2011 10:21:38 -0400
Content-Disposition: inline
In-Reply-To: <1307150298-23921-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 03, 2011 at 06:18:12PM -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch changes iscsit_alloc_buffs() w/ SCF_SCSI_CONTROL_NONSG_IO_CDB
> to take into account the offset_in_page(), and also handles the case
> where length and PAGE_SIZE are identical, and require nents to be incremented.
> 
> It also moves iscsit_allocate_iovecs() for the SCSI payload case until
> after transport_generic_map_mem_to_cmd() has been called because the
> iovec allocation depends upon cmd->se_cmd.t_tasks_se_num having been
> set by the return of transport_map_sg_to_mem() done in RX thread context.

I'd rather just remove the SCF_SCSI_CONTROL_NONSG_IO_CDB side of the
code path, and always allocate one page per S/G list item.  That simplifies
the code, and fixes the issues with non-aligned kmallocs.

