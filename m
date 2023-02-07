Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E2AC636CD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 15:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjBGPsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Feb 2023 10:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjBGPsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2023 10:48:14 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Feb 2023 07:48:12 PST
Received: from mailout.easymail.ca (mailout.easymail.ca [64.68.200.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3995FEF
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2023 07:48:12 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id B8540686C4;
        Tue,  7 Feb 2023 15:28:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo07-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo07-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Q74Za2DJ3bS7; Tue,  7 Feb 2023 15:28:25 +0000 (UTC)
Received: from mail.gonehiking.org (unknown [38.15.45.1])
        by mailout.easymail.ca (Postfix) with ESMTPA id 78079686B7;
        Tue,  7 Feb 2023 15:28:25 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 6A48D3EEDB;
        Tue,  7 Feb 2023 08:28:22 -0700 (MST)
Message-ID: <47e6d710-d666-5f5b-5d65-4f31afe4359d@gonehiking.org>
Date:   Tue, 7 Feb 2023 08:28:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Reply-To: khalid@gonehiking.org
Subject: Re: [PATCH] scsi: FlashPoint: Replace arithmetic addition by bitwise
 OR
To:     jejb@linux.ibm.com, Deepak R Varma <drv@mailo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
References: <Y+I0HXsHezZRtFOM@ubun2204.myguest.virtualbox.org>
 <9a78cdd254d5d962450242d2e01c3a0f702a63a0.camel@linux.ibm.com>
Content-Language: en-US
From:   Khalid Aziz <khalid@gonehiking.org>
In-Reply-To: <9a78cdd254d5d962450242d2e01c3a0f702a63a0.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/7/23 05:26, James Bottomley wrote:
> On Tue, 2023-02-07 at 16:51 +0530, Deepak R Varma wrote:
>> When adding two bit-field mask values, an OR operation offers higher
>> performance over an arithmetic operation. So, convert such additions
>> to an OR based expressions. Issue identified using orplus.cocci
>> semantic patch script.
> 
> No it doesn't, at least not for constants, which is the entirety of
> this patch: the compiler can find the value at compile time, so the
> whole lot becomes a load immediate of a single value.  Whether the
> compiler sees OR or + is immaterial to the compile time computation.
> Perhaps Coccinelle should be fixed not to complain about this case?
> 
> James
> 

Agreed. This would be lot of code changes for no benefit.

--
Khalid
