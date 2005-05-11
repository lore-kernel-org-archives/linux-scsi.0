From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 11:02:32 -0700
Message-ID: <20050511180232.GD9286@us.ibm.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com> <4281F396.2030607@torque.net> <4282345B.4010102@adaptec.com> <20050511174549.GB9286@us.ibm.com> <42824726.3010503@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:986 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261255AbVEKSCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 14:02:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4BI2cVt020014
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 14:02:38 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4BI2bc0114662
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 14:02:37 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4BI2bCh002587
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 14:02:37 -0400
Content-Disposition: inline
In-Reply-To: <42824726.3010503@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: dougg@torque.net, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, May 11, 2005 at 01:55:50PM -0400, Luben Tuikov wrote:
> On 05/11/05 13:45, Patrick Mansfield wrote:

> > It might be a bit odd in some cases and maybe hardware specific (for multi
> > path io, does QUEUE FULL mean a storage port/controller is full, or the
> > LUN is full? if port, then you want to send back to the upper level, but
> > if LUN, you might want to let scsi core requeue it). 
> 
> If it is coming from SDS (TASK SET FULL) then it is the LUN.  If it
> is coming from the LLDD, then it is the other (host queue full).

I mean that if it is from the LUN, and there are multiple ports or
controllers on the LUN, you don't know if the QUEUE FULL means the port is
busy, or the LUN (or target) is busy.

-- Patrick Mansfield
