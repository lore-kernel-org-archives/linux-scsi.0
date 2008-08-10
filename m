From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v5] cmdfilter: clean up sysfs interface
Date: Sun, 10 Aug 2008 16:31:48 +0900
Message-ID: <20080810163206X.fujita.tomonori@lab.ntt.co.jp>
References: <20080809033935.GI8618@parisc-linux.org>
	<6cf6b73e0808090309y94a071dh3079d4e89cc1154f@mail.gmail.com>
	<20080809135520.GJ8618@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59573 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbYHJHcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2008 03:32:33 -0400
In-Reply-To: <20080809135520.GJ8618@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: adel.gadllah@gmail.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, pjones@redhat.com, dougg@torque.net, dan.j.williams@intel.com, James.Bottomley@hansenpartnership.com

On Sat, 9 Aug 2008 07:55:21 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Aug 09, 2008 at 12:09:38PM +0200, Adel Gadllah wrote:
> > ------------------------
> > This patch changes the interface of the cmd filter to use a +/- notation like:
> > echo -- +0x02 +0x03 -0x08
> > If neither + or - is given it defaults to + (allow command).
> > 
> > Note: The interface was added in 2.6.17-rc1 and is unused
> > and undocumented so far so it's safe to change it.
> > 
> > Cc: matthew@wil.cx
> > Cc: fujita.tomonori@lab.ntt.co.jp
> > Cc: jens.axboe@oracle.com
> > Cc: James.Bottomley@hansenpartnership.com
> > Cc: dan.j.williams@intel.com
> > Cc: pjones@redhat.com
> > Cc: viro@zeniv.linux.org.uk
> > Cc: dougg@torque.net
> > Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> 
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

I am also fine with this version.

After using this API a bit, I thought that this interface is a bit
unhandy when I just want to set up new access permissions from the
scratch though the new interface is handy when I want to modify the
current permissions.

I guess that in some cases (such as on bootup), we don't care about
the current permissions, just want to set up our permissions. It would
be nice if we can drop the current permissions (all the commands are
prohibited), something like "echo -- > read_table"
