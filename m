From: Christoph Hellwig <hch@lst.de>
Subject: remove the cmd_type field from struct request
Date: Tue, 31 Jan 2017 16:57:21 +0100
Message-ID: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

this series gets rid of the cmd_type field in struct request and
instead folds it into the REQ_OP* space.  This reduces the size of
struct request, and leads to a single op namespace that drivers
can easily switch on.  Except for the legacy ide driver which has
a mess of different request types [1] this also nicely cleans up the
code.

Note that the patches are on top of the

    "make SCSI passthrough support optional"

series I sent out on Saturday.  To make life easier I also have a git
tree available here:

	git://git.infradead.org/users/hch/block.git cmd_type

	http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/cmd_type

[1] which were a pain in the ass to untangle and debug during development,
it's really time for it to die..
