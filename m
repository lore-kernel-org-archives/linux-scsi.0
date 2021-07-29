Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D215C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 21:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E78660524
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 21:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhG2VLF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 17:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhG2VLE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 17:11:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246A2C061765;
        Thu, 29 Jul 2021 14:11:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id f18-20020a05600c4e92b0290253c32620e7so7470925wmq.5;
        Thu, 29 Jul 2021 14:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8SkuOyTmyIB5hT8ozqKKAwUAdXcXcTyxuVRFatULG8M=;
        b=DWk49QFZkR5as4hP27AYXu0irseC6zGLUvqN+ph9UXUz597r5LK57bqXI9FFi27QNX
         mxjeXWh8tAyMlQ2FQnC6zbYsCICgouVVF+fVligDpu9779zSF7kC9oRHlphjwB8XVy9j
         brVWw/3tmijMfJHuvLGF0Il89bJaysvdVgmAind3FUbodtMXRWHyu4tzJzeGcLBBp71V
         Wy90hp4aqyckgOH4h2ogcSj4FxM1gEuxIFIkz01sjX16UU3lUx3RFDqehXxjCleJHlM1
         AAj4tpKB40m+v8a5iQW12FKkN/CDrVW9+uaYcl73Rp2j5aFYqLRUbo8nsUx0+InIx2s5
         vwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8SkuOyTmyIB5hT8ozqKKAwUAdXcXcTyxuVRFatULG8M=;
        b=kNoiByQ6pE2UY2hcpnt6KOBh+7WgpSeCc/8O6Z6RgxxlIr7MAjN4nTdy5gx/1es3/g
         1Pm201MAaWFSkgGChNPf8P2iS69sCofwy+EzO6Ra/S2yjsfmgO2sTGNqV1YiWzhoTNmz
         ygWjSP9NHWOwlhpT0vA+2EGQhtcZ28LS9anf3PrHRMSnBPZViOE3/KTyWZtywOrNr0yk
         rLS7XH9lO9sk+H0zLQGTWueyV/iIMibJdkaipp0ekD3P8Zx2dpyQhbgfoUpSkIGCCx06
         mn40Or6oc+9xot5NJrDBFKvV5D9tl/sX3cUKaVyntzhhJIHKLkm2HldfVvgXpMUcQLy7
         0CkQ==
X-Gm-Message-State: AOAM530B5fu41cQVZ5rjTbiuFxdMyrBezbulga9lIvF1rbwWgMTLAWLO
        JYe2qCWtEL/7PQgqFoUUoWA=
X-Google-Smtp-Source: ABdhPJzHd1t4wdMOxnOe8QZjk8B7YHwst01lbmIJjN/GWcY6+uq08T/fz7kg77oiLzhVIlnx/BCXrw==
X-Received: by 2002:a7b:c30f:: with SMTP id k15mr385705wmj.128.1627593059736;
        Thu, 29 Jul 2021 14:10:59 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id q7sm4281641wmq.33.2021.07.29.14.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 14:10:59 -0700 (PDT)
Message-ID: <27287a3c10d6096bd050f1f743c218b825dde2b9.camel@gmail.com>
Subject: Re: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
From:   Bean Huo <huobean@gmail.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        'Krzysztof Kozlowski' <krzk@kernel.org>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     'Can Guo' <cang@codeaurora.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Kiwoong Kim' <kwmad.kim@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        'Christoph Hellwig' <hch@infradead.org>,
        'Bart Van Assche' <bvanassche@acm.org>,
        'jongmin jeong' <jjmin.jeong@samsung.com>,
        'Gyunghoon Kwon' <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org
Date:   Thu, 29 Jul 2021 23:10:58 +0200
In-Reply-To: <002e01d78351$6996d040$3cc470c0$@samsung.com>
References: <20210714071131.101204-1-chanho61.park@samsung.com>
         <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
         <20210714071131.101204-15-chanho61.park@samsung.com>
         <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
         <000601d7820a$9aa11210$cfe33630$@samsung.com>
         <602ee8bc56891f0f0429afe274d7174ec325172e.camel@gmail.com>
         <004601d782d0$2f43cd20$8dcb6760$@samsung.com>
         <8af01dbdfbecf2aa2f35e8c3a5240b2bcf76d9b0.camel@gmail.com>
         <002e01d78351$6996d040$3cc470c0$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-28 at 10:39 +0900, Chanho Park wrote:
> > Hi Chanho Park,
> > Thansk for yoru reply.
> > I didn't see your changes about task_tag and IID. Having a look at
> > ufshcd_prepare_utp_scsi_cmd_upiu(), the task tag in the UPIU header
> > is
> > still only task tag. and IID is always 0x00.
> > If you didn't add these changes, your patch is un-readable, and
> > also the
> > driver doesn't have a real usage case.
> 
> 
> I already replied regarding this in another mail thread and please
> refer below comments. The controller will handle the tag translation.
> 
> https://lore.kernel.org/linux-scsi/002901d782c6$937ac0f0$ba7042d0$@samsung.com/
> 
> 
> 
> > Also, you mentioned there is no support/change needed from the UFS
> > device
> > side. But, IMO, if you changed the UPIU header, there are changes
> > needed
> > on the UFS device side in order to use your driver.
> 
> 
> Please see the figure[1]. Once IID_IN_TASKTAG bit is set, the
> function arbiter will translate the value of UPIU header before
> delivering it to the device.
> 
> 
> 
> [1]: 
> https://lore.kernel.org/linux-scsi/20210714071131.101204-1-chanho61.park@samsung.com/
> 
> 
> 
> Best Regards,
> 
> Chanho Park

Hi Chanho Park,

thansk for your further reply. I didn't find out your cover-letter in
your patchset before.

IID will be automatically set by HW controller according to the VH_ID
in the tasg_tag byte[7:5]. Before sending this RPMB to UFS device,
doese your controller reset task_tag byte[7:5] to 0x0 or your
controller will keep VH_ID?

one more question, you mentioned para-virtualization, did you use Xen
or KVM?

Kind regards,
Bean

