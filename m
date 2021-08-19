Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A38C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 02:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6046B610FA
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 02:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhHSCa5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 22:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhHSCa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 22:30:56 -0400
Received: from mail-vs1-xe62.google.com (mail-vs1-xe62.google.com [IPv6:2607:f8b0:4864:20::e62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D661C061764
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 19:30:21 -0700 (PDT)
Received: by mail-vs1-xe62.google.com with SMTP id h29so795481vsr.7
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 19:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:content-transfer-encoding;
        bh=pqboTJCcAOfo09rbB71PF8zWvy4otzTvc+THnflfZow=;
        b=q+BGyQOl5RzNj1uDZ9EXWbpixem+zUKIhTYzhikP5iNKvM4q+0skpb5SS/Quu68JM9
         Bk0m2J3Qdl6kBnSVvPaUfY9WOa4J15vwcS6Xz/pgurHfJB7UofALtnezfvoFsV2+FKgq
         GbFa8M8N37ReUFrFSpiHOLTd+0bth35R+q4Xm6uwWnfBYgOk9UbTjipWJG6pT7pKyDJ2
         wq+8zatDiTBqR4ho+pWc08A6OmssdXce4k4E6J1GGvqq2iie8jUbz2PWefHRcdQftzf0
         eVpkYW0Yqal57QmDU7IMElCb8dRmaGwqKPHcmq0y0Y4STXaQJPbGfYHcyb4/DjyNE6fz
         dXiw==
X-Gm-Message-State: AOAM533RtEamBpLI6gSotkkRGLTkbGtCSboHQouItHU0ju4EcgBDp4Ri
        uOI8XWLXIc/xdlj9dhO6s1IQC1NT/d+2b56Iy1wsqfLajIyj
X-Google-Smtp-Source: ABdhPJzQ6jgObdXjtEO3ZjgEbcgu59O2EIq8CFX2YU++F2dMAZP465I7ZnniqR4it0bPZaFbuyztQzcfldMi
X-Received: by 2002:a67:6704:: with SMTP id b4mr10727566vsc.6.1629340220051;
        Wed, 18 Aug 2021 19:30:20 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [52.0.43.43])
        by smtp-relay.gmail.com with ESMTPS id g15sm427225uam.2.2021.08.18.19.30.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Aug 2021 19:30:20 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.69.61])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 74B7F30031F7;
        Wed, 18 Aug 2021 19:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1629340218;
        bh=pqboTJCcAOfo09rbB71PF8zWvy4otzTvc+THnflfZow=;
        h=From:To:Cc:Subject:Date:From;
        b=GzmSurSBdHLzTKClk0fzGjZP3Xm3sXzOcxHxp4OzuABBjL/QHClO1jxG+6qhFwOUM
         FAOS14JfOZCmBOziHJZ6kfmslrn4NeKrL2hOWCXtnObfXT80TW3lk0SRM74p+Idf6+
         vfKHrPWeSkqJR9CVv1USn0wPcicFny9pm/Wp5zbwsI8A77WZaNB0cr11wyQxFRz5y4
         Zmy3NqgWYeu0LLWmFEsSHNwqlAejg+03gbNapYxe7LbYuafCIWW6fgh/OnJZ7Y07F+
         0pdQhG/qZJWvTUJkoZF2x1v9imdBBWZn3osGjiQvCjG5R3Ca6yA36GWTHJerI6br7t
         bnw/oXFx2GY5A==
Received: from kevmitch by chmeee with local (Exim 4.94.2)
        (envelope-from <kevmitch@chmeee>)
        id 1mGXot-002MCU-Tt; Wed, 18 Aug 2021 19:30:15 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] lkdtm: update block layer crashpoints
Date:   Wed, 18 Aug 2021 19:29:38 -0700
Message-Id: <20210819022940.561875-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is v2 of https://lkml.org/lkml/2021/8/16/1497.

These patches update the lkdtm crashpoints in the block layer that have been
moved or removed.  In response to feedback, I've renamed the SCSI_DISPATCH_CMD
crashpoint to SCSI_QUEUE_RQ to correspond to the new function that it hooks
into. I have also added a commit to remove IDE_CORE_CP.


