From: Roland Dreier <roland@kernel.org>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 6 Jul 2011 11:07:47 -0700
Message-ID: <CAL1RGDXXQc3VOq7UB0z7P=xwpmV3m8vNnFk078p_G8aMGJ5XDQ@mail.gmail.com>
References: <CAL1RGDW41oxoES=c+g9oLdx4mriBiEtxRpv=OD7yEJ6XKdU_fQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1107061251580.1995-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:39458 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753198Ab1GFSIJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2011 14:08:09 -0400
Received: by mail-qw0-f47.google.com with SMTP id 5so109543qwh.34
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2011 11:08:08 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1107061251580.1995-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, Jul 6, 2011 at 9:53 AM, Alan Stern <stern@rowland.harvard.edu> =
wrote:
> He probably meant blk_execute_rq_nowait(). =A0The test has to be done
> before the elevator is accessed.

Hmm, seems we would need the test in multiple places, since my second c=
all
trace is io_schedule -> blk_flush_plug_list -> queue_unplugged ->
__blk_run_queue

So I don't think I hit blk_execute_rq_nowait in my crash.

But maybe the problem is that dm-multipath is trying to requeue the IO =
to an
underlying sdX device that is already dead?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
