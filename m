From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Fri, 12 Aug 2016 16:56:02 -0400
Message-ID: <yq1lh01n1ul.fsf@sermon.lab.mkp.net>
References: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
	<yq1r39upy7p.fsf@sermon.lab.mkp.net>
	<CAGnHSE=E1Bj99EciXrDS31n4Q4VcRL0sDJ2t4ynx0bHgp5RNtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGnHSE=E1Bj99EciXrDS31n4Q4VcRL0sDJ2t4ynx0bHgp5RNtw@mail.gmail.com>
	(Tom Yan's message of "Fri, 12 Aug 2016 13:02:42 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

>> put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM / (sector_size / 512), &rbuf[36]);

How many 8-byte ranges fit in a 4096-byte sector?

Tom> So were you trying to pointing out something I am still missing, or
Tom> were you merely confirming I was right?

I suggest you drop ATA_MAX_TRIM_RNUM and do:

enum {
     ATA_TRIM_BLOCKS_PER_RANGE = 65535, /* 0xffff blocks per range desc. */
     ATA_TRIM_RANGE_SIZE_SHIFT = 3,     /* range descriptor is 8 bytes */
};

put_unaligned_be64(ATA_TRIM_BLOCKS_PER_RANGE *
		   sector_size >> ATA_TRIM_RANGE_SIZE_SHIFT, &rbuf[36]);

Might be worthwhile to create an ata_max_lba_range_blocks() wrapper.

-- 
Martin K. Petersen	Oracle Linux Engineering
