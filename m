From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [PATCH] SCSI host ID assigment overoptimization removal in 2.4.18
Date: Mon, 22 Jul 2002 14:15:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFDA988AB2.620F41A5-ONC1256BFE.0042F037@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
Cc: Vladislav Bolkhovitine <vlls@hotbox.ru>, linux-scsi@vger.kernel.org, nahshon@actcom.co.il, zaitcev@redhat.com

Hi Pete,

as far as I can see these are two completely distinct problem fixes.
The first one addresses the fact that allocation success has to be checked
for shn->name in scsi_register.
The second one deals with the problem of leaving the scsi host numbering in
a weird state upon scsi unregister. (Fixed by simply removing the
interconnected series of bizarre loops).
They should therefore both be included in the kernel as fixes.

Cheers,
Aron

> --- linux-2.4.18-enc.orig/drivers/scsi/hosts.c  Wed Jul 17 12:49:51 2002
> +++ linux-2.4.18-enc.register_kmalloc/drivers/scsi/hosts.c      Thu Jul
18 15:47:51 \
> 2002 @@ -174,6 +186,12 @@
>                  return NULL;
>          }
>         shn->name = kmalloc(hname_len + 1, GFP_ATOMIC);
> +       if (!shn->name) {
> +               kfree(retval);
> +               kfree(shn);
> +               printk(KERN_ERR "scsi: out of memory(3) in scsi_register.
\n");
> +               return NULL;
> +        }
>         if (hname_len > 0)
>             strncpy(shn->name, hname, hname_len);
>         shn->name[hname_len] = 0;

Does it solve the same problem as the following? It looks like
it does, only in a different place. Which one is better?

--- drivers/scsi/hosts.c.orig   Mon Feb 25 21:38:04 2002
+++ drivers/scsi/hosts.c        Wed Apr 17 01:42:47 2002
@@ -81,8 +81,8 @@
 struct Scsi_Host * scsi_hostlist;
 struct Scsi_Device_Template * scsi_devicelist;

-int max_scsi_hosts;
-int next_scsi_host;
+int max_scsi_hosts;    /* host_no for next new host */
+int next_scsi_host;    /* count of registered scsi hosts */

 void
 scsi_unregister(struct Scsi_Host * sh){
@@ -107,21 +107,8 @@
     if (shn) shn->host_registered = 0;
     /* else {} : This should not happen, we should panic here... */

-    /* If we are removing the last host registered, it is safe to reuse
-     * its host number (this avoids "holes" at boot time) (DB)
-     * It is also safe to reuse those of numbers directly below which have
-     * been released earlier (to avoid some holes in numbering).
-     */
-    if(sh->host_no == max_scsi_hosts - 1) {
-       while(--max_scsi_hosts >= next_scsi_host) {
-           shpnt = scsi_hostlist;
-           while(shpnt && shpnt->host_no != max_scsi_hosts - 1)
-               shpnt = shpnt->next;
-           if(shpnt)
-               break;
-       }
-    }
     next_scsi_host--;
+
     kfree((char *) sh);
 }


See:
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0206.0/1220.html

I poked Marcelo with it for Itai, and he said to wait for 2.4.20
to open. Currently we ship Itai's variant.

-- Pete
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




