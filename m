From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
Date: Wed, 16 May 2012 16:22:15 -0400
Message-ID: <20120516202215.GO22985@linux.intel.com>
References: <1337188023.3796.130.camel@schen9-DESK>
 <CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
 <20120516193506.GM22985@linux.intel.com>
 <CAAsGZS5wivyHUGNtHuTNCQQnnqZ=qt-7uSZjbE-7_KC+L-Yoaw@mail.gmail.com>
 <20120516194332.GN22985@linux.intel.com>
 <CAAsGZS5tzf5-aciK2kCJCHn4oDTSAvN+=FQWzkH_3PzVm5m-iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAsGZS5tzf5-aciK2kCJCHn4oDTSAvN+=FQWzkH_3PzVm5m-iA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: chetan loke <loke.chetan@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 16, 2012 at 03:54:06PM -0400, chetan loke wrote:
> I thought that 'scsi_ram_device_thread' has a
> 'wait_event_interruptible' call if it sees that the list is empty. I
> don't see that call that's why the confusion. Either queuecmd or
> kthread will get the lock and so why keep the kthread spinning in that
> while loop if there's nothing to do?

It doesn't spin, it sleeps:

+               spin_lock_irqsave(host->host_lock, flags);
+               if (list_empty(&ram_device->commands)) {
+                       set_current_state(TASK_INTERRUPTIBLE);
+                       spin_unlock_irqrestore(host->host_lock, flags);
+                       schedule();
+                       continue;
+               }
