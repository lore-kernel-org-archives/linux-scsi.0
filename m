From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Is sata_nv compatible with async scsi scan?
Date: Tue, 21 Apr 2009 05:26:08 -0600
Message-ID: <20090421112608.GV1926@parisc-linux.org>
References: <49ED6FD7.3070307@panasas.com> <49ED9FAC.1080303@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49ED9FAC.1080303@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Benny Halevy <bhalevy@panasas.com>, Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 21, 2009 at 06:27:56AM -0400, Jeff Garzik wrote:
> Benny Halevy wrote:
> >Hi Jeff,
> >
> >Since 2.6.29 I'm having intermittent problems with booting kernels.
> >After supposedly waiting for scsi async scan to complete,
> >quite frequently I see errors from the init resume process
> >when it fails to find the swap partition and later the root
> >file system fails to load.
> >
> >A workaround that I found to be helpful is booting the kernel
> >with scsi_mod.scan=sync so I suspect sata_nv has a problem
> >with asynchronous scanning.
> 
> Personally, I think the whole system is broken, so continue to use this 
> workaround until it gets fixed upstream.  This sounds like some timing 
> issues related to waiting for the device probe to finish, something that 
> people keep breaking (witness my USB flash drive boot breakage).

No, it's 4ace92fc112c6069b4fcb95a31d3142d4a43ff2a.

Specifically, this bit:

@@ -179,6 +180,8 @@ int scsi_complete_async_scans(void)
        spin_unlock(&async_scan_lock);
 
        kfree(data);
+       /* Synchronize async operations globally */
+       async_synchronize_full();
        return 0;
 }
 
Vegard Nossum has a patch that seems to have been ignored:

http://marc.info/?l=linux-kernel&m=123920746830420&w=2

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
