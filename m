From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with
 DID_RESET status for log_info value 0x0x32010081
Date: Tue, 9 Dec 2014 17:38:32 +0530
Message-ID: <CAK=zhgr-+MaT6UeXR96G-nMGfo8RdmHVRN1wkUKjz7h6gwLNhg@mail.gmail.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1a934i055.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:60833 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbaLIMIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2014 07:08:34 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so623064wgh.23
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2014 04:08:32 -0800 (PST)
In-Reply-To: <yq1a934i055.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 8:36 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth> For any SCSI command, if the driver receives IOC status =
> Sreekanth> SCSI_IOC_TERMINATED and log info = 0x32010081 then that
> Sreekanth> command will be completed with DID_RESET host status.
>
> What does that log info value mean?

The meaning of this log info value is "Virtual IO has failed and has
to be retried".

Firmware will provide this log info value with IOC Status
"SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume)
is pulled and pushed back with some minimal delay.  With this log info
value, firmware informs the driver to retry the failed IO command
infinite times, so to provide some time for the firmware to discover
the reinserted drive successfully instated of just retrying failed
command for five times( doesn't giving enough time for firmware to
complete the drive discovery) and failing the IO permanently even
though drive came back successfully.

Regards,
Sreekanth.
