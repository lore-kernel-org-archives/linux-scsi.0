Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3F6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 08:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349971AbiDSI2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 04:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244295AbiDSI2R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 04:28:17 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76AF13D66
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 01:25:33 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l7so31360114ejn.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 01:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=SCcpgFyaQZUAJcvuvhPHKQcoQsiAphTEhs/1sD45xGQ=;
        b=kbRTiTwLViZg8IqN2WupwyL/17oDj/3Ha6sqx3EQThM5vi6AQhNTdMdFtw3XG5cy7h
         uF4adNkF6MLwN5F0M2oWr/ke8OEaSqw8F/w+ybAZU0ZOlOZQ2paetGbMlfCPYYa0JORj
         W5B3+eOY5LSPzIiQkQNfWOoIry8CaWl1wTNnoEQI3OKlM2PErIBRo6o04waojD8zqGEK
         dnH3WGV4cNZiKquFEcuYr3LFJPgbf0yNyvI/+CoHJ2mQJwdc2C72TiPfAUgFeSya2q4/
         IbMOci0dh+ARfjWIK5F5hcmfy1BUSH2jDwJjGpNEQne9cq4G43GreONcfA20hMft7BTZ
         HmWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=SCcpgFyaQZUAJcvuvhPHKQcoQsiAphTEhs/1sD45xGQ=;
        b=txixoL9Sydanyk5fhWFOcfJHC550jjzuhaVK0ayZeWb8ielNeyw9P2OfF4DQAr6FIt
         esmWWKMwCpqiCxwTfUKUyocdrsc7CwzeGgEvabgoggJkm4npNNkW+PqC1CVWL415FDhh
         ln7FtRqiwU2W+Xj9Cbjr4b4TWkbkfu+qsaA9lSM1w3sDrFACRYtGUrRe28dojEFEx29i
         vJXfduJO1rWajIk3MSny81xljHX82shBa27HcGCuDi57SyltF5s8TAlzq3N6Kk6CT4w8
         ZmB9hbqHBC0QDfNPhStjJOQrZCPqF1Ob3wDsihoMEnof+vNN12XFIU1j1UOpGaDr4YHv
         zslw==
X-Gm-Message-State: AOAM532iGun2QIFxfTkcOkd5OJTg4unEly/3OeyL71yZ4XenmUyRroPh
        n7S9gYOIbqiyoXzDViBU7oR3NRVmNZ88Lw==
X-Google-Smtp-Source: ABdhPJx9JEqzQVKogozu3EaSsMi09H4mh2dYDIJXJRoCZp9HELLSqha3IgfK7h9iEhZ01r50UTVm4w==
X-Received: by 2002:a17:907:9687:b0:6ef:8eee:34ea with SMTP id hd7-20020a170907968700b006ef8eee34eamr10078265ejc.186.1650356732170;
        Tue, 19 Apr 2022 01:25:32 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id s11-20020a170906284b00b006e108693850sm5351894ejc.28.2022.04.19.01.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 01:25:31 -0700 (PDT)
Message-ID: <e2cb03ed21a52e1bfd0d6eb197b43ebea6f9abba.camel@gmail.com>
Subject: Re: [PATCH v2 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>
Date:   Tue, 19 Apr 2022 10:25:30 +0200
In-Reply-To: <492cd10d-9964-6a5c-2896-9fc0d5397a54@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
         <20220412183228.3729720-1-bvanassche@acm.org>
         <492cd10d-9964-6a5c-2896-9fc0d5397a54@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-04-18 at 10:11 -0700, Bart Van Assche wrote:
> Can anyone help with reviewing this patch?
>=20
> Thanks,
>=20
> Bart.

Bart,
Looks good to us, but we need to verify it on the two platforms, and
need some time before add reviewed and tested tag.

Kind regards,
Bean=20
