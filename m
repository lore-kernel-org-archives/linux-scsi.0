Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5DDC43461
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 17:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E9422204
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 17:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cq2i5Du9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgIMRAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 13:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgIMRAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 13:00:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF83EC06174A;
        Sun, 13 Sep 2020 09:59:59 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so9599751pgd.5;
        Sun, 13 Sep 2020 09:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Omc5GUviZXmY9Fz9BCq4ZAvwSSBNWz0aHFjh7JiCaqY=;
        b=Cq2i5Du97qqZ9zymjDh//gocDk6OuGx4PmVS3Xx72RkkIF08zJzcdSB8CQ46x7/Uqq
         Ptidw2bGkNuKFvkBDhwuhJQ29+9mwuhGmw65W1jMa022tWLkCqZUtOhd7qB9IipVgIl8
         49BSGyKnPgUsu/iSpU5dR3TRfK5kNTkuYDjPGkNw1dcgdSFPGhjEeNHclnvicgz57MUN
         2IAlSqknJwKkUc+oh3deU2H4h1QImvn14jwvKz1gyP1C2oc1fudWqHc3FYzVcOB5dd1O
         Z24zAsZef7oOKuwpLcCN6i0T86OvaYh3r5Xk2WYoA02WxQNimvtltr5lAqM5Fw7WLSC1
         CZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Omc5GUviZXmY9Fz9BCq4ZAvwSSBNWz0aHFjh7JiCaqY=;
        b=pO1QGTokn9fP6nzvZsKiomD3MN3rhihWCXXceBbESWS1w+Vdx8Zr2ECrdDd2Dxg5TA
         sugMQUdS7XIbLG4NhF6ouPuZFnV7RTbhHJvkbSNUg9qhH72yFtvt4Jv+dVnhgtPHPjVe
         yz3FMoP3rAxzGY7UArfynxdyNJwX6ljgcbtPiW3wnllg9LmU14bECjpyQqBBJm8SMs6x
         rUMHP6OfA4Tt9IhE1uYJ4ISjaC5oclKT8aD2j2gqw+d6QpkwoBg3Mxpzam16xdNsjExo
         3dk1ncg9XqfjS1II1pkIe+vRMhwHYQ/c8QO+SGFXeoxTuZiyeCeKVKl4cm9P0sEXm0kQ
         VtzQ==
X-Gm-Message-State: AOAM5320kHECuhHHqveq/WaydNMxR8gCwGOX4N48vAdb/V/TKCYPDHY8
        xm9DloufAHxi9VthI2vRDDY=
X-Google-Smtp-Source: ABdhPJz+4c4MuctOfAwI2G1i7KUosHfkY0WgLJ1iZnpv35csZu+oFytF/ciXTmIJ67rs3/q2wvjzDA==
X-Received: by 2002:a63:a05:: with SMTP id 5mr4091629pgk.140.1600016399059;
        Sun, 13 Sep 2020 09:59:59 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id s8sm221929pjn.10.2020.09.13.09.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 09:59:58 -0700 (PDT)
Date:   Sun, 13 Sep 2020 09:59:56 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: Re: [PATCH v3 08/11] Input: hyperv-keyboard: Make ringbuffer at
 least take two pages
Message-ID: <20200913165956.GG1665100@dtor-ws>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-9-boqun.feng@gmail.com>
 <MW2PR2101MB1052688710B98D8C31191A8DD7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052688710B98D8C31191A8DD7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 12, 2020 at 07:37:23PM +0000, Michael Kelley wrote:
> From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 7:35 AM
> 
> > 
> > When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
> > least 2 * PAGE_SIZE: one page for the header and at least one page of
> > the data part (because of the alignment requirement for double mapping).
> > 
> > So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
> > using vmbus_open() to establish the vmbus connection.
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >  drivers/input/serio/hyperv-keyboard.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> 
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Please feel free to merge with the rest of the patches through whatever
tree they will go in.

Thanks.

-- 
Dmitry
