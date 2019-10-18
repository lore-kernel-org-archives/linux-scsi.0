Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4BBCA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 14:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3932321D7C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 14:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XwpQPnbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410349AbfJROsM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:48:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60269 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408588AbfJROsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 10:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571410090;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+xUWPDHliBoxc0ihU+NKk1qsJN/0TLVezwKKP1i/PSI=;
        b=XwpQPnbEtf3ilv0j2DNlwQK8EFvVQtAmfdUbFyWITxKJzAlt6WDJJ5DK3Mh+GJhHnqeNl8
        ctHBNLbTlue3YmQsVkCbjKJoxejEipUHQgvdqmnDn+ehNYEsVjIVmkESoyzf9B/tPvP8Zo
        pJlY5gNZJEZSOKrieCBg6IYfjUOWKTs=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-kWCwFF5_NSaKSqu_hlLqlw-1; Fri, 18 Oct 2019 10:48:08 -0400
Received: by mail-il1-f199.google.com with SMTP id e15so1903005ilq.23
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 07:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=0SSL2373lC6DgsMmmsDZmA6zvnlA8UickiHBAjdntOQ=;
        b=p7sQorHVau9ink8QwdtyRmyHOBjjfzk7iIeEQEy0683S0pLzb1EbyPq6xiFEDdwC+l
         +Zmi8uDNzKxEnIVSJF9czbMbffsyZxMwNjIf04nq2vHNLdiSTipAHdLc20dEmvHXrd7L
         CnW5gmf5CMkBjwwQ9qsQkAjjhYpR9JrAJ8HQ6Qljwdlt33Skh/f7bEIAtklNQGTjPPgL
         xd31Sy2w8y0ZFbOG5jq0aj5/licQHcwq1pd8hiemzJ8qM0O0DAqlRJ5o51wlczq4JJku
         xKC06D0P1kdTJb4n0soatr3XnXwBeqTnEvEN5rCYQtDpddfbR+DRutSzeZ6ruLyenVv/
         Klwg==
X-Gm-Message-State: APjAAAWYnXETDq9DpcKe7kXB39HyBUfvUwHa1BYmzpDSCyt3b/PZMGYM
        PnJ9Mz1KV4dg3phre28Mx0onqzil+JnlktSS0V5ODSkDzd3vmqA2kwOHoc+G8zMij/qUtIRxq6D
        gg8qdB7QCKjTKbyYvki7jqA==
X-Received: by 2002:a92:c2:: with SMTP id 185mr10527384ila.92.1571410088307;
        Fri, 18 Oct 2019 07:48:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwWbRwj/fjTBeTuKTGQTT7Fu5ra8qoDURv6eP3usXETnKzvD8vxqCt0UkKoNoyNlAsUsHb8gQ==
X-Received: by 2002:a92:c2:: with SMTP id 185mr10527353ila.92.1571410088007;
        Fri, 18 Oct 2019 07:48:08 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id l3sm1778016ioj.7.2019.10.18.07.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 07:48:07 -0700 (PDT)
Date:   Fri, 18 Oct 2019 07:48:05 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Qian Cai <cai@lca.pw>, don.brace@microsemi.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, esc.storagedev@microsemi.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] iommu/amd: Check PM_LEVEL_SIZE() condition in locked
 section
Message-ID: <20191018144805.ici3ewsvonlgketl@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Joerg Roedel <jroedel@suse.de>, Qian Cai <cai@lca.pw>,
        don.brace@microsemi.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        esc.storagedev@microsemi.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
References: <20191016225859.j3jq6pt73mn56chn@cantor>
 <577A2A6B-3012-4CDE-BE57-3E0D628572CB@lca.pw>
 <20191018093830.GA26328@suse.de>
MIME-Version: 1.0
In-Reply-To: <20191018093830.GA26328@suse.de>
User-Agent: NeoMutt/20180716
X-MC-Unique: kWCwFF5_NSaKSqu_hlLqlw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri Oct 18 19, Joerg Roedel wrote:
>On Thu, Oct 17, 2019 at 07:36:51AM -0400, Qian Cai wrote:
>>
>>
>> > On Oct 16, 2019, at 6:59 PM, Jerry Snitselaar <jsnitsel@redhat.com> wr=
ote:
>> >
>> > I guess the mode level 6 check is really for other potential callers
>> > increase_address_space, none exist at the moment, and the condition
>> > of the while loop in alloc_pte should fail if the mode level is 6.
>>
>> Because there is no locking around iommu_map_page(), if there are
>> several concurrent callers of it for the same domain, could it be that
>> it silently corrupt data due to invalid access?
>
>No, that can't happen because increase_address_space locks the domain
>before actually doing anything. So the address space can't grow above
>domain->mode =3D=3D 6. But what can happen is that the WARN_ON_ONCE trigge=
rs
>in there and that the address space is increased multiple times when
>only one increase would be sufficient.
>
>To fix this we just need to check the PM_LEVEL_SIZE() condition again
>when we hold the lock:
>
>From e930e792a998e89dfd4feef15fbbf289c45124dc Mon Sep 17 00:00:00 2001
>From: Joerg Roedel <jroedel@suse.de>
>Date: Fri, 18 Oct 2019 11:34:22 +0200
>Subject: [PATCH] iommu/amd: Check PM_LEVEL_SIZE() condition in locked sect=
ion
>
>The increase_address_space() function has to check the PM_LEVEL_SIZE()
>condition again under the domain->lock to avoid a false trigger of the
>WARN_ON_ONCE() and to avoid that the address space is increase more
>often than necessary.
>
>Reported-by: Qian Cai <cai@lca.pw>
>Fixes: 754265bcab78 ("iommu/amd: Fix race in increase_address_space()")
>Signed-off-by: Joerg Roedel <jroedel@suse.de>
>---
> drivers/iommu/amd_iommu.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
>index 2369b8af81f3..a0639e511ffe 100644
>--- a/drivers/iommu/amd_iommu.c
>+++ b/drivers/iommu/amd_iommu.c
>@@ -1463,6 +1463,7 @@ static void free_pagetable(struct protection_domain =
*domain)
>  * to 64 bits.
>  */
> static bool increase_address_space(struct protection_domain *domain,
>+=09=09=09=09   unsigned long address,
> =09=09=09=09   gfp_t gfp)
> {
> =09unsigned long flags;
>@@ -1471,8 +1472,8 @@ static bool increase_address_space(struct protection=
_domain *domain,
>
> =09spin_lock_irqsave(&domain->lock, flags);
>
>-=09if (WARN_ON_ONCE(domain->mode =3D=3D PAGE_MODE_6_LEVEL))
>-=09=09/* address space already 64 bit large */
>+=09if (address <=3D PM_LEVEL_SIZE(domain->mode) ||
>+=09    WARN_ON_ONCE(domain->mode =3D=3D PAGE_MODE_6_LEVEL))
> =09=09goto out;
>
> =09pte =3D (void *)get_zeroed_page(gfp);
>@@ -1505,7 +1506,7 @@ static u64 *alloc_pte(struct protection_domain *doma=
in,
> =09BUG_ON(!is_power_of_2(page_size));
>
> =09while (address > PM_LEVEL_SIZE(domain->mode))
>-=09=09*updated =3D increase_address_space(domain, gfp) || *updated;
>+=09=09*updated =3D increase_address_space(domain, address, gfp) || *updat=
ed;
>
> =09level   =3D domain->mode - 1;
> =09pte     =3D &domain->pt_root[PM_LEVEL_INDEX(level, address)];
>--=20
>2.16.4
>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

