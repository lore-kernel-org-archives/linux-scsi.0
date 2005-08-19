From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: libata error handling
Date: Fri, 19 Aug 2005 12:38:54 -0700
Message-ID: <20050819193853.GA1549@us.ibm.com>
References: <20050729050654.GA10413@havoc.gtf.org> <20050807054850.GA13335@htj.dyndns.org> <430556BF.5070004@pobox.com> <4306290B.6080608@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4306290B.6080608@adaptec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 19, 2005 at 02:46:35PM -0400, Luben Tuikov wrote:

> 
> Using the command time out hook and the strategy routine, gives _complete_
> control over host recovery, and I really do mean _complete_.
> 

I assume you mean hostt->eh_timed_out.

Is anyone implmenting (or has implemented) a ->eh_timed_out function? I see
none in mainline kernel.

I was looking at using it in an LLDD, but hit two problems, and have
started to work on an alternate approach of cancelling (aborting or wtf you
want to call it) a list of commands in the eh thread.

The two problems I see with the hook are:

It calls the driver in interrupt context, so the called function can't
sleep.

There is no queueing or list mechanism, so LLDD's that can only cancel one
command at a time will have problem.

-- Patrick Mansfield
