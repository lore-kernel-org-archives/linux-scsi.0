From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] target: Fix transport_cmd_finish_abort queue removal
 bug
Date: Sat, 8 Oct 2011 22:27:49 -0400
Message-ID: <20111009022749.GB7948@infradead.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
 <1317358511-10664-4-git-send-email-nab@linux-iscsi.org>
 <20111009013326.GC32104@infradead.org>
 <1318125812.4978.106.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1318125812.4978.106.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 08, 2011 at 07:03:32PM -0700, Nicholas A. Bellinger wrote:
> The reordering in transport_cmd_finish_abort() was not the issue here,
> but the calling transport_remove_cmd_from_queue() when 'remove == 0'.
>
> This should not be a problem in transport_cmd_finish_abort_tmr() as we
> always expect to release the tmr associated command.

I know, but I'd really not have subtily different calling conventions
between the two.

Right now transport_cmd_finish_abort and transport_cmd_finish_abort_tmr
only differ in:

 - transport_cmd_finish_abort calling transport_lun_remove_cmd
 - transport_cmd_finish_abort having the remove flag to make the
   transport_put_cmd (and with your patch the
   transport_remove_cmd_from_queue) call optional.

I'd much rather add a conditional on the command beeing a TMR and merge
the two into a single helper than having them diverge further.
