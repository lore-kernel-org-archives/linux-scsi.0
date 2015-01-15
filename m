From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Wed, 14 Jan 2015 16:52:44 -0800
Message-ID: <1421283164.24701.53.camel@haakon3.risingtidesystems.com>
References: <54B63F74.2040702@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50211 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbAOAwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 19:52:45 -0500
In-Reply-To: <54B63F74.2040702@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Wed, 2015-01-14 at 11:05 +0100, Bart Van Assche wrote:
> The LIO and SCST SCSI target subsystems consist of the following components:
> * A core that processes SCSI commands and that provides common
> functionality like persistent reservations, LUN masking and an interface
> that allows configuration from user space.
> * Device handlers that allow this core to access SCSI devices, block
> devices and files uniformly as SCSI devices.
> * Target drivers that implement a storage protocol (iSCSI, FC, SRP,
> iSER, FCoE, ...) and that realize the SCSI request and response
> communication between the target system and an initiator system.
> 
> A significant amount of code is shared between several LIO target
> drivers and the SCST target drivers that implement the same storage
> protocol. Since there are two sets of these drivers this means that each
> set has to be maintained, extended and tested separately. This means a
> lot of redundant work. The main difference between these two sets of
> drivers is the interface between the target drivers and the SCSI target
> core.  Hence the proposal to discuss the unification of the API between
> SCSI target core and SCSI target drivers. Implementing a single unified
> API would have the following advantages:
> * A single set of target drivers works for both projects which means a
> reduction of the maintenance effort for those who maintain target
> drivers for target driver developers and target driver users.
> * This would increase the size of the user base for the unified target
> drivers.
> * This would reduce the workload for the storage target maintainers.
> * This would motivate the SCST target driver maintainers to contribute
> to the upstream target drivers and to bring the upstream SRP and FCoE
> target drivers to the same feature and stability level as their SCST
> counterparts. In other words, the LIO users would also benefit from this
> work.
> * This effort would also help SCST users by ensuring that all latest
> target driver features are also available to SCST users. Some time ago
> (but no longer today) the LIO QLogic target driver was ahead of the SCST
> QLogic target driver. This motivated an SCST user to port the LIO QLogic
> target driver to SCST. See also Greg Wettstein, New release of
> SCST/Qlogic target interface driver, linux-scsi, April 2014,
> http://marc.info/?l=linux-scsi&m=139649571807085).
> 
> During the first phase of this initiative the focus will be on the
> QLogic FC, SRP and FCoE target drivers since a significant part of the
> code of these drivers is shared between the two target frameworks.
> 

As always, I'm open to discussion, but if the main selling point for
unification is a bag of out-of-tree drivers that LIO already has vendor
and enterprise distro support for in upstream code, the net result will
not be to bring in more developers, vendors, and users to contribute to
a single target-core subsystem.

Contributing to a single target-core is after all, my main interest as
target subsystem maintainer.

If anything, this proposal gives certain vendors continued incentive to
avoid supporting and improving upstream target-core.

--nab

