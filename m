From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 1/7] iscsi-target: Fix iscsit_alloc_buffs() breakage	with
 offset_in_page
Date: Tue, 07 Jun 2011 14:43:05 -0700
Message-ID: <4DEE9B69.5080301@redhat.com>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org> <1307150298-23921-2-git-send-email-nab@linux-iscsi.org> <20110604142138.GB13579@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab1FGVnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2011 17:43:09 -0400
In-Reply-To: <20110604142138.GB13579@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 06/04/2011 07:21 AM, Christoph Hellwig wrote:
> On Fri, Jun 03, 2011 at 06:18:12PM -0700, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>> This patch changes iscsit_alloc_buffs() w/ SCF_SCSI_CONTROL_NONSG_IO_CDB
>> to take into account the offset_in_page(), and also handles the case
>> where length and PAGE_SIZE are identical, and require nents to be incremented.
>>
>> It also moves iscsit_allocate_iovecs() for the SCSI payload case until
>> after transport_generic_map_mem_to_cmd() has been called because the
>> iovec allocation depends upon cmd->se_cmd.t_tasks_se_num having been
>> set by the return of transport_map_sg_to_mem() done in RX thread context.
> 
> I'd rather just remove the SCF_SCSI_CONTROL_NONSG_IO_CDB side of the
> code path, and always allocate one page per S/G list item.  That simplifies
> the code, and fixes the issues with non-aligned kmallocs.

I thought about doing that but didn't quite have the guts.

It *would* simplify things a lot, though. Offsets of offsets are no fun.
+1 from me. Express everything in pages and scatterlists.

-- Andy
