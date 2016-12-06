From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: scsi: use-after-free in bio_copy_from_iter
Date: Tue, 6 Dec 2016 10:32:57 +0100
Message-ID: <20161206093257.GC4818@linux-x5ow.site>
References: <CACT4Y+aBd+1pssnsVx2x145n7Q1nDMU=xc7NAiOCtpy-MA-EDg@mail.gmail.com>
 <CACT4Y+auCpJbXhmxbr4OmSHbiVkatyWmDxGGShs=WvO=HCXRKA@mail.gmail.com>
 <20161203103802.dmvqzzquthwa7kd7@linux-x5ow.site>
 <CACT4Y+bB+oxjPoC0WVCUV_Bq9ePqdV3m_V4snsfUrZ2BSWub2Q@mail.gmail.com>
 <20161203181948.GA3322@linux-x5ow.site>
 <CACT4Y+Z4V=9nm04H-uyy0tA4yXLp7Ld7dqgjLiA5_opeQC_m6A@mail.gmail.com>
 <20161205151753.GI8481@linux-x5ow.site>
 <20161205190339.GK1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161205190339.GK1555@ZenIV.linux.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller <syzkaller@googlegroups.com>, Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk, linux-block@vger.kernel.org, David Rientjes <rientjes@google.com>, Hannes Reinecke <hare@suse.de>, mhocko@suse.cz
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2016 at 07:03:39PM +0000, Al Viro wrote:
> On Mon, Dec 05, 2016 at 04:17:53PM +0100, Johannes Thumshirn wrote:
> > 633         hp = &srp->header;
> > [...]
> > 646                 hp->dxferp = (char __user *)buf + cmd_size;
> 
> > So the memory for hp->dxferp comes from:
> > 633         hp = &srp->header;
> 
> ????
> 
> > >From my debug instrumentation I see that the dxferp ends up in the
> > iovec_iter's kvec->iov_base and the faulting address is always dxferp + n *
> > 4k with n in [1, 16] (and we're copying 16 4k pages from the iovec into the
> > bio).
> 
> _Address_ of hp->dxferp comes from that assignment; the value is 'buf'
> argument of sg_write() + small offset.  In this case, it should point
> inside a pipe buffer, which is, indeed, at a kernel address.  Who'd
> allocated srp is irrelevant.

Yes I realized that as well when I had enough distance between me and the
code...

> 
> And if you end up dereferencing more than one page worth there, you do have
> a problem - pipe buffers are not going to be that large.  Could you slap
> 	WARN_ON((size_t)input_size > count);
> right after the calculation of input_size in sg_write() and see if it triggers
> on your reproducer?

I did and it didn't trigger. What triggers is (as expected) a
	WARN_ON((size_t)mxsize > count);
We have count at 80 and mxsize (which ends in hp->dxfer_len) at 65499. But the
65499 bytes are the len of the data we're suppost to be copying in via the
iov. I'm still rather confused what's happening here, sorry.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
