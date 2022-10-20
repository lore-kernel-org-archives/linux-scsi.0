Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2230C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 21:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJTVWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 17:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJTVWt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 17:22:49 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD02222F0D
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 14:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666300963; x=1697836963;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=mmMPK7MWLnlltYGrkqJnW24HrCsPtBvS4WZUL2KqcQE=;
  b=aL91bww1UNjb4XHS5a8yGzG6564KmYL+w0y9WR/Gzas7HP+we7nwnSON
   KNuiSjTEoUo1nv5GlRLCOn4I0bn4QeRoMaqikpFZh78+ftO1SCkT1tojp
   MEzfg283fIhe7jLexQO+eqz0hh8zg+T8cYCO1e776gtkGeTWIlaGwEXlW
   Sp73Qew0FSNTnO8geJ2ULVugljG18CIVkN/M1cOidhBiwhkK0jXHvaiML
   FDterO1+yt7xBhlvLmsHXFaKcHqJutLx8gDyL6MS8JVT8SsrOvsCb924s
   3NYx33+2/iTa+uEn4HxLGrLIWN0UPhLHngT4C1/TLp3eIsCANUhDy9W8r
   A==;
X-IronPort-AV: E=Sophos;i="5.95,199,1661788800"; 
   d="scan'208";a="219531648"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 05:22:41 +0800
IronPort-SDR: HCLFssI10qorYqxov41hzhlBDHTGHzecijHcV4ZGjr4PHvKKGqteZQxsweZjLA32Fqnfykg1JY
 c38qZXDfXFnUwknmnp44fSatLXDwcN6+Sdem/bOsl1h9cVxDUVj7Bk6hYgjkbNkjg2SOuRaic0
 z/OH69trirmwPDDc+ivwiNFWyBi8W48Eftk5Qi1sSDfHZYNexYshO5P4x6n4RuNtKc7WWTdgUU
 EBRpe3bRv1KCPA1aHRoY1BiiRGM9w17gvPuJCoBfrFb+vY2ODTvE23BE60GamytCvE97NXAHEh
 4aiyDQD1yrGUgTxGiGhCNgjD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 13:42:10 -0700
IronPort-SDR: ZHb+radb8WvcV1xr56QRg6JLWF/2cAVuVJTh7YTxf9ebvm2um4T9RhWxYuXqMJKE+vSt/JjGh7
 OaNTMB4G+siUtfqLPmBWb4a7LmcS/k4AKGet1NaWhpOJX+UoyUqnwAoj0e9F4O/08jRBkrnGS7
 ba/SAS/ozE+n7w17Hz0nvpj0TNsCNwDlJnnhor8OHN00ldXfEmZbyBagneyqFS/pzapZ/lvitG
 n52S2IcQfOYaH4UJFhB8ca9vNelGmetVaXdYk6OgyH7DLAhpRlm6JKXfBzJ7AN+PhUSQaitWvd
 cdc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 14:22:41 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MtgYF18ctz1RvTr
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 14:22:41 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666300960; x=1668892961; bh=mmMPK7MWLnlltYGrkqJnW24HrCsPtBvS4WZ
        UL2KqcQE=; b=WxRdHKFzxXZVuX+ih2FysZ+ROA7VjC31OUuH3Oc8p3cNmtB+CHu
        5KN1PyVyHs2zuJ0B+9HvaZF5wxNTzUb2sXPqTlDzVGMonRAZw+48t8BkWuIKFrOs
        Edf6w9gsf8m4Wvj78KLi0uZgyMgFH3/BUFZUKse6A0RkRVnreon1pX1Ap2O6fLM8
        CKK7KvxedKc2bRvDPEwt6lG/s4jsnD68gV/6uRHy0MJjIqAtgErLDJW6XhWGf0lC
        nANY74YxD/Jzhp/Zbc7ZqbWNIb/rPc+LMsJwo5rjqzWvXLFCQc9LIqZR6sSf403n
        Wei7rs1qYAiIZcSv8ijzftgilVV4YJq1vpw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vFpbQdKKBOZ7 for <linux-scsi@vger.kernel.org>;
        Thu, 20 Oct 2022 14:22:40 -0700 (PDT)
Received: from [10.225.163.126] (unknown [10.225.163.126])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MtgYC5Cl8z1RvLy;
        Thu, 20 Oct 2022 14:22:39 -0700 (PDT)
Message-ID: <1dcc64f4-8432-f99d-e897-381eafcda9ac@opensource.wdc.com>
Date:   Fri, 21 Oct 2022 06:22:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v4 06/36] hwmon: drivetemp: Convert to scsi_exec_req
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-7-michael.christie@oracle.com>
 <01d9407a-26d1-e00b-8e52-04760af4b65a@acm.org>
 <787a0875-27c3-7bb8-8777-3d8b38635789@opensource.wdc.com>
 <77dd1234-ff8a-e86e-f1ea-16cfd49582b1@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <77dd1234-ff8a-e86e-f1ea-16cfd49582b1@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/22 02:52, Bart Van Assche wrote:
> On 10/19/22 16:23, Damien Le Moal wrote:
>> Anyway, while not being a fan of the function call + struct initialization
>> all together, this looks correct to me.
> 
> Hi Damien,
> 
> I asked to make this change for scsi_execute() because Mike's patch 
> series adds an argument to that macro and because I would like to add 
> another argument to that macro. Adding a member to a struct is much 
> easier than adding an additional argument to a macro and updating all 
> callers.

I like that the arguments are passed as a struct. This is fine. It is the
struct being initialized inside the "( )" for the function call that I am
not a fan of. But as said, not a big deal.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

