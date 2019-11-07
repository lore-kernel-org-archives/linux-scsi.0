Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2262CFA372C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 07:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7F9521D6C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 07:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="BED9/AYx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfKGHEj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 02:04:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52008 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfKGHEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 02:04:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id q70so1223803wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 23:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1BWOBnBh3RsSrHmTF9OyTNjqu4CElUB2toH/DiA/qIc=;
        b=BED9/AYxEqSzI3EIPyUatgXBzDzJIxvgb0tT/vCP+uqowsV2RHUg0bX6M8PTiGO66K
         n7MyBQhs7dvtPaFHFKpel/rUchRTLdALNm7Nou59bT7p1fZ0MQGt+lJi3gBhtLgJe2nI
         K2ljk6GK9pXXI9DWK67jD+Edy51V3hkVEHkATxqkphL1L5B/RUdDw8UV9MN6cnC+feiQ
         X1yVn1O0lJ2Qqr7nY1RV8g5jxqtwrGcS1eGKEWk337YlszC44W+AkYRuFLEBO4SJJuv7
         ORRsE2UglZFYFgEQC2tCWXH7/lTb3I9PXK50YxjTCVoF749iSKlHRdTYyRllwY0Nix7R
         cVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1BWOBnBh3RsSrHmTF9OyTNjqu4CElUB2toH/DiA/qIc=;
        b=g3JqQp+WLAvUUv4/iGNNhT2ypSAmnBl46qGlqBRQ8mLlB7/456evW+INBoyG72fIJW
         j994MHyX9qjxbcsiV4/V/iP+Tyd4JDmBhONyOecWBO9vFksOi36PXZjkBadM1JEmiDTP
         fNbO5uzo2zsns9gro8hJww9d2E9In3aAhixVv+K2LP0E5hNY17cNz1ztxVBkExm9jkGR
         HmIyhzr/FKUWqZ+ip93G9xLCwG8K7r4x2E7BtkTgrgqjSMEJCi3yL6BZS6+oUcpGuNDY
         8SuD77k1jvMMDDa5QJ8v1EWKN45d6jQH5LLiVIMjMe0tvrvKx9MHMjgsyqwMX5tXUPU/
         INdw==
X-Gm-Message-State: APjAAAX7DoEIUHlL9f8s/nzbWRIjIvpmpBDFdSOG4a23QyWjBZd5yda9
        96sH1StXEIp/w8Y4pJDkjT2X5g==
X-Google-Smtp-Source: APXvYqw5oCk6xXi6ixLz7jByPs1zY84R0XhXM9pbgD9ZCxKqdl36Geh9BAUevrqz0GAD8gxGpRTXcA==
X-Received: by 2002:a05:600c:254f:: with SMTP id e15mr1260124wma.37.1573110275553;
        Wed, 06 Nov 2019 23:04:35 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id u7sm1508088wre.59.2019.11.06.23.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 23:04:34 -0800 (PST)
Message-ID: <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date:   Thu, 07 Nov 2019 08:04:28 +0100
In-Reply-To: <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
         <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha scritto:
> 
> 
> Please simply try your write tests after doing this:
> 
> echo mq-deadline > /sys/block/<name of your USB
> disk>/queue/scheduler
> 
> And confirm that mq-deadline is selected with:
> 
> cat /sys/block/<name of your USB disk>/queue/scheduler
> [mq-deadline] kyber bfq none

ok, which kernel should I test with this: the fresh git cloned, or the
one just patched with Alan's patch, or doesn't matter which one?

Thanks, and bye,
Andrea

