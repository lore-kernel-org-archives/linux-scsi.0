From: Willem Riede <wrlk@riede.org>
Subject: Re: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Date: Wed, 28 Jan 2004 12:36:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128173609.GE23308@serve.riede.org>
References: <20040127003244.GM23308@serve.riede.org> <20040128033041.GY23308@serve.riede.org> <20040128084142.A4835@beaverton.ibm.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:17853 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S266022AbUA1RgM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 12:36:12 -0500
Content-Disposition: inline
In-Reply-To: <20040128084142.A4835@beaverton.ibm.com> (from patmans@us.ibm.com on Wed, Jan 28, 2004 at 11:41:43 -0500)
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 2004.01.28 11:41, Patrick Mansfield wrote:
> On Tue, Jan 27, 2004 at 10:30:41PM -0500, Willem Riede wrote:
> > On 2004.01.26 19:32, Willem Riede wrote:
> > > Jan 26 17:13:23 fallguy kernel: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
> 
> I was trying to figure out what happened, apparently I missed a check when
> splitting the locks up and removing a lock hiearchy.
> 
> We should only clear starget_sdev_user when the sdev has no more IO. We
> want to run (a bunch of) IO for a given starget_sdev_user, and when there is
> no more IO, clear starget_sdev_user so someone else has a chance to run.
> 
> I'm trying to figure out a fix without adding any lock hiearchy. queue_lock
> protects device_busy, but host_lock protects starget_sdev_user.

Anything I can do to help (if only to test when you have an idea)?

> The single lun devices and code are annoying :-(
> 
> Do you know if the single lun code is for performance, or because of
> hardware limitations - that is we don't want a disc change between IO, or
> does the device just fail?

In the case of the NEC PD/CD, it is a hardware limitation. You can only
have one disc inserted at a time, either CD or PD. Mixing IO will fail
for the absent media type.

Regards, Willem Riede.
