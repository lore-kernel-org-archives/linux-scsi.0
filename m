From: "invictus rm" <invictus_rm@hotmail.com>
Subject: scsi driver hangs!!!
Date: Fri, 22 Aug 2003 01:24:08 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BAY7-F74jCcxadcJl9d0001f265@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay7-f74.bay7.hotmail.com ([64.4.11.74]:1292 "EHLO hotmail.com")
	by vger.kernel.org with ESMTP id S262883AbTHUTyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 15:54:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi ,
    I am trying to write a HBA driver for a  PCI SCSI card.

   On insmoding the driver( after enabling scsi verbose logging) i was able 
to trace the point at which it get stuck.

                                               Activating command for device 
0 (1)
                                               Leaving 
scsi_init_cmd_from_req()
                                               Adding timer for command 
cee2a400 at 600 (d090d700)
                                              scsi_dispatch_cmnd (host = 0, 
channel = 0, target = 0, command =
                                                      cee2a458, buffer = 
c38dfc08, bufflen = 256, done = d09080b0)
                                              queuecommand : routine at 
d0b2d1e0
                                              leaving scsi_dispatch_cmnd()
                                              Leaving scsi_do_req()
                                              Clearing timer for command 
cee2a400 1
                                              Command finished 1 0 0x0
                                              Notifying upper driver of 
completion for device 0 0

   and then the driver HANGS.

  The piece of code where the hang occur is
         scsi_wait_req( )   <---- scsi.c
          {

                scsi_do_req (SRpnt, (void *) cmnd,
                                  buffer, bufflen, scsi_wait_done, timeout, 
retries);
                generic_unplug_device(q);
                wait_for_completion(&wait);

    }

The detect( ) reads as
       host->max_id = 5;
       host->hostt->use_new_eh_code = 1;
       host->this_id = tmpt->this_id;


What am I doing wrong ?? Why does the HBA driver hangs (initializing ) on 
insmoding ??

Thanking for any help in helping me to resolve this problem ......

_________________________________________________________________
Find an old friend. Revisit your past. http://www.batchmates.com/msn.asp 
It's never been easier!

