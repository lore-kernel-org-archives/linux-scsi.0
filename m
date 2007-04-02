From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SMP pass through interface via bsg
Date: Sun, 01 Apr 2007 22:57:42 -0500
Message-ID: <1175486263.27675.11.camel@mulgrave.il.steeleye.com>
References: <20070402110125U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54421 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752834AbXDBD6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Apr 2007 23:58:07 -0400
In-Reply-To: <20070402110125U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Mon, 2007-04-02 at 11:49 +0900, FUJITA Tomonori wrote:
> I started to work on SMP pass through via bsg as a non-SCSI command
> experimentation. I asked Doug to try the patch but it seems to take
> some time to make Doug's hardware work with the mainline aic94xxx
> driver.

If you post the code, others who also have the hardware can try it
too ...

> How should a user-space tool (like Doug's smp_utils) send a request
> and get the response via bsg?

Basic frame in/frame out ... this is why we need the block layer
bidirectional support

> -- each SAS object (host, device, expander, etc) has the own bsg
> device

I think so; probably attached via the transport class.

> A user-space tool opens a bsg device for a sas object that it wants to
> send a request to.
> 
> -- one bsg device handles multiple SAS objects
> 
> Some options: one bsg device in the whole system; one bsg device per
> SAS driver; one bsg device per SAS host; etc.
> 
> With this approach, we need to invent a header incluing routing
> information.
> 
> My hacky patch creates one bsg device per SAS host and invents:
> 
> struct smp_passthrough_hdr {
>         __u64 sas_address;
>         __u8 phy_identifier;
> };

I'd really rather not go this route unless the one device per object
approach becomes untenable.

> a user-space tool sends this header instead of scb via bsg and put a
> SMP request at dout_xfer and a buffer response at din_xfer (note that
> now I do bidi transfer in a hacky way).
> 
> 
> - SAS implementation details
> 
> As I said, the patch is too hacky. I just tried to implement a
> smp_portal alternative by using bsg.
> 
> The patch adds a hook into sas transport class. sas_host_setup calls
> bsg_register_queue. Then, the request_fn calls smp_execute_task to
> send a smp request and get the response. It doesn't look good to link
> the sas transport class with libsas. In addition, the mpt driver
> handles smp request/response in a very different way.
> 
> Any suggestion to bind SMP pass through via bsg to aic94xx and mpt
> cleanly?

bind in the transport class, not the driver ...

James


