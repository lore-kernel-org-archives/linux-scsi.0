From: Christoph Hellwig <hch@infradead.org>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Sat, 17 Jan 2004 19:17:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040117191704.A6344@infradead.org>
References: <OF317B32D5.C8C681CB-ONC1256E19.005066CF-C1256E19.00538DEF@de.ibm.com> <20040112151230.GB5844@devserv.devel.redhat.com> <20040112194829.A7078@infradead.org> <1073937102.3114.300.camel@compaq.xsintricity.com> <Pine.LNX.4.58L.0401131843390.6737@logos.cnet> <1074345000.13198.25.camel@compaq.xsintricity.com> <20040117165828.A4977@infradead.org> <1074366452.13198.48.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1074366452.13198.48.camel@compaq.xsintricity.com>; from dledford@redhat.com on Sat, Jan 17, 2004 at 02:07:33PM -0500
To: Doug Ledford <dledford@redhat.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Arjan Van de Ven <arjanv@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Jens Axboe <axboe@suse.de>, Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>, ihno@suse.de
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 17, 2004 at 02:07:33PM -0500, Doug Ledford wrote:
> #ifdef SCSI_HAS_HOST_LOCK
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
> 	adapter->lock_ptr = &adapter->lock;
> 	host->lock = &adapter->lock;
> #else
> 	adapter->lock_ptr = &adapter->lock;
> 	host->host_lock = &adapter->lock;
> #endif
> #else
> 	adapter->lock_ptr = &io_request_lock;
> #endif

Still looks wrong for the 2.6 case which should just be;

	adapter->lock_ptr = shost->host_lock;

as I just stated in the review for the megaraid update.
