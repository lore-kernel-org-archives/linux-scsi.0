From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: target: Check LUN numbers
Date: Mon, 14 Feb 2011 15:19:16 +0900
Message-ID: <20110214151918J.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTimQktk0e2dLiHB=YQNC1tUS1HYgnD3MF76it2Sq@mail.gmail.com>
	<1297636980.13306.136.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42265 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1BNGTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2011 01:19:23 -0500
In-Reply-To: <1297636980.13306.136.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fubo.chen@gmail.com, linux-scsi@vger.kernel.org

On Sun, 13 Feb 2011 14:43:00 -0800
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Sun, 2011-02-13 at 09:24 +0100, Fubo Chen wrote:
> > Check LUN before reading from device_list[] array.
> > 
> > Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
> > ---
> >  drivers/target/target_core_device.c |   13 +++++++++++++
> >  1 file changed, 13 insertions(+), 0 deletions(-)
> > 
> 
> I think this is a reasonable check to add considering the number of TCM
> fabric modules calling transport_get_lun_for_[cmd,tmr]() directly.
> 
> Note this patch did not apply cleanly because of the extra BUG_ON() in
> transport_get_lun_for_cmd(), but has been fixed + committed as
> 0f75d7cf4b259.

I think that we need the mechanism that enable target drivers to limit
the maximum lun.

Also TRANSPORT_MAX_LUNS_PER_TPG, 256, sounds too small.
