From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: make ->no_write_same independent of reported ->max_ws_blocks
Date: Mon, 05 Dec 2016 22:29:56 -0500
Message-ID: <yq1d1h5viob.fsf@sermon.lab.mkp.net>
References: <20161205235638.11539-1-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161205235638.11539-1-nicstange@gmail.com> (Nicolai Stange's
        message of "Tue, 6 Dec 2016 00:56:38 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nicolai" == Nicolai Stange <nicstange@gmail.com> writes:

Nicolai,

Nicolai> Due to reported problems with Write Same on ATA devices, commit
Nicolai> 0ce1b18c42a5 ("libata: Some drives failing on SCT Write Same")
Nicolai> strived to report non-support for Write Same on non-zoned ATA
Nicolai> devices.

Nicolai> However, due to the following control flow in
Nicolai> sd_config_write_same() this doesn't always take effect, namely
Nicolai> if the ->max_ws_blocks as set in the by the ATA Identify Device
Nicolai> exceeds SD_WS10_BLOCKS:

I'd much prefer for libata to set no_write_same = 1 for non-ZAC devices.

Older SCSI devices have no way to explicitly report that WRITE SAME is
supported. So the heuristic is the way it is to permit trying WRITE SAME
unless no_write_same has been set by the device driver. libata used to
do this prior to the zoned support going in.

Nicolai> Since commit e73c23ff736e ("block: add async variant of
Nicolai> blkdev_issue_zeroout"), blkdev_issue_zeroout() got a little bit
Nicolai> more sensitive towards failing Write Sames on devices that
Nicolai> claim to support them and this results in messages like

That's something that needs to be addressed. blkdev_issue_zeroout() must
cope with WRITE SAME failing and fall back to a manual zeroout.

-- 
Martin K. Petersen	Oracle Linux Engineering
