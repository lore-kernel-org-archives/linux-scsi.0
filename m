From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 31 May 2002 09:57:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205311357.g4VDvWI10367@localhost.localdomain>
References: <ARZEH@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA13863
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2002 06:57:43 -0700
In-Reply-To: Message from "Aron Zeh" <ARZEH@de.ibm.com>
   of "Fri, 31 May 2002 13:07:50 +0200." <OFF6A89763.CD0EBEF7-ONC1256BCA.003CD69A@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com, linux-scsi@vger.kernel.org

ARZEH@de.ibm.com said:
> I had hoped to be able to reproduce by now, but unfortunately my 2.5
> kernels currently fail to boot on zSeries. I'll try the repro and the
> bit change as soon as that little problem can be alleviated. 

Actually, I'm afraid there's more to it than my initial recommendation of just 
plugging the elevator queue.  Your problem lies in the device_blocked flag, 
which gets set when queuecommand returns non-zero and is not reset until an 
I/O comes back through scsi_finish_command().

I don't believe the host and device blocking serve any purpose anymore.  Also, 
with the advent of blocking in the blkdev layer, I think we can even get rid 
of the host_self_blocked flag (which is currently only used by the mesh 
driver).  So I'll look into getting rid of them all.

In the mean time, temporarily you may be able to fix it (and this should work 
for 2.4) by manually setting host_blocked to false and running the q->
request_fn(q) from your driver when you detect that the can't accept any 
commands condition is alleviated.

James


