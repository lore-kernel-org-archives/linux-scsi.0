From: Vladislav Bolkhovitine <vlls@hotbox.ru>
Subject: Re: [PATCH] SCSI host ID assigment overoptimization removal in 2.4.18
Date: Fri, 19 Jul 2002 11:42:01 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020719114201.A950@j4.msk.systemsix.com>
References: <OFFA9F6CBB.28C701CD-ONC1256BFB.0027213D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by j4.msk.systemsix.com (8.11.2/8.11.2) id g6J7g1K00954
	for linux-scsi@vger.kernel.org; Fri, 19 Jul 2002 11:42:01 +0400
Content-Disposition: inline
In-Reply-To: <OFFA9F6CBB.28C701CD-ONC1256BFB.0027213D@de.ibm.com>; from ARZEH@de.ibm.com on Fri, Jul 19, 2002 at 09:09:05AM +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

So, should I send this patch directly to Linus Torvalds then to see it in?

BTW, looking at the sources, I have noticed kmalloc() with unchecked return
value in scsi_register(). Here is the patch.

Vlad

diff -urdN linux-2.4.18-enc.orig/drivers/scsi/hosts.c linux-2.4.18-enc.register_kmalloc/drivers/scsi/hosts.c
--- linux-2.4.18-enc.orig/drivers/scsi/hosts.c  Wed Jul 17 12:49:51 2002
+++ linux-2.4.18-enc.register_kmalloc/drivers/scsi/hosts.c      Thu Jul 18 15:47:51 2002
@@ -174,6 +186,12 @@
                 return NULL;
         }
        shn->name = kmalloc(hname_len + 1, GFP_ATOMIC);
+       if (!shn->name) {
+               kfree(retval);
+               kfree(shn);
+               printk(KERN_ERR "scsi: out of memory(3) in scsi_register.\n");
+               return NULL;
+        }
        if (hname_len > 0)
            strncpy(shn->name, hname, hname_len);
        shn->name[hname_len] = 0;


On Fri, Jul 19, 2002 at 09:09:05AM +0200, Aron Zeh wrote:
>
> My blessings go with the patch, too. I checked and tested the fix on its
> prior submission and it worked fine.
>
> Aron
>
> Vladislav Bolkhovitine wrote:
> >
> > There is an overoptimization in SCSI host ID assigment algorithm in
> 2.4.18
> > and possibly others, which lead to appearance of SCSI hosts with the same
> IDs.
> >
> > Simple scenario:
> > 1. Add one adapter, host_id=0
> > 2. Remove it
> > 3. Add another adapter, its host_id=0
> > 4. Add the adapter 1 again, it reuses its original scsi_host_no_list
> entry
> >         and gets host_id=0 as well. Oops.
> >
> > When the adapter was being unregistered on step 2, max_scsi_hosts gets
> > decremented to 0. During registration of the new host, it received
> > host_id=max_scsi_hosts. On the step 4, the old entry in scsi_host_no_list
> > was found and reused, thus we have two hosts with the same host_id 0.
> >
> > So, it is impossible to use simultaneously scsi_host_no_list and host IDs
> > reusing (i.e. max_scsi_hosts decrementing). I chose to remove the last
> one.
> > Here is the patch against 2.4.18.
> >
> > I was not able to find who is the maintainer of SCSI subsistem at the
> moment.
> > Who is doing so, please consider the idea of this patch to include in the
> > mainstream kernel.
>
>
> Yep, I concur -- this patch works.
>
> I've wanted a patch for this for sometime and brought this same
> issue on 02/05/29, but was too busy with my own project to unscramble
> the infamous SCSI host registration.
>
> AFAIK, Doug is working on this now and it will be a whole different
> and better story for latter 2.5/6 (struct list_head, etc.).
>
> Anyways, this works for 2.4 and I'd be happy to see it in.
>
> Thanks,
> --
> Luben
>
> > Vlad

