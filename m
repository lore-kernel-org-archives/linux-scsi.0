Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0F1EB64DB
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Jun 2023 06:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjFQGz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Jun 2023 02:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjFQGz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Jun 2023 02:55:27 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FC91BF2;
        Fri, 16 Jun 2023 23:55:25 -0700 (PDT)
Received: from mars.fo.jb.local ([188.174.26.59]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis) id
 1MKKER-1qOv5Z2Ob9-00LqEc; Sat, 17 Jun 2023 08:55:14 +0200
Received: from localhost (unknown [127.0.0.1])
        by mars.fo.jb.local (Postfix) with ESMTP id 1B72617F700;
        Sat, 17 Jun 2023 06:55:13 +0000 (UTC)
X-Virus-Scanned: amavisd-new at jmbreuer.net
Received: from mars.fo.jb.local ([127.0.0.1])
        by localhost (mars.jmbreuer.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O10Sinob0lYP; Sat, 17 Jun 2023 08:55:06 +0200 (CEST)
Received: from sol.fo.jb.local (sol.fo.jb.local [192.168.23.1])
        by mars.fo.jb.local (Postfix) with ESMTP id 79A3817F6FD;
        Sat, 17 Jun 2023 08:55:06 +0200 (CEST)
Received: from [192.168.23.25] (mars.fo.jb.local [192.168.23.254])
        by sol.fo.jb.local (Postfix) with ESMTPSA id 699DB604E111;
        Sat, 17 Jun 2023 08:55:06 +0200 (CEST)
Message-ID: <0a698809-bc7d-e5a1-7825-d42001121913@jmbreuer.net>
Date:   Sat, 17 Jun 2023 08:55:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ata: libata-scsi: Avoid deadlock on rescan after device
 resume
Content-Language: en-GB
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hannes Reinecke <hare@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20230615083326.161875-1-dlemoal@kernel.org>
 <df96d9fd-e8fa-c1d0-d6b0-4327ddf45514@kernel.org>
From:   Joe Breuer <linux-kernel@jmbreuer.net>
Organization: Joachim Breuer EDV
In-Reply-To: <df96d9fd-e8fa-c1d0-d6b0-4327ddf45514@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:qZD4QCK8F7Rs7ceT1tXfgEvUCZQM3a5iiUCoS1qfo5jBRATWuoQ
 K1ZTqHEC7fVxvk2WBwGFsF27Ba86wILNIm6E1ZxRo+k3/GAPdscHB5mUdTMNm5jRXequ6sX
 xlfef8b5d98ArDFOVhcbPConrDPH+oBSQLoYJtPydKNv76Hsc/sXCQ02jOJcR6KMPeqyw9x
 XfCx/6I6C4bXC/mk+Yptg==
UI-OutboundReport: notjunk:1;M01:P0:40Z1lR+UeDI=;jHOkXEFBdhKEEQR+Ae3m1rMG/ok
 6dR8wrj++3iAVzZMvzchlKCK+PW4jwDtGkZ8t2Zr/Rzz2E8L8qfLBPm8junCYv7dvrhppxTb4
 POiEfwfbnnWCoPRQW4Uj6In1aX46gZsCH5DBxk9lQdd65T+an/DF9C0oHwdYH3Iyek0pTsDzN
 hPDb83OcKQ8ElgrlUey9xqU7VUZo+64X1mKzvhnDFsVQzG99tsjjGX9I4ryg/4+zaz8vEMOC3
 mVJzg6hvkuskcJoSChC+bEcfZ9htCz/2k9vh2KSi1FT2s4t711AX4zmctqO6tyLP1foYwclh8
 b5x41UxW6EWsErS3KVlC9vFWTPyZrdWzGIzaf15OYuyW9YRvWBYFGApfByIN2Ti0thPUTcNid
 fFR22xeKhZKMArwT1HJdleUwfNWq8VbEFsb5b5j8fuEMiOPq/sg0CqFTtqjsRaLYLwQcJFNiE
 veuH6riKqDK+2QweKZR4U0QTwgrbBCvQ9mOJNfHDi2vRt4Uz7WB+vZWPmPCCIfaBpr8NY3ekr
 dZbnQXS923vIJoragK+EYdOMefs8HM3+Y8R5klXaKxZhx4pEvKpxR/yTllcHjokIN64QGunEe
 7PDY0adcY01l2XP+KRIN0EfcAcBK/4qhhNAUG1nApoZXzvUVC5ZfT4ZRAbFInVzXuzHK7REZW
 MBZwFoz2TCPsn6T/Q/ECmwkU6TtpmcJs3KYMg6rUHw==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15.06.23 10:35, Damien Le Moal wrote:
> On 6/15/23 17:33, Damien Le Moal wrote:
> Joe, Kai-Heng,
> 
> I cannot recreate the issue on my test machines. So it would be great if you
> could test this new candidate fix.

Thank you for looking into this!

I've tried this patch against 6.3.4 on the affected machine, and it 
looks like a full success. Suspend/resume work without any deadlocks, 
and the optical drive stays usable after resuming.

Since the patch and discussion around it mentions async vs 'guaranteed 
order' power management: My original tests (without any patch) were with 
both pm_async=0 and pm_async=1, no difference on my affected system.
Also, with pm_trace=1, which is documented to imply pm_async=0.

>> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Reported-by: Joe Breuer <linux-kernel@jmbreuer.net>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217530
>> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Tested-by: <linux-kernel@jmbreuer.net>

