Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12FCCA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 18:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE77D2084C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 18:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfJUScv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 14:32:51 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42457 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729270AbfJUScv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 14:32:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DF7BE2041C0;
        Mon, 21 Oct 2019 20:32:48 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fD7W-nU8zsB6; Mon, 21 Oct 2019 20:32:43 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 0FC7320414F;
        Mon, 21 Oct 2019 20:32:41 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH RFC 00/24] scsi: Revamp result values
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <8e07f2ba-cdef-6faa-559d-3beabc173edf@interlog.com>
Date:   Mon, 21 Oct 2019 14:32:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021095322.137969-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-21 5:52 a.m., Hannes Reinecke wrote:
> Hi all,
> 
> the 'result' field in the SCSI command is defined as having
> 4 fields. The top byte is declared as a 'driver_byte', where the
> driver can signal some internal status back to the midlayer.
> However, there is quite a bit of overlap between the driver_byte
> and the host_byte, resulting in the driver_byte being used in
> very few places, and mostly in legacy drivers.
> Additionally, we have _two_ sets of definitions for the
> last byte (status byte), which can specified either in SAM terms
> or in the linux-specific terms, which are shifted right by one
> from the SAM ones.
> Needless to say, the linux-specific ones are declared obsolete
> for years now.
> And to make the confusion complete, both the status byte and
> the driver byte have a byte for a valid sense code, resulting
> in quite some confusion which of those bits to check.
> 
> This patchset does several things:
> - remove the linux-specific status byte definitions, and use
>    the SAM values throughout
> - replace the driver-byte values with either SAM ones (for sense
>    code checking) or host-byte definitions
> - remove the driver-byte definitions

This is a brave change proposal. The masked_status has been tricked
up so it won't break user code. However the driver byte is exposed
by the sg v2, v3 and v4 interfaces which means via bsg device nodes,
sg devices nodes and many other block storage device nodes (e.g.
/dev/sdc and /dev/st1) via:
       ioctl(<storage_dev>, SG_IO, ptr_to_v3_interface) .

So if there is any user space code out there that checks the
driver byte (e.g. 'sg_io_hdr::driver_status & DRIVER_SENSE') do we
have a problem?

If so, we could hack the DRIVER_SENSE case *** by putting it back
for the user space to see when the driver (e.g. sg) knows there
is sense data. What about the other values?

> As usual, comments and reviews are welcome.

It is hard to make an omelette without breaking some eggs.

Doug Gilbert

> Please note, commit 66cf50e65b18 ("scsi: qla2xxx: fixup incorrect
> usage of host_byte") from 5.4/scsi-fixes is a prerequisite for
> this patch series.

<snip>

*** Here is a snippet from sg3_utils library code:

     if ((SAM_STAT_CHECK_CONDITION == scsi_status) ||
         (SAM_STAT_COMMAND_TERMINATED == scsi_status) ||
         (SG_LIB_DRIVER_SENSE == masked_driver_status))
         return sg_err_category_sense(sense_buffer, sb_len);

Due to the logical OR, as long as SAM_STAT_CHECK_CONDITION is set
whenever there is sense, then we don't care about DRIVER_SENSE.

I believe this code comes from the days before auto-sense when say a
READ(6) would fail, send back a CHECK_CONDITION and the host would then
need to issue a REQUEST SENSE command to get the sense data. However
REQUEST SENSE could itself yield a CHECK_CONDITION. Hence DRIVER_SENSE
set, SAM_STAT_CHECK_CONDITION clear could be interpreted as the
initial command failing and the follow-up REQUEST SENSE succeeded; if
they are both set, then both commands failed (e.g. the disk has gone
away).
