From: Jeremy Linton <jli@greshamstorage.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 6 Dec 2006 17:55:07 -0600
Message-ID: <200612061755.08213.jli@greshamstorage.com>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org> <45774927.8090204@cs.wisc.edu> <200612061742.27884.jlinton@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:3723 "EHLO
	austin.greshamstorage.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937820AbWLFXzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 18:55:36 -0500
In-Reply-To: <200612061742.27884.jlinton@greshamstorage.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Wednesday 06 December 2006 17:42, Jeremy Linton wrote:
> On Wednesday 06 December 2006 16:50, Mike Christie wrote:
> > > For iscsi, we could negotiate a value like MaxBurstLength which says
> > > don't send commands with a payload larger than that size. I would guess
> > > other transports have something similar. We have to check or make sure
>
> ...
>
> > Oh yeah the exception I am thinking about may not be max sectors exactly
> > but something close like iscsi's MaxBurstLength limit. Maybe iscsi LLDs
> > are supposed to be translating that iscsi limit to max_sectors in which
> > case we are talking about the same thing. For this limit we do not want
>
> 	Sort of off topic, but the iSCSI MaxBurstLength doesn't set the max
> transfer size, it simply is the amount of data that can be sent without a
> R2T. If the transfer is larger then you have to wait for the R2T. In
> practice it ends up controlling the _minimum_ amount of buffer space that
> needs to be available _before_ the transfer starts, otherwise performace
> sucks.
	Whops, Slight clarification, the MaxBurstLength is the max sent between R2T's 
what I described above is closer to the FirstBurstLength. What you guys are 
describing might better be the MaxRecvDataSegmentLength, but not really since 
that parameter should be hidden within the iSCSI driver.


