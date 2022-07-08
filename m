Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BA1C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 08:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbiGHIuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 04:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbiGHIuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 04:50:03 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D09823B7;
        Fri,  8 Jul 2022 01:50:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y141so22988472pfb.7;
        Fri, 08 Jul 2022 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=cm1LB66MmDD8EmwUS6z+lWnw11bNSlxHjmWpghPAHzM=;
        b=JwNmXtIQZ+R6XuLQ4EpKmk0z/gxvYCIhxWBJNaK/mN9gUw8o0Xqt/aM+b2pNSpfVZm
         do1JvlZEqQy2iK2E1T8jubfV3aOMc5r8ScZAfSuslwOPrjiHHOgRyzZ/OiUrxtHZlUiZ
         gjNQMPmPDcqSiRJ2F75xsmgSh26YdLFMb9nCWWIxP+HT5uBae43NaV9YHSxE6z+NWvD/
         T3C5ynQZdAMXMQ4THL219cOWSirCMV/oJEMM2fw+rDCJSqrYv8Cfxnt05pn+fp9u90xl
         uSGv9qI2YDbP1voCkz+NaEmiD3v4rfaA/sdTSG7/jhk4SIYezH5p0RW/yEGVvJ8Gf/Ir
         2KFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=cm1LB66MmDD8EmwUS6z+lWnw11bNSlxHjmWpghPAHzM=;
        b=fBOLUcaSEmU1ZgYeYRS53ClOCqzmUTtbYiwtnZ8nV6ZZJoSx+cmAMB9q0Z/3VRrqLU
         FDChBHtt75aEmsJP7QhBpnJlGiW0NubL0GMF1ggRtXQNYVPas+niRat08lY9/WM/5L1u
         hNw9CmSlrAnII8ZF8CzzavmOiwLAgCvQCFExGrqsC8cPkTTQl4YywqW0l3NnUo5ajiLC
         zri5yOZRdTv9W7lsAqbQilsQQMeGkvYiCU9tX2iqHyo/N8mckUm9teduJ9vFDqwIC8BQ
         CmV8mQ+nAJkFUCUMvw3m32QuUWypuq+l98smtoRVAz0+1Eij98ubc/a59l9Qli49OrU+
         8UDw==
X-Gm-Message-State: AJIora8DCr3kE8+6Etkue0dq7169dnWdiGwBcYSBxWnGrzYG2eQ5dgdA
        iU9iep8hlbtQmlgHW/PTreE=
X-Google-Smtp-Source: AGRyM1u5OybdFjCdVZuX3bTD2Q2hdEbPmrGWOEjYD9cbK4PQrsV5GgrKiIpaZOxIBPnt9M2G52pQIA==
X-Received: by 2002:a63:1259:0:b0:411:f92b:8e6c with SMTP id 25-20020a631259000000b00411f92b8e6cmr2327841pgs.108.1657270201849;
        Fri, 08 Jul 2022 01:50:01 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ec8200b0016be3d7c3basm10685550plg.60.2022.07.08.01.49.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Jul 2022 01:50:01 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] Converting m68k WD33C93 drivers to DMA API
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220630033302.3183-1-schmitzmic@gmail.com>
 <yq1zghk63iv.fsf@ca-mkp.ca.oracle.com>
Cc:     linux-m68k@vger.kernel.org, arnd@kernel.org,
        linux-scsi@vger.kernel.org, geert@linux-m68k.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <da7bc74d-ff2d-5052-7703-e87e1e21b964@gmail.com>
Date:   Fri, 8 Jul 2022 20:49:55 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <yq1zghk63iv.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Am 08.07.2022 um 09:01 schrieb Martin K. Petersen:
>
> Michael,
>
>> This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
>> m68k WD33C93 still used virt_to_bus to convert virtual addresses to
>> physical addresses suitable for the DMA engines (note m68k does not
>> have an IOMMU and uses a direct mapping for DMA addresses).
>
> Applied to 5.20/scsi-staging, thanks!

Thanks - I'll have the mvme147_scsi conversion out for review shortly.

Cheers,

	Michael


