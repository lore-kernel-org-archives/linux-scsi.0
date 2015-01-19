From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Mon, 19 Jan 2015 08:07:24 -0800
Message-ID: <1421683644.2080.24.camel@HansenPartnership.com>
References: <1421600146.2080.8.camel@HansenPartnership.com>
	 <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au>
	 <20150119082815.GA26697@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150119082815.GA26697@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-01-19 at 00:28 -0800, Christoph Hellwig wrote:
> On Mon, Jan 19, 2015 at 04:21:15PM +1030, Rusty Russell wrote:
> > The first one I think should be eliminated, and the second one is simply
> > an assertion before calling module_put() (which should probably be
> > eliminated).  The others are just printing information.
> 
> FYI, I've got a pathcset to eliminate the use of module_refcount in
> SCSI, which was a horrible hack to start with, but it needs a little more
> clarification / work, so I'd prefer to do it for 3.20.  Bart has a fix
> that eliminates it for 3.19, which piles aother bandaid over the bandaid
> that introduced the use module_refcount, and James doesn't seem to like
> it.

I don't like adding another refcount where one already exists because
it's pointless duplication.  Rusty's fix is fine because it captures the
intention of the use in scsi_device_get, so let's go with it.  You can
add an Acked-by from me to his patch.

James
