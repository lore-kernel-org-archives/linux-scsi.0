Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCB6C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 400A260C3E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376817AbhCDAb1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348422AbhCCN4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 08:56:17 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B2C061793
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 05:55:03 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e10so23534569wro.12
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 05:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5YOg5zpUZn68sgiB7/CmxizbcXg6Inaa7h+fkuHr+NU=;
        b=Q++B4VWZxWtKiqGZOTBh7Q0d/9A0phGVBtZ6Tcdb4OivrfT3V4n0KsvoOItbwPg22B
         eZTQxcobUCkgxxpQhiOnUPwwsQn5nBwRoE+k3WqfxZVKFY9QUzku8hGKZrGRskpwzURk
         E5Ounzx8YiqKubHadqCT9jr9p3ukzspXgv7PzPpS4UDG8X4gIV+KbXQ9KHcg9IXAJw63
         UCL5onsn8O1KAKUci0VzlWmxEzyBpCh0XxHnmS8yB8ldQUD1vrBPT733kTGT2Lhnk9Rg
         /IJLSGZaMvFGuHZpxikQ11dPtZqZQ2/uP5/kW5517eYdIOTW/PX+bPcsXFZvVm7dQK3p
         9//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5YOg5zpUZn68sgiB7/CmxizbcXg6Inaa7h+fkuHr+NU=;
        b=dP0Zkr4zM9AeW2mk/OfBSN5on/d0RkkLWrcJC12yG0wuz/ZQnNXk4YGZaCWz/OZ+EN
         toBv8aiG2rhvDWQ5RzD4ZQyXp4689xdZeKe+HNpPQpXRRsCEhw/LnI7kVkA3fk/Jjwrj
         rnpqz9OUETvR+7BeiIsMbltCba5/shySpf2kfBg6Ut4uDiGi+jMuAAd/hRnFncMY7hFu
         prd03yTaDsupNQ2puAYBPhG12OV9FeLBytCKW/uzHV2j1M7QFExXwJobdP4kKjGR7Acd
         LntKHQ4AwiVY+Cp55dwmrG+quDzx4i/cD3GFtvIRGufyENR7OgesYgOkKtIc7j5Vq+K8
         Jd3A==
X-Gm-Message-State: AOAM5312NtAyLrpc3acYOzMMSVn32e1AKFQwY/FwpfWVOX4zSmVHekdV
        PB9WFoFogcx667p0vvDFB1Mvlw==
X-Google-Smtp-Source: ABdhPJx91tE7QNaiOg4lhJlGoG68rNj5C29IKjGEmIu6HFCWZYgTHkJqWzctCL1kV5mftTGxfwRG5A==
X-Received: by 2002:adf:c752:: with SMTP id b18mr4774484wrh.233.1614779702514;
        Wed, 03 Mar 2021 05:55:02 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id p10sm18581441wrw.33.2021.03.03.05.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 05:55:01 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 901401FF7E;
        Wed,  3 Mar 2021 13:55:00 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     linux-kernel@vger.kernel.org
Cc:     maxim.uvarov@linaro.org, joakim.bech@linaro.org,
        ilias.apalodimas@linaro.org, arnd@linaro.org,
        ruchika.gupta@linaro.org, tomas.winkler@intel.com,
        yang.huang@intel.com, bing.zhu@intel.com,
        Matti.Moell@opensynergy.com, hmo@opensynergy.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH  0/5] RPMB internal and user-space API + WIP virtio-rpmb frontend
Date:   Wed,  3 Mar 2021 13:54:55 +0000
Message-Id: <20210303135500.24673-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This is a follow-up to the email I sent last month:

  Subject: RPMB user space ABI
  Date: Thu, 11 Feb 2021 14:07:00 +0000
  Message-ID: <87mtwashi4.fsf@linaro.org>

which attempts to put some concrete flesh on the bones of the proposal
for a new internal kernel API for dealing with RPMB partitions and the
resultant exposed user-space character device API.

It became apparent while implementing a virtio-rpmb backend that the
initial proposed API didn't sit well with a device like virtio-rpmb
which isn't part of a greater device (like eMMC or UFS). It also
exposed the gritty details of the frame format to userspace leaving it
to deal with the complications of creating JDEC frames and calculating
MACs.

The series is based on Thomas' last posting with a bunch of
functionality dropped:

  - no FS/RPMB integration
  - dropped the simulator
  - dropped the sysfs patches

There is a start of a WIP virtio-rpmb front-end however as the initial
discussion should be focused on the proposed APIs I thought it would
be worth posting as an RFC before getting too deep into the weeds of
implementation. The principle changes to the original proposal:

  - frame construction left to device driver

  The differences between UFS/JEDEC/VirtioRPMB are left for the driver
  itself to deal with. This means things like MAC calculation and
  validation also remain the preserve of the low level implementation
  details. This doesn't mean there can't be shared code where
  implementation details are common across several device types.

  - key management uses keyctl()

  This means in theory userspace could interact with the RPMB device
  without having to manage the key itself. This also means you don't
  need to pass as much data about as the kernel internals can just use
  the keyring id with the API to fetch the key when required.

  - user-space interface split across several ioctls

  Now we no longer have multiple command frames going back and forth
  we can have a single structure per ioctl which just contains what is
  needed for the operation in question.

So what do people think? Is it worth pursuing this approach?

I'm certainly intended to complete the virtio-rpmb driver and test it
with my QEMU based vhost-user backend. However I've no direct interest
in implementing the interfaces to real hardware. I leave that to
people who have access to such things and are willing to take up the
maintainer burden if this is merged.


Alex Bennée (5):
  rpmb: add Replay Protected Memory Block (RPMB) subsystem
  char: rpmb: provide a user space interface
  tools rpmb: add RPBM access tool
  rpmb: create virtio rpmb frontend driver [WIP]
  tools/rpmb: simple test sequence

 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 MAINTAINERS                                   |   9 +
 drivers/char/Kconfig                          |   2 +
 drivers/char/Makefile                         |   1 +
 drivers/char/rpmb/Kconfig                     |  28 +
 drivers/char/rpmb/Makefile                    |   9 +
 drivers/char/rpmb/cdev.c                      | 246 +++++++
 drivers/char/rpmb/core.c                      | 431 ++++++++++++
 drivers/char/rpmb/rpmb-cdev.h                 |  17 +
 drivers/char/rpmb/virtio_rpmb.c               | 366 ++++++++++
 include/linux/rpmb.h                          | 173 +++++
 include/uapi/linux/rpmb.h                     |  68 ++
 include/uapi/linux/virtio_ids.h               |   1 +
 include/uapi/linux/virtio_rpmb.h              |  54 ++
 tools/Makefile                                |  14 +-
 tools/rpmb/.gitignore                         |   2 +
 tools/rpmb/Makefile                           |  41 ++
 tools/rpmb/key                                |   1 +
 tools/rpmb/rpmb.c                             | 649 ++++++++++++++++++
 tools/rpmb/test.sh                            |  13 +
 20 files changed, 2121 insertions(+), 5 deletions(-)
 create mode 100644 drivers/char/rpmb/Kconfig
 create mode 100644 drivers/char/rpmb/Makefile
 create mode 100644 drivers/char/rpmb/cdev.c
 create mode 100644 drivers/char/rpmb/core.c
 create mode 100644 drivers/char/rpmb/rpmb-cdev.h
 create mode 100644 drivers/char/rpmb/virtio_rpmb.c
 create mode 100644 include/linux/rpmb.h
 create mode 100644 include/uapi/linux/rpmb.h
 create mode 100644 include/uapi/linux/virtio_rpmb.h
 create mode 100644 tools/rpmb/.gitignore
 create mode 100644 tools/rpmb/Makefile
 create mode 100644 tools/rpmb/key
 create mode 100644 tools/rpmb/rpmb.c
 create mode 100755 tools/rpmb/test.sh

-- 
2.20.1

