From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [Suspected Spam:#] Re: [PATCH] qla2xxx: Fix to allow to reset devices using sg interface (sg_reset)
Date: Thu, 27 Jul 2006 15:53:10 -0700
Message-ID: <20060727225310.GU2338@jdlab1.qlogic.org>
References: <44C61AE4.2010600@vlnb.net> <44C8F615.4060902@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:13206 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751408AbWG0WxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jul 2006 18:53:12 -0400
Content-Disposition: inline
In-Reply-To: <44C8F615.4060902@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Thu, 27 Jul 2006, Vladislav Bolkhovitin wrote:

> Also I've found that without this patch qla2xxx_eh_device_reset() 
> refuses to reset the device during normal error recovery carrying out by 
> SCSI mid-layer as well. I didn't do deeper investigations though, with 
> this patch the error recovery works as expected.

The only way I see this happening is if the command completed after
the abort handler FAILED and before the device reset handler executed.
Possibly.

During normal EH routines the driver still hold a reference to the
command, so the sp should be valid.

In any case, those codes (referencing SP) are residual left-overs from
our 'standard' non-upstream driver, and should be clensed.

Thanks again,
Andrew Vasquez
