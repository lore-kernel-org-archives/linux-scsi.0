From: Doug Ledford <dledford@redhat.com>
Subject: 2.5.43 IO-APIC bug and spinlock deadlock
Date: Wed, 16 Oct 2002 23:33:02 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021017033302.GP8159@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

IO-APIC bug: regular kernel, UP, no IO-APIC or APIC on UP enabled, compile
fails (does *everyone* run SMP or at least UP + APIC now?)

spinlock deadlock: run an smp kernel on a up machine.  On mine here all I 
have to do is try to boot to multiuser mode, it won't make it through the 
startup scripts before it locks up by trying to reenter common_interrupt 
on the only CPU.  Seems like an SMP kernel on UP hardware doesn't disable 
interrupts properly maybe?  I get task lists via alt-sysreq when the 
machine should be hardlocked I think.  Anyway, this is what has been 
tricking me into thinking I had an IDE problem.  IDE is innocent, it's the 
core interrupt handling code.

Back to work on scsi stuff now that I have a decently running 2.5.43
system, I'll let someone else deal with these.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
