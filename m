Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C83DC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Oct 2021 19:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A5261077
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Oct 2021 19:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhJaTod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Oct 2021 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhJaToc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2021 15:44:32 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EA3C061746
        for <linux-scsi@vger.kernel.org>; Sun, 31 Oct 2021 12:42:00 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id h23so2868124ila.4
        for <linux-scsi@vger.kernel.org>; Sun, 31 Oct 2021 12:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hlMJUQ5tJAJOcDvzdSEHB3wKufZfvQwyRD3UIZQHrs0=;
        b=sSQNR/mIOpJrIoZwQgrcNNfoBl4POu1peI6ogutkrDUn63twMz1WQIbOkVamgPDa3I
         lH0znMfnxB1myxGRBoNu0BAnSji9RHsr71VDYElac6ntDzGRt8MfyuIx+EbRz4IEboE6
         fL6DDdEWfv023Caz7D7zMaIXMvHUL1AA589Ex78J2R/K+nJKrVJiy5H6CJm4x5jpnj7a
         L2dAjCQF089fimTwttOAI0mbL62UB3Ua4YNp5smUmIrfRPISkn7mj+nAN3bTho4dZQ0s
         h0fbpDuHkPbBEf8F8+yaIoiSttv3qaAjUlmr0XEGR6A3nVT5Nh1p9X60bfznyq1j+z3i
         nq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hlMJUQ5tJAJOcDvzdSEHB3wKufZfvQwyRD3UIZQHrs0=;
        b=gZ+f8CY3cynjlaevgaYJSpu/1qye6fR1FlLo7gREmCGCRstkNpwpOvtza01xcBg1ZP
         +C+/pYqFp64dSo9f0YMrwghETMj2RlI7OqdbUF0FaPEzDkRM6PDJJe8eOm/LMtzvUspn
         s8ufqvX1i5OueeTdVFHXEHoZmHSpm8qAWwyrQbScdr+HWRws0qUm3FabwiEuH63SHSuk
         xomgk/yNL3TUPehvsCdy80C/hv5GT7yp2obAV1WJzVkI3kLLCJ6L4WNTTw6GvNqAr8Td
         A2ODtJIhLFd8V1E1CDBvqUnsHAFJbh9crw//BpztDhf+ygGsd4qYXVA+wXRjuyUUlAT7
         CznA==
X-Gm-Message-State: AOAM531TRGaMJmCmxECeFqPlqmvE4H4ZxNUih2OSgpEZCgaMky+cBeDw
        0h1qUuEXIwnezKaYTQbAeY552cN0BQ0RpQ==
X-Google-Smtp-Source: ABdhPJw1nPV+gxkmTuviAfalHZOJJVz+PkkASGKVSZWBXZPiC0KlBzQ1EPYSdELUc7oByHEcW2XFqQ==
X-Received: by 2002:a92:c5a1:: with SMTP id r1mr16583691ilt.228.1635709319967;
        Sun, 31 Oct 2021 12:41:59 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id k7sm6431487iob.7.2021.10.31.12.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 12:41:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] SCSI multi-actuator support
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Message-ID: <93d17044-440c-a7f6-45fe-ea804b2a0977@kernel.dk>
Date:   Sun, 31 Oct 2021 13:41:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Linus,

On top of the core block tree, this pull request adds SCSI support for
the recently merged block multi-actuator support. Since this was sitting
on top of the block tree, the SCSI side asked me to queue it up.

Please pull!


The following changes since commit a2247f19ee1c5ad75ef095cdfb909a3244b88aa8:

  block: Add independent access ranges support (2021-10-26 20:36:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.16/scsi-ma-2021-10-29

for you to fetch changes up to 9d824642889823c464847342d6ff530b9eee3241:

  doc: Fix typo in request queue sysfs documentation (2021-10-26 21:01:48 -0600)

----------------------------------------------------------------
for-5.16/scsi-ma-2021-10-29

----------------------------------------------------------------
Damien Le Moal (4):
      scsi: sd: add concurrent positioning ranges support
      libata: support concurrent positioning ranges log
      doc: document sysfs queue/independent_access_ranges attributes
      doc: Fix typo in request queue sysfs documentation

 Documentation/block/queue-sysfs.rst | 33 ++++++++++++++-
 drivers/ata/libata-core.c           | 57 +++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c           | 48 +++++++++++++++++-----
 drivers/scsi/sd.c                   | 81 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h                   |  1 +
 include/linux/ata.h                 |  1 +
 include/linux/libata.h              | 15 +++++++
 7 files changed, 224 insertions(+), 12 deletions(-)

-- 
Jens Axboe

