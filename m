Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D670C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Oct 2022 07:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJMHwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Oct 2022 03:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJMHw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2022 03:52:29 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D18F127911
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2022 00:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665647548; x=1697183548;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nrhVsbzNcy1sQd2FmHuxrZcMS3UkNIcfyGdPZvyiupY=;
  b=RVFwsRwN9C3TTithGIAJOOXhm88cWVff1OJUfaf5Yjt9xq/+Y248b6nq
   dLZ5KjXbTpyxxtlCiX/s6vc0/cLG1/9guyHg8F7Rt2437JrlxvbUCa97M
   /Mp5X3MgbHHoibM+zyLeSeoiDEDHHoNHQzom9pH0c/gDPZfMTtQJYTUBB
   Jz9vB8l0B0BqKzDAwjDnIvfjC705Bpq6IDI/e8qfCWaSnc9XiQKIsk0Ts
   fvn2S1WZLK7tx61DP7mSNzvrgB+sNkZSVR4zyPsW7DliI1w2NebspZw3q
   kor5v1DSPM29dmxELiieMMhKz1qqj963x7K41K7SlKi+FxhwKX30xHSGa
   g==;
X-IronPort-AV: E=Sophos;i="5.95,180,1661788800"; 
   d="scan'208";a="214076277"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2022 15:52:27 +0800
IronPort-SDR: vquCr6dpFn3Boc1gKQfwnyr7vTgux1v6SxHkqXN7PaaCSEKW2ICkwUJJSiZItwpmLEhZjgdizk
 1uU4/NTp/LY7zTSymCw74kkeEdAoBw2L2NFdWPvmmGAcraDhMXNTO6OCvy5VDBYz1/f7Qpl4zQ
 oDATBBgL+A1NgNCJVZYOpOKoIjM7wAS8VsJa4/7aSWTwC0nI8DINgZoIymPnxD5O2jTx2EYAwP
 a3mu+0LibM/7B+nqAXtgjjS7fCBD4gJu2Z56Fn0K0rme0X5c67FkrsLrXsD8jukP4YowIZXrJG
 uxA+DENvAoGDEa2q/0tcnz6V
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2022 00:06:27 -0700
IronPort-SDR: zW7culnE4rV9dOVY5kP9fv+N8H2lXJMZWI5tpC/EwIXyl5YW3C0qLkxCyYqFYIWxww8i6Z70K9
 lqxVRhj33VKiWE3dLgJRjTUh8kPv4VQOXKGEP4fPBrgb75ZviaVrytdlb9dfc0/LK25BOqlwNR
 6BHyHLlBt4PVDQ3v7Y24KXFKvs2AI1YTX8eyGFMWwsuwxAogEZqYwKh8iLuZYdY7gU0DMne0dH
 VmobdsQTF4k7naVArV60cb+CGmvgQ5TgZW0ah+3somug+MM25OJCAxwcdWjA9n4IBLL+wVuVVV
 knk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2022 00:52:28 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mp1vb1Pjxz1RwqL
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2022 00:52:27 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665647546; x=1668239547; bh=nrhVsbzNcy1sQd2FmHuxrZcMS3UkNIcfyGd
        PZvyiupY=; b=IkpTS4GuokEGDuIzWvWWHIAvtI1fkqfWqi4IVL0jD0Zxxtw5R0I
        FlQm5M4q4AIlCb6JUh6oivWu2einzxVH1iJOl99DQrQN5tvBc7cp2rIlidbrWFmz
        ilHMJUoT+luIJosCUckIDw3mRFIPoe026WX3f6b+H4TY9Lg+CtxPizC8Ts4wbAAY
        JN8sSDVVOYoz9Xs0om8Fl84hHAjks4OzuH4ijidQcui9dM431cRjnanzun0D1mry
        CEsBw1ddIpp50fsSrcfzNjOlGnqR9bxcuPPwgIs+9274aptd4lM85MxwpKAEkz1T
        2By+UfDp6vgGw0fGo9jw+Km3uXBHhC7RdeQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dAET7cyuaZpe for <linux-scsi@vger.kernel.org>;
        Thu, 13 Oct 2022 00:52:26 -0700 (PDT)
Received: from [10.89.85.169] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.85.169])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mp1vY6CrXz1RvLy;
        Thu, 13 Oct 2022 00:52:25 -0700 (PDT)
Message-ID: <035b7855-b6fc-5604-7969-7b356ffa33e3@opensource.wdc.com>
Date:   Thu, 13 Oct 2022 16:52:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 4.19] scsi: sd: Fix 'sdkp' in sd_first_printk
Content-Language: en-US
To:     Li kunyu <kunyu@nfschina.com>, yanaijie@huawei.com
Cc:     jejb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <badf255f-df60-fbc7-0f61-c69b99ebbaa6@huawei.com>
 <20221013073920.279180-1-kunyu@nfschina.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221013073920.279180-1-kunyu@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/10/13 16:39, Li kunyu wrote:
> 
> Hello, I'm not sure how to operate it. Do you want to execute git push to submit this patch in branch 4.19.
> 
> thanks,
> kunyu
> 

Please see Documentation/process/stable-kernel-rules.rst for how to proceed. In
this case, I think you should follow "option 2", but read the entire document to
understand all cases.

-- 
Damien Le Moal
Western Digital Research

