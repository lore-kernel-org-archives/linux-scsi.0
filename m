From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 1/1] cciss: read config to obtain max outstanding
 commands per controller
Date: Mon, 7 Jul 2008 15:12:19 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778825963E5E81@GVW0547EXC.americas.hpqcorp.net>
References: <20080701210247.GA5095@roadking.ldev.net>
 <20080701142308.4958bc5f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:40619 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYGGPMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 11:12:48 -0400
In-Reply-To: <20080701142308.4958bc5f.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, July 01, 2008 4:23 PM
> To: Miller, Mike (OS Dev)
> Cc: jens.axboe@oracle.com; linux-kernel@vger.kernel.org;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] cciss: read config to obtain max
> outstanding commands per controller
>
> On Tue, 1 Jul 2008 16:02:47 -0500
> Mike Miller <mike.miller@hp.com> wrote:
>
> > This patch changes the way we determine the maximum number of
> > outstanding commands for each controller. Most Smart Array
> controllers
> > can support up to 1024 commands, the notable exceptions are
> the E200 and E200i.
> > The next generation of controllers which were just added support a
> > mode of operation called Zero Memory Raid (ZMR).  In this mode they
> > only support 64 outstanding commands. In Full Function Raid
> (FFR) mode they support 1024.
> > We have been setting the queue depth by arbitrarily assigning some
> > value for each controller. We needed a better way to set the queue
> > depth to avoid lots of annoying "fifo full" messages. So we
> made the
> > driver a little smarter. We now read the config table and
> subtract 4
> > from the returned value. The -4 is to allow some room for
> ioctl calls
> > which are not tracked the same way as io commands are tracked.
>
> What would be the effect of _not_ having this patch upon
> users of the new hardware?
>
> If the answer is "bad" then we should get this change into
> 2.6.26 and 2.6.25.x, because people will surely be running
> those kernels on the new hardware.

Sorry for my late reply, I've been out of the office. Not having this patch would be bad. The performance at a queue depth of 64 is not very good anyway. If we hit the "fifo full" condition we spew annoying messages and spin for a bit and try again. This leads to very poor performance.

Thanks,
mikem
