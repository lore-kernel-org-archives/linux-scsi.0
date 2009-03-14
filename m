From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] sd: Try READ CAPACITY 16 first for SBC-2 devices
Date: Sat, 14 Mar 2009 15:41:31 -0500
Message-ID: <1237063291.3907.64.camel@localhost.localdomain>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
	 <1236882030-27964-3-git-send-email-willy@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55696 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbZCNUlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 16:41:35 -0400
In-Reply-To: <1236882030-27964-3-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Thu, 2009-03-12 at 14:20 -0400, Matthew Wilcox wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> 
> New features are being added to the READ CAPACITY 16 results, so we
> want to issue it in preference to READ CAPACITY 10.  Unfortunately, some
> devices misbehave when they see a READ CAPACITY 16, so we restrict this
> command to devices which claim conformance to SPC-3 (aka SBC-2), or claim
> they have features which are only reported in the READ CAPACITY 16 data.
> 
> The READ CAPACITY 16 command is optional, even for SBC-2 devices, so
> we fall back to READ CAPACITY 10 if READ CAPACITY 16 fails.

We're going to have to do something about the scary error messages on
SBC-2 supporting drives, this is what mine say (and this is after mkp's
chat reduction):

sd 1:0:1:0: [sdc] READ CAPACITY(16) failed
sd 1:0:1:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 1:0:1:0: [sdc] Sense Key : Illegal Request [current] 
sd 1:0:1:0: [sdc] Add. Sense: Invalid command operation code
sd 1:0:1:0: [sdc] 71096640 512-byte hardware sectors: (36.4 GB/33.9 GiB)
sd 1:0:1:0: [sdc] Write Protect is off
sd 1:0:1:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:1:0: [sdc] READ CAPACITY(16) failed
sd 1:0:1:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 1:0:1:0: [sdc] Sense Key : Illegal Request [current] 
sd 1:0:1:0: [sdc] Add. Sense: Invalid command operation code
 sdc: sdc1 sdc2 sdc3
sd 1:0:1:0: [sdc] Attached SCSI disk

What they're saying is that they don't support READ CAPACITY(16) which
is perfectly legal for SBC-2 conforming devices which don't support
protection information ... like almost every modern disk in the field.

James


