From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Tue, 24 Jul 2007 18:22:08 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70885438@NAMAIL4.ad.lsil.com>
References: <20070724142757F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43878 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbXGYAXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 20:23:00 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070724142757F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On Monday, July 23, 2007 11:28 PM, FUJITA Tomonori wrote:

> 
> With 2.6.23-rc1 + mptsas smp patch, you get directories /sys/class/bsg
> like:

I hadn't enabled bsg support in the linux kernel, that was my problem.

> 
> # ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/expander-0:1
> 
> 
> I think that James tested this with aic94xx, however, I guess that
> nobody has tested this with mptsas.
> 

I got garbage (I'm using the 2.6.23-git11 patch from last week, before
rc1):

# ./smp_rep_manufacturer /sys/class/bsg/expander-2:0
  SAS-1.1 format: 1
  vendor identification: _BUS_ADD
  product identification: RESS=unix:abstra
  product revision level: ct=/
  component vendor identification: tmp/dbus
  component id: 11609
  component revision level: 69

With Doug Gilberts tools it works:

# smp_rep_manufacturer --sa=0x500605b0000016b0 /dev/mptctl
Report manufacturer response:
  SAS-1.1 format: 0
  vendor identification: LSILOGIC
  product identification: SASx12 A.0
  product revision level:


Also, unloading and reloading the driver resulted in two expander
entryies in /sys/class/bsg.    The old entry was not deleted when I
unloaded the driver.  When I tryied to run smp_rep_manufacture on the
old expander instance, it panicked.

> 
> > I was trying to run the smp_rep_manufacture from sgv4_tools, and I
> > got that error.  Due to that, I have not able to test this patch.
> 
> What is the error message?
> 

The application complained it couldn't bind to a bsg device.  Well  part
of the problem is I wasn't passing anything on the command line.
Anyways, I figured it out.

> > I'm not sure what the intent of this else case.
> 
> This code is for an "invisible" SMP target in LSI SAS HBAs. There are
> better ways to get the target's address, I think. Any suggestions?
> 

I've never heard that we(as in LSI) are attaching invisable SMP targets
to HBA's.  I've seen the Virtual SMP Port, but those are not hidden, the
driver would report them to the transport layer, therefore rphy should
be non-zero.   For instance a 12 phy expander would have 13 phys(with
the last being the virtual phy).   I doubt we need to have this else
case in the code, as it will be returning the sas_address to the first
attached device(which may not always be an expander).    Are you
executing the else path?



> Yeah, I guess that it would be better to send mpt's smpReply to user
> space then user-space tools can examine it. You know, That's what mpt
> ioctl and Doug' smp_utils do. But we can't use the in-buffer for this
> since it's used for the smp response. We could use sense buffer for
> this.
>

there is no sense data associated to a SMP request.    there is
response-data, but that is something else.

I'm not sure rather it would be good idea to send the smp_reply back up
the stack, as this data would be unique only to fusion.  In the reply,
there is ioc_status, loginfo, and sas_status.  With this info, you can
determine how to process the SMP request.  The sas_status defines are
located at the top of mpi_sas.h (look for Values of SASStatus).
ioc_status is in mpi.h (look for MPI_IOCSTATUS_XXX), and loginfo is
defined in mpi_log_sas.h.


Eric Moore

      
