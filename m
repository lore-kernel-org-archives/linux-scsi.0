From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Wed, 25 Jul 2007 09:47:40 +0900
Message-ID: <20070725094740H.fujita.tomonori@lab.ntt.co.jp>
References: <20070724142757F.fujita.tomonori@lab.ntt.co.jp>
	<664A4EBB07F29743873A87CF62C26D70885438@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:37110 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760953AbXGYAsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 20:48:04 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70885438@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Tue, 24 Jul 2007 18:22:08 -0600

> On Monday, July 23, 2007 11:28 PM, FUJITA Tomonori wrote:
> 
> > 
> > With 2.6.23-rc1 + mptsas smp patch, you get directories /sys/class/bsg
> > like:
> 
> I hadn't enabled bsg support in the linux kernel, that was my problem.

What do you mean? You might hit the bug that you can't build scsi as a
modular. It was fixed before rc1.


> > # ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/expander-0:1
> > 
> > 
> > I think that James tested this with aic94xx, however, I guess that
> > nobody has tested this with mptsas.
> > 
> 
> I got garbage (I'm using the 2.6.23-git11 patch from last week, before
> rc1):
> 
> # ./smp_rep_manufacturer /sys/class/bsg/expander-2:0
>   SAS-1.1 format: 1
>   vendor identification: _BUS_ADD
>   product identification: RESS=unix:abstra
>   product revision level: ct=/
>   component vendor identification: tmp/dbus
>   component id: 11609
>   component revision level: 69
> 
> With Doug Gilberts tools it works:
> 
> # smp_rep_manufacturer --sa=0x500605b0000016b0 /dev/mptctl
> Report manufacturer response:
>   SAS-1.1 format: 0
>   vendor identification: LSILOGIC
>   product identification: SASx12 A.0
>   product revision level:
> 
> 
> Also, unloading and reloading the driver resulted in two expander
> entryies in /sys/class/bsg.    The old entry was not deleted when I
> unloaded the driver.  When I tryied to run smp_rep_manufacture on the
> old expander instance, it panicked.

I forgot to remove bsg entries. James fixed the bug. Please try
2.6.23-rc1.

But probably, the tool still don't work against an expander. Does it
work against the Virtual SMP Port?


> > > I'm not sure what the intent of this else case.
> > 
> > This code is for an "invisible" SMP target in LSI SAS HBAs. There are
> > better ways to get the target's address, I think. Any suggestions?
> > 
> 
> I've never heard that we(as in LSI) are attaching invisable SMP targets
> to HBA's.  I've seen the Virtual SMP Port, but those are not hidden, the
> driver would report them to the transport layer, therefore rphy should
> be non-zero.

I just used Doug's word, "invisible" SMP target.


>   For instance a 12 phy expander would have 13 phys(with
> the last being the virtual phy).   I doubt we need to have this else
> case in the code, as it will be returning the sas_address to the first
> attached device(which may not always be an expander).    Are you
> executing the else path?

I guess so. If I do:

./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/sas_host0

I hit the else path (check sas_bsg_initialize in scsi_transport_sas.c).


> > Yeah, I guess that it would be better to send mpt's smpReply to user
> > space then user-space tools can examine it. You know, That's what mpt
> > ioctl and Doug' smp_utils do. But we can't use the in-buffer for this
> > since it's used for the smp response. We could use sense buffer for
> > this.
> >
> 
> there is no sense data associated to a SMP request.    there is
> response-data, but that is something else.

Yeah, I know. I just said we can't use the in-buffer for mpt's
smpReply.


> I'm not sure rather it would be good idea to send the smp_reply back up
> the stack, as this data would be unique only to fusion.  In the reply,
> there is ioc_status, loginfo, and sas_status.  With this info, you can
> determine how to process the SMP request.  The sas_status defines are
> located at the top of mpi_sas.h (look for Values of SASStatus).
> ioc_status is in mpi.h (look for MPI_IOCSTATUS_XXX), and loginfo is
> defined in mpi_log_sas.h.

Oh, I thought that LSI wants to send the smp_reply back to user space
since Doug's smp-utils does. But If you don't want, I'll just put the
response check code that you suggested in the previous mail.

Thanks,
