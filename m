From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 0/2] : definion, code, and use of new SCSI ML
	hoststatus DID_COND_REQUEUE
Date: Fri, 02 Feb 2007 18:40:00 -0600
Message-ID: <1170463200.3380.49.camel@mulgrave.il.steeleye.com>
References: <0F08E10B769EAF4EA2C43A573B8CC87F8BD30D@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37822 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946159AbXBCAkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 19:40:09 -0500
In-Reply-To: <0F08E10B769EAF4EA2C43A573B8CC87F8BD30D@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <Yanling.Qi@lsi.com>
Cc: Edward Goggin <egoggin@vmware.com>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Fri, 2007-02-02 at 17:31 -0700, Qi, Yanling wrote:
>  [Qi, Yanling] The following code in the scsi_lib.c will be enough for
> RDAC/MPP. BTW, why do we do "wait_for = (cmd->allowed + 1) *
> cmd->timeout_per_command". With a sd request, the wait_for will be 180
> seconds. (SD_MAX_RETRIES=5 and SD_TIMEOUT=30 * HZ).

Because that's the maximum guarantee.  If the command repeatedly timed
out, we'd retry it cmd->allowed times, so the max timeout is 

cmd->timeout_per_command*cmd->allowed

Shorter timeout periods can be set via sysfs.

James


