From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 1/1] Remove LUNs that no longer exist when we scan a
 target with REPORT LUNS.
Date: Mon, 16 Aug 2010 06:59:53 -0700
Message-ID: <AANLkTi=mSgyGAK2NDnE-6bF5wG_FkX8mc6BsYwM5QpYt@mail.gmail.com>
References: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com>
	<1281917313-1855-2-git-send-email-realrichardsharpe@gmail.com>
	<201008160945.01369.konrad@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59523 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0HPN7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2010 09:59:54 -0400
Received: by gxk23 with SMTP id 23so1888956gxk.19
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2010 06:59:53 -0700 (PDT)
In-Reply-To: <201008160945.01369.konrad@darnok.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2010 at 6:45 AM, Konrad Rzeszutek Wilk
<konrad@darnok.org> wrote:
> On Sunday 15 August 2010 20:08:33 realrichardsharpe@gmail.com wrote:
>> From: Richard Sharpe <realrichardsharpe@gmail.com>
>>
>> If the target returns logical_unit_not_supported when we send REPORT LUNS
>> it means that it supports REPORT LUNS but there really are no LUNs there.
>> Delete LUN 0 in that case.
>>
>> Also, when parsing the LUNs reported, remove any LUNs that used to exist
>> in the gaps, and remove LUNs beyond the end of those reported. They no
>> longer exist.
>>
>> Also don't scan a target where the ID is too large or the channel is
>> too large.
>>
>> Tested by adding four LUNs with scst_local and then deleting them in
>> various combinations, including deleting from LUN 0, deleting from last
>> LUN and deleting in the middle out.
>
> What happens if you stack the device? Say you got multipath on top of this or
> device-mapper? Does this work properly ? For multipath I would expect it to
> work OK, and multipath device would queue the I/O until a LUN with the same
> SCSI_ID would reappear.

I do not know :-)

Let me test this situation to find out.

-- 
Regards,
Richard Sharpe
