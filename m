From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH][SCSI] megaraid_sas: Fix synchronization problem between
 sysPD IO path and AEN path
Date: Thu, 17 Oct 2013 09:45:07 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF418B04DBEE2@inbmail01.lsi.com>
References: <201310161134.r9GBYYqK021397@cosmhbs0.lsi.com>
 <1381959886.1864.25.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.199.154.188] ([213.199.154.188]:50375 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab3JQEQ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Oct 2013 00:16:29 -0400
In-Reply-To: <1381959886.1864.25.camel@dabdike>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "aradford@gmail.com" <aradford@gmail.com>



>-----Original Message-----
>From: James Bottomley [mailto:jbottomley@parallels.com]
>Sent: Thursday, October 17, 2013 3:15 AM
>To: Saxena, Sumit
>Cc: linux-scsi@vger.kernel.org; Desai, Kashyap; aradford@gmail.com
>Subject: Re: [PATCH][SCSI] megaraid_sas: Fix synchronization problem
>between sysPD IO path and AEN path
>
>On Wed, 2013-10-16 at 17:04 +0530, Sumit.Saxena@lsi.com wrote:
>> There is syncronization problem between sysPD IO path and AEN path.
>> Driver maintains instance->pd_list[] array, which will get updated(by
>> calling function megasas_get_pd_list[]), whenever any of below events
>> occurs-
>>
>> MR_EVT_PD_INSERTED
>> MR_EVT_PD_REMOVED
>> MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED
>> MR_EVT_FOREIGN_CFG_IMPORTED
>>
>> At same time running sysPD IO will be accessing the same array
>> instance->pd_list[], which is getting updated in AEN path, because of
>this IO may not get correct PD info from instance->pd_list[] array.
>>
>> Signed-off-by: Adam Radford <adam.radford@lsi.com>
>> Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
>
>Explain the signoff chain: is this a joinly authored patch?

Yes, it's jointly authored patch. Originally, this patch is authored by Adam Radford, and then modified by me(Sumit Saxena).

>
>James
>


