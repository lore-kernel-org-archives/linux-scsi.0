Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D3EEE4996
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 05:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjHVFrq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 01:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjHVFrp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 01:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A36133
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 22:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5434762DA9
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 05:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE3AC433C8;
        Tue, 22 Aug 2023 05:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692683262;
        bh=y5icXLM1/COEYzP3l4LEahC7ou1L/P1eUfiV6pD0HOM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lLCOszGpD4I4u40YR/3+YfjrT7XdqGRElfxbZx4wvaZfa2iz753Nd/0opz6ubisYv
         ux0KFj94ih1vwsTXobireozSHt92ZJcUfpN4cTvX84RGB9aQ7wLz0T1RrwnguNmPox
         6jY1sJL9k1csbPcdpjzEZvhKvQuNM8aHxYysyjOE9WuOpXjIrefxL/qA78GpFRCEEx
         i1ys9hWDQyTFZ2canTNOLBP5DDs3lzu0RDeGGly9H6BF8YU/5EBrY1wOExAYWPrrAd
         ht+zV7Zrh4228NGZfSX2BhMbW3lMQJaPdBY5BQDRbwVuqqOXGZJeuzSnqwMAYm0RGg
         MBY0o9NVBSwfg==
Message-ID: <c8476456-ae88-f7a9-5ef2-a6db406876ca@kernel.org>
Date:   Tue, 22 Aug 2023 14:47:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi: core: Improve type safety of scsi_rescan_device()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230821204009.3601639-1-bvanassche@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230821204009.3601639-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/23 05:40, Bart Van Assche wrote:
> Most callers of scsi_rescan_device() have the scsi_device pointer

s/Most/All ? If it is most, then you have an issue somewhere :)

> available. Pass a struct scsi_device pointer to scsi_rescan_device()
> instead of a struct device pointer. This change prevents that a
> pointer to another struct device pointer would be passed accidentally to

...pointer to another struct device to be passed accidentally to...

> scsi_rescan_device().
> 
> Remove the scsi_rescan_device() declaration from the scsi_priv.h header
> file since it duplicates the declaration in <scsi/scsi_host.h>.

With the above nits fixed, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

