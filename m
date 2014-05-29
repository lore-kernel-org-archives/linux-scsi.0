From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 6/6] [SCSI] sd: Implement copy offload support
Date: Thu, 29 May 2014 10:48:18 -0400
Message-ID: <538748B2.2020508@interlog.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com> <1401335565-29865-7-git-send-email-martin.petersen@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37162 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbaE2OsZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2014 10:48:25 -0400
In-Reply-To: <1401335565-29865-7-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 14-05-28 11:52 PM, Martin K. Petersen wrote:
> Implement support for hardware copy offload. This initial implementation
> only supports EXTENDED COPY(LID1). If need be we can add support for
> LID4 or token copy at a later date.
>
> If a device has the 3PC flag set in the standard INQUIRY response we'll
> issue a RECEIVE COPY OPERATION PARAMETERS command. We require the device
> to support two copy source/copy destination descriptors and one block to
> block (0x02) segment descriptor. The device must support the NAA
> identification descriptor (0xE4). If the device is capable we'll set the
> queue limits to indicate that the device supports copy offload.

SPC-4 has downgraded the RECEIVE COPY OPERATION PARAMETERS command
in favour of the new Third Party Copy (TPC) VPD page [0x8f]. If the
latter is present, it should be used. Most real world implementations
of XCOPY(LID1) comply (loosely) with SPC-2 and SPC-3 since VMWare's
VAAI is the effective "standard".

Further I noticed some ODX ** implementations which do use that TPC
VPD page, do not implement its (SPC-4 defined) mandatory descriptors
(0x1 and 0x8001) needed to support XCOPY(LID1). Perhaps there may be
some convergence after SPC-4 becomes a standard.

In any case, this patch set looks good.

May I also point out the NAB's target subsystem has a block to
block XCOPY(LID1) implementation. So it can be used to test
this patch set. The standards require copies between LUs in
the same target to be supported (if xcopy is supported),
otherwise support is optional (i.e. between LUs in different
targets). Hence most implementations restrict the LUs to being
in the same target.

Doug Gilbert


** ODX is MS's name for the subset of XCOPY(LID4) defined in
    SBC-3 using the POPULATE TOKEN and WRITE USING TOKEN
    commands. So this is a "token copy" referred to above.
