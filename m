From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes +
 tcm_qla2xxx fabric module
Date: Sun, 13 May 2012 20:29:28 -0700
Message-ID: <1336966168.25759.293.camel@haakon2.linux-iscsi.org>
References: <4FAFD976.8090409@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44913 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2END3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2012 23:29:31 -0400
In-Reply-To: <4FAFD976.8090409@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On Sun, 2012-05-13 at 15:55 +0000, Bart Van Assche wrote:
> On Sunday December 18, 2011 Nicholas Bellinger wrote:
> > So to get the ball rolling on remaining items, one question is still how to
> > resolve mixed target/initiator mode operation on a HW per port context basis..?
> > 
> > This is currently done with a qla2xxx module parameter, but to do mixed mode
> > properly we will need something smarter between scsi-core and target-core ports.
> > Note we currently set qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED, so by default
> > patch #1 will effectively disable initiator mode by skipping scsi_scan_host()
> > from being called in to avoid scsi-core timeouts when performing immediate
> > transition from initiator mode -> target mode via ISP reset.
> > 
> > What we would like to eventually do is run qla2xxx LLD to allow both initiator
> > and target mode access based on the physical HW port.  We tried some simple
> > qla_target.c changes this make this work, but to really do it properly
> > and address current qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED usage it will
> > need to involve scsi-core so that individual HW port can be configured and
> > dynamically changed across different access modes.
> 
> (sorry for the late reply)
> 
> Dynamically switching between initiator mode, target mode or even using both
> modes simultaneously is already possible for iSCSI over Ethernet and for SRP
> over InfiniBand with the current SCSI core.

Correct, because the implementation of these two examples is not
dependent upon the registering of any LLD logic within scsi-core in
order to function in target mode.  We've always been able to avoid these
types of conflicts between scsi-core and target-core subsystems up until
now when initiator + target have been implemented as logically separate
drivers.

> Why would the SCSI core have to be modified in order to make the same possible
> for FCP ? Am I missing something ?

So it's nothing fabric specific to FCP of course, look at software +
Intel 82599 HW offload for example in tcm_fc(FCoE) where initiator and
target mode are logically separate drivers based upon common libfc
code..

But the underlying issue with the current implementation of HW FC HBAs
such as qla2xxx is that only a small subset of code is actually made
common (at least in the fabric I/O codepath sense) amongst HW FC LLDs
within libfc.  It's my understanding that since this type of code has
historically been very driver/vendor specific, trying to make this
(more) common for individual HW FC HBAs hasn't been interesting enough
for vendors to pursue benefit wise given the amount of re-factoring +
regressions involved to existing initiator-mode operation. 

That being the case, qla_target.c ends up depending upon alot of LLD
specific code (some of which is not initiator specific or made common in
libfc), so at least in the current implementation it really doesn't make
sense to try to push this logic back out into tcm_qla2xxx code..

> If SCSI initiator timeouts during initiator-to-target mode transitions are an
> issue, why not to abort pending SCSI commands before performing the transition ?
> 

That would probably work, but I think it's still just a band-aid on the
underlying issue of SCSI LLDs always kicking off initiator mode enable /
disable operations from within PCI *_probe_one() / *_remove_code() code.

--nab


