From: Doug Ledford <dledford@redhat.com>
Subject: Re: Several Misc SCSI updates...
Date: Sun, 17 Nov 2002 17:04:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117220410.GI3280@redhat.com>
References: <Pine.LNX.4.44.0211171338570.12975-100000@home.transmeta.com> <Pine.GSO.4.21.0211171653391.23400-100000@steklov.math.psu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.21.0211171653391.23400-100000@steklov.math.psu.edu>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Viro <viro@math.psu.edu>
Cc: Linus Torvalds <torvalds@transmeta.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 04:55:26PM -0500, Alexander Viro wrote:
> 
> 
> On Sun, 17 Nov 2002, Linus Torvalds wrote:
> 
> > 
> > On Sun, 17 Nov 2002, Doug Ledford wrote:
> > > 
> > > Won't work.  module->live is what Rusty uses to indicate that the module 
> > > is in the process of unloading, which is when we *do* want the attempt to 
> > > module_get() to fail.
> > 
> > That's fine, as long as "module_get()" is the only thing that cares. Just 
> > make it go "live" early as you indicate, and everybody should be happy. I 
> > certainly agree that it should be illegal to do more module_get()'s once 
> > we've already started unloading..
> 
> On the unload side it's OK.  module_get() also breaks during _init_ and that's
> the problem.  IOW, you'll need to make every block device driver to set ->live
> manually.  Smells like a wrong API...

This is the patch I just put into my tree (beware cut-n-paste breakage is 
in effect, but Linus should have the change in his tree momentarily 
anyway):

diff -Nru a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c   Sun Nov 17 17:02:48 2002
+++ b/kernel/module.c   Sun Nov 17 17:02:48 2002
@@ -1058,6 +1058,15 @@
        list_add(&mod->extable.list, &extables);
        spin_unlock_irq(&modlist_lock);

+       /* Note, setting the mod->live to 1 here is safe because we haven't
+        * linked the module into the system's kernel symbol table yet,
+        * which means that the only way any other kernel code can call
+        * into this module right now is if this module hands out entry
+        * pointers to the other code.  We assume that no module hands out
+        * entry pointers to the rest of the kernel unless it is ready to
+        * have them used.
+        */
+       mod->live = 1;
        /* Start the module */
        ret = mod->init ? mod->init() : 0;
        if (ret < 0) {
@@ -1070,9 +1079,10 @@
                        /* Mark it "live" so that they can force
                           deletion later, and we don't keep getting
                           woken on every decrement. */
-                       mod->live = 1;
-               } else
+               } else {
+                       mod->live = 0;
                        free_module(mod);
+               }
                up(&module_mutex);
                return ret;
        }
@@ -1087,7 +1097,6 @@
        mod->module_init = NULL;

        /* All ok! */
-       mod->live = 1;
        up(&module_mutex);
        return 0;
 }


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
