From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: scsi: fix target reset handling
Date: Fri, 29 Feb 2008 18:27:46 -0600
Message-ID: <47C8A302.3010500@cs.wisc.edu>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45662 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYCAA2T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 19:28:19 -0500
In-Reply-To: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

Oh yeah, the patches were made over scsi-rc-fixes, but can be applied 
over scsi-misc or 2.6.25-rc3.

michaelc@cs.wisc.edu wrote:
> This patchset fixes the problem where scsi-ml will call the device reset
> handler for each logical unit, but some drivers are sending a target
> reset. Because we do not need to send a target reset multiple times,
> this patchset creates a new target reset callout which of course is
> called once per target instead of once per lu. It also cleans up
> the all the commands sent to the target when SUCCESS is returned.
> 
> qla4xxx, qla2xxx and lpfc were test with a hacked up sg_reset. I also
> sent lots of commands to the target and decreased the cmd timeout to
> 1 second so the scsi would run (turned off the eh abort callout too).
> 
> The arm scsi, mpt fusion, sym53c8xx_2, and a100u2w, and qla1280
> drivers were only compile tested, but looked like the only needed
> a rename of the scsi eh handler.
> 
> The zfcp driver is also only compile tested. It was doing a lun
> reset and possibly target reset, so I split that up to use
> the device and target reset handlers. scsi-ml will escalate from
> the device to the target reset for the driver.
> 
