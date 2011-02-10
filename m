From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/3] ibmvscsis driver rewrite
Date: Thu, 10 Feb 2011 22:22:04 +0100
Message-ID: <AANLkTikN4dRuAXg26LrPa65WpWfBG1CHwmctGOGwmFWE@mail.gmail.com>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <4D53DE96.2020502@suse.de> <1297363312.18212.153.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64749 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab1BJVWZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2011 16:22:25 -0500
Received: by iyj8 with SMTP id 8so1749070iyj.19
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2011 13:22:25 -0800 (PST)
In-Reply-To: <1297363312.18212.153.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alexander Graf <alex@csgraf.de>, Stefan Hajnoczi <stefanha@gmail.com>

On Thu, Feb 10, 2011 at 7:41 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> On Thu, 2011-02-10 at 13:48 +0100, Hannes Reinecke wrote:
> >
> > On 02/10/2011 01:21 PM, FUJITA Tomonori wrote:
> > > Finally, I have the working driver. We are ready to remove the old
> > > ibmvstgt driver.
> > >
> > Hmm. Wouldn't it be possible to use it as a template for a
> > virtio-srp target?
> > From what I've seen we 'just' need to modify it to use virtio
> > instead for pSeries rdma callbacks.
> > And then we would have a virtio-srp target onto which any kvm guests
> > could connect to.

One should keep in mind that there exist two kinds of SRP drivers for Linux:
- Those based on synchronous data transfer calls - calls that only
return after the entire transfer has finished. The ibmvscsi, ibmvscsis
drivers and the libsrp library fall in this category.
- Those based on asynchronous data transfers - calls that return
immediately and where a callback function is invoked to report
completion. ib_srp and ib_srpt fall into this category (ib_srp is
upstream, ib_srpt not yet).

As far as I know the virtio interface uses callbacks and hence is an
asynchronous interface ? If so, the InfiniBand drivers might be a
better starting point.

Bart.
