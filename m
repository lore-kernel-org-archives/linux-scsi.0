From: Lyle Seaman <lwseaman@excite.com>
Subject: suspicious code in hosts.c
Date: Fri, 29 Nov 2002 10:44:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021129154455Z267086-22911+3959@vger.kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from SOLO.o-o.yi.org (065-93-189-66.wo.cpe.charter-ne.com [66.189.93.65])
	by o-o.yi.org (Postfix) with ESMTP id 2F8201480A
	for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2002 10:52:15 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Message-Id: <20021129155215.2F8201480A@o-o.yi.org>
Date: Fri, 29 Nov 2002 10:52:15 -0500 (EST)

I sent this to the list earlier, but I never saw it come back, so I'm
assuming it got lost.  

scsi_tp_for_each_host drops the scsi_host_list_lock, does some work,
then picks up the lock and continues traversing the list.  It naively
uses list_for_each_safe, but that is only safe for non-preemptive,
non-yielding, single-processor applications.  Is there some other lock
that prevents the scsi_host_list from being altered behind my back
while I'm in scsi_tp_for_each_host ?  I don't see it.  It sure looks
like it could race with scsi_unregister, for instance.

Also, scsi_register_host runs without locking the list?

And scsi_unregister_host uses the BKL but not the scsi_host_list_lock?

I don't know enough about the scsi subsystem to be certain that these are
wrong, or that I know how to fix them, but they seem awfully
suspicious and are at best confusing.   What am I missing?



