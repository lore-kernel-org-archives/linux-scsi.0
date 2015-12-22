From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 22/77] ncr5380: Eliminate selecting state
Date: Tue, 22 Dec 2015 08:14:07 +0100
Message-ID: <5678F83F.8090903@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011743.975930787@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbbLVHOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 02:14:09 -0500
In-Reply-To: <20151222011743.975930787@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Linux v2.1.105 changed the algorithm for polling for the BSY signal
> in NCR5380_select() and NCR5380_main().
>
> Presently, this code has a bug. Back then, NCR5380_set_timer(hostdata=
, 1)
> meant reschedule main() after sleeping for 10 ms. Repeated 25 times t=
his
> provided the recommended 250 ms selection time-out delay. This got br=
oken
> when HZ became configurable.
>
> We could fix this but there's no need to reschedule the main loop. Th=
is
> BSY polling presently happens when the NCR5380_main() work queue item
> calls NCR5380_select(), which in turn schedules NCR5380_main(), which
> calls NCR5380_select() again, and so on.
>
> This algorithm is a deviation from the simpler one in atari_NCR5380.c=
=2E
> The extra complexity and state is pointless. There's no reason to
> stop selection half-way and return to to the main loop when the main
> loop can do nothing useful until selection completes.
>
> So just poll for BSY. We can sleep while polling now that we have a
> suitable workqueue.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
