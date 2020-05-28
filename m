Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD45C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 04:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C33212CC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 04:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZ7TGabY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgE1ErI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 00:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgE1ErI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 00:47:08 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6CEC05BD1E
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2020 21:47:07 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id o5so28548482iow.8
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2020 21:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=j6XGlvgWV49S48DSksRXohZGJWNRTEpYHnF/8yCqa0I=;
        b=hZ7TGabYrfPpBYE4X/+/iMW4j0zutzjLn5wm1uAO8MdxI+Od9NvVM3GENwj+ElmW+0
         2DnzYWRquh0Gn6RhWLFLCpPglr3xgGV3XgDIW4Fxq0jxzIeum+H+N27X/djA5vf3sbrX
         o5+fzrcY64ec4lEXq4/icIQVGE7IkJ5MRC77P2JVK4hKytu9CjrABmONYGcKGDp1ZT3W
         vfvpHEIRYrWJe5mVOhcgibpendKMECB63chSwdIU+T+2uuR2Y2l8k9TaqyPvX2Z8ifct
         3YICcKQQuN2+8/bZRWDqqevIuBqux3jWz+W/Wg/CywgkRoZEFg+gdKl+xywYkEQtqaaV
         wI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=j6XGlvgWV49S48DSksRXohZGJWNRTEpYHnF/8yCqa0I=;
        b=RdzyRsYzGTSm+RJ2wJQPx2JnDB8zK1dkIOYX1gmvOr+rydbug9yMCnlp4myonrsZvu
         6/JivEub0XI/Dln4jWBEGQaYbIps0GSBCyZ/U/bSvkg28cckK2/ulqgrYf667Jus51zs
         Wnfd2jVeMi8Ye/hyDawA+DINV396voHSxU0ZEbOvV9akQ2lgvODWyoobM5zaByHyEvo5
         toT32vDl8/ans1tI/KTh3L0+v6shzrsQVb1nFgOpJdzkXIx48SG6owAczkvBMDKMKc8/
         fArMUZMYV/CW0x0gsQN98y44UhxKl6stvopzCKlhuLbFIR+ZsKB0fZVaZiLwwiE1kx/y
         18OQ==
X-Gm-Message-State: AOAM531dIS9Zmn00WTSYFEHrBk663H/96ICYkBaUZLOSTM9S9bp8ScDa
        xJyjld7PbxqRZj1ReoOuSNON4qAlswCinrvTu5k=
X-Google-Smtp-Source: ABdhPJwHsxHTy0UCiscXiXr6URFClwQAbiK1TXLJvX7nPByGR3hEd7lkw57dC91SxPXimT6CJZzC6Hi6LThqHolmTd8=
X-Received: by 2002:a05:6602:153:: with SMTP id v19mr926570iot.127.1590641227218;
 Wed, 27 May 2020 21:47:07 -0700 (PDT)
MIME-Version: 1.0
From:   Dongyang Zhan <zdyzztq@gmail.com>
Date:   Thu, 28 May 2020 12:46:56 +0800
Message-ID: <CAFSR4cuv1X9kHomWoBOHP=DxsFydeMU1-qMjehCKvcLWQqOGnw@mail.gmail.com>
Subject: Potential Memory Leak Bug and Wrongly Written Code in drivers/scsi/csiostor
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
My name is Dongyang Zhan, I am a security researcher.
Currently, I found two bugs in Linux 5.6 drivers/scsi/csiostor/csio_lnode.c.
I hope you can help me to confirm them. Thank you.
The first one is memory leak in  drivers/scsi/csiostor/csio_lnode.c
ln->fcfinfo will not be released when csio_ln_fdmi_init() fails.

static int csio_ln_init(struct csio_lnode *ln)
{
...
 ln->fcfinfo = kzalloc(sizeof(struct csio_fcf_info),
....
 kref_init(&ln->fcfinfo->kref);
if (csio_fdmi_enable && csio_ln_fdmi_init(ln))
    goto err; //ln->fcfinfo will not be released.
...
err:
    return rv;
}
This function is invoked by csio_lnode_init(), and the error code will
be passed to
csio_shost_init() (drivers/scsi/csiostor/csio_init.c), but
csio_shost_init() also does not release ln->fcfinfo.

The second bug is in drivers/scsi/csiostor/csio_lnode.c, csio_handle_link_up().
I think the code is wrongly written.

if (ln->vnp_flowid != CSIO_INVALID_IDX) {
/* New VN-Port */
spin_unlock_irq(&hw->lock);
csio_lnode_alloc(hw);   // this line should be ln=csio_lnode_alloc(hw);
spin_lock_irq(&hw->lock);
if (!ln) {
csio_err(hw,
"failed to allocate fcoe lnode"
"for port:%d vnpi:x%x\n",
portid, vnpi);
CSIO_DB_ASSERT(0);
return;
}
ln->portid = portid;
}
