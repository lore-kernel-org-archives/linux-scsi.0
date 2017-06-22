From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH] lpfc: Fix nvme io stoppage after link bounce
Date: Thu, 22 Jun 2017 08:52:14 -0700
Message-ID: <7f10cbae-a88e-f5a8-d54d-a22a543438e0@gmail.com>
References: <20170621173758.28058-1-jsmart2021@gmail.com>
 <20170622074142.GB5670@linux-x5ow.site>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35229 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdFVPwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2017 11:52:19 -0400
Received: by mail-wr0-f194.google.com with SMTP id z45so5652533wrb.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 08:52:19 -0700 (PDT)
In-Reply-To: <20170622074142.GB5670@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>

On 6/22/2017 12:41 AM, Johannes Thumshirn wrote:
> On Wed, Jun 21, 2017 at 10:37:58AM -0700, James Smart wrote:
> [...]
>> -	/*
>> -	 * Catch race where our node has transitioned, but the
>> -	 * transport is still transitioning.
>> -	 */
> 
> 
> The patch looks fine but can you please explain why the above race can't
> happen anymore?
> 
> Thanks,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 

well, the primary reason is the code that was removed was bogus to begin 
with. Abort of an io/exchange, if its active, needs to occur on the link 
regardless of the ndlp state. This it simply needed to occur. As not 
checks on ndlp state are needed, there is no race.

-- james
