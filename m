From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes + tcm_qla2xxx
 fabric module
Date: Sun, 13 May 2012 15:55:34 +0000
Message-ID: <4FAFD976.8090409@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:51210 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2EMP4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2012 11:56:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On Sunday December 18, 2011 Nicholas Bellinger wrote:
> So to get the ball rolling on remaining items, one question is still how to
> resolve mixed target/initiator mode operation on a HW per port context basis..?
> 
> This is currently done with a qla2xxx module parameter, but to do mixed mode
> properly we will need something smarter between scsi-core and target-core ports.
> Note we currently set qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED, so by default
> patch #1 will effectively disable initiator mode by skipping scsi_scan_host()
> from being called in to avoid scsi-core timeouts when performing immediate
> transition from initiator mode -> target mode via ISP reset.
> 
> What we would like to eventually do is run qla2xxx LLD to allow both initiator
> and target mode access based on the physical HW port.  We tried some simple
> qla_target.c changes this make this work, but to really do it properly
> and address current qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED usage it will
> need to involve scsi-core so that individual HW port can be configured and
> dynamically changed across different access modes.

(sorry for the late reply)

Dynamically switching between initiator mode, target mode or even using both
modes simultaneously is already possible for iSCSI over Ethernet and for SRP
over InfiniBand with the current SCSI core. Why would the SCSI core have to be
modified in order to make the same possible for FCP ? Am I missing something ?
If SCSI initiator timeouts during initiator-to-target mode transitions are an
issue, why not to abort pending SCSI commands before performing the transition ?

Bart.
