Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635A5C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375A620684
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="jCteqbHZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfKZUBt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:01:49 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:44909 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfKZUBs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 15:01:48 -0500
Received: by mail-pj1-f65.google.com with SMTP id w8so8769770pjh.11
        for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2019 12:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b4nMYyMZLdJTu1lsp2vJ7LJSFFbPniRCr7vgs74sWbM=;
        b=jCteqbHZIlDVKF77LxJogeNq0ChJQpDzdTb8SfTvrCSoky7CKHFC5o66x3Zac7V8Le
         MEUvAWyMsK6FMcJCKQtGwCCokHpV3OerEo8C0oirA53k+b4rVilYguFTDSJhQZ2Z+neu
         gzViq+zCV8nrResRpHBZTSyXMgC+g7NoK4DFuziDj56v4GXPPhtTczkSSEmUPDWPpMq1
         2mRCJTWA0J/IOK9OqwV9LvDqq47Cu99zA7MaT9Symp+NotD+Yg+yHhdlNFtD7EcwQ60z
         tcXHCUfMGMxyqC8l8J7MIGI5P7js1NCrFu99jSix84tf0ba9h0yWl7xRB4lx81SK8YMM
         qpsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b4nMYyMZLdJTu1lsp2vJ7LJSFFbPniRCr7vgs74sWbM=;
        b=Ywb/V1j7CyRwzPdXrYPpchANkgR0F1DPSmu6XWDXlkrQCABaSF5T18Ey1wCjZ0jpxM
         CRH6DTl1KDBeK3tH/wih8gcp+z1Ih7rkbWmWYtjMKT/jUd38AiTFOYoR9k5/i+uvZZ+I
         6tA7hyXjpwQFw1CJwGOFzSOPt5IQ/D24MXQvAa3p/g6nu7fHvl6nJwgPqUEW3WfKlxfQ
         M04EaqwfCtE0TwbAPd3qJ5haOpOBOt6auQVYAhYQlNs9TcfS8VXsbTl1/5acEUPE9frA
         5sgQ29H0ZhW+BBBkbdrxLhTp+u/f8/xNBEmXkdZ21BMUSDt4kTtBIn+1ZXV0kQ4g9C/P
         OnHw==
X-Gm-Message-State: APjAAAVLNA+ZaE9d9jbFbXPJiJ0kUu+BXqSf7nHnz7m0z5JBvt8YHQA0
        q6DtBfJzRL2qWk48YNoezwYxYQ==
X-Google-Smtp-Source: APXvYqzxZXjLZ+Y0q/kzUzpcJTVYX2YMUaQDISq6yRH+d/E+Tl5Yhl/S5xZe/N5wi80C6h7C9sLD+Q==
X-Received: by 2002:a17:902:b101:: with SMTP id q1mr105469plr.154.1574798506461;
        Tue, 26 Nov 2019 12:01:46 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id u24sm13371114pfh.48.2019.11.26.12.01.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 12:01:45 -0800 (PST)
Subject: Re: [PATCH v4 rebase 00/10] Fix cdrom autoclose
To:     Michal Suchanek <msuchanek@suse.de>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biggers <ebiggers@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>
References: <cover.1574797504.git.msuchanek@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c6fe572c-530e-93eb-d62a-cb2f89c7b4ec@kernel.dk>
Date:   Tue, 26 Nov 2019 13:01:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <cover.1574797504.git.msuchanek@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/19 12:54 PM, Michal Suchanek wrote:
> Hello,
> 
> there is cdrom autoclose feature that is supposed to close the tray,
> wait for the disc to become ready, and then open the device.
> 
> This used to work in ancient times. Then in old times there was a hack
> in util-linux which worked around the breakage which probably resulted
> from switching to scsi emulation.
> 
> Currently util-linux maintainer refuses to merge another hack on the
> basis that kernel still has the feature so it should be fixed there.
> The code needs not be replicated in every userspace utility like mount
> or dd which has no business knowing which devices are CD-roms and where
> the autoclose setting is in the kernel.
> 
> This is rebase on top of current master.
> 
> Also it seems that most people think that this is fix for WMware because
> there is one patch dealing with WMware.

I think the main complaint with this is that it's kind of a stretch to
add core functionality for a device type that's barely being
manufactured anymore and is mostly used in a virtualized fashion. I
think it you could fix this without 10 patches of churn and without
adding a new ->open() addition to fops, then people would be a lot more
receptive to the idea of improving cdrom auto-close.

-- 
Jens Axboe

