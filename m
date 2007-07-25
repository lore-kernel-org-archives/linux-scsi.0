From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Wed, 25 Jul 2007 13:33:25 +0900
Message-ID: <20070725133325B.fujita.tomonori@lab.ntt.co.jp>
References: <20070724142757F.fujita.tomonori@lab.ntt.co.jp>
	<664A4EBB07F29743873A87CF62C26D70885438@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:63429 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbXGYEd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 00:33:57 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70885438@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Tue, 24 Jul 2007 18:22:08 -0600

> > > I'm not sure what the intent of this else case.
> > 
> > This code is for an "invisible" SMP target in LSI SAS HBAs. There are
> > better ways to get the target's address, I think. Any suggestions?
> > 
> 
> I've never heard that we(as in LSI) are attaching invisable SMP targets
> to HBA's.  I've seen the Virtual SMP Port, but those are not hidden, the
> driver would report them to the transport layer, therefore rphy should
> be non-zero.   For instance a 12 phy expander would have 13 phys(with
> the last being the virtual phy).   I doubt we need to have this else
> case in the code, as it will be returning the sas_address to the first
> attached device(which may not always be an expander).    Are you
> executing the else path?

In the else path, I try to get the virtual phy's address. That is, I
try to do what sas_low_phy_scandir_select() in Doug's lsscsi tool
does.
