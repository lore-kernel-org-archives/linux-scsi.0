From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD reentrancy
Date: Mon, 26 Aug 2002 09:16:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826091628.A6694@eng2.beaverton.ibm.com>
References: <3D669AC2.4C5D522A@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D669AC2.4C5D522A@splentec.com>; from luben@splentec.com on Fri, Aug 23, 2002 at 04:27:46PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Aug 23, 2002 at 04:27:46PM -0400, Luben Tuikov wrote:

> * In scsi_scan.c :: void scan_scsis(), select_queue_depths() is called
> when there is a _dummy_ device in host_queue. This comes from
> doing that juggle with SDpnt and oldSDpnt, allocating it in one
> place and freeing it in another...
> 
> So when select_queue_depths() is called, in the host_queue, there's
> _one__more_ device than there really should be, because of that SDpnt/oldSDpnt.
> 
> I filter the dummy SDpnt in select_queue_depths() by checking
> vendor, model, rev and attached. But I'd rather
> just get only the _actual_ devices in the host_queue, by
> probably getting rid of that SDpnt/oldSDpnt juggle logic.

The above is for the "hardcoded" scans; the cleaned-up scsi_scan.c has
this change and is in the latest linus bk tree, so it should show up
in 2.5.31.

-- Patrick Mansfield
