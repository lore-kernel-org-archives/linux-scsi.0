From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] scsi: move initialization of scmd->eh_entry
Date: Sat, 25 May 2013 04:47:42 -0400
Message-ID: <20130525084742.GA3288@infradead.org>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
 <1369389050-118628-2-git-send-email-hare@suse.de>
 <20130524165739.GC30270@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41719
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab3EYIrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 May 2013 04:47:45 -0400
Content-Disposition: inline
In-Reply-To: <20130524165739.GC30270@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: J??rn Engel <joern@logfs.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>

On Fri, May 24, 2013 at 12:57:40PM -0400, J??rn Engel wrote:
> >  	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> >  	if (cmd->cmd_len == 0)
> >  		cmd->cmd_len = scsi_command_size(cmd->cmnd);
> > +	INIT_LIST_HEAD(&cmd->eh_entry);
> > +	cmd->eh_eflags = 0;
> 
> I always suspect something subtle going on when a variable is
> initialized to 0 three lines below a memset.  Can line this go away?

The memset only zeroes the sense_buffer, not the whole scsi command
which would cause a major havoc for the callers.

