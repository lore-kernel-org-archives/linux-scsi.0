From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI HA problems
Date: Sat, 22 Oct 2011 08:31:48 -0500
Message-ID: <1319290308.3054.15.camel@dabdike.int.hansenpartnership.com>
References: <3915A3F8-ECF9-469B-869F-EA4C8421476E@mines.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43706 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519Ab1JVNbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2011 09:31:51 -0400
In-Reply-To: <3915A3F8-ECF9-469B-869F-EA4C8421476E@mines.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Robbert <mrobbert@mines.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2011-10-21 at 18:08 -0600, Michael Robbert wrote:
> I want some technical advice from the SCSI/SAS/SATA experts. We are
> trying to setup a low cost HA storage system with multiple servers
> that have SAS HBAs, SAS JBOD, and desktop SATA disks. When we first
> set it up everything appeared to work. I created RAID6 on one host and
> put it into a corosync/pacemaker config. I was then able to migrate
> the RAID from one host to another. A short while later a failover
> failed and I noticed that some of the drives became inaccessible on
> one of the hosts. The kernel was showing timeouts to the device. 
> 
> Oct 21 17:55:34 haraid-12-1 kernel: sd 1:0:3:0: timing out command, waited 10s
> 
> So, my question is this, is this setup technically possible or are the
> 2 HBAs going to conflict with each other when talking over the same
> SAS bus to the SATA drives?

Well, yes, but the devil is in the details.  Firstly it's only possible
with SAS; SATA controllers don't really do multi-initiator and SATA
disks don't have the cluster commands that SAS disks do.  It is
theoretically possible with a SAS controller and SATA disk provided the
cluster software doesn't use any of the SCSI commands for clustering.

The reason your setup likely doesn't work is because of the expander.
SAS expanders are complex beasts:  Any port can be device, table or
subtractively routed.  You don't usually see it, but a JBOD ships with a
subtractive port for the HBA connection and a device port for everything
else.  You can't just plug another HBA into a random device port because
the routing won't get device replies back to you (hence the timeout).

The way I've got this set up at home uses a 12x expander with 4x
subtractive and 9x table routing phys which group in clusters of up to
four for ports.  I can plug the second HBA into one of the table routed
ports because the SCSI transport class installs the correct route
tables, so I know it works for aic9xxx and mvsas.

James


