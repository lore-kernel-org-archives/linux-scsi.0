From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Thu, 31 Jul 2008 16:24:54 +0900
Message-ID: <20080731162449X.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0807301259s309f6332wef74d2ac5bafe691@mail.gmail.com>
	<20080731135521N.fujita.tomonori@lab.ntt.co.jp>
	<20080731071851.GA30534@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59727 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYGaHZa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 03:25:30 -0400
In-Reply-To: <20080731071851.GA30534@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: fujita.tomonori@lab.ntt.co.jp, adel.gadllah@gmail.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Thu, 31 Jul 2008 01:18:52 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Jul 31, 2008 at 01:55:31PM +0900, FUJITA Tomonori wrote:
> > Someone might think that it would be better if we can change the
> > filter without specifying all the accepted commands. For example, we
> > could do like:
> > 
> > clover:/sys/block/cciss!c0d0/cmd_filter# cat read_table
> > 03 08 12 1a 1b 1c
> > 
> > clover:/sys/block/cciss!c0d0/cmd_filter# echo 02 > read_table_on
> > 02 03 08 12 1a 1b 1c
> > 
> > But I don't have strong opinions about it.
> 
> We need to be able to delete as well as add.

Yeah, I thought about adding a new file such as read_table_off.


> We could have a scheme in which:
> 
> echo -- "-03" >read_table
> cat read_table
> 08 12 1a 1b 1c
> 
> echo -- "+02 +07 +08" >read_table
> cat read_table
> 02 07 08 12 1a 1b 1c
> 
> The + could be implicit.

Looks another potential option though I prefer "-0x03" than "-03" as I
said in the previous mail.
