From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH]SCSI signal(I/O) failure causes no response
Date: 14 Apr 2004 10:28:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081956506.10872.41.camel@mulgrave>
References: <200404140107.AA03169@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:9874 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264265AbUDNP2e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Apr 2004 11:28:34 -0400
In-Reply-To: <200404140107.AA03169@fukuchi.jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric Dean Moore <Emoore@lsil.com>

On Tue, 2004-04-13 at 20:07, Masao Fukuchi wrote:
> 1.Fusion MPT driver issues read command to its firmware.
>   (our server has LSI53C1030 as SCSI adapter)
>   Then the firmware returns protocol error for the command.
>   Fusion MPT driver makes DID_RESET status by protocol error 
>   and sends it to SCSI midlayer.
> 
> 2.SCSI midlayer analyzes the status from LLD.
>   SCSI midlayer schedules command retry because the status is just
>   DID_RESET status.
>   (When the status has DID_RESET plus some sense code, the retry
>    sequence depends on the sense code. But when the status has only
>    DID_RESET, SCSI midlayer schedules command retry)
> 
> Sequence 1. and 2. are repeated infinitely and it causes no response.
> 
> To prevent this problem, I proposed Eric Moore to change the DID_RESET
> status to DID_SOFT_ERROR in fusion MPT driver.
> But he suggested me to change SCSI midlayer to prevent infinite loop.

Well, there clearly is a problem, because we can't retry no-rety
commands that return DID_RESET (like tape commands or fastfail).

However, DID_RESET is supposed to be returned for events where it was
determined that the command was lost because the bus or device was reset
(either as part of error handling or because an external entity issued
the reset).  Since these events, if they originate externally, can be
beyond the control of the device, making retryable commands subject to
the retry limit would be asking for unnecessary I/O errors because of
something we couldn't do anything about.

Why is the LSI driver returning DID_RESET for the problem (i.e. is it
some type of external bus reset, or is something else going on)?

James


