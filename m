From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 31 May 2002 14:04:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFDC5A65E2.CC9DBDD9-ONC1256BCA.003F6545@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12relay01.de.ibm.com (d12relay01.de.ibm.com [9.165.215.22])
	by d12lmsgate-2.de.ibm.com (8.12.3/8.12.3) with ESMTP id g4VC4bj2017094
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2002 14:04:37 +0200
Received: from d12ml030.de.ibm.com (d12ml030_cs0 [9.165.223.25])
	by d12relay01.de.ibm.com (8.11.1m3/NCO/VER6.1) with ESMTP id g4VC4bL71252
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2002 14:04:37 +0200
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com


James,

I had hoped to be able to reproduce by now, but unfortunately my 2.5
kernels currently fail to boot on zSeries.
I'll try the repro and the bit change as soon as that little problem can be
alleviated.

Cheers,
Aron

ARZEH@de.ibm.com said:
> I think we are talking about two different things. If I am not
> mistaken, __scsi_insert_special is only called for character devices
> or ioctl (at least that is what it states in the description).
[...]
> The command is put into the mlqueue to be resent when a command
> completes.

True, but look what happens to it after that:

scsi_mlqueue_insert() -> scsi_insert_special_cmd -> __scsi_insert_special
().

__scsi_insert_special() is the ultimate point you always get to in the
mid-layer for pushing anything back to the block layer.

My theory is that because we set host or device blocked in
scsi_mlqueue_insert
which causes the termination of our request processing loop.  But, the
block
layer only expects this termination on exhaustion or plugging, so it thinks

we're still processing commands, however we're actually not.  Thus, the
request function is never called again and we get stuck I/Os.  The way to
correct this is to tell the block layer we have stopped processing by
plugging
the device queue.  Actually, I think host_blocked and device_blocked could
be
eliminated in favour of relying on the device queue plugging status.

The test of this theory is just the previously mentioned change of the 0 to
1,
could you try it since you seem to be able to reproduce the problem
reliably.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html







