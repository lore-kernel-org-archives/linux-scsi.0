From: rudmer@legolas.dynup.net
Subject: [PATCH] 2.5.18-pre3 - fix for aha152x
Date: 13 Apr 2002 05:22:04 -0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020413052204.766.qmail@legolas.dynup.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: fischer@norbit.de
Cc: linux-scsi@vger.kernel.org

Hi,

since kernel 2.5.5 aha152x.c does not compile due to a missing
member in struct scatterlist, I think I have found the cure.
I sort of copied the conversion/modification used in sg.c and
only modified the name of the inline function accordingly.

The modified aha152x.c does compile when included in the kernel
or when it is build as a module. I only tested the module, and
it works for me (could use my scanner and got a good scan of a
full A4)

Juergen can you (as maintainer) submit this for inclusion (when
everything seems fine)


Patch follows,

	Rudmer

--
diff -u linux-2.5.8-pre3/drivers/scsi/aha152x.c.orig linux-2.5.8-pre3/drivers/scsi/aha152x.c
--- linux-2.5.8-pre3/drivers/scsi/aha152x.c.orig        Sat Apr 13 06:40:39 2002
+++ linux-2.5.8-pre3/drivers/scsi/aha152x.c     Sat Apr 13 07:51:38 2002
@@ -803,6 +803,13 @@
        return ptr;
 }

+static inline unsigned char * aha152x_scatg2virt(const struct scatterlist * sclp)
+{
+    return (sclp && sclp->page) ?
+               (unsigned char *)page_address(sclp->page) + sclp->offset :
+               NULL;
+}
+
 #if defined(PCMCIA) || !defined(MODULE)
 void aha152x_setup(char *str, int *ints)
 {
@@ -1494,7 +1501,7 @@
           SCp.phase            : current state of the command */
        if (SCpnt->use_sg) {
                SCpnt->SCp.buffer           = (struct scatterlist *) SCpnt->request_buffer;
-               SCpnt->SCp.ptr              = SCpnt->SCp.buffer->address;
+               SCpnt->SCp.ptr              = aha152x_scatg2virt(SCpnt->SCp.buffer);
                SCpnt->SCp.this_residual    = SCpnt->SCp.buffer->length;
                SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
        } else {
@@ -2681,7 +2688,7 @@
                                                /* advance to next buffer */
                                                CURRENT_SC->SCp.buffers_residual--;
                                                CURRENT_SC->SCp.buffer++;
-                                               CURRENT_SC->SCp.ptr           = CURRENT_SC->SCp.buffer->address;
+                                               CURRENT_SC->SCp.ptr           = aha152x_scatg2virt(CURRENT_SC->SCp.buffer);
                                                CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
                                }
                        }
@@ -2791,7 +2798,7 @@
                        /* advance to next buffer */
                        CURRENT_SC->SCp.buffers_residual--;
                        CURRENT_SC->SCp.buffer++;
-                       CURRENT_SC->SCp.ptr           = CURRENT_SC->SCp.buffer->address;
+                       CURRENT_SC->SCp.ptr           = aha152x_scatg2virt(CURRENT_SC->SCp.buffer);
                        CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
                }

@@ -2821,13 +2828,13 @@
                CURRENT_SC->resid += data_count;

                if(CURRENT_SC->use_sg) {
-                       data_count -= CURRENT_SC->SCp.ptr - CURRENT_SC->SCp.buffer->address;
+                       data_count -= (unsigned char *)CURRENT_SC->SCp.ptr - aha152x_scatg2virt(CURRENT_SC->SCp.buffer);
                        while(data_count>0) {
                                CURRENT_SC->SCp.buffer--;
                                CURRENT_SC->SCp.buffers_residual++;
                                data_count -= CURRENT_SC->SCp.buffer->length;
                        }
-                       CURRENT_SC->SCp.ptr           = CURRENT_SC->SCp.buffer->address - data_count;
+                       CURRENT_SC->SCp.ptr           = aha152x_scatg2virt(CURRENT_SC->SCp.buffer) - data_count;
                        CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length + data_count;
                } else {
                        CURRENT_SC->SCp.ptr           -= data_count;

