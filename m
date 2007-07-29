From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Sun, 29 Jul 2007 16:36:56 +0900
Message-ID: <20070729163656J.fujita.tomonori@lab.ntt.co.jp>
References: <20070726043933K.tomof@acm.org>
	<664A4EBB07F29743873A87CF62C26D708B3D8B@NAMAIL4.ad.lsil.com>
	<20070729140701B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:41656 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887AbXG2HhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 03:37:06 -0400
In-Reply-To: <20070729140701B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: tomof@acm.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Sun, 29 Jul 2007 14:07:01 +0900

> From: "Moore, Eric" <Eric.Moore@lsi.com>
> Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
> Date: Fri, 27 Jul 2007 17:24:19 -0600
> 
> > On  Thursday, July 26, 2007 6:44 PM, FUJITA Tomonori wrote:
> > > 
> > > Does this work for you? Sorry, I'm not at the lab now and can't test
> > > it. But I can do next week.
> > > 
> > > I also updated bsg's smp_rep_manufacturer to print the mpi's
> > > replay. You can get it from the git tree.
> > > 
> > 
> > yes this will work, and I pulled the updated sgv4, and saw your
> > inclusion of mptsas.h.
> 
> I confirmed that this patch sends mpi's unique reply back to user
> space.
> 
> When I send a wrong smp frame, I got:
> 
> nice:/home/fujita# ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/sas_host0
> IOCStatus=0x1 IOCLogInfo=0x0 SASStatus=0x2
> expected SMP frame response type, got=0x10
> 
> 
> Eric, can I get your ACK on this patch?

One comment on the the patch:

+	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_COMMAND_GOOD)) {
+		printk(KERN_ERR "%s: smp response invalid!\n", __FUNCTION__);
+		ret = -ENXIO;
+	}

We don't need this part since user-space can get mpt's reply, I think.
