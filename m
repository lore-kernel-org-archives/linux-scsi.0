From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/17] scsi_dh_alua: Use workqueue for RTPG
Date: Mon, 11 May 2015 15:49:14 +0200
Message-ID: <20150511134914.GA7795@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40548 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbbEKNtQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 09:49:16 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:20PM +0200, Hannes Reinecke wrote:
> The current ALUA device_handler has two drawbacks:
> - We're sending a 'SET TARGET PORT GROUP' command to every LUN,
>   disregarding the fact that several LUNs might be in a port group
>   and will be automatically switched whenever _any_ LUN within
>   that port group receives the command.
> - Whenever a LUN is in 'transitioning' mode we cannot block I/O
>   to that LUN, instead the controller has to abort the command.
>   This leads to increased traffic across the wire and heavy load
>   on the controller during switchover.
> 
> With this patch the RTPG handling is moved to a workqueue, which
> is being run once per port group. This reduces the number of
> 'REPORT TARGET PORT GROUP' and 'SET TARGET PORT GROUPS' which
> will be send to the controller. It also allows us to block
> I/O to any LUN / port group found to be in 'transitioning' ALUA
> mode, as the workqueue item will be requeued until the controller
> moves out of transitioning.

I'm having a hard time understanding the workqueue use here.
What is the benefit of that one worker function to do everything?
It seems having a work struct in struct alua_queue_data to just
run STPG, and a different one to run RPTG in the port group structure
would be more sensible instead of interwinding them.

Also why do you need the sigle threaded workqueue?  That seems
like a possible limiting factor in a large enough system having
to deal with a cable disconnect cutting off multiple port groups,
or just during bootup.
