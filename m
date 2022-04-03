Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E18DC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 11:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiDCLWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 07:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357005AbiDCLWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 07:22:54 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0FB3585A
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 04:21:01 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bq8so14474679ejb.10
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 04:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=knsu6IMgop8c/eSL8NNLL74twrXhwRfR1CGEz2WW0Ic=;
        b=dQbfh6hHrlQaK7PAykQbG22zI1NqtzwgH0PYFkPcq6lBpFZ7l5I6+w6YEj2VaxJAdv
         34My2SSsMdCl6Uns65tPzPVejwVkylA9GprKEPggiehO26J9jjb6TI25d687jjsC1Foa
         +zblKvmHkNK1MwHzcklmgCyXxR1tAuM/KoAnKG1GwzjnNJBMJkND0WkPplKVYt96BP55
         L5z5YJWrTpLWSTzbwqxAJXzvoYacjXfYIQqK1pe8ubf0QZEPI027O1dRYghXfMzSiaai
         DVdwG6T3bAKGSCwepSBUNiTMOqicq9avW74hmA5F/Lht0NkjhLdM8bWWSn4lfUJJNgJF
         M9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=knsu6IMgop8c/eSL8NNLL74twrXhwRfR1CGEz2WW0Ic=;
        b=PbpOgQxogLfIHxLky7eRSmxIpaMOEhwVXcN+l/y+ZjDtvOBiTzA7AaSHfSf9WIjD2G
         yi2jWPX7wi3OQu81AZtAqVsT0lOJLsM5J1dMlOPHjroTtol7dI6IZX+dmflXFDX9yDSJ
         UinofJiH2KSFXrhODEG0+jLLN6uUUhpViIPyQXXQK2HfX9JEN9ygWnkntQ/6q48FikY6
         zWBFoqFmvA0V1gY5nZlHoVQzqlxvSwK46UarD8nolNoodhBR3Gl6u6/rr+gAtJuuSn7H
         ZZwPD4ncqRMX3IJuX0zuEbggBWsi/yOQvlA1uE4nyvNbNvgzKSkzy+l8Kp7gOjWPrUhr
         ZnnQ==
X-Gm-Message-State: AOAM533kxU7l3J4OMljjEoTYBOmV82y2oe+FwU6b4zLZQYjulZB1JDQo
        eUM51IWv8Ii1xKiTHuubjZA=
X-Google-Smtp-Source: ABdhPJxJn45OAZfzNGjyH5l3Emrh/wwZ/01QcRM5fNt2d8m6x5jGFw81N8MLSlpbblXybmRnL5y+0w==
X-Received: by 2002:a17:907:3f97:b0:6e0:93af:1b5e with SMTP id hr23-20020a1709073f9700b006e093af1b5emr6823187ejc.653.1648984859785;
        Sun, 03 Apr 2022 04:20:59 -0700 (PDT)
Received: from p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de (p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de. [2003:c5:8701:8437:2b88:b730:2efe:cb4a])
        by smtp.googlemail.com with ESMTPSA id a1-20020a50da41000000b0041c83587300sm3044990edk.36.2022.04.03.04.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 04:20:59 -0700 (PDT)
Message-ID: <74d441f6956f45e9049feed0d9aa758ec4c2b744.camel@gmail.com>
Subject: Re: [PATCH 06/29] scsi: ufs: Use get_unaligned_be16() instead of
 be16_to_cpup()
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Sun, 03 Apr 2022 13:20:58 +0200
In-Reply-To: <20220331223424.1054715-7-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
         <20220331223424.1054715-7-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-03-31 at 15:34 -0700, Bart Van Assche wrote:
> Use get_unaligned_be16(...) instead of the equivalent but harder to
> read
> be16_to_cpup((__be16 *)...).
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

