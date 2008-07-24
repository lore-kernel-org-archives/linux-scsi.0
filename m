From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Thu, 24 Jul 2008 12:31:47 +0900
Message-ID: <20080724123140V.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0806260310n5988b59dycb0aeab3b0f5c930@mail.gmail.com>
	<20080626233633E.fujita.tomonori@lab.ntt.co.jp>
	<e9c3a7c20807231811n23785a12jfac8647f698e82a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40093 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYGXDc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2008 23:32:28 -0400
In-Reply-To: <e9c3a7c20807231811n23785a12jfac8647f698e82a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, adel.gadllah@gmail.com, pjones@redhat.com, dgilbert@interlog.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, viro@ZenIV.linux.org.uk

On Wed, 23 Jul 2008 18:11:58 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> On Thu, Jun 26, 2008 at 7:36 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> >> Jens can we add merge this for .27 or does anyone still has objections?
> >
> > I think that this patch makes sg's permission stricter. So this could
> > break the existing user-space applications.
> 
> Yes, it seems to have broken a simple routine I had to retrieve the
> disk serial number from /dev/sg0.  Works fine if I run the ioctl on
> /dev/sda.
> 
> Can we consider this a regression or am I doing something wrong?  The
> following returns 2 on post-2.6.26 mainline and 0 otherwise.

This is a regression. Obviously, the filter patch was tested with only
the block SG_IO partly. It breaks sg and bsg. Al Viro pointed out:

http://marc.info/?l=linux-kernel&m=121662171123285&w=2

I think that it breaks even the block SG_IO with tape drives.

I'll send fixes tonight.
