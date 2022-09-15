Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D720ECAAA1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Sep 2022 10:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIOK5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 06:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiIOK45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 06:56:57 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD8C8A6C8
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 03:56:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id d1so434928eje.8
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 03:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=PwCvl2GS9Z7tUa2K/61g/KqY6oAnPnxj77jiY0xnFnI=;
        b=ffhJ12fsHX50adqycQW4YDlYiWNe3KD06oqXT5e/tMKc5AUAMmjfN4b5ohg6bi5l66
         HNvRasJZVZMOJIW9go6uVPMc1m3s9v76gZawBjsnrZEkR/QqOUeP9hrYXTQ5hmHMWfIe
         mC9T3Y0yqUk1/FcrHfoTNCrcyhs4Vgbd2CymN2k865TZfhlShPgu88Y2jCLJY6ciYqLY
         Jr4Vp4coaqgTtygOFOBehacrRFDT82mGacYYBqHJjwC0ilXJv9vhZpLrZJ8TP6kx1W5i
         Tv4mSFJQloAk1njR3CfDn/J4Pe2+JfQwyk/OUZAL23S/qxfhzVEBcKDkb1HGym/hEuPf
         CMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=PwCvl2GS9Z7tUa2K/61g/KqY6oAnPnxj77jiY0xnFnI=;
        b=KjoTN6XTCfeZEZci5rjhnZh9EPJVDk11wl2dyr7yx1y7wlhIewfC9dmLf9/1PzLgeQ
         Sdy6FmZTp3XRBmjF/4zZJpVrilhZazM83rRZ5BO96ypqu+hl8IdcLbJbOs0C6RRKempE
         24Z8PFaC/fLOBadlVIiSc4x2lH/DAXmY2Nojw0jAmd09iYgbegFj69gq+41hiih7A1zS
         9tiCuGKPl+IpSMcmTZwlUti+P+reGuUHJ+71L8g7s3uMwXMb7pgYW/4Sif6QOAiIqcme
         SfaTTIKa25ELtRwV2bZiF2NSFNDeyrVJ7ECsWwlhHpg2HUjIEwDxN4vwswQ1tf7yzwiL
         e2Bw==
X-Gm-Message-State: ACgBeo1sEQ3izMs1fL1aPQUQwqbVUzzZ7XAzfE+Mr/aNLOuwAywL92Bw
        Feo0d0hp5L5+guUQENxGoUU=
X-Google-Smtp-Source: AA6agR7aZas52PGQfeX2SoIm/KujTBOK7x9IHVjZaBfodJpPUAi6hNqlnOAWiQqFCR84YACxvkfGQQ==
X-Received: by 2002:a17:907:3201:b0:741:94f2:aeaf with SMTP id xg1-20020a170907320100b0074194f2aeafmr28144832ejb.505.1663239414884;
        Thu, 15 Sep 2022 03:56:54 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id u3-20020a05640207c300b00451e3160451sm7463892edy.89.2022.09.15.03.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 03:56:54 -0700 (PDT)
Message-ID: <cf7cc030524bc25be4a69df7508f79f76d0ba052.camel@gmail.com>
Subject: Re: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "yohan.joung@sk.com" <yohan.joung@sk.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Date:   Thu, 15 Sep 2022 12:56:53 +0200
In-Reply-To: <5a293aef-80da-1130-b11d-d556828a6bf8@acm.org>
References: <20220726225232.1362251-1-bvanassche@acm.org>
         <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
         <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
         <ea43b861ac1c7b87a11934d2e5606fa37b2ae7fe.camel@gmail.com>
         <5a293aef-80da-1130-b11d-d556828a6bf8@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-09-06 at 11:04 -0700, Bart Van Assche wrote:
>=20
> Hi Bean,
>=20
> It seems to me that the block layer only uses the optimal transfer
> size=20
> (io_opt) to determine how much data to read ahead during sequential=20
> reads? See also disk_update_readahead().
>=20

Bart,
Sorry for later reply, Didn't notice a question here.=20

In the upstream standard Linux kernel, if the device supports a valid
VPD, I think, your this change will also not change the read-ahead
window.

....

sdkp->opt_xfer_blocks =3D get_unaligned_be32(&vpd->data[12]);


sd_revalidate_disk() {

...
 if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
     q->limits.io_opt =3D logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
     rw_max =3D logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 }=09
...
}


device_add_disk()
	 disk_update_readahead(disk) {
		disk->bdi->ra_pages =3D
		max(queue_io_opt(q) * 2 / PAGE_SIZE,
VM_READAHEAD_PAGES);=20
	}

e.g., if device reports opt 512KB, and the maximum transfer length will
be 512KB, and readahead window will be 1MB.


Kind regards,
Bean

