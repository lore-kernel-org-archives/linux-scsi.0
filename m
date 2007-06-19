From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aacraid: change srb status busy return
Date: Tue, 19 Jun 2007 12:40:45 -0500
Message-ID: <1182274845.3432.31.camel@mulgrave.il.steeleye.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22D5D@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48789 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758080AbXFSRks (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 13:40:48 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22D5D@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-06-19 at 11:41 -0400, Salyzyn, Mark wrote:
> This patch is more like a spelling correction than a fix. It was
> discovered that if we had a busy status return from the Adapter for the
> SCSI srb command to a physical component, that we returned
> DID_NO_CONNECT rather than what one would expect DID_BUS_BUSY.

Are you sure you want DID_BUS_BUSY?  I'm just asking because I'm not
sure of the firmware ramifications.  DID_BUS_BUSY will turn the command
around for an immediate retry.  If there's a firmware resource issue,
you should return something like DID_REQUEUE which will throttle the
queue and reissue this command when another one returns (I'm afraid it
throttles the device queue, not the host queue, which may not be what
you want but we can add another DID_HOST_REQUEUE or something).

James


