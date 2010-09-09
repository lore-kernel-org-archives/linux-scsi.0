From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi_cmnd data_buffer checksum
Date: Thu, 09 Sep 2010 09:23:24 -0400
Message-ID: <yq1fwxjt5ir.fsf@sermon.lab.mkp.net>
References: <215508.92384.qm@web32402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <215508.92384.qm@web32402.mail.mud.yahoo.com> (Anil kumar's
	message of "Thu, 9 Sep 2010 02:09:28 -0700 (PDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Anil kumar <anils_r@yahoo.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Anil" == Anil kumar <anils_r@yahoo.com> writes:

Anil> cmd-> write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
Anil> memcpy(cmd->local_write_buf, cmd->write_buf, cmd->scsibufflen(scsi_cmnd));

You need to walk the scatterlist.  You can't assume that the pages are
contiguous in memory.

But why are you doing this checksumming stuff manually when the existing
DIX/DIF code can do it for you?

-- 
Martin K. Petersen	Oracle Linux Engineering
