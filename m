From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v5 1/3] cxlflash: Base error recovery support
Date: Thu, 13 Aug 2015 20:10:00 +1000
Message-ID: <1439460600.21643.48.camel@neuling.org>
References: <1439423466-15609-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:53611 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbbHMKKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 06:10:03 -0400
In-Reply-To: <1439423466-15609-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Wed, 2015-08-12 at 18:51 -0500, Matthew R. Ochs wrote:
> Introduce support for enhanced I/O error handling.
> 
> A device state is added to track 3 possible states of the device:
> 
> Normal - the device is operating normally and is fully operational
> 
> Limbo - the device is in a reset/recovery scenario and its operational
>         status is paused
> 
> Failed/terminating - the device has either failed to be reset/recovered
>                      or is being terminated (removed); it is no longer
>                      operational
> 
> All operations are allowed when the device is operating normally. When the
> device transitions to limbo state, I/O must be paused. To help accomplish
> this, a wait queue is introduced where existing and new threads can wait
> until the device is no longer in limbo. When coming out of limbo, threads
> need to check the state and error out gracefully when encountering the
> failed state. When the device transitions to the failed/terminating state,
> normal operations are no longer allowed. Only specially designated
> operations related to graceful cleanup are permitted.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Daniel Axtens <dja@axtens.net>

Thanks for integrating my suggestions.

Reviewed-by: Michael Neuling <mikey@neuling.org>

> ---
>  drivers/scsi/cxlflash/Kconfig  |   2 +-
>  drivers/scsi/cxlflash/common.h |  12 ++-
>  drivers/scsi/cxlflash/main.c   | 174 ++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/cxlflash/main.h   |   6 +-
>  4 files changed, 177 insertions(+), 17 deletions(-)

