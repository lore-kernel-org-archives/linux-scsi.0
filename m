Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC80C4167E
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 21:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378986AbiDDVT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379466AbiDDRLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 13:11:20 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B69237E1
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 10:09:23 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id a5so7991422qvx.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2022 10:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=VcPjK2xIshaSha7P/73c4uJIeEh9LCIV9h696014eSY=;
        b=0/1W3PtmahDM2zaiwQOfAOI7x0n7aJlY78Edx82FG8yn3sBRYT/xK8rwyUWlSIPkVk
         FbhTcMOufB5eBtNbzu+A7OVMx2KouPMqLL4fqMN5fXrX9FdDb+g8E/WNbt7rmfNyOJqQ
         3yTps2pezT8XzRvoiqVDfU0khY6BzaT9b9y+qgU1cNgUC5dLdbyJ926rZhqt1ZSdlvB7
         wu1tox0qINOoXy+nUe+Na9v9dWOAA/GUbXFNkrYHSwHS3aWbXTRBR4ZEacGNaIi8qzUK
         oh7jsSFehuBrZbWoTHGlWiHmYACJyn+L1iSBP/T8RxtxXRT0rUV4Sb16jlJtGgFKMGWg
         lnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=VcPjK2xIshaSha7P/73c4uJIeEh9LCIV9h696014eSY=;
        b=Y4tsnVJ+QNyw7Ws09k5gtKCZcKRRamC8FzUqIqTuIEyOPANhFg7pFaeTdZOMc4gzEi
         4LKUMvhAe95qn70nC1X0gjc18Ow2CYIV0vifftvgGe1p2C9LstNxpiHbbZLNur99uaXO
         ZC9hDZxcIOBhARxaDIozTdv/XL0PASos792k2riEkqoojowAnQCnLNLhboqO2C6+uB8f
         qRtIImsaiJ6JxgbFP2tf3W4Zfq/AqtbDX+m0H890V9xjFGMV26fVK9qB0w3cXW65riqL
         oZBsxmxy3uOufkI1mUQ1cOTR4YQLsIstey9uuRPu98XybhQ3Mh9CDbppfx05coJpJrDz
         CHtw==
X-Gm-Message-State: AOAM530XPrKEAESNFsSAMXqLkCuQNg9GLidkfmx8igUPX2h5ZJuCnVIv
        9DdJw5EtTPlkE6JCrPOL+k6JvA==
X-Google-Smtp-Source: ABdhPJw975xdZtFy73BXNqDffuAX0xg4/F4udCpxsEE662P0gVWTk/Y3sjsyhUGgB9jNpu/nvzm/zA==
X-Received: by 2002:ad4:5f0f:0:b0:441:1e3a:dbc with SMTP id fo15-20020ad45f0f000000b004411e3a0dbcmr485180qvb.99.1649092162831;
        Mon, 04 Apr 2022 10:09:22 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b0067afe7dd3ffsm7312292qki.49.2022.04.04.10.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:09:22 -0700 (PDT)
Date:   Mon, 4 Apr 2022 13:09:21 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     lsf-pc@lists.linuxfoundation.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: LSF/MM/BPF: 2022: Call for Proposals VIRTUAL OPTION
Message-ID: <YksmQSfuIx/OiNA8@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a follow up to the original CFP, you can find here

https://lore.kernel.org/all/YfGnDRM%2FPe4jzbSr@localhost.localdomain/

This is for those who have been waiting for a virtual option.  Those plans have
solidified and now we have an actual process we would like you to follow.

IF YOU WANT A VIRTUAL INVITE PLEASE FILL OUT THE GOOGLE FORM AND INDICATE YOU
WOULD LIKE TO ATTEND VIRTUALLY

https://forms.gle/uD5tbZYGpaRXPnE19

The track leaders will send out individual invites for the virtual component of
LSF/MM/BPF.  From there you will register like normal, making sure to select the
virtual option during registration, and then the Linux Foundation will email you
with the connection details closer to the conference.

The virtual component will be hosted on Zoom.  We will attempt to make this as
seamless as possible, but anticipate it being essentially a glorified
live-stream.

Those who already filled out the form indicating you want the virtual option
don't need to re-submit, we've got you on our lists already.  We will be sending
these invites out as quickly as possible as we need to make sure we have an
accurate count for the Linux Foundation.

Thank you on behalf of the program committee:

        Josef Bacik (Filesystems)
        Amir Goldstein (Filesystems)
        Martin K. Petersen (Storage)
        Omar Sandoval (Storage)
        Michal Hocko (MM)
        Dan Williams (MM)
        Alexei Starovoitov (BPF)
        Daniel Borkmann (BPF)
