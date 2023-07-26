Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDB3C001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 12:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjGZMOg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 08:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjGZMOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 08:14:33 -0400
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1941D19BF;
        Wed, 26 Jul 2023 05:14:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 959E5C0007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690372540; bh=xdgyRgw1OcoQaf1uILZNJ74oN+M3FHJX3tQ++Y+yd8w=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=hwaCui+VKoi920x6Rg1sN7Za54/UKvr9EdXO5zcxwJ48X9lQHwcXVP4qLVGfgZ1hU
         R8VWjNqGG/5WzATfGQoqBU/0vFQuD955mUMk8hy/4GysrrFwr9iY26Vkt8RtwbPyon
         WXFK1Ry+W85RY/M2Ms6fqqMaRaf0GCmiaLtht5SIwE/SaZxQuf9qcB+SZ1zUv0DHoY
         1310tsYaaIuJCmJX6ESSh5vgcnyqJwYqA6OzKV9ylnDocrdfpcktqbsldvgac7Akew
         oZsUmFF169VMWhI3ACSpvINB2zLhAPQEHOxOcdTEN1SRk8ESSjubkOtxvDh/ZkutqT
         RtCeL2ecT+P0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690372540; bh=xdgyRgw1OcoQaf1uILZNJ74oN+M3FHJX3tQ++Y+yd8w=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=aieNPyJkIRvZatE5q7k55c9MeQfDpNQoGaf2XFByQljNMgO4zjQ6/B3d6Bbdrf8p/
         jNyaot8RIATbJvLD+YMnlxEMJKOG6xxdqMh/rHZ6dKMxCc9f3lkHO6sKcDeN4Dkrxy
         4/YiUP+/V+MR8w9R5tF+40JQykYOIBibd4gga8LjoADsDqGLZUkGWDgcAlqU99Yt/X
         flhi51sI1eOZ9ACvLmFq3pNyyWXCT5cUZMdXEA1q3PRmU8sfSwpRa2E4xNig3GkQe5
         BaBfwLsEeX9MbOtnQ6/jK0MRlyfEKnCGslSuFxA+Q7H/jwPh5EQ00/ICO9N2wePnFI
         hWx9RHB7QDL1w==
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux@yadro.com>
Subject: [RFC PATCH 0/3] SCSI target logs
Date:   Wed, 26 Jul 2023 14:55:06 +0300
Message-ID: <20230726115509.357-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-08.corp.yadro.com (172.17.11.58) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is an initial work on scsi target logging improvement, that
was discussed here:
https://lore.kernel.org/target-devel/ZF0MiCRW8HWm8YYj@yadro.com/
This is an example of how it will look.

Things worth mentioning:

1. I've decided not to implement target_lun_LEVEL() and implement
   target_cmd_LEVEL() instead because the mapped lun is stored in the
   se_cmd structure, and most of the time we already have the cmd when
   we want to log a lun.

2. Target prefix such as "core" or "iscsi" will be defined in the
   beginning of each file.

For example, you can test it with such command:

   sg_inq -f -c --page=255 /dev/sda


And the log output will look like that:

   [ 2229.586394] target core (iqn.1996-04.de.suse:01:6e84cb30fc63 -> 1/0): INQUIRY with EVPD==0 but PAGE CODE=ff


For bio errors log will look like that:

   [ 3354.495867] target iblock (iqn.1996-04.de.suse:01:6e84cb30fc63 -> 1/0): bio error: 0000000097ff0ac0, err: 10

I'll be thankful for your comments and suggestions. It would also be
great if you could tell me whether it would be better to send the entire
series for all modules at onse, or send patches for each module
individually as soon as they are ready.

Kind regards,
Anastasia Kovaleva

Anastasia Kovaleva (3):
  target: core: Initial work on improving SCSI target logs
  target: core: apply the new wrapper to spc
  target: core: apply the new wrapper to iblock

 drivers/target/target_core_iblock.c | 94 ++++++++++++++---------------
 drivers/target/target_core_spc.c    | 27 ++++-----
 include/target/target_core_base.h   | 25 ++++++++
 3 files changed, 82 insertions(+), 64 deletions(-)

-- 
2.40.1

