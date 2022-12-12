Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702F5C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 05:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiLLFLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 00:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLLFLf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 00:11:35 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C52B7D7
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670821893; x=1702357893;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=tZMzSye8BMLFj1pGS6mwBXOhT4IeM6UCltrMWRTGyn0=;
  b=XAOoM0ryWXa3DQisptczpW6QnQnsY6CUS9rbFLousvRqzg+a6jWaezv4
   kzGTdpsO+nPdKPEu+dXfSTuHC8WknI2kMAO1jMdVM9Gue8sLu5KyBD2sW
   wlhbDQqZxVOBoI436TTB7TJdAGJwssiqsmVW/gY7g07iZBcePu3Dur0Gj
   81AexwEbzij4mapCMdqTp68MNg4j+/3hosCF6aeXDJIjOPdsfbe0cb15o
   oAOqzwgeY3hD0rwbygpXs37WddujUjYb7+nTkTwhqTisj6LGWJkXmSTac
   90glU6m6w/1VjDTEp90LTWdTDQf2Xa9kbcR7lC92FunUW939pgfIXZzpF
   w==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="322775534"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 13:11:32 +0800
IronPort-SDR: Qz6rL8NFRnd5ICUYRQQ5aTSk1RvZwqvvQ7o4aGNwR/wYV1kaz0S+Reh82UedBDvW179BQE7SVZ
 lhCm1jjKOMnKEHNGcLzB+fdt9bzMC40Nd1B1cnWKSjKOyCMRYaaiG1Si6SQLOoubyxdWSSBmeA
 eBB4K17TYq9ghabZUUrOzgIDDUd+mbcjqpVp8r1j5khl7zKuxq8oK19ww9xMyeZ+j/pmWMNsmr
 2dQI9nlQTVCQXST3un8jmvsd/hfCQxCWw7NuF1qH3iIzAw20hlwkkHA/7J3c1CJVc5KiFTYKSL
 87E=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 20:24:13 -0800
IronPort-SDR: hdLLKh7bczjSKiaaG+q7H3OXmifItCW1RA0x1Ukd8SFaZQ4x3gUXWj6hJSAZyBHkT3siwU3J1Y
 bN3zTT0+8L67M+Q2NZVmk8IyAlj3YEiFCYcD04pspNi2pGbTWBmgcznRh8tFfqLXh7TAl+ZSyB
 CqgJuNoufNYlpko/tXpZ2gj9vgd2HuyT4NzLNKjsHX3qL79eURSizFhpMkZ1Ei6vPuPIh9/Q1y
 VZlIzQxETGPgKVt7VpdLAl1bpZnp9Elii+rK1QSKv9XdQaXhEG7C5y7TPjjxY5hLUBCl+BFzRZ
 jMc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 21:11:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NVqVD014Vz1Rwtm
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:11:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670821891; x=1673413892; bh=tZMzSye8BMLFj1pGS6mwBXOhT4IeM6UCltr
        MWRTGyn0=; b=cXRip5qeCiHsCs3ESAbgrl+I6KNFY2RQ0L4GucalowEmDnASkLg
        zQ/3zAfYHINiihB4tYpl4IulxRK3vVmSfXM58KLcmjTib90CWILSqUB702cJYBvx
        MIQuxvPgxS2xUmPXfopH8Sjlh9kqWqSEVIbc/i3esPJHOSy0zzl9OC0rBQmVAf00
        HIZ6GPhGj2T6VmDmrCEiaH3iUsnAilEJItacQWvZljVfbcQ7z9lmAUT9SDDXUbyA
        KRUqblauwUnSGpZxIcUGsBqNxejjlGaPAYw8ZATMtV35qQMzX5gO1erotU0O1W7G
        D//1BO9Obfb8PfR+SKiXLZj9CneW2HmMeow==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zqQQofBqLTL3 for <linux-scsi@vger.kernel.org>;
        Sun, 11 Dec 2022 21:11:31 -0800 (PST)
Received: from [10.225.163.90] (unknown [10.225.163.90])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NVqVB1DW0z1RvLy;
        Sun, 11 Dec 2022 21:11:29 -0800 (PST)
Message-ID: <6650b9a3-c9a4-c97d-06c3-50ca3643671f@opensource.wdc.com>
Date:   Mon, 12 Dec 2022 14:11:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 02/15] scsi: libata: Convert to scsi_execute_args
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-3-michael.christie@oracle.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221209061325.705999-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 15:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert libata to
> scsi_execute_args.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

The title should be:

ata: libata-scsi: Convert to scsi_execute_args

Apart from that,

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Martin,

Can you take that one through the scsi tree ?

-- 
Damien Le Moal
Western Digital Research

