From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: Wed, 5 Feb 2003 16:03:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302051603.48510@bilbo.math.uni-mannheim.de>
References: <200302041123.06204@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200302041123.06204@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi again,

I'm now looking for the best way to port this to use 53c700.c. This will 
surely take a while, should I fix my fix and resend it or better leave this 
unfixed until I find time to port it?

For today this fix should be enough. The second one is unneeded because 
mca_register_driver does it.

Eike

Note: Please CC me, I'm not ...

--- linux-2.5.59-test/drivers/scsi/53c700.c     Fri Jan 17 03:21:40 2003
+++ linux-2.5.59/drivers/scsi/53c700.c  Wed Feb  5 15:47:00 2003
@@ -1769,7 +1769,7 @@
        NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) + 1);

        /* begin the command here */
-       /* no need to check for NULL, test for command_slot_cound above
+       /* no need to check for NULL, test for command_slot_count above
         * ensures a slot is free */
        slot = find_empty_slot(hostdata);

--- linux-2.5.59-test/drivers/scsi/NCR_D700.c   Fri Jan 17 03:21:39 2003
+++ linux-2.5.59/drivers/scsi/NCR_D700.c        Wed Feb  5 15:47:02 2003
@@ -340,7 +340,6 @@
        .id_table = NCR_D700_id_table,
        .driver = {
                .name = "NCR_D700",
-               .bus = &mca_bus_type,
                .probe = NCR_D700_probe,
        },
 };
