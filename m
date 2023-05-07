Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9C4C77B7C
	for <linux-scsi@archiver.kernel.org>; Sun,  7 May 2023 14:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjEGOvu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 May 2023 10:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjEGOvs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 May 2023 10:51:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB505B8B;
        Sun,  7 May 2023 07:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DD3A60EA8;
        Sun,  7 May 2023 14:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7EDC433D2;
        Sun,  7 May 2023 14:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683471106;
        bh=6Uz2eGplQeLWHfzSTBT1n6hG4hAqwi661BYrpEeRNGA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=r1RM+995JVQuFTyIWjf/iW2TSPddyJpJmvdFZ3n1bhJhAy5fC/8h0mWu5KBB9+aBh
         Nr/AzCNMftFUvehr0EgA27DyczWlCWmW48igY+uze6/rXtVoB856+iHMDZyZ1DEIz6
         niA59lNU1e3ougA8KMj5g400nP47u08AqtqFoZUYNRpEYuu396+NJz8ZPwZTndsfML
         jw71KMA7JR9OmotYgBbl/L3uaMNm14K/7/4taNhoyHxA6tgD8hD8vDYwBn4DAG3xfs
         Zf8xwAijacW2P92E99EQZO1Vb/Y78I05aCAi3lRFN2IrXDoCQ7eGUTPn+kqJayuBoo
         GhoV9h6uQkJ6w==
Message-ID: <f4ba7a92-1f00-c254-d196-7d21fe14dee2@kernel.org>
Date:   Sun, 7 May 2023 23:51:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2] ata: libata-scsi: Fix get identity data failed
To:     yangxingui <yangxingui@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, john.g.garry@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        kangfenglong@huawei.com
References: <20230505025712.19438-1-yangxingui@huawei.com>
 <291f1d97-9195-45ac-8e12-058f5c797277@kernel.org>
 <02d36ee9-cdad-454d-d822-95442d7bd67b@huawei.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <02d36ee9-cdad-454d-d822-95442d7bd67b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/05/05 18:06, yangxingui wrote:
> 
> 
> On 2023/5/5 16:17, Damien Le Moal wrote:
>> On 2023/05/05 11:57, Xingui Yang wrote:
>>> The function ata_get_identity() uses the helper ata_scsi_find_dev() to get
>>> the ata_device structure of a scsi device. However, when the ata device is
>>> managed by libsas, ata_scsi_find_dev() returns NULL, turning
>>> ata_get_identity() into a nop and always returns -ENOMSG.
>>
>> What do you do to hit the issue ? A while back for me it was the queue depth
>> setting causing problems. As Garry mentioned, this led to patch 141f3d6256e5
>> ("ata: libata-sata: Fix device queue depth control").
> Attempt to return the correct value at ata_scsi_find_dev() instead of 
> NULL, when the ata device is managed by libsas?

That I understand. My question is *what* user operation/command triggers this ?
Because on my test setup, under normal use, I do not see this issue (beside what
was already corrected with the queue depth control). Is the issue showing up
when using passthrough commands only ?


-- 
Damien Le Moal
Western Digital Research

