Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA922C47090
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 18:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLFScE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 13:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiLFSbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 13:31:43 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654D045A3A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 10:26:28 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id m15so6859437ilq.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2022 10:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4IgAV0xIyvbwpM5yKjLqn+3xEvTqGQImla8lRmFjooY=;
        b=XJPXSnXYtqzyoEvG44PNoB+1gOv5k1OID8qM6iICUEPJA6HHkW4GMQrQVFvIJqguuk
         OGOdxnwkdbTGq6LjlVM1f27XJb3Ep44/YwPY7wrnw+/rNvpd4qJQuyoESdtuuvrdbeKH
         ao/8ht7AedDebOx4LiMMCtrbO4VSJ9fcjASSJ1g3EIQSvtLkUTsuLqR9ywJ1o5KwBaJb
         lzXZUB7AM29agYXILjmEyFzyjOjplMZHP6+hfWMxHw2ruxJf3CvI95Ue1gc0WcWxWvSo
         40cBJupRlPOhpXVpJVuRyp3hCjx8phcTIXoj8CbVh6dh2SOcqINnjOKbYxcS5XYdHwzg
         XEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4IgAV0xIyvbwpM5yKjLqn+3xEvTqGQImla8lRmFjooY=;
        b=NkbmqlWgq1QAS8P9QiAIxk1r07D7TdOsCKnP7faJRjHe9ARLBKDIoUaGQVtyQZRnrr
         87lgduII1vC6iLfsfCrHVX1e0JgQ60RkTl8TJHFW4Me84kJt8Wmd09+5KDvi01rHwP+k
         oxpJencCc0BOrnd9EYVnqGBE5oloNqVB16s3qsAgr+uJfsiJUqBQnRMT8nCybUDL2+BM
         UhdQNrDG6Nn3+GyRttXBNkU5BDU4mALYWSZatJOqd594dPRYacNOXFByZWArN55PL5lY
         YSrTzikYWCZ3hwHEMDIKSmqID/IOb4ESw0TBRnQIUnxeFXLwl0xG2UPgY9uS64jSYCk9
         AIhg==
X-Gm-Message-State: ANoB5plukmfatcL7hUXKVQ+s4z1lfvINV7OW6oCR+vgitzQuW8gewrd3
        rnXRnAC3QmH4BlQY3ZiB8iB/tYG7xiniV6gpf7hFEA==
X-Google-Smtp-Source: AA0mqf4OFLTHTjVrQA6b2z/UjNJEshTdpsFl+xYEou0s/2/0KkWYoGxGNXdyK9Sb1If+AAfg1/RuRv752BxW7M+hQoM=
X-Received: by 2002:a92:d702:0:b0:302:8a13:6744 with SMTP id
 m2-20020a92d702000000b003028a136744mr31558581iln.52.1670351187587; Tue, 06
 Dec 2022 10:26:27 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y49ucLGtCOtnbM0K@fedora> <20221206113744-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221206113744-mutt-send-email-mst@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Tue, 6 Dec 2022 20:25:50 +0200
Message-ID: <CAJs=3_CfwV=gzgsM=PseLoigzU+CFOXHk=9Sy-SBro5HHn_uhQ@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks,
I will fix it in the next version.
