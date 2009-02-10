From: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch] powerpc/ps3: Use hard coded values for LV1 device type
Date: Tue, 10 Feb 2009 14:46:19 -0800
Message-ID: <499203BB.5010902@am.sony.com>
References: <498C6C49.1010200@in.ibm.com>  <498CF52E.4040903@am.sony.com>	 <1234092590.10240.4.camel@localhost>  <1234138267.31963.77.camel@pasglop> <1234151988.8776.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:42486 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbZBJWrM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Feb 2009 17:47:12 -0500
In-Reply-To: <1234151988.8776.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, michael@ellerman.id.au, Mel Gorman <mel@csn.ul.ie>, linuxppc-dev@ozlabs.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2009-02-09 at 11:11 +1100, Benjamin Herrenschmidt wrote:
>> The PS3 platform code wants to use some of the standard SCSI types from
>> there though, as they are part of the hypervisor ABI. (And in fact it
>> can be argued that non-block devices using SCSI do exist, such as
>> scanners, no ?)
>> 
>> Any reason other than pre-historical to have blkdev.h shielded like
>> that ?
> 
> Actually, I think the fix lies in scsi.h ... we can make that into a
> nicely independent protocol header file.  Your current woes come because
> it pulls in scsi_cmnd.h ... perhaps just getting rid of this will fix
> it.
> 
> Can the rest of linux-scsi verify that the fix below doesn't break
> something else?
> 
> I found one cockup: block/cmd-filter.c is apparently not including
> linuc/blkdev.h directly but via scsi/scsi.h ... I fixed this up.
...
> diff --git a/block/cmd-filter.c b/block/cmd-filter.c
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h

I tested this scsi header fix on PS3 and it fixes the BLK_MAX_CDB
not defined build error when CONFIG_BLOCK=n.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>


