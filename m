Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F765C7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 01:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbjEWBVI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 21:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjEWBVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 21:21:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA2693;
        Mon, 22 May 2023 18:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 435DA61990;
        Tue, 23 May 2023 01:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA92C433EF;
        Tue, 23 May 2023 01:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684804865;
        bh=yFQuG1ghxykUNbtOvy6MwI9xsYMH1cMEJOySRSZyp10=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=TVr/EPGOzgmSjA8a8vnrObQ2AQ5HFImBw3O1HSLT9mRjqlpHf7NvT6AExfWi+PRga
         a+ZGU8do5SIBoxBQ5bCxmhsVlZiJ4tuwCke9A37Zawq/qf+GMHcqB+snt/7MISCf6+
         haDcLPqGtyo30V4Qte9lqm9wmbZzEimLXnzw8NmNgzLyDO2mEcPcyEOHrwyowYgwes
         4RBHhl1MXE3i8FKfOb4lVSatp187gEEwLqSyYDSl0tP05ecl/B0pkOHN7Go9H74VXM
         UdBFwl9XAT9qS+TCmpxpE87RsTHbmTzgT5YSeYTDYOxQgprvD0ntyxomOtn1wfeBqC
         LFpjkZUPvwspQ==
Date:   Mon, 22 May 2023 18:21:02 -0700
From:   Kees Cook <kees@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>
CC:     azeemshaikh38@gmail.com, Adam Radford <aradford@gmail.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        linux-hardening@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_scsi=3A_3w-9xxx=3A_Replace_a?= =?US-ASCII?Q?ll_non-returning_strlcpy_with_strscpy?=
User-Agent: K-9 Mail for Android
In-Reply-To: <yq18rdgm1mo.fsf@ca-mkp.ca.oracle.com>
References: <20230517142955.1519572-1-azeemshaikh38@gmail.com> <168478437626.244538.8257051598276343700.b4-ty@chromium.org> <yq18rdgm1mo.fsf@ca-mkp.ca.oracle.com>
Message-ID: <A8157E92-E340-4031-8054-378728CC5BD4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 22, 2023 3:41:58 PM PDT, "Martin K=2E Petersen" <martin=2Epetersen@o=
racle=2Ecom> wrote:
>
>Kees,
>
>> On Wed, 17 May 2023 14:29:55 +0000, Azeem Shaikh wrote:
>>> strlcpy() reads the entire source buffer first=2E
>>> This read may exceed the destination size limit=2E
>>> This is both inefficient and can lead to linear read
>>> overflows if a source string is not NUL-terminated [1]=2E
>>> In an effort to remove strlcpy() completely [2], replace
>>> strlcpy() here with strscpy()=2E
>>> No return values were used, so direct replacement is safe=2E
>>>=20
>>> [=2E=2E=2E]
>>
>> Applied to for-next/hardening, thanks!
>>
>> [1/1] scsi: 3w-9xxx: Replace all non-returning strlcpy with strscpy
>>       https://git=2Ekernel=2Eorg/kees/c/fa36c95739ab
>
>Are you planning on sending these? That's fine with me, just need to
>know if I should close them in patchwork=2E=2E=2E

Yeah, I took a bunch that hadn't been picked up yet:
https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/kees/linux=2Egit/log/?=
h=3Dfor-next/hardening

Thanks!


--=20
Kees Cook
