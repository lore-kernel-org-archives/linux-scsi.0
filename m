From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Thu, 29 Aug 2002 08:59:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF9C38FD78.07E54601-ON87256C24.0056B509@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org, patman@beaverton.ibm.com


>GFP_KERNEL *should* never fail until
>we get to a true OOM condition because it will block and wait for the vm
>subsystem to free us up some space.  Under true OOM conditions it will
>return NULL AFAIK.

That (the NULL case) doesn't sound right to me.  The purpose of the OOM
Killer is to choose wisely which processes should die when there's simply
not enough memory to go around.  And it does it by terminating a process
directly, not by affecting the return value of kmalloc().  So if
kmalloc(GFP_KERNEL) returns NULL when the system is out of memory, the
system is arbitrarily killing whoever is the next guy to ask for memory,
thus defeating the purpose of the OOM Killer.

Incidentally, I've had to explain GFP_ATOMIC to many people, and I believe
the reason for its incorrect usage is that people know it's supposed to be
called by processes that can't wait, and they think that means "I can't
wait for this memory, so be sure you give it to me _now_."  Simple
explanations of GFP_ATOMIC give you the impression that it's just a higher
priority request than GFP_KERNEL.

One thing about GFP_ATOMIC that is often overlooked is that what it really
means is that the caller, instead of VM, is responsible for doing the
waiting and retrying and whatever to deal with memory allocation failure.
Failing some operation permanently because a kmalloc(GFP_ATOMIC) it did
failed is usually the wrong thing to do.

Again, many people have just the opposite impression.  One person told me
he used GFP_ATOMIC instead of GFP_KERNEL because he needed to be guaranteed
the allocation wouldn't fail.



