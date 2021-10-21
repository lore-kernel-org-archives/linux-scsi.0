Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DECC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FDB9610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJUPDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 11:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbhJUPDZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 11:03:25 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22C9C061224
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 08:01:09 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id u69so1210515oie.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=6jnVZbBkLbnw6pFZpxUldRg4FuFfEZElhVVQao3Uy20=;
        b=ZGFMo833ta2HUfgqVLXUNHJV5pTUNb23BosrQDRrArzz1VYW1rZvujqd1q9AvwL/2L
         I3qasTS/LaOX+rTG38fA1WkYeozE1AIG6Y1LWW3KJy++pLKzaue+ysn5BR5qqBazSL3X
         IVR4Fjt0Mg/h6j4Zo8LPwJHvk9rRXi+EODiN4CZjW0a3nWKAwsxdaWUyN0Iinpv2NO0m
         dB+Q+OGRW5ZAtyv3ynB4fi22vLxF+kmJ+bRRxyM9NM8BrnQaDlNccb6EwaqBPSB/5dXE
         w0UzuwJbGrVM1iqd9niPDqAPfBdtIGPYSTrtcyZITTG5mzlvKTmg+/w7FrEp4Vj/y3G+
         Cdig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=6jnVZbBkLbnw6pFZpxUldRg4FuFfEZElhVVQao3Uy20=;
        b=QqN2BRFrFC/J2Q60GksojtipkYZ5ARekPPjlXPssx1aLdrdjEzEIXN2J6iMIIS5nFf
         j9/xtvbiv9O/SZGeAuQvBIcCZg1IcKNNbyBjAohHvfPzNbKSwrpKvH7u7/HU2sORiFF1
         AlBCQb1c/bR57KKZQyx+bdSqH3MahXFLdGfKTlac07PlwwiCgf9HTRITRDmR57IZAAkF
         WaT3BaPeb/t5KFXGt4vPRXAeZnadz3SLeV5PYqHx3GSKcvDThCtZbkY2qEVCkuP3Q6Se
         d3s+zz6B8FX4qfuWI0HQwFR8IDTumylGAHPEcaLguVpK9IdUsl/cRcTeINMxdsCJyGke
         UqKQ==
X-Gm-Message-State: AOAM531g4fWfC+xCDW0s+LeZKjF97Ly+7KTzP2kTVWKcepxRBDHkdoyr
        iW3gCbPoGPc3N+6vNn1CICwRNQ==
X-Google-Smtp-Source: ABdhPJxcqYzZpw8hjWvx8wtyMAFaG+Ip962yojdp/B4kEz2Pn9lx52Qn4eX8lgw7zW26Sgpyf8s+nQ==
X-Received: by 2002:a05:6808:3c9:: with SMTP id o9mr4905862oie.20.1634828468846;
        Thu, 21 Oct 2021 08:01:08 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:783a:c43c:af64:c142:4db7:63ac])
        by smtp.gmail.com with ESMTPSA id w18sm1173833ott.29.2021.10.21.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:01:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        johannes.berg@intel.com, roger.pau@citrix.com,
        miquel.raynal@bootlin.com, jdike@addtoit.com,
        anton.ivanov@cambridgegreys.com, geert@linux-m68k.org,
        krisman@collabora.com, vigneshr@ti.com, richard@nod.at,
        hare@suse.de, jinpu.wang@ionos.com, jgross@suse.com,
        sstabellini@kernel.org, ulf.hansson@linaro.org, agk@redhat.com,
        linux-mtd@lists.infradead.org,
        Luis Chamberlain <mcgrof@kernel.org>, tj@kernel.org,
        colyli@suse.de, jejb@linux.ibm.com, chris.obbard@collabora.com,
        snitzer@redhat.com, boris.ostrovsky@oracle.com,
        kent.overstreet@gmail.com, martin.petersen@oracle.com
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        xen-devel@lists.xenproject.org, linux-um@lists.infradead.org,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
Subject: Re: (subset) [PATCH 0/9] block: reviewed add_disk() error handling set
Message-Id: <163482846658.50565.12530170761457767964.b4-ty@kernel.dk>
Date:   Thu, 21 Oct 2021 09:01:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 Oct 2021 16:30:19 -0700, Luis Chamberlain wrote:
> Jens,
> 
> I had last split up patches into 7 groups, but at this point now
> most changes are merged except a few more drivers. Instead of creating
> a new patch set for each of the 7 groups I'm creating 3 new groups of
> patches now:
> 
> [...]

Applied, thanks!

[3/9] dm: add add_disk() error handling
      commit: e7089f65dd51afeda5eb760506b5950d95f9ec29
[4/9] bcache: add error handling support for add_disk()
      commit: 2961c3bbcaec0ed7fb7b9a465b3796f37f2294e5
[5/9] xen-blkfront: add error handling support for add_disk()
      commit: 293a7c528803321479593d42d0898bb5a9769db1
[6/9] m68k/emu/nfblock: add error handling support for add_disk()
      commit: 21fd880d3da7564bab68979417cab7408e4f9642
[7/9] um/drivers/ubd_kern: add error handling support for add_disk()
      commit: 66638f163a2b5c5b462ca38525129b14a20117eb
[8/9] rnbd: add error handling support for add_disk()
      commit: 2e9e31bea01997450397d64da43b6675e0adb9e3
[9/9] mtd: add add_disk() error handling
      commit: 83b863f4a3f0de4ece7802d9121fed0c3e64145f

Best regards,
-- 
Jens Axboe


