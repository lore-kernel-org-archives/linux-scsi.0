From: Christoph Hellwig <hch@lst.de>
Subject: Re: NVMe over Fabrics target implementation
Date: Tue, 7 Jun 2016 12:55:50 +0200
Message-ID: <20160607105550.GB17113@lst.de>
References: <1465248177-17970-1-git-send-email-hch@lst.de> <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, keith.busch@intel.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

There is absolutely no point in dragging in an overcomplicated configfs 
structure for a very simple protocol which also is very different from
SCSI in it's nitty gritty details.  Keeping the nvme target self contains
allows it to be both much simpler and much easier to understand, as well
as much better testable - see the amount of test coverage we could easily
add for example.

Or to put it the other way around - if there was any major synergy in
reusing the SCSI target code that just shows we're missing functionality
in the block layer or configfs.

The only thing where this is the case mid-term is persistent reservations,
but Mike Christie already has a plan for a pluggable PR API, which I'm
very interested in.
