From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/7] Allow requeuement on DID_SOFT_ERROR
Date: Wed, 26 Nov 2008 12:47:47 -0600
Message-ID: <1227725267.3387.20.camel@localhost.localdomain>
References: <200811261840.45360.bs@q-leap.de>
	 <200811261846.51644.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44043 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbYKZSrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 13:47:49 -0500
In-Reply-To: <200811261846.51644.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-11-26 at 18:46 +0100, Bernd Schubert wrote:
> Activate the error handler if DID_SOFT_ERROR failed to often, but only 
> for commands which have a scmd->allowed > 1. 
> Also make a function out of a goto-block.

What is the rationale for this?  It really doesn't look right since
DID_SOFT_ERROR is supposed to be for temporary out of resource
conditions in the HBA driver ... activating the error handler isn't
really going to fix this because the eh is taking us through a state
model for device conditions, which DID_SOFT_ERROR shouldn't be.

If you just need a DID_FAIL to activate the eh, it can be added without
changing the meaning of DID_SOFT_ERROR.

Also, you changed the return to make it device blocking (which also
doesn't look right) but didn't document that in the change log.

James


