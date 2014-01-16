From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3
 emulation
Date: Wed, 15 Jan 2014 18:32:30 -0800
Message-ID: <1389839550.5567.643.camel@haakon3.risingtidesystems.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <52D6CD70.20706@mellanox.com>
	 <1389822920.5567.560.camel@haakon3.risingtidesystems.com>
	 <yq1wqi0wvm4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43894 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaAPCaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 21:30:35 -0500
In-Reply-To: <yq1wqi0wvm4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: sagi grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>

On Wed, 2014-01-15 at 20:42 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> nab> The issue is that existing fs/bio-integrity.c code always assumes
> nab> client/initiator mode, in that it will attempt to
> nab> bio_integrity_generate() protection information in the submit_bio
> nab> WRITE path, and bio_integrity_verify() of protection information in
> nab> the bio_endio READ completion path.
> 
> Only if the submit_bio() caller hasn't attached protection information
> already. If you submit a bio with a bip already attached the block layer
> will not generate/verify.
> 

Mmm, missed that detail.  So that would take care of the passthrough for
the WRITE case then..

How about a passthrough on the READ completion side for target fabrics
doing a hardware VERIFY..?  Any preferences how this should work..?

Also, for IBLOCK responses to properly generate GUARD + REFERENCE tag
CHECK_CONDITION sense failures from an underlying device VERIFY failure,
there will also need to be a way to propagate up the failure status
through bio_endio().  I assume bio_integrity_payload is the proper place
for adding something like this..?

One other item from my TODO list for IBLOCK protection support is how to
go about determining which DIF type to expose in the target, based upon
what is currently enabled on the underlying struct block_device.  I'm
currently trying to deduce the protection type by looking at struct
blk_integrity, but it would be helpful to make this explicit with
bi->prot_type.

--nab

