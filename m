From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: + mpt-fusion-dont-oops-if-numphys==0.patch added to -mm tree
Date: Wed, 20 Feb 2008 04:17:31 +0100
Message-ID: <20080220031731.GA31633@outback.rfc2324.org>
References: <200802192335.m1JNZ7MV005426@imap1.linux-foundation.org> <1203475151.3103.40.camel@localhost.localdomain> <Pine.LNX.4.64.0802200400001.6490@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rfc2324.org ([89.149.194.216]:37068 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYBTDu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 22:50:59 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802200400001.6490@bizon.gios.gov.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Oledzki <olel@ans.pl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, akpm@linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, mm-commits@vger.kernel.org, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com, max@rfc2324.org

Am Wednesday, den 20 February hub Krzysztof Oledzki folgendes in die Tasten:

Hi Krzysztof, *

Thanks for CC'ing me.

> >On Tue, 2008-02-19 at 15:34 -0800, akpm@linux-foundation.org wrote:
> >>Subject: mpt fusion: don't oops if NumPhys==0
> >>From: Krzysztof Oledzki <olel@ans.pl>
> >>
> >>Don't oops if NumPhys==0, instead return -ENODEV.
> >>This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9909
> >>
> >>Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> >>Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >>Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>Cc: Eric Moore <Eric.Moore@lsi.com>
> >>Cc: Sathya Prakash <sathya.prakash@lsi.com>
> >>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>---
> >>
> >> drivers/message/fusion/mptsas.c |    5 +++++
> >> 1 file changed, 5 insertions(+)
> >>
> >>diff -puN 
> >>drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0 
> >>drivers/message/fusion/mptsas.c
> >>--- a/drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0
> >>+++ a/drivers/message/fusion/mptsas.c
> >>@@ -1701,6 +1701,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
> >> 	if (error)
> >> 		goto out_free_consistent;
> >>
> >>+	if (!buffer->NumPhys) {
> >>+		error = -ENODEV;
> >>+		goto out_free_consistent;
> >>+	}
> >>+
> >> 	/* save config data */
> >> 	port_info->num_phys = buffer->NumPhys;
> >> 	port_info->phy_info = kcalloc(port_info->num_phys,
> >>_
> >
> >This is a bit odd ... It looks like a work around for a fusion firmware
> >problem.

> Workaround or not, the driver should not oops by allocating 0 size memory 
> block and dereferencing it. It used to work in <2.6.23 but not now.

ACK.
Nevertheless my server is working absolutely well with this
fix/workaround. No problems at all.

> >What's the topology this thing is connected to?

> It is a Dell-1950III server with two 400GB SAS disks (RAID1) installed in 
> a dwo disk SAS backplane.

Here it's a Dell 1950 with two 73G SAS disks (RAID1) but having four
SAS disk slots.

If you need further information about the hardware, just let me know.

Ciao
Max
-- 
	Follow the white penguin.
