From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: IO transfer limits
Date: Thu, 11 Jan 2007 17:13:00 +0100
Message-ID: <45A6620C.3040807@s5r6.in-berlin.de>
References: <8260533.post@talk.nabble.com> <45A5250E.3020205@cs.wisc.edu> <8269227.post@talk.nabble.com> <45A58FA5.2090003@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:48912 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXAKQND (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 11:13:03 -0500
In-Reply-To: <45A58FA5.2090003@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: john clyne <clyne@ucar.edu>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> john clyne wrote:
>> What do the different hostX in /sys/class/scsi_host corespond to? There are
>> seven hostX directories, 5 with sg_tablesize set to 128 and two set to 255.
> 
> A Linux "host" is a SCSI initiator port (e.g. FC) or a
> SCSI initiator device (e.g. SAS). Another way of looking
> at a "host" is as a bridge between a computer bus (e.g. PCI)
> and a storage transport. There is usually one (low level)
> driver (LLD) controlling all hosts associated with a
> specific class of hardware.
> 
> If you fetch the lsscsi utility and load it then you can
> try 'lsscsi --hosts' to list the active hosts on a
> system (numbered on the left) and see the names of the
> various LLDs associated with them. Here is an example:
> 
> # lsscsi --hosts
> [0]    sata_nv
> [1]    sata_nv
> [2]    sata_nv
> [3]    sata_nv
> [4]    mptsas
> [5]    aic94xx
> [6]    sbp2
> 
> The first four are SATA ports (connectors) on the motherboard,
> all controlled by the same driver. Then there is a LSI SAS
> HBA (whose driver is mptsas), an Adaptec SAS HBA (48300) and
> finally an Adaptec IEEE 1394 controller.

A side note:
I don't think a Scsi_Host has a well-defined meaning beyond "the
kernel-internal resource which LLDs use to connect to the Linux SCSI mid
layer". It may have further meaning for many LLDs, but not for all.
Specifically, the host6 in your example is in the current implementation
 indeed nothing more than an internal resource. lsscsi is nevertheless
able to determine the actual initiator port by means of knowledge of the
implementation.
-- 
Stefan Richter
-=====-=-=== ---= -=-==
http://arcgraph.de/sr/
