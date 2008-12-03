From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 2/7] Allow requeuement on DID_SOFT_ERROR
Date: Wed, 3 Dec 2008 13:17:36 +0100
Message-ID: <200812031317.37096.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de> <200811261846.51644.bs@q-leap.de> <1227725267.3387.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:37375 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYLCMRl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 07:17:41 -0500
In-Reply-To: <1227725267.3387.20.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday 26 November 2008 19:47:47 James Bottomley wrote:
> On Wed, 2008-11-26 at 18:46 +0100, Bernd Schubert wrote:
> > Activate the error handler if DID_SOFT_ERROR failed to often, but only
> > for commands which have a scmd->allowed > 1.
> > Also make a function out of a goto-block.
>
> What is the rationale for this?  It really doesn't look right since
> DID_SOFT_ERROR is supposed to be for temporary out of resource
> conditions in the HBA driver ... activating the error handler isn't
> really going to fix this because the eh is taking us through a state
> model for device conditions, which DID_SOFT_ERROR shouldn't be.

What do you suggest instead of? Just returning an I/O error without even to 
try to recover the device isn't nice.

>
> If you just need a DID_FAIL to activate the eh, it can be added without
> changing the meaning of DID_SOFT_ERROR.
>
> Also, you changed the return to make it device blocking (which also
> doesn't look right) but didn't document that in the change log.

Last year you suggested to switch from NEEDS_RETRY to ADD_TO_MLQUEUE

http://www.mail-archive.com/linux-scsi%40vger.kernel.org/msg12475.html

When I wrote the patch documentation, I already forgot about it, sorry. 
Unfortunately, it didn't help much for our devices. So I made it to activate 
the eh only, if it fails too often. With activated eh, devices sometimes can 
be recovered. But I'm certainly grateful for any hints to further improve 
recovery and to prevent i/o errors. 

Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
