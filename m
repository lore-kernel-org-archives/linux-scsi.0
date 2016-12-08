From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: make ->no_write_same independent of reported ->max_ws_blocks
Date: Wed, 07 Dec 2016 19:18:31 -0500
Message-ID: <yq1lgvrqnmw.fsf@sermon.lab.mkp.net>
References: <20161205235638.11539-1-nicstange@gmail.com>
        <yq1d1h5viob.fsf@sermon.lab.mkp.net> <87lgvteaz0.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87lgvteaz0.fsf@gmail.com> (Nicolai Stange's message of "Tue, 06
        Dec 2016 09:08:19 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nicolai" == Nicolai Stange <nicstange@gmail.com> writes:

Nicolai,

Nicolai> 1.) Do these older SCSI devices have a way to report
Nicolai>     ->max_ws_blocks?

I'm afraid not.

Nicolai> 3.) Those older devices that have ->max_ws_blocks >
Nicolai>     SD_MAX_WS10_BLOCKS but ->ws16 == ->ws10 == 0, i.e. the
Nicolai>     heuristicated ones would always be given WRITE_SAME, not
Nicolai>     WRITE_SAME_16 commands?  C.f. sd_setup_write_same_cmnd():
Nicolai>     if ->ws16 is not set, do WRITE_SAME. Isn't this a little
Nicolai>     bit odd given that the reported -> max_ws_blocks would be
Nicolai>     greater than SD_MAX_WS10_BLOCKS?

The check looks confusing because it caps the number of blocks to 0xFFFF
(the WRITE SAME(10) limit) for WRITE SAME(16) commands. Several older
devices accept the 16-byte command which allows for a bigger block range
but they only actually check the lower two bytes. This will cause data
corruption as parts of a block range may not be zeroed as requested.

FWIW, I'm in agreement with your patch to disable write same in libata
as a quick fix for 4.9.

-- 
Martin K. Petersen	Oracle Linux Engineering
