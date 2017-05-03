From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [scsi-qedf] question about parameter ordering
Date: Wed, 03 May 2017 13:34:49 -0500
Message-ID: <20170503133449.Horde.-WcP75Z1VExB_dKSscExwX4@gator4166.hostgator.com>
References: <20170503125818.Horde.8rEDF6U_fTKRV29evjbXFMa@gator4166.hostgator.com>
 <alpine.OSX.2.00.1705031427250.1568@administrators-MacBook-Pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.46.234]:40565 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753376AbdECSew (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 14:34:52 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id F347255BF3
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2017 13:34:49 -0500 (CDT)
In-Reply-To: <alpine.OSX.2.00.1705031427250.1568@administrators-MacBook-Pro.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>

Hi Chad,

Quoting Chad Dupuis <chad.dupuis@cavium.com>:

> On Wed, 3 May 2017, 1:58pm, Gustavo A. R. Silva wrote:
>
>>
>> Hello everybody,
>>
>> While looking into Coverity ID 1402011 I ran into the following  
>> piece of code
>> at drivers/scsi/qedf/qedf_io.c:2057:
>>
>> /* Fill FC header */
>> fc_hdr = &(tm_req->req_fc_hdr);
>> sid = fcport->sid;
>> did = fcport->rdata->ids.port_id;
>> __fc_fill_fc_hdr(fc_hdr, FC_RCTL_DD_UNSOL_CMD, sid, did,
>>                   FC_TYPE_FCP, FC_FC_FIRST_SEQ | FC_FC_END_SEQ |
>>                   FC_FC_SEQ_INIT, 0);
>>
>> The issue here is that the position of arguments in the call to
>> __fc_fill_fc_hdr() function do not match the ordering of the parameters:
>>
>> _sid_ is passed to _did_
>> _did_ is passed to _sid_
>>
>> this is the function prototype:
>>
>> static inline void __fc_fill_fc_hdr(struct fc_frame_header *fh,
>>                                    enum fc_rctl r_ctl,
>>                                    u32 did, u32 sid, enum fc_fh_type type,
>>                                    u32 f_ctl, u32 parm_offset)
>>
>> My question here is if this is intentionala?
>
> This may have been but this code has been superseded by commit
> be086e7c53f1fac51eed14523b28f2214b548dd2.B
>>

Oh OK, great.

>> In case it is not, I will send a patch to fix it. But first it  
>> would be great
>> to hear any comment about it.
>>
>> By the way... the same is happening at drivers/scsi/qedf/qedf_els.c:109
>
> May be a bug here so you could send a patch.
>

I'll send a patch for this shortly.

Thanks for your comments.
--
Gustavo A. R. Silva
