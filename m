From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] scsi: aacraid: Added support for hotplug
Date: Tue, 14 Feb 2017 10:43:39 +0300
Message-ID: <20170214074339.GF4162@mwanda>
References: <20170213184707.GA19576@mwanda>
 <4D8E82A446BF54499747901DBDEB737A7B8BD440@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19365 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdBNHn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 02:43:56 -0500
Content-Disposition: inline
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A7B8BD440@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Feb 13, 2017 at 07:39:15PM +0000, Raghava Aditya Renukunta wrote:
> Hi Don,
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Monday, February 13, 2017 10:47 AM
> > To: Raghava Aditya Renukunta
> > <RaghavaAditya.Renukunta@microsemi.com>
> > Cc: linux-scsi@vger.kernel.org
> > Subject: [bug report] scsi: aacraid: Added support for hotplug
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > Hello Raghava Aditya Renukunta,
> > 
> > The patch 6223a39fe6fb: "scsi: aacraid: Added support for hotplug"
> > from Feb 2, 2017, leads to the following static checker warning:
> > 
> >         drivers/scsi/aacraid/commsup.c:2243 aac_process_events()
> >         error: double unlock 'spin_lock:t_lock'
> > 
> > drivers/scsi/aacraid/commsup.c
> >   2130          spin_lock_irqsave(t_lock, flags);
> >                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >   2131
> >   2132          while (!list_empty(&(dev->queues-
> > >queue[HostNormCmdQueue].cmdq))) {
> >   2133                  struct list_head *entry;
> >   2134                  struct aac_aifcmd *aifcmd;
> >   2135                  unsigned int  num;
> >   2136                  struct hw_fib **hw_fib_pool, **hw_fib_p;
> >   2137                  struct fib **fib_pool, **fib_p;
> >   2138
> >   2139                  set_current_state(TASK_RUNNING);
> >   2140
> >   2141                  entry = dev->queues-
> > >queue[HostNormCmdQueue].cmdq.next;
> >   2142                  list_del(entry);
> >   2143
> >   2144                  t_lock = dev->queues->queue[HostNormCmdQueue].lock;
> >   2145                  spin_unlock_irqrestore(t_lock, flags);
> >                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >   2146
> >   2147                  fib = list_entry(entry, struct fib, fiblink);
> >   2148                  hw_fib = fib->hw_fib_va;
> >   2149                  if (dev->sa_firmware) {
> >   2150                          /* Thor AIF */
> >   2151                          aac_handle_sa_aif(dev, fib);
> >   2152                          aac_fib_adapter_complete(fib, (u16)sizeof(u32));
> >   2153                          continue;
> > 
> > The locking isn't right here.  We should re-take the spinlock before
> > continuing.
> 
> The intention here is to protect the retrieval of entry from the queues.
> Or do you mean that we should just protect the whole while loop with one spin_lock (t_lock)?
> 

This is a static checker warning that says we call
spin_unlock_irqrestore(t_lock, flags); at the end of the loop but
sometimes we're not holding the lock.

This is a Smatch warning and it doesn't handle loops correctly.  It
should also warn that on line 2145 we might not be holding the lock
either but it misses that bug.

There is no way this continue is correct with regards to locking.

regards,
dan carpenter

> Thank you,
> Raghava Aditya
> 
> >   2154                  }
> >   2155                  /*
> >   2156                   *      We will process the FIB here or pass it to a
> >   2157                   *      worker thread that is TBD. We Really can't
> >   2158                   *      do anything at this point since we don't have
> >   2159                   *      anything defined for this thread to do.
> >   2160                   */
> > 
> >         [ snip ]
> > 
> >   2221  free_mem:
> >   2222                  /* Free up the remaining resources */
> >   2223                  hw_fib_p = hw_fib_pool;
> >   2224                  fib_p = fib_pool;
> >   2225                  while (hw_fib_p < &hw_fib_pool[num]) {
> >   2226                          kfree(*hw_fib_p);
> >   2227                          kfree(*fib_p);
> >   2228                          ++fib_p;
> >   2229                          ++hw_fib_p;
> >   2230                  }
> >   2231                  kfree(fib_pool);
> >   2232  free_hw_fib_pool:
> >   2233                  kfree(hw_fib_pool);
> >   2234  free_fib:
> >   2235                  kfree(fib);
> >   2236                  t_lock = dev->queues->queue[HostNormCmdQueue].lock;
> >   2237                  spin_lock_irqsave(t_lock, flags);
> >   2238          }
> >   2239          /*
> >   2240           *      There are no more AIF's
> >   2241           */
> >   2242          t_lock = dev->queues->queue[HostNormCmdQueue].lock;
> >   2243          spin_unlock_irqrestore(t_lock, flags);
> > 
> > Otherwise it is a double unlock bug.
> > 
> >   2244  }
> > 
> > 
> > regards,
> > dan carpenter
