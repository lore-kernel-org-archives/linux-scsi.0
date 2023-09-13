Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956EAEE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbjIMBom (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:44:42 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C98E10DF;
        Tue, 12 Sep 2023 18:44:38 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6beff322a97so4203498a34.3;
        Tue, 12 Sep 2023 18:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569477; x=1695174277; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3k/EdjDVOnhNhSNiAQVc5HdAaYzAcsNDFoFBb4kZ8cI=;
        b=Bg82WzCXTFhnUmujDRiZNRHBVgHLOldrf464j1dndEIO8DrHK8rjyCH++SiO+wV+a/
         nU9vHHsITfOcRlHLj/FJJX8z0cezNDTDIG4hCE5EAHWxF+Blg+0uvSBsNrU5VdoTSzno
         yn8xfq50XUPOup80S07dqUrEe0OsLGvd4S9NU6BdkLG8nUZI9/5jLZWPR0w6E/xYPqOC
         edv7QGbmWPzP/eYLsYVC+Q29/HtDM2D3PgbLGPoaKMcUr+hzg9LM/Gr7carUSnBhFm0j
         KtTqeqjVj4jb8MBqpx10Fq1P6rP3HcVqlqbKs78w5eTq8cH8rMMRetw+sXnXLhGjH0mM
         AI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569477; x=1695174277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3k/EdjDVOnhNhSNiAQVc5HdAaYzAcsNDFoFBb4kZ8cI=;
        b=khxsEL8Mazp51nzjez0Huj6a7nfmxI2Ka66tNLe5BlikD0rZ+b87kzRno/1GYLgKP0
         dGwVR82Uwx2aMUbk7BxTF7SiElathTNnRM2nVZ3DYzajqZHl6VEV/qckCX53X7dQWr8G
         Ne9SW7dsAzwuINYCRNpj/A4eC9WBnCN0oVuvnUlkMKTUhMVk00Zk1gUqSqpOqiuHmoAO
         FDlZERQklg+SLDsd9o98cZ4Xd69lQZB1T6c9Y/L83J+W4AzdUW2qod2Y3X55Xom/q5pL
         qUovhIpo/EYogLjOYQJ0ugBcFRPKLIPtKcHEUlJj8+Z+9BYJU1Z+JCxB2mYmo55H8c1e
         PTaw==
X-Gm-Message-State: AOJu0YwAw47zlVTCyxEhkkED1PPEE54qtYIzlg8iRHYjxY4efJYh86S6
        nKl8pGkBJ5rEv6BddXUXoA0=
X-Google-Smtp-Source: AGHT+IETSdsnrD+PggBysWDwX3ph3cZywCt/SNNQtPJywajM3vg68i23dOOZ/R5WvWT3Z0rWKS7+eg==
X-Received: by 2002:a05:6358:728:b0:142:d71b:59ce with SMTP id e40-20020a056358072800b00142d71b59cemr497789rwj.26.1694569477542;
        Tue, 12 Sep 2023 18:44:37 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id m21-20020a638c15000000b005697e8cc5f3sm7661604pgd.22.2023.09.12.18.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:44:37 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:44:31 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 05/19] ata: libata-scsi: Fix delayed scsi_rescan_device()
 execution
Message-ID: <ZQET/8e6/CcYVE2q@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-6-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-6-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:03PM +0900, Damien Le Moal wrote:
> Commit 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after
> device resume") modified ata_scsi_dev_rescan() to check the scsi device
> "is_suspended" power field to ensure that the scsi device associated
> with an ATA device is fully resumed when scsi_rescan_device() is
> executed. However, this fix is problematic as:
> 1) it relies on a PM internal field that should not be used without PM
>    device locking protection.
> 2) The check for is_suspended and the call to ata_scsi_dev_rescan() are
>    not atomic and a suspend PM even may be triggered between them,
>    casuing ata_scsi_dev_rescan() to be called on a suspended device,
>    resulting in that function blocking while holding the scsi device
>    lock, which would deadlock a following resume operation.
> These problems can trigger PM deadlocks on resume, especially with
> resume operations triggered quickly after or during suspend operations.
> E.g., a simple bash script like:
> 
> for (( i=0; i<10; i++ )); do
> 	echo "+2 > /sys/class/rtc/rtc0/wakealarm
> 	echo mem > /sys/power/state
> done
> 
> that triggers a resume 2 seconds after starting suspending a system can
> quickly lead to a PM deadlock preventing the system from correctly
> resuming.
> 
> Fix this by replacing the check on is_suspended with a check on the scsi
> device state inside ata_scsi_dev_rescan(), while holding the scsi device
> lock, thus making the device rescan atomic with regard to PM operations.
> Additionnly, make sure that scheduled rescan tasks are first cancelled
> before suspending an ata port.
> 
> Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after device resume")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
