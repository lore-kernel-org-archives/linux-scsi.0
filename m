From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3 emulation
Date: Wed, 15 Jan 2014 22:04:58 -0500
Message-ID: <yq1ob3cwrs5.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<52D6CD70.20706@mellanox.com>
	<1389822920.5567.560.camel@haakon3.risingtidesystems.com>
	<yq1wqi0wvm4.fsf@sermon.lab.mkp.net>
	<1389839550.5567.643.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389839550.5567.643.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Wed, 15 Jan 2014 18:32:30 -0800")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, sagi grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> Mmm, missed that detail.  So that would take care of the
nab> passthrough for the WRITE case then..

nab> How about a passthrough on the READ completion side for target
nab> fabrics doing a hardware VERIFY..?  Any preferences how this should
nab> work..?

Just attach a bip and issue a READ.

nab> Also, for IBLOCK responses to properly generate GUARD + REFERENCE
nab> tag CHECK_CONDITION sense failures from an underlying device VERIFY
nab> failure, there will also need to be a way to propagate up the
nab> failure status through bio_endio().  I assume bio_integrity_payload
nab> is the proper place for adding something like this..?

In my qualification tooling I have a patch that passes the info up the
stack. But it's a bit of a hack (declares a completion status on the
stack that shared between all clones). The alternative is to create new
errno values for each case.

nab> One other item from my TODO list for IBLOCK protection support is
nab> how to go about determining which DIF type to expose in the target,
nab> based upon what is currently enabled on the underlying struct
nab> block_device.  I'm currently trying to deduce the protection type
nab> by looking at struct blk_integrity, but it would be helpful to make
nab> this explicit with bi->prot_type.

You need to match on the integrity profile string. T10-DIF-TYPE1-IP
means it's DIF Type 1 format with IP checksum.

-- 
Martin K. Petersen	Oracle Linux Engineering
