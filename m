From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] SCSI: fix unsafe operations related to sshdr in
 scsi_test_unit_ready()
Date: Wed, 15 Sep 2010 00:27:53 +0900
Message-ID: <20100915002400F.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTinDmT5aVZ0PdozfGHE9tsqomaNfP0CGAcg6j=98@mail.gmail.com>
	<1284475625.20409.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57166 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0INP2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2010 11:28:10 -0400
In-Reply-To: <1284475625.20409.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: dhillf@gmail.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

On Tue, 14 Sep 2010 09:47:05 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Tue, 2010-09-14 at 21:26 +0800, Hillf Danton wrote:
> > The kzalloc for sshdr is replaced with sshdr struct on stack, then it
> > looks safer.
> 
> This premise is completely wrong.  There are lots of times stack can be
> wrong for driver code especially: DMA or aligment but for general code,

This patch looks fine about DMA because scsi_execute_req() doesn't do
DMA with sshdr. scsi_execute_req() allocates a buffer for DMA with
kzalloc.


> since we went to 4k stacks we have very little space; a lot of arrays
> and structures got moved to kmalloc to reduce stack consumption.

Yes but scsi_sense_hdr is just 8 bytes so I think that this conversion
could be fine. Actually, I sent a patch to do the same long ago.
