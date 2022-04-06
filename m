Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE95C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 12:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiDFMZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiDFMZF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 08:25:05 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE53E42B252
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649232655; x=1680768655;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OXlW7XMsm7YkB8BmULX0rKO6acP3cTihzhxzw0jjfqc=;
  b=WXJg1bSwTyHYus/XvaDBFA97p5ux75osIfj6SvogxCKtcwtqyGGL73ov
   7L7/O2BI3XzKn0VP9QWGLdP/nUrgkDjczdhWJ3/zHfB2NnmKj0wrkNGaI
   UA0ZwLS7cLDD+7j1zpxVvSN2WGQCf+kxhs8FQK6SxnZe/7Qq758DJznrL
   2jC/iT0fz2ol2h9A5q+w0xY8yTjwofhd15G3LNacJX8ma2SYciO35dH7a
   u+R8i47+aYEkYjTnLQ/lW8BdayOurP0gBieis9ukX2+ESgsuzZRmedDom
   ks3ahSPhIMKv2u3TLUSroIILPvsaZ+g0Hd9b2RiNIZvTfQbG8cJi38lL7
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643644800"; 
   d="scan'208";a="197220761"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 16:10:48 +0800
IronPort-SDR: IzK97cqLeNx737i8FWFHMUfMVox9NrFJDLkTh7xhiNVhJkbvsIoKwTEvuJwj0BDLCTzlH5uYZV
 7Iqb5JYikX/wKkVv8NpGXfxuxj5HnGj2tKMd3prO2RD0ZXvSH4gq69BeYiGoQNSK4u6vWBqOgo
 2zZBWWAq+dBpEBTnmpiytmbXg9dxoZyQIeVVCxd5Fxx7/33Va9luV44IcXdfNs6SZpZKFrZJGk
 F+aqNSBEZtruqGgrNG90CWlp9qLtsyiPeNQMq8NfsvDgAkERfrf969K5u5Lf5M6mqvhJyOiUh4
 Wi8OAk/LWoJWp91GNOmsLUAk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 00:41:30 -0700
IronPort-SDR: AxZu3atPONlZr+nc1X/iTIrDkf85SFNhhtCNyOqa1sOUgwBd3Y+uMasvfwd6aDF5qsmNblnul6
 pLpUN0UtTNgaLAxukXyW/PYlNc+SYjXkIi/XVv3B7rU24rK3ZuvkBo/p6ihtKPQdZpczXGAiLR
 b6XkNepoRVDGaTYKFqsR7YsVKHLYzfVqZwZAeYTpeTbfSTT1dDtwED5zxG/S2TQnQSyO7nYiWB
 ru5D1Yd70ugIfjMqPbWRj4alJqRKAjBUKMFACLotKDRzN9w+A8lXUx8sqozcEW33dh7syzcrv4
 99A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 01:10:49 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KYHJS3CYrz1SVp2
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:10:48 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649232647; x=1651824648; bh=OXlW7XMsm7YkB8BmULX0rKO6acP3cTihzhx
        zw0jjfqc=; b=o4BCjSaKcmUeC3V/ysxboezAk7mt0Fxzqh0MWkY8sT2l+gU7jPB
        Kdld9C6XDIdwdhu6MiqU1d/sFMaFZp1s88kGT8889lanvnwC5C8AIwciYM+n0oHv
        v8DNdpfzNAnjxkMmWc8SAOte06L8HEC5Aaq0RJ3++HsG5s0JRjox/1O/RVWyl8QV
        csjgkizdLNStKiwYAn6XM9sdJYrB3kTdTlk3xh1VqjcLqZnatbHvvIiBNcoawOPo
        TlPhnPSSi8mM80a14xE+5tRgZNdUKq+STK7pG4aKau780AYeHKeAm1wTs8z6wem3
        vskcmDgDMic33lD85Uly6zeGQTyojauhR1A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bJOZOx27LQWx for <linux-scsi@vger.kernel.org>;
        Wed,  6 Apr 2022 01:10:47 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KYHJR0CwQz1Rvlx;
        Wed,  6 Apr 2022 01:10:46 -0700 (PDT)
Message-ID: <a984b4d6-bc7d-ef81-8bd6-34d50127174d@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 17:10:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/2] libata: Inline ata_qc_new_init() in
 ata_scsi_qc_new()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org
References: <1649083990-207133-1-git-send-email-john.garry@huawei.com>
 <1649083990-207133-3-git-send-email-john.garry@huawei.com>
 <20220405055252.GA23698@lst.de>
 <f7bbb09f-562f-fce2-cd16-a1c67fc334b5@opensource.wdc.com>
 <febb03e4-ea1d-c7e1-58a6-fa564c902af0@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <febb03e4-ea1d-c7e1-58a6-fa564c902af0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/6/22 16:16, John Garry wrote:
> On 06/04/2022 02:48, Damien Le Moal wrote:
>> On 4/5/22 14:52, Christoph Hellwig wrote:
>>> On Mon, Apr 04, 2022 at 10:53:10PM +0800, John Garry wrote:
>>>> From: Christoph Hellwig <hch@lst.de>
>>>>
>>>> It is a bit pointless to have ata_qc_new_init() in libata-core.c 
>>>> since it
>>>> pokes scsi internals, so inline it in ata_scsi_qc_new() (in 
>>>> libata-scsi.c).
>>>>
>>>> <Christoph, please provide signed-off-by>
>>>> [jpg, Take Christoph's change from list and form into a patch]
>>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>
>>> Although I still think merging the two patches into one to avoid all
>>> the churn would be much better.
>>
>> I agree. Let's merge these 2 patches.
> 
> I'd say that they are distinct changes.
> 
> Anyway, if that is the preference then who shall be the author? 
> Considering I did most effort I will be and add Christoph as 
> co-developed-by - please let me know if not ok.

Works for me.

> 
> thanks,
> John


-- 
Damien Le Moal
Western Digital Research
