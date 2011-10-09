From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/4] target: Fix transport_cmd_finish_abort queue
 removal bug
Date: Sat, 08 Oct 2011 19:03:32 -0700
Message-ID: <1318125812.4978.106.camel@haakon2.linux-iscsi.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
	 <1317358511-10664-4-git-send-email-nab@linux-iscsi.org>
	 <20111009013326.GC32104@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111009013326.GC32104@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-10-08 at 21:33 -0400, Christoph Hellwig wrote:
> The fix looks reasonable, but shouldn't the reordering also be applied
> to transport_cmd_finish_abort_tmr?
> 

The reordering in transport_cmd_finish_abort() was not the issue here,
but the calling transport_remove_cmd_from_queue() when 'remove == 0'.

This should not be a problem in transport_cmd_finish_abort_tmr() as we
always expect to release the tmr associated command.

--nab
