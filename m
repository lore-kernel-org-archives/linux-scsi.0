From: Andrew Morton <akpm@osdl.org>
Subject: Re: [BUG 2.6.0-test10] SCSI update in CSET 1.1437.1.2 caused
 'Badness'
Date: Sun, 23 Nov 2003 23:49:19 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031123234919.72ae0316.akpm@osdl.org>
References: <50478.68.105.173.45.1069651886.squirrel@mail.mainstreetsoftworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <50478.68.105.173.45.1069651886.squirrel@mail.mainstreetsoftworks.com>
To: Brad House <brad_mssw@gentoo.org>
Cc: linux-kernel@vger.kernel.org, tony@vroon.org, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"Brad House" <brad_mssw@gentoo.org> wrote:
>
> A user noticed this oddness while using -test10 that he did
>  not see while using -test9.  This error does not seem to affect
>  anything. His e-mail is tony@vroon.org if you need more info
>  from him.
> 
>  Reverting CSET 1.1437.1.2 fixed his problem below:
>  http://linux.bkbits.net:8080/linux-2.5/patch@1.1437.1.2?nav=index.html|tags|ChangeSet@1.1350.1.2..|cset@1.1437.1.2
> 
> 
> 
>  scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
>          <Adaptec 29160 Ultra160 SCSI adapter>
>          aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
>  (scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
>  (scsi0:A:1): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
>  (scsi0:A:2:0): refuses WIDE negotiation.  Using 8bit transfers
>  (scsi0:A:2): 20.000MB/s transfers (20.000MHz, offset 16)
>  (scsi0:A:4:0): refuses WIDE negotiation.  Using 8bit transfers
>  (scsi0:A:4): 20.000MB/s transfers (20.000MHz, offset 7)
>  Badness in kobject_get at lib/kobject.c:439
>  Call Trace:
>   [<c0238bad>] kobject_get+0x4d/0x50
>   [<c0291278>] get_device+0x18/0x30
>   [<c02d285c>] scsi_device_get+0x2c/0x80
>   [<c02d294e>] __scsi_iterate_devices+0x3e/0x70
>   [<c02d6409>] scsi_run_host_queues+0x19/0x50
>   [<c02f5f14>] ahc_linux_release_simq+0x94/0xd0
>   [<c02f2552>] ahc_linux_dv_thread+0x1e2/0x230
>   [<c02f2370>] ahc_linux_dv_thread+0x0/0x230
>   [<c01070a9>] kernel_thread_helper+0x5/0xc

Me too.  Also with aic7xxx.  
