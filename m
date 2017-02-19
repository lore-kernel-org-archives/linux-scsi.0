From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi: BUG in scsi_init_io
Date: Sun, 19 Feb 2017 09:25:41 -0800
Message-ID: <20170219172541.GA29867@infradead.org>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
 <20170131092048.GB3687@linux-x5ow.site>
 <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
 <1485877311.3199.4.camel@linux.vnet.ibm.com>
 <20170219071522.GI29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170219071522.GI29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Dmitry Vyukov <dvyukov@google.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 19, 2017 at 07:15:27AM +0000, Al Viro wrote:
> The root cause is unfixable without access to TARDIS and dose of
> antipsychotics sufficient to prevent /dev/sg API creation.
> 
> What happens is that write to /dev/sg is given a request with non-zero
> ->iovec_count combined with zero ->dxfer_len.  Or with ->dxferp pointing
> to an array full of empty iovecs.
> 
> AFAICS, the minimal fix would be something like this:
> 
> YAMissingSanityCheck in /dev/sg
> 
> write permission to /dev/sg shouldn't be equivalent to the ability to trigger
> BUG_ON() while holding spinlocks...

Looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

The other thing we really need to consider is to finally merge the
SG_IO implementations for /dev/sg with the common block layer one.
