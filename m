From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] do we really need PG_error at all?
Date: Tue, 28 Feb 2017 12:12:14 +0200
Message-ID: <0bea2b1c-ddb1-f2bf-8ef7-b83d6a6404fc@gmail.com>
References: <1488120164.2948.4.camel@redhat.com>
 <1488129033.4157.8.camel@HansenPartnership.com>
 <877f4cr7ew.fsf@notabene.neil.brown.name>
 <1488151856.4157.50.camel@HansenPartnership.com>
 <874lzgqy06.fsf@notabene.neil.brown.name>
 <1488208047.2876.6.camel@redhat.com>
 <DC27F5BA-BCCA-41FF-8D41-7BB99AA4DB26@dilger.ca>
 <87varvp5v1.fsf@notabene.neil.brown.name>
 <1488244308.7627.5.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1488244308.7627.5.camel@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Jeff Layton <jlayton@redhat.com>, NeilBrown <neilb@suse.com>, Andreas Dilger <adilger@dilger.ca>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, lsf-pc <lsf-pc@lists.linuxfoundation.org>, Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2017 03:11 AM, Jeff Layton wrote:
<>
> 
> I'll probably have questions about the read side as well, but for now it
> looks like it's mostly used in an ad-hoc way to communicate errors
> across subsystems (block to fs layer, for instance).

If memory does not fail me it used to be checked long time ago in the
read-ahead case. On the buffered read case, the first page is read synchronous
and any error is returned to the caller, but then a read-ahead chunk is
read async all the while the original thread returned to the application.
So any errors are only recorded on the page-bit, since otherwise the uptodate
is off and the IO will be retransmitted. Then the move to read_iter changed
all that I think.
But again this is like 5-6 years ago, and maybe I didn't even understand
very well.

> --
> Jeff Layton <jlayton@redhat.com>
> 

I would like a Documentation of all this as well please. Where are the
tests for this?

Thanks
Boaz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
