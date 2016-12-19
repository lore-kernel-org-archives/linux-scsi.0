From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 1/9] qla2xxx: Move cmd search out of qla during ABTS
Date: Mon, 19 Dec 2016 07:59:39 -0800
Message-ID: <20161219155939.GA3002@infradead.org>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
 <1482051769-22941-2-git-send-email-himanshu.madhani@cavium.com>
 <1482161586.25336.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482161586.25336.3.camel@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2016 at 03:33:27PM +0000, Bart Van Assche wrote:
> Please consider removing the sess_cmd_list loop. Any lookups in
> sess_cmd_list should be performed by the target core and not by a
> target driver. Are you aware that core_tmr_abort_task() performs a very
> similar lookup to the one above?

This was my first reaction as well, but it seems like qla2xxx hardware
doesn't pass up the LUN for an abort request.  If that's really the
case (which seems really odd to me) we'll need this loop.  If there is a
way to get the lun out of the hardware it would be preferable to make
use of that passed up lun.
