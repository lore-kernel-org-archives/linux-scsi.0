From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Fri, 25 Mar 2011 14:34:58 -0500
Message-ID: <1301081698.4073.32.camel@mulgrave.site>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
	 <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
	 <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
	 <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
	 <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
	 <1301012333.4087.24.camel@mulgrave.site>
	 <AANLkTik2UxAO3uZ8r1U0bqYVX+0zHGUAd8uuiPzVQq57@mail.gmail.com>
	 <1301065611.4073.7.camel@mulgrave.site>
	 <AANLkTims4pYwuwU7UeOvgiXvr6CRBRUk8+juLKA3DpWm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1CYTfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2011 15:35:07 -0400
In-Reply-To: <AANLkTims4pYwuwU7UeOvgiXvr6CRBRUk8+juLKA3DpWm@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Fri, 2011-03-25 at 19:44 +0100, Bart Van Assche wrote:
> On Fri, Mar 25, 2011 at 4:06 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > Explain first what lock inversion problems you see ... those usually
> > only happen if you have the in the kernel upcall thread waiting for
> > completion.
> 
> In this context asynchronous upcalls have their problems too: the
> in-kernel and the user space visible state may become inconsistent.
> What will happen if processing of such notifications is delayed and
> concurrently attempts are made from user space to act on these objects
> ? I'm afraid that could result in horrible race conditions.

What race conditions?  The current exemplar is udev which uses the
uevent mechanism.  The usual way of coping with use before init is to
key visibility off completion ... at least that's the way we do it in
sysfs.

James


