Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EBECA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 18:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C13EB2086A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 18:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfJ2SAJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 14:00:09 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50886 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbfJ2SAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Oct 2019 14:00:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id CA4C2204238;
        Tue, 29 Oct 2019 19:00:04 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sbeakG39yp-q; Tue, 29 Oct 2019 19:00:02 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 645CE204163;
        Tue, 29 Oct 2019 19:00:01 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: Fix scsi_get/set_resid() interface
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191028105732.29913-1-damien.lemoal@wdc.com>
 <eb8f6e3e-0350-9688-58c8-9d777ba93298@acm.org>
 <BYAPR04MB5816FF25422E60C168F78308E7610@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4eb733b9-8f52-a6c2-eb56-f0759113dc1e@interlog.com>
Date:   Tue, 29 Oct 2019 13:59:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816FF25422E60C168F78308E7610@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-29 4:17 a.m., Damien Le Moal wrote:
> Bart,
> 
> On 2019/10/28 21:38, Bart Van Assche wrote:
>> On 10/28/19 3:57 AM, Damien Le Moal wrote:
>>> struct scsi_cmnd cmd->req.resid_len which is returned and set
>>> respectively by the helper functions scsi_get_resid() and
>>> scsi_set_resid() is an unsigned int. Reflect this fact in the interface
>>> of these helper functions.
>>> [ ... ]
>>> -static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
>>> +static inline void scsi_set_resid(struct scsi_cmnd *cmd, unsigned int resid)
>>>    {
>>>    	cmd->req.resid_len = resid;
>>>    }
>>>    
>>> -static inline int scsi_get_resid(struct scsi_cmnd *cmd)
>>> +static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
>>>    {
>>>    	return cmd->req.resid_len;
>>>    }
>>
>>   From the iSCSI RFC:
>>
>>      SCSI-Presented Data Transfer Length (SPDTL) is the term this document
>>      uses (see Section 1.1 for definition) to represent the aggregate data
>>      length that the target SCSI layer attempts to transfer using the
>>      local iSCSI layer for a task.  Expected Data Transfer Length (EDTL)
>>      is the iSCSI term that represents the length of data that the iSCSI
>>      layer expects to transfer for a task.  EDTL is specified in the SCSI
>>      Command PDU.
>>
>>      When SPDTL = EDTL for a task, the target iSCSI layer completes the
>>      task with no residuals.  Whenever SPDTL differs from EDTL for a task,
>>      that task is said to have a residual.
>>
>>      If SPDTL > EDTL for a task, iSCSI Overflow MUST be signaled in the
>>      SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST
>>      be set to the numerical value of (SPDTL - EDTL).
>>
>>      If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
>>      SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST
>>      be set to the numerical value of (EDTL - SPDTL).
>>
>>      Note that the Overflow and Underflow scenarios are independent of
>>      Data-In and Data-Out.  Either scenario is logically possible in
>>      either direction of data transfer.
>>
>> If the residual is changed from signed into unsigned, how is a SCSI LLD
>> expected to report the difference between residual overflow and residual
>> underflow to the SCSI core?



> As mentioned in the commit message, cmd->req.resid_len where the resid
> is stored is an unsigned int. And it has been an unsigned int forever as
> far as I know.

If my memory serves, I put it in over 20 years ago, about the same time
as the sg v2 interface (struct sg_io_hdr) was implemented. And when I
put it in it was a (signed) int and this is why:

struct ccb_accept_targ3 {
     .....
     CAM_I32 cam_resid;    /* Transfer residual length: 2's comp */
     .....
};

[from cam3r03.pdf]

So it coped with both underflow and the less likely case of overflow.

Notice in:
    struct sg_io_hdr {
       .....
       int resid;  /* [o] dxfer_len - actual_transferred */
       ...
};

At the time the SCSI mid-level and the block layer didn't bother about
resid, only some LLDs which is where the sg driver picked it up from.

So some ignoramus changed it to unsigned since then, probably before
git strangled the kernel source tree.

> So I think changing the interface to unsigned int makes sense in that
> context. Also, unless I am reading this wrong, the above definition you
> quote always lead to resid >= 0, so I do not see what problem you are
> worried about. Could you elaborate your concerns please ?

Linux's internal representation is wrong and should be fixed to match
its exposed interface (struct sg_io_hdr) which predates the breakage.

Doug Gilbert

