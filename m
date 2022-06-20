Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793B4CCA47E
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 07:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbiFTHOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbiFTHOa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 03:14:30 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C2E086
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2022 00:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655709268; x=1687245268;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LQCjkc8AWo140OOvRLywKCQJ1P+ERh6S+u9P0Z4sSUA=;
  b=qjqGsf9ztft7mSaqZ7+kwrz7MZI4VmXtFx9RUqyxjACmtjHKwN7/X6VI
   wJ19sk/rGUDI7LFStXpMXNmhF5zcHZz/JXt7bJWpCtGpRmD+3C+yT3hoy
   /Stdi5i4Oqh5nusTQd715d95yOSjj6+Wa+fe7ihqtgaruByF09GxXhwGB
   Xx3uRUAsOoqopblN2G3dCjwXvnwQBxEVP5fI5YFHgRMH+wKmbZvjpzrvx
   pL4u/rPWre2gtqiOW+ccNn1pCRkrQuOnp7eilxhveoJoDZW+g9zhhvpFZ
   avtacmH0LQxF4wFfgadiIgTpXod8ZZWbPBPo+ZqtpIn1M+fauw95YtKHi
   g==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; 
   d="scan'208";a="202304785"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jun 2022 15:14:27 +0800
IronPort-SDR: gyZiOTzWPlUuKfCGJs+N4ZQgJqi5hsS8O+DlXnLKcvgwfSH9qmWNDo7UDB6XjUCXMMdzkBu8uT
 XI9IxmRPS+MEmbCpKsgYxPjCtMX8jy0jWURJaWyvJqAbbeTVQG3p5ZWZoC8qTautoi3NnRu76m
 AzvMLi4+7qotdj5VUab2oZX8mdPipH7wEtrt8vOu7myELvP2mbnHCHJkIIcOxnH0skqEFeahqx
 6yO6yveGHxruahHxKrmtkj5Ki1FT4v2JCnzcyKB5jwRRAesOn32ysNbdbxqZR59aKYjDvuG1Wy
 hfYHE5vtqu3GD6KQqD5kNJjW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2022 23:32:36 -0700
IronPort-SDR: Bu+ory7KD3bLKoz+Tp2m43h6lpB0q0schgpCdOfaMDVSRDpw/wvqAHokBAbjVApFio/tyvVST0
 me/niGP49nFKHphvlU2FUyzy1cDeMkbuZ/9UMdpy5zU67V8CdzgkwZAOCVx23rIFqoWIjhq9vG
 Y5C1h90QE0wEQvv/GcJOPIjPBrqgV9x4I8ONZciSjB230d43blM57qDv2KP93HwBfiLFp0Sq+Q
 A56EXH/J5+PMxd6K+Lk+Sp8HUWXArCWupmyn4RXRANfxf7TJU/JLxZEuBqz48AKH7AsZto17jg
 J3Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 00:14:28 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LRLVp6zgXz1Rwrw
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2022 00:14:26 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655709266; x=1658301267; bh=LQCjkc8AWo140OOvRLywKCQJ1P+ERh6S+u9
        P0Z4sSUA=; b=hE5C4cse7H91CDizGdPcKqgBtuJyeKrdEbOK7pIEVMhmK97zrbm
        8JTGvYQZyWz1G1I1xUTLjnlnlfeOrXnJIwoo5e1HuuFJAvcnXQftMBqsejWeaaI9
        fab1VyHXwfUOI0eD9ZnvCwGcEqytsrLglQGPnDEXyHVNYtuqRY5vw8aSZ7XQ5rUP
        bDHGCNqN8zVuT4Ucbui2ay/o2LGdEroUGsTuH+y+TngDG6vHuQe6iQl7vS4VgBJK
        AiRDbvcHTnTHUTeqBb7UFAdcT1uCwhnO/APJVCLVl3zLN10czwgguiwzty4IWiYZ
        kdyC79lCAIyMrJ2j5HPFi7rf9tyeBpUV6jQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id o29poiJyup2C for <linux-scsi@vger.kernel.org>;
        Mon, 20 Jun 2022 00:14:26 -0700 (PDT)
Received: from [10.225.163.87] (unknown [10.225.163.87])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LRLVm18lkz1Rvlc;
        Mon, 20 Jun 2022 00:14:24 -0700 (PDT)
Message-ID: <113c8918-1d11-b3e0-0435-19405d103e0c@opensource.wdc.com>
Date:   Mon, 20 Jun 2022 16:14:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC v2 03/18] scsi: core: Implement reserved command
 handling
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com, brking@us.ibm.com,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        chenxiang66@hisilicon.com
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-4-git-send-email-john.garry@huawei.com>
 <b4a0ede5-95a3-4388-e808-7627b5484d01@opensource.wdc.com>
 <88d192b5-741b-7104-7f72-0178aa18bafb@suse.de>
 <20220620062828.GA10753@lst.de>
 <2ea41701-8be5-f981-d178-0d8e703962e0@suse.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <2ea41701-8be5-f981-d178-0d8e703962e0@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/20/22 16:03, Hannes Reinecke wrote:
> On 6/20/22 08:28, Christoph Hellwig wrote:
>> On Mon, Jun 20, 2022 at 08:24:24AM +0200, Hannes Reinecke wrote:
>>> So my idea for SATA is simply _not_ to use reserved tags.
>>> Any TMF functions (or the equivalent thereof) should always be sent as
>>> non-NCQ commands. And when doing so we're back to QD=1 on SATA anyway, so
>>> there _must_ be tags available. Consequently the main reason for having
>>> reserved tags (namely to guarantee that tags are available for TMF) doesn't
>>> apply here.
>>
>> At least in the non-elevator case (which includes all passthrough I/O)
>> request have tags assigned as soon as they are allocated.  So, we
>> absolutely can have all tags allocated and then need to do a TMF.
> 
> SATA internals may come to the rescue here; if there's an error all NCQ 
> commands are aborted. So we'll get at least one command tag back.
> As for the command duration limits I'm still waiting for clarification
> from Damien if we can reuse tags there.

We cannot easily reuse tags as the CDL case is *not* an error. So no queue
abort come with it. If we had the queue abort, things would be easy as
that would essentially be a regular eh.

Simply using scsi_execute_req() does not work since we have no guarantees
we can get a tag: all 32 commands being executed may complete with needing
sense data, and so scsi_execute_req() would hang waiting for a tag. I
could try hacking scsi_execute_req() to reuse a tag instead of allocating
a new one... Calling scsi_execute_req() from libata is really ugly though.

> 
> But I do agree it's ugly.
> 
> Cheers,
> 
> Hannes


-- 
Damien Le Moal
Western Digital Research
