From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx woes in 2.5
Date: Mon, 16 Dec 2002 11:52:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <32310000.1040064745@aslan.btc.adaptec.com>
References: <3DFC059A.9AA3F75F@digeo.com>
 <23290000.1039982976@aslan.btc.adaptec.com> <3DFD9F89.4B994586@digeo.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DFD9F89.4B994586@digeo.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

> The driver still has a serious bug in ahc_linux_queue_recovery_cmd().
> It does
> 
> 	ahc_unlock(ahc, &s);

The sole ahc_unlock() in that routine looks like this:

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
                ahc_unlock(ahc, &s);
#else
                spin_unlock_irq(ahc->platform_data->host->host_lock);
#endif

Since you are running 2.5.X, the ahc_unlock never occurs.
In 2.4.X, ahd_midlayer_entrypoint_lock() saves the cpu flags
for us, so the variable is never uninitialized in the case
where it actually is compiled in.

> The driver got through recognising the disks and then locked up
> strangely:
> 
> Program received signal SIGEMT, Emulation trap.
> cache_alloc_refill (cachep=0xd00675a0, flags=0) at
> include/linux/list.h:127 127             prev->next = next;
> (gdb) bt
># 0  cache_alloc_refill (cachep=0xd00675a0, flags=0) at
># include/linux/list.h:127 1  0x00000246 in ?? ()
># 2  0xc0135947 in kmalloc (size=256, flags=0) at mm/slab.c:1652
># 3  0xc0239835 in ahc_linux_dv_inq (ahc=0xc175e400, cmd=0xc3dd0c00,
># devinfo=0xc3d77fb0, targ=0xc3dcee00, request_length=96)
>     at drivers/scsi/aic7xxx/aic7xxx_osm.c:3303
># 4  0xc0237f5d in ahc_linux_dv_target (ahc=0xc175e400, target_offset=4)
># at drivers/scsi/aic7xxx/aic7xxx_osm.c:2060 5  0xc0237d47 in
># ahc_linux_dv_thread (data=0xc175e400) at
># drivers/scsi/aic7xxx/aic7xxx_osm.c:1955
> 
> This is an NMI watchdog interrupt.  In here:
> 
> 1571                    while (slabp->inuse < cachep->num && batchcount--)
> 1572                            ac_entry(ac)[ac->avail++] =
> 1573                                    cache_alloc_one_tail(cachep,
> slabp);
> 
> Presumably due to errors in use of slab-allocated memory.

I'll look into this today.

> I can debug further if you like, but would really appreciate unified
> diffs, thanks.

Against???  That's the whole problem with diffs.  Every person wants them
against something different.  If you can use BK, the  James Bottomley 
has integrated the latest driver into here:

http://linux-scsi.bkbits.net/scsi-aic7xxx-2.5

I have not pulled down this repro to verify it yet though.

--
Justin
