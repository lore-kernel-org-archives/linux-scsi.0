From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg driver and Fedora Core 2
Date: Mon, 07 Jun 2004 18:56:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C42DD0.2020003@torque.net>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave> <40B8C81E.3050106@pobox.com> <20040529172916.GD18613@suse.de> <40B9B95A.40304@torque.net> <20040530104145.GA3172@devserv.devel.redhat.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:58638 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264330AbUFGI5H
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jun 2004 04:57:07 -0400
In-Reply-To: <20040530104145.GA3172@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Alan Cox wrote:
> On Sun, May 30, 2004 at 08:37:14PM +1000, Douglas Gilbert wrote:
> 
>>configuring the SAS domain. Expanders are SAS devices but
>>not SCSI devices (i.e. they are neither initiators nor
>>targets ***). It seems obvious that the management of a SAS
>>domain should be done from the user space. Only those
>>expanders and devices directly attached to a SAS Host Bus
>>Adapter should automatically be visible.
> 
> 
> Is there any reason that the SAS domain should in itself be a character
> device file. I've always thought of it as a network and anticipated
> a network layer interface for such things. That might just be my background
> however.

Alan,
In the SCSI parallel world the "domain" is usually
called the "bus" which is a set of targets and one or more
initiators and the ribbon (or external) cable that
interconnect them.

In SAS the "domain" is a little more rubbery. After wide
links are taken into account, there cannot be multiple
paths between scsi devices within one SAS domain (i.e. "no
loops"). An expander is part of the service interconnect
subsystem of a _single_ SAS domain (i.e. it can't be shared).
This means that expanders can be wired incorrectly.
Even simple interconnects need some thought:

     |   SAS  2   |
     |  port HBA  |
     --------------
         |     |
         |     |
         |     |
         |     |
      -------------
      | SAS dual  |
      |ported disk|

Is this a (2 phy) wide-link, single SAS domain or two SAS
domains? On current indications it is two SAS domains since
dual ported SAS disks have different SAS addresses on each
port. [The fact that the SAS HBA has the same SAS addresses
on both phys only meets half the requirement for a wide link.]

See SAS Quiz question 1 (then its answer) in the pdfs at:
http://www.scsita.org/aboutscsi/sas/tutorials.html
for a more complex scenario.

Detecting and explaining to a user why his/her SAS domain(s)
is incorrectly wired will be an interesting challenge.


So it wasn't the SCSI domain that I was proposing should
be a char (or network) device file. It was the SMP target
port inside each expander that is used for discovery,
configuration and statistics that needs a packet based
initiator driver/interface (like the sg driver). The concept
of a SAS domain I would rather leave for a user space
program.

Doug Gilbert
