From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 08/18] bnx2fc: Handle NETDEV_UNREGISTER for vlan
 devices
Date: Wed, 24 Aug 2011 13:40:55 -0700
Message-ID: <4E5561D7.7010003@broadcom.com>
References: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
 <1312483633-479-9-git-send-email-bprakash@broadcom.com>
 <1313711526.9128.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=windows-1252;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3440 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1HXUlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 16:41:02 -0400
In-Reply-To: <1313711526.9128.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>

On 8/18/2011 4:52 PM, Bhanu Gollapudi wrote:
> On Thu, 2011-08-04 at 11:47 -0700, Bhanu Prakash Gollapudi wrote:
>> Since the driver holds the reference for vlan netdev, the reference has to be
>> released by the driver when the vlan device is removed. Driver handles this in
>> NETDEV_UNREGISTER event.
>>
>> Signed-off-by: Bhanu Prakash Gollapudi<bprakash@broadcom.com>
>
> As per Mike Christie's comments, we need not call __bnx2fc_destroy()
> with schedule parameter, because we are already in the right context
> with indicate_netevent being called with rtnl_lock().
>
> Re-spinning this patch alone with 'schedule' parameter removed from
> __bnx2fc_destroy().


James, I realize that the modified patch has not been picked up by you. 
I will submit a follow-on patch with specific changes shortly.

Thanks.

>
> ------------------------
>
> Since the driver holds the reference for vlan netdev, the reference has to be
> released by the driver when the vlan device is removed. Driver handles this in
> NETDEV_UNREGISTER event.
>
> Signed-off-by: Bhanu Prakash Gollapudi<bprakash@broadcom.com>
> ---
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   87 ++++++++++++++++++++++---------------
>   1 files changed, 52 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 673c97c..9a7077b 100644

