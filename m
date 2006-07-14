From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Fri, 14 Jul 2006 18:25:05 -0500
Message-ID: <1152919505.17780.44.camel@mulgrave.il.steeleye.com>
References: <20060712170507.GA10308@lsil.com>  <44B5B0F8.8080806@torque.net>
	 <1152811359.25660.63.camel@bluto.andrew>
	 <1152918120.20147.25.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22973 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1945905AbWGNXZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jul 2006 19:25:37 -0400
In-Reply-To: <1152918120.20147.25.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: dougg@torque.net, Eric Moore <eric.moore@lsil.com>, linux-scsi@vger.kernel.org, elliott@hp.com

On Fri, 2006-07-14 at 17:02 -0600, Andrew Patterson wrote:
> As discussed long ago, we could also add a field in the SSP frame
> header
> to confirm that an HBA supports TLR; if not set, then the drive would
> know not to attempt TLR.  Right now, the target sets a RETRY DATA
> FRAMES
> bit in the frame header for XFER_RDY frames to let the initiator know
> that retrying DATA frames is allowed - this way it doesn't have to
> remember the mode page setting for that target.  The initiator could
> set
> a similar bit in COMMAND and TASK frames to let the target know that
> it
> is safe to retry frames for the whole command.  Is LSI able to set
> such
> a bit in their COMMAND frames today?"
> [[This might work as existing hardware that didn't implement TLR would
> just ignore the contents of the field, and if both drive and HBA
> implemented it as a temporary "extension" to SAS 1.1, a vendor
> specific
> command would not be needed.]]

This looks fine to me ... I think it's fairly simple to implement in the
aic94xx just by changing the driver ... there needs to be an additional
abstraction because the driver controls the ssp frame header but the
transport wants to control the TLR flag ... however, that can be done
simply by extending the task flags.

I have no idea about the fusion ... the frame control is embedded deeply
in the firmware, so I think it would probably require a firmware
upgrade.  Eric can comment on this better than I.

James


