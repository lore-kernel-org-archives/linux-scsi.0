From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Tue, 24 Jul 2007 22:14:43 -0400
Message-ID: <1185329683.3488.46.camel@localhost.localdomain>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57529 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758136AbXGYCOp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 22:14:45 -0400
In-Reply-To: <20070725010525.614621080E4@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org, freelsjd@ornl.gov
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2007-07-24 at 18:05 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=12126&action=view)
> failed driver dmesg
> 
> This driver fails at time of boot up.  there are many scsi errors shown in the
> output.  It is the "new" aic7xxx driver.

This is about the most significant line

> (scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x84) SCSIRATE(0x80)

The SCSIRATE indicates wide.  I'd bet this is a narrow device; in which case, does 

echo 0 > /sys/class/spi_transport/target0:0:3/max_wide

and then triggering a revalidate with

echo 1 > /sys/class/spi_transport/target0:0:3/revalidate

produce anything different?

James


