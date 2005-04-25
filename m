From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] SAS domain layout for Linux sysfs
Date: Mon, 25 Apr 2005 12:06:10 -0400
Message-ID: <426D1572.70508@adaptec.com>
References: <425D392F.2080702@adaptec.com> <20050424111908.GA23010@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8105 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262688AbVDYQGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2005 12:06:17 -0400
In-Reply-To: <20050424111908.GA23010@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, andrew.patterson@hp.com, Eric.Moore@lsil.com, mike.miller@hp.com, dougg@torque.net, Madhuresh_Nagshain@adaptec.com

On 04/24/05 07:19, Christoph Hellwig wrote:
> 
> This is contrary to any sysfs topology I know about, especially any
> existing transport class (SPI, FC, iSCSI).

This RFC is about SAS.

>  We only ever care about what's seen from a HA,

Imagine you could connect to the same device via two
different PCI controllers on the same host.

> e.g. if you have muliple SPI cards that are
> on a single parallel bus you'll have the same bus represented twice,
> similarly if you have two fibre channel HBAs connected to the same
> SAN you'll have the SAN topology duplicated in both sub-topologies.

Hmm, this proposal is for SAS only, Christoph.

If you have multiple SAS host adapters connected to the same
SAS domain, the _path_ they connect to a SAS device may be _different_.
But what is the same is the SAS domain (topology) itself *regardless of
how you connect to it.*

In order to eliminate duplication of sysfs entries (directories
and files) to describe the same SAS device, we split up the
representation into a "flat" directory with just a bunch
of SAS devices, this is /sys/bus/sas/.  And the way you _connect_
to those SAS devices is represented in sys/class/sas_ha/.

See this (new) picture:
           |                        |
+-------+  |                        |
|ha0 [] =--|-----------.            |
+---||||+  |            \  +-----+  |
           |             `-= ex2 =--|--> ta0
           |               |     =--|--> in2
           |             .-=     =--|--> ta2
+-------+  |  +-----+   /  +-----+  |
|ha1 [] =--|--= ex1 =--'            |
+---||||+  |  +-----+               |
           |                        |
Host domain| Sysfs SAS domain only  | Both domains

Anything *but* "Host domain" is "out there" and *doesn't
change* regardless of how you connect to it.

What changes is *how you connect* to to SAS devices from
your host (the host domain).

In effect ta0, in2, ta2, ex1, ex2 are represented only *once*,
in /sys/bus/sas/.  But the way your host adapter connects to
them is described in /sys/class/sas_ha/, with the appropriate
symbolic links as described in the RFC.

	Luben


> This matches the internal data structure of the scsi subsystem and
> the transport class, e.g. we have a scsi_device object for every lun
> that's seen from a hba, linked to the HBAs Scsi_Host object and not
> one shared by multiple HBAs.  Dito for fibre channel remote ports.
> 
> 
> One note to this proposal:  it probably doesn't make a lot of sense to
> try to flesh out the sysfs topology before doing the kernel internal
> object model as the former pretty much follows the latter.
> 

