From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/3] SG v4 support
Date: Fri, 15 Dec 2006 13:41:40 -0600
Message-ID: <1166211700.2846.48.camel@mulgrave.il.steeleye.com>
References: <20061216001753F.fujita.tomonori@lab.ntt.co.jp>
	 <20061215185704.GZ5010@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42821 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753306AbWLOTmI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Dec 2006 14:42:08 -0500
In-Reply-To: <20061215185704.GZ5010@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, dougg@torque.net

On Fri, 2006-12-15 at 19:57 +0100, Jens Axboe wrote:
> Good start! Just one comment before I look over this and merge it -
> I'd
> prefer keeping this out of sg.c. One of the problems we have right now
> are dual pieces of code for sg v3, and I think it would be silly to
> continue down this path. Lets keep sg.c as a legacy sg v3 interface
> (it'll be the only one except SG_IO in the block layer), and let bsg
> take sg v4 and forward.
> 
> There's really zero gain in having it in two places.

There is a slight complexity here in that sg is the only thing that
attaches to things like processor devices, or other devices we have no
ULD for; so if we want sg v4 exposed to them, we need to at least route
sg though this ioctl.

James


