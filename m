From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: Is sata_nv compatible with async scsi scan?
Date: Tue, 21 Apr 2009 15:30:26 +0300
Message-ID: <49EDBC62.5070202@panasas.com>
References: <49ED6FD7.3070307@panasas.com> <49ED9FAC.1080303@garzik.org> <20090421112608.GV1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:10208 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZDUMag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 08:30:36 -0400
In-Reply-To: <20090421112608.GV1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>

On Apr. 21, 2009, 14:26 +0300, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Apr 21, 2009 at 06:27:56AM -0400, Jeff Garzik wrote:
>> Benny Halevy wrote:
>>> Hi Jeff,
>>>
>>> Since 2.6.29 I'm having intermittent problems with booting kernels.
>>> After supposedly waiting for scsi async scan to complete,
>>> quite frequently I see errors from the init resume process
>>> when it fails to find the swap partition and later the root
>>> file system fails to load.
>>>
>>> A workaround that I found to be helpful is booting the kernel
>>> with scsi_mod.scan=sync so I suspect sata_nv has a problem
>>> with asynchronous scanning.
>> Personally, I think the whole system is broken, so continue to use this 
>> workaround until it gets fixed upstream.  This sounds like some timing 
>> issues related to waiting for the device probe to finish, something that 
>> people keep breaking (witness my USB flash drive boot breakage).
> 
> No, it's 4ace92fc112c6069b4fcb95a31d3142d4a43ff2a.
> 
> Specifically, this bit:
> 
> @@ -179,6 +180,8 @@ int scsi_complete_async_scans(void)
>         spin_unlock(&async_scan_lock);
>  
>         kfree(data);
> +       /* Synchronize async operations globally */
> +       async_synchronize_full();
>         return 0;
>  }
>  
> Vegard Nossum has a patch that seems to have been ignored:
> 
> http://marc.info/?l=linux-kernel&m=123920746830420&w=2
> 

Hmm, it might help somewhat but my test machine still failed
to boot 2 out of 5 times with this patch.

Benny

