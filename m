From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Wed, 19 Jun 2002 13:44:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020619134436.A27002@devserv.devel.redhat.com>
References: <20020619014048.B8623@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020619014048.B8623@redhat.com>; from dledford@redhat.com on Wed, Jun 19, 2002 at 01:40:48AM -0400
List-Id: linux-scsi@vger.kernel.org
To: dledford@redhat.com
Cc: linux-scsi@vger.kernel.org

>   So, when Justin Gibbs' driver allocates a queue depth of 253 
> commands on drive X, then finds out that drive X has a hard limit of 64, 
> then we aren't continuing to waste 189 commands worth of allocated kernel 
> memory that can never be effectively used.

> +		  diff = p->dev_lun_queue_depth[tindex] -
> +			 p->dev_active_cmds[tindex];
> +		  p->dev_lun_queue_depth[tindex] -= diff;

I think this is not enough, or backwards. We hit a situation with
EMC when attaching hundreds of disks depleted atomic memory with
queue request arrays before swapper had a chance to replenish it.
I would much appreciate if the initial allocation was concervative,
if low performing, and was adjusted upwards at slave_attach time.

For 2.5 I would appreciate if we made some SCSI allocations non-atomic.
The probe time things better be GFP_KERNEL.

-- Pete
