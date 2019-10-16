Return-Path: <SRS0=T0eU=YJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D444FA3728
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Oct 2019 22:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0F19207FF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Oct 2019 22:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGkoD3I3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405317AbfJPW7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Oct 2019 18:59:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38337 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391935AbfJPW7H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2019 18:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571266745;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NyiMlWJkqAf8MO4pTs8/WbLKzyR9A5LqxtBH32MGUbQ=;
        b=EGkoD3I3DTgw/WShNfXNPwkX7Qycm7b3GbyA3bMJpVzq+dBSFEeqTh8sA5ynB7Nx8Q/9D2
        OXPhAilrWUFEUAoABf1A6kiP75moOmsy1hsdJHLdK7AK1QQx42KFKnu3pivBk/Qxnx8iT9
        sx9zE30082C6lTw7GK++iKtpabEpaTY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-2OhQNQ1hP4iYIERNtDi8eA-1; Wed, 16 Oct 2019 18:59:03 -0400
Received: by mail-io1-f72.google.com with SMTP id w1so376427ioj.9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2019 15:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=izr2IsFI8KdP3bcHd0eKxqMK3CSawZuxmuGffwvF3wM=;
        b=ll0F0hyt+fRDyswrlkU2k9x4nCncwPK8sVezGWXj+QA12+PQVw/r/0ItK+8gK+O2+C
         5sO11eEg/x9PQ6kB5aJC5kRQ2Du2IiaLIfYSB7Ct064GOEZ8Ct3YU2Zsd2fTBcZwzjEo
         pCQy95upwjr7oUUas26NiJS61zk4MqwJutGhQkqmKey/CPrth4T03wg+6rTNcTFoz8LU
         v4erI2yqDUl8HfLBpy6QkWXzE8qkqFPnYlgAJ6K1/7HIXvcxCxrjjLSrkCSrrptIQ0Xd
         pvG3fYaEOEu3jsaGSbyLVYZIAkL0aOz0aC2Lgtl1UKJWApkt0VITQmedhRfUKy/gVKfa
         n8JQ==
X-Gm-Message-State: APjAAAXJ5fkf1Wdx3Xgu++gCO5lBrWkq9jvWJd8OXcAChFm/7j8W6C1+
        cB3FQ5mx1SKwW9zAxNMTvNGLgL9V4oOlvkZkF4lLvU6mVmCUckqXPYCoOTisNfw4/Jkkn9aZOJk
        eTAGm9JLq10L5i75nJciL4w==
X-Received: by 2002:a02:7124:: with SMTP id n36mr450928jac.90.1571266743020;
        Wed, 16 Oct 2019 15:59:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyXgcSDWOvFVRU4qEgI4WtmHcPsJHr4aMIDVzx1G2HnyuwCQ56ZEGP2XRwkkjSFyOMu6fRo6A==
X-Received: by 2002:a02:7124:: with SMTP id n36mr450914jac.90.1571266742774;
        Wed, 16 Oct 2019 15:59:02 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id t8sm101183ild.7.2019.10.16.15.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 15:59:01 -0700 (PDT)
Date:   Wed, 16 Oct 2019 15:58:59 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Qian Cai <cai@lca.pw>, jroedel@suse.de, don.brace@microsemi.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, esc.storagedev@microsemi.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH -next] iommu/amd: fix a warning in increase_address_space
Message-ID: <20191016225859.j3jq6pt73mn56chn@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Qian Cai <cai@lca.pw>, jroedel@suse.de,
        don.brace@microsemi.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        esc.storagedev@microsemi.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
References: <1571254542-13998-1-git-send-email-cai@lca.pw>
 <20191016220415.cbam7qk3pxjmw4gi@cantor>
MIME-Version: 1.0
In-Reply-To: <20191016220415.cbam7qk3pxjmw4gi@cantor>
User-Agent: NeoMutt/20180716
X-MC-Unique: 2OhQNQ1hP4iYIERNtDi8eA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed Oct 16 19, Jerry Snitselaar wrote:
>On Wed Oct 16 19, Qian Cai wrote:
>>
>>BTW, Joerg, this line from the commit "iommu/amd: Remove domain->updated"=
 looks
>>suspicious. Not sure what the purpose of it.
>>
>>*updated =3D increase_address_space(domain, gfp) || *updated;
>>
>
>Looking at it again I think that isn't an issue really, it would just
>not lose updated being set in a previous loop iteration, but now
>I'm wondering about the loop itself. In the cases where it would return
>false, how does the evaluation of the condition for the while loop
>change?
>

I guess the mode level 6 check is really for other potential callers
increase_address_space, none exist at the moment, and the condition
of the while loop in alloc_pte should fail if the mode level is 6.

