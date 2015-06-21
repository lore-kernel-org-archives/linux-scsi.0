From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: configurable discard parameters
Date: Sat, 20 Jun 2015 20:20:54 -0400
Message-ID: <yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38324 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbFUAU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2015 20:20:58 -0400
In-Reply-To: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	(Tom Yan's message of "Sun, 21 Jun 2015 01:12:10 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> Today I check if blkdiscard really does a full device trim/wipe for
Tom> my Intel 530 SSD (240gb) with hexdump. I end up found that it fail
Tom> to do so because it report garbage info on its block limits VPD.

It is a SATA-attached drive, it has no block limits VPD. What you are
seeing is information prepared by libata's SATL.

Tom> The fact is, in each iteration, for this drive, blkdiscard can only
Tom> trim a maximum of 65528 sectors, which is the largest multiple of 8
Tom> sectors, which is the minimum possible.

  Maximum write same length: 0x3fffc0 blocks

That's 2GB-e per request for a drive with 512-byte logical blocks.

Tom> but still I would like to know why the kernel doesn't allow
Tom> "discard_granularity" and "discard_max_bytes" to be configurable
Tom> for users.

Because if the vendor got these trivial values wrong there is little to
no chance that they implemented discard correctly in their firmware.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
