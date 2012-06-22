From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [PATCH] scsi_dh_alua: Re-enable STPG for unavailable ports
Date: Fri, 22 Jun 2012 20:05:09 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B07E50592@SACEXCMBX02-PRD.hq.netapp.com>
References: <4FE431A2.2050500@acm.org>
 <77471C95FAFD844C8CA02DD4F4C5FE2B07E504FD@SACEXCMBX02-PRD.hq.netapp.com>
 <4FE4BE6C.1080608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:56510 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab2FVUFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 16:05:11 -0400
In-Reply-To: <4FE4BE6C.1080608@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

> -----Original Message-----
> From: Bart Van Assche [mailto:bvanassche@acm.org]
> Sent: Friday, June 22, 2012 1:50 PM
> To: Moger, Babu
> Cc: linux-scsi; Hannes Reinecke
> Subject: Re: [PATCH] scsi_dh_alua: Re-enable STPG for unavailable ports
> 
> On 06/22/12 17:52, Moger, Babu wrote:
> 
> > One concern, the spec also says..
> > ==============================
> > The unavailable target port asymmetric access state is
> > intended for situations when the target port accessibility to a logical unit
> may be severely restricted due to SCSI
> > target device limitations (e.g., hardware errors). Therefore it may not be
> possible to transition from this state to
> > either the active/optimized, active/non-optimized or standby states.
> > =====================================================
> >
> > What happens if we cannot transition to active/optimized, active/non-
> optimized or standby states.
> > Are we going to loop forever?  From kernel side it looks ok.  We are going
> mark the path as failed.
> > It depends on what the path checker from multipath is going to do.  Do you
> have any idea about it?
> 
> 
> Good question. I'm not a multipath expert, but as far as I understand
> the multipath user space software if activating a path fails after some
> delay multipathd tries again to find a usable I/O path.

I was worried that path checker will somehow think the "unavailable state"
as good. That  might trigger continues path activations.  But that is not the case.
Tested with  tur checker. It detects the state correctly.  We are good. See below.

Jun 22 14:27:20 nilgiris multipathd: mpathg: sdh - tur checker reports path is down
Jun 22 14:27:20 nilgiris kernel: sd 1:0:1:1: [sdh] Done: SUCCESS
Jun 22 14:27:20 nilgiris kernel: sd 1:0:1:1: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jun 22 14:27:20 nilgiris kernel: sd 1:0:1:1: [sdh] CDB: Test Unit Ready: 00 00 00 00 00 00
Jun 22 14:27:20 nilgiris kernel: sd 1:0:1:1: [sdh] Sense Key : Not Ready [current]
Jun 22 14:27:20 nilgiris kernel: sd 1:0:1:1: [sdh] Add. Sense: Logical unit not accessible, target port in unavailable state

Patch looks good.

Reviewed-by: Babu Moger <babu.moger@netapp.com> 

> 
> Bart.
