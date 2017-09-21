From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: ibmvfc oddities
Date: Thu, 21 Sep 2017 10:13:32 -0500
Message-ID: <4b11b1f6-cc46-5f40-2810-02f8ae9792cb@linux.vnet.ibm.com>
References: <a0969601-e06a-7b90-36f0-357c54bfbfe7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751686AbdIUPNi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Sep 2017 11:13:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8LFBe7W111472
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 11:13:37 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2d4euy3kwv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 11:13:37 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Thu, 21 Sep 2017 09:13:36 -0600
In-Reply-To: <a0969601-e06a-7b90-36f0-357c54bfbfe7@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/21/2017 05:02 AM, Hannes Reinecke wrote:
> Hi Brian,
> 
> I was looking at the ibmvfc code (trying to hook up libfc), and have
> found this definition:
> 
> struct ibmvfc_fcp_rsp_info {
> 	__be16 reserved;
> 	u8 rsp_code;
> 	u8 reserved2[4];
> }__attribute__((packed, aligned (2)));
> 
> in comparison, libfc has this:
> 
> struct fcp_resp_rsp_info {
>     __u8      _fr_resvd[3];       /* reserved */
>     __u8      rsp_code;           /* Response Info Code */
>     __u8      _fr_resvd2[4];      /* reserved */
> };
> 
> So both look _nearly_ identical, except the missing byte at the start.
> It might be inserted due to some compile alignment magic, but I'd rather
> not rely on this.
> Could you clarify if the two structures really are different, or if this
> is a simple oversight?

Looks like a bug to me. We should probably just have ibmvfc use the
libfc definition.

Tyrel - can you do this conversion and run a bit of regression testing?
Looking at the possible values of rsp_code, the most likely place where
this might cause us some issues is in TMF handling. I'm a little
worried this could result in a potential double completion in error
handling in some rare cases.... Tyrel - are you aware of any issues
like that, which this might explain?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
