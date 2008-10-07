From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] scsi_lib_dma.c : fix bug w/ dma maps on virtual fc
	ports
Date: Wed, 8 Oct 2008 00:48:29 +0900
Message-ID: <20081008004752G.fujita.tomonori@lab.ntt.co.jp>
References: <1223386518.3082.9.camel@ogier>
	<1223387629.3254.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42252 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbYJGPsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2008 11:48:39 -0400
In-Reply-To: <1223387629.3254.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Tue, 07 Oct 2008 08:53:49 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-10-07 at 09:35 -0400, James Smart wrote:
> > When the updated scsi dma code was introduced recently, it assumed the
> > physical host/adapter was the parent of the scsi host. Unfortunately,
> > on FC virtual ports, the parent of the scsi host is the virtual port,
> > which does not have dma information.
> 
> Hmm, so now we have nested hosts; I'd missed that piece; we might be in
> trouble in other places than just here.

This is a problem that we met one year ago?

http://marc.info/?t=118312464100002&r=1&w=2

vport's shost is not initialized like a normal shost so it doesn't
have dma information.

The updated patch looks nice. I should have done it at the time.
