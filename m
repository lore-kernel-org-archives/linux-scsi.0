Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A4DE81E18
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 22:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378912AbjJIWgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 18:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378146AbjJIWgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 18:36:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162449F;
        Mon,  9 Oct 2023 15:36:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08663C433C8;
        Mon,  9 Oct 2023 22:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696890962;
        bh=Ba++xVfy/dlh5ZGc5856oWG61Z9dEsUxdAxmqe8VWWw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ActcM9zZ9xv/osyNUqzvcPs/cqXciLrtNzh2xz71PPVU/QU/V85M4MJLwQd4HCcFv
         IX3t7S4G1eQUg0gWkNu9WNxE3cDbJtHZy86StcVUF4E4dZ5AUwNiBdRU0VDd44kneg
         RWFm9G6aEQy8Uja94NMyyecGu/DRk62IvtKysFQv2lFnYH0SiwK/YWSWRLrTYAE06+
         I2ZcFEY23+3ZR5kBSAAVV5+6W5RwI5woAnTt31Iu1HW5ydBVYVYTc5nhKk0oa3Z6O4
         ezkGagYDHjpUvT53GZXBtWNKsfv4mW+457WgKNyW9Q6ZCpUJ4le3825aI18zeYm/Rn
         7I5BaODdh0LIw==
Message-ID: <c05ba025-48f3-4c76-b4db-bceeff5d4f03@kernel.org>
Date:   Tue, 10 Oct 2023 07:36:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Do not rescan devices with a suspended queue
Content-Language: en-US
To:     =?UTF-8?B?UGV0ciBUZXNhxZnDrWs=?= <petr@tesarici.cz>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231004085803.130722-1-dlemoal@kernel.org>
 <20231009081736.28ddb5fe@meshulam.tesarici.cz>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231009081736.28ddb5fe@meshulam.tesarici.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/23 15:17, Petr Tesařík wrote:
> Hi, (adding James)
> 
> On Wed,  4 Oct 2023 17:58:03 +0900
> Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> Commit ff48b37802e5 ("scsi: Do not attempt to rescan suspended devices")
>> modified scsi_rescan_device() to avoid attempting rescanning a suspended
>> device. However, the modification added a check to verify that a SCSI
>> device is in the running state without checking if the device request
>> queue (in the case of block device) is also running, thus allowing the
>> exectuion of internal requests. Without checking the device request
>> queue, commit ff48b37802e5 fix is incomplete and deadlocks on resume can
>> still happen. Use blk_queue_pm_only() to check if the device request
>> queue allows executing commands in addition to checking the SCSI device
>> state.
> 
> FTR this fix is still needed for rc5. Is there any chance it goes into
> fixes before v6.6 is final?

The patch is on the scsi list, not for libata. Martin will likely apply it this
week.

Martin ? Please confirm !

-- 
Damien Le Moal
Western Digital Research

