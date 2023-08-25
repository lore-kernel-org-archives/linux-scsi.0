Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBCAC88CB2
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbjHYBdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbjHYBdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:33:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B0519BE;
        Thu, 24 Aug 2023 18:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F17C963BBA;
        Fri, 25 Aug 2023 01:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDCEC433C7;
        Fri, 25 Aug 2023 01:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692927192;
        bh=xdhvbd4ckulFxb0CiU99NxCz5awg7MunA/GEM9Nk67U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WCb8oHpBjRRBLg5hGzEySu16rBuxJYr4ecmuBoEX9J+v8+MnZ25eJytsl7a/sF8HN
         IS5MIWccjUpVyDZ65SyHh0hBbxXPBVWbW8xHj05Ot3VAA/0j7NYJsPvabhI+hNucb0
         qL+Gb53yYzTLZB/GZyVYoJdqq2kNhL/My8LnZQw0cufhshSS71ttUbBbSwZU6HQYIQ
         d1QvbFWI31xeozXYDfP7/K4b+buD8YH8jjrpWQG9W8vDhNUX0g1pgMavT0D5llfFq2
         0StK/owCowYL6oZAhAMc6M85wGPJ4urxzIrdeR56LGtZAZYOl867wIW2rhixDZqt0H
         CQ9xwT+22pLVg==
Message-ID: <bcb1bc1e-d110-05d8-9849-c84ec94fa069@kernel.org>
Date:   Fri, 25 Aug 2023 10:33:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
 <yq1zg2f3ocm.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <yq1zg2f3ocm.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/25/23 10:31, Martin K. Petersen wrote:
> 
> Damien,
> 
>> The main issue I think is that there is no direct ancestry between the
>> ata port (device) and scsi device,
> 
> I really think this should be fixed. It is a major deficiency as far as
> I'm concerned and it affects other things than power management.

Working on it :)

> 

-- 
Damien Le Moal
Western Digital Research

