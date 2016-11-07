From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187231] New: kernel panic during hpsa MSI plus tg3 MSI
Date: Mon, 07 Nov 2016 13:53:06 +0000
Message-ID: <bug-187231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752867AbcKGNxK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 08:53:10 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 24B5B20219
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 13:53:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id D65CA20212
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 13:53:06 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187231

            Bug ID: 187231
           Summary: kernel panic during hpsa MSI plus tg3 MSI
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.8.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: kernelorg@bof.de
        Regression: No

Created attachment 243801
  --> https://bugzilla.kernel.org/attachment.cgi?id=243801&action=edit
kernel 4.8.6 .config

I'm not sure whether this is a SCSI / HPSA bug or a networking / tg3 driver
bug. Both are seen in the stack dump. As the trigger seems to be HPSA I'm
reporting as a SCSI issue here...

I've been recently attempting to run mainline 4.8.x kernels, most recently
4.8.6, on our production HP DL 380 Intel servers.

On several of them there is some related issue reported in
https://bugzilla.kernel.org/show_bug.cgi?id=187221 where the HPSA driver on
some of the hosts sometimes resets the logical device. I had seen that already
with 4.4.x kernels, and again with 4.8.6.

Now, specifically with 4.8.6, on the box which has the worst of these symptoms,
I _additionally_ experienced multiple full kernel panics. The same box (with
the same hpsa reset symtoms) had been running 4.4.x kernels before without such
kernel panics. The panics then happened multiple times with about a day in
between.

On the last round I had the ILO SSH console running under screen with logging
enabled, and was able to retrieve the following panic backtrace:

[187283.903173] hpsa 0000:03:00.0: scsi 0:1:0:0: resetting logical 
Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSmartPathCap- En- Exp=1   
[187314.331375] sd 0:1:0:0: rejecting I/O to offline device                     
[187314.413441] sd 0:1:0:0: rejecting I/O to offline device                     
[187314.854183] sd 0:1:0:0: rejecting I/O to offline device                     
... lots of these ...
[187328.991285] sd 0:1:0:0: rejecting I/O to offline device                     
[187328.991389] sd 0:1:0:0: rejecting I/O to offline device                     
[187329.190166] sd 0:1:0:0: rejecting I/O to offline device                     
[187329.271304]  ffff88bd1a7e8000 ffff88bd1a7be500 ffff88bd7f483eb8
ffffffff8143
493f                                                                            
[187329.271304] Call Trace:                                                     
[187329.271310]  <IRQ>                                                          
[187329.271310]  [<ffffffffa002e332>] ? tg3_poll_msix+0xc2/0x160 [tg3]          
[187329.271311]  [<ffffffff8143493f>] do_hpsa_intr_msi+0x8f/0x1c0               
[187329.271314]  [<ffffffff81148c46>] __handle_irq_event_percpu+0x66/0xe0       
[187329.271315]  [<ffffffff81148cde>] handle_irq_event_percpu+0x1e/0x50         
[187329.271316]  [<ffffffff81148d37>] handle_irq_event+0x27/0x50                
[187329.271318]  [<ffffffff8114bda5>] handle_edge_irq+0x65/0x140                
[187329.271320]  [<ffffffff81057255>] handle_irq+0x15/0x20                      
[187329.271321]  [<ffffffff81057086>] do_IRQ+0x46/0xd0                          
[187329.271324]  [<ffffffff816dc4fc>] common_interrupt+0x7c/0x7c                
[187329.271325]  <EOI>                                                          
[187329.271338] Code: 53 48 89 fb 48 83 ec 28 4c 8b a7 5c 02 00 00 4c 8b bf 40
0
2 00 00 4c 8b b7 38 02 00 00 4c 8b af 4c 02 00 00 49 8b 04 24 4c 89 e7 <48> 8b
8
0 98 00 00 00 48 89 45 c0 49 8b 87 d0 01 00 00 48 89 45                         
[187329.271339] RIP  [<ffffffff81431417>] complete_scsi_command+0x37/0x8c0      
[187329.271339]  RSP <ffff88bd7f483e38>                                         
[187329.271339] CR2: 0000000000000098                                           
[187329.271341] ---[ end trace 52898916f0da5c53 ]---                            
[187329.273413] Kernel panic - not syncing: Fatal exception in interrupt        
[187330.308465] Shutting down cpus with NMI                                     
[187330.308471] Kernel Offset: disabled                                         
[187330.919173] Rebooting in 300 seconds..  

I'll attach my kernel .config.

As this is a production system and so far the panics only hit with our usual
(webserver and DB kvm machine) production load active, there's not much testing
or bisecting I can do, but I didn't want to drop the issue unreported, either. 

Hope this helps somebody. If there is any more info I can provide, just ask
what would be useful.

(I'm back to running 4.4.x)

-- 
You are receiving this mail because:
You are the assignee for the bug.
