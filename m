From: "invictus rm" <invictus_rm@hotmail.com>
Subject: scsi wait_for_completion hangs!!!
Date: Fri, 22 Aug 2003 15:18:06 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BAY7-F92BLMasiZAPG400002a63@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay7-f92.bay7.hotmail.com ([64.4.11.92]:56592 "EHLO hotmail.com")
	by vger.kernel.org with ESMTP id S263099AbTHVJsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 05:48:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi ,
    I am trying to write a HBA driver for a  PCI SCSI card(linux - 2.4.7 ).

   On insmoding the driver( after enabling scsi verbose logging) i was able 
to trace the point at which it get stuck.

Aug 22 13:07:21  kernel: Wake up parent 0
Aug 22 13:07:21  kernel: Error handler sleeping
Aug 22 13:07:21  kernel: scsi0 : SCSI Adapter Registeration...
Aug 22 13:07:21  kernel:
Aug 22 13:07:21  kernel: scsi: performing INQUIRY
Aug 22 13:07:21  kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =f6995d90, bufflen = 256, done = f90f6090, timeout = 600, retries = 
3)
Aug 22 13:07:21  kernel: command : 12  00  00  00  ff  00  99  f6  2a  82
Aug 22 13:07:21  kernel: Activating command for device 0 (1)
Aug 22 13:07:21  kernel: Leaving scsi_init_cmd_from_req()
Aug 22 12:38:42  kernel: Adding timer for command f6eeb800 at 600 (f88cdcc0)
Aug 22 12:38:42  kernel: scsi_dispatch_cmnd (host = 0, channel = 0, target = 
0, command = f6eeb858, buffer = f6983d90,
Aug 22 12:38:42  kernel: bufflen = 256, done = f88c9090)
Aug 22 12:38:42  kernel: queuecommand : routine at f913b8e4
Aug 22 12:38:42  kernel:
Aug 22 12:38:43  kernel: leaving scsi_dispatch_cmnd()
Aug 22 12:38:43  kernel: Leaving scsi_do_req()
Aug 22 12:38:43  kernel: Clearing timer for command f6eeb800 1
Aug 22 12:38:43  kernel: Notifying upper driver of completion for device 0 0
Aug 22 12:38:43  kernel: Clearing timer for command f6eeb800 0

HANGS after this ( lsmod shows the module as initializing)

It seems to be waiting on wait_for_completion( ) but the scsi_wait_done ( ) 
never calls the complete(req->waiting) and so the driver hangs.

Any help will be highly appreciated...
Tx a ton

_________________________________________________________________
Access Hotmail from your mobile now. 
http://server1.msn.co.in/sp03/mobilesms/ Click here.

