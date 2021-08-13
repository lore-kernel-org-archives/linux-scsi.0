Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF7CC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E75B6109E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhHMXBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhHMXBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 19:01:16 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D48C061756
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:00:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso13230810pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/tJv56DB72FC6rB3RaeXVGHIdonqg5oZJW3wFcUU3Yk=;
        b=CnITUf/3gVGM0EuKrfLw/m8jxMK+c6gqOMQu1wthZYVOLpBuZFXWz+2M0br0KrRSKQ
         YHEoeRc02HqUcd6iZnsu0k/KsykPJwiVZ79ohtC48tJLBavoIjyT2gQVICGY9pe/bMiO
         M5m4NUOzQ0oYPliwMRf0qSjgfJqwxYRfX5BdzKo6XwOnrIQFtqDQ6HXoBat6HdJNavTE
         RnOQ+0hc4GAxl9vmf7ue+2m80coF6soP9zMPBDUCS6Fsl1WA7Rv4PQAor365diPV4B9h
         skGo5sbxyB0Iozj43m0lNAzdNKeK1+1z5HPuIazIltcQh9qXhKklOkGdNBHkSCzjeAov
         Fftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/tJv56DB72FC6rB3RaeXVGHIdonqg5oZJW3wFcUU3Yk=;
        b=CCjN578CDRFdMieEpD0WQnr8nwXdqqTaOq4vCd2KtI/bCs7keGmo2NJ1HHgziu2VCW
         4ijQa6laWD+NljhF/+4/YUs2uiqXHajwTI5yL0pVtbRVBsoVVEaOH8fiXnEaiCslkb18
         gMZo9ok//BHKkaH7TkanlyI8RQJVlKuymIf8/EV7gjzvuCvobhtu2OVBGFqnSOh2SCyP
         Yg35GVoJ3Q/yW4Br18ixgJfWFajech3cqo42wshjvI0x3JiAQ9JtpiP3gwTqKo74OXb6
         aU63ZNWE8Myk6kAoXnxqnANHnVH3ztYwOh4uUdjCQcZ33/tVg+KprhAnxgqq/b8lavno
         EEOw==
X-Gm-Message-State: AOAM532x7WcB0o+PQ4neb6c/kQNfojx1PW3jTOYU5XBeD1uVyV1o9Iy9
        o2taFYF9VDUyXr3Ak3c4i/1gKwkP8sk=
X-Google-Smtp-Source: ABdhPJymk6gbRCvQIgyzW9pno6qzV2yA/oIWhrTZR52z1J4DFdiL8lV1zBkfBwSsEpFMhItNycIi6A==
X-Received: by 2002:a05:6a00:23ca:b0:3e1:2d8:33f3 with SMTP id g10-20020a056a0023ca00b003e102d833f3mr4187177pfc.42.1628895648635;
        Fri, 13 Aug 2021 16:00:48 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e8sm4001997pgg.31.2021.08.13.16.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 16:00:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/16] lpfc: Update lpfc to revision 14.0.0.1
Date:   Fri, 13 Aug 2021 16:00:23 -0700
Message-Id: <20210813230039.110546-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.0.0.1

This patch set adds support the Congestion Management Framework (CMF)
which a component of Emulex San Manager (ESM). ESM is an inband
monitoring and management solution.  CMF performs congestion monitoring
and adaptive managment with roles split between the adapter and the
driver.

The CMF framework consists of tables and buffers exchanged between
the adapter and the driver. The tables indicate whether congestion is
to be managed, values for management, and congestion statistics. When
fully managed, periodic synchronization occurs between the driver
and the adapter.

The patches were cut against Martin's 5.15/scsi-queue tree

V2:
 Addressed kernel test robot warnings for printk arg types. Substituted
   0x%zx for %ld for sizeof args.

James Smart (16):
  fc: Add EDC ELS definition
  lpfc: Add SET_HOST_DATA mbox cmd to pass date/time info to firmware
  lpfc: Add MIB feature enablement support
  lpfc: Expand FPIN and RDF receive logging
  lpfc: Add EDC ELS support
  lpfc: Add cm statistics buffer support
  lpfc: Add support for cm enablement buffer
  lpfc: add cmfsync WQE support
  lpfc: Add support for the CM framework
  lpfc: Add rx monitoring statistics
  lpfc: Add support for maintaining the cm statistics buffer
  lpfc: Add debugfs support for cm framework buffers
  lpfc: Add cmf_info sysfs entry
  lpfc: Add bsg support for retrieving adapter cmf data
  lpfc: Update lpfc version to 14.0.0.1
  lpfc: Copyright updates for 14.0.0.1 patches

 drivers/scsi/lpfc/lpfc.h         |  252 ++++++
 drivers/scsi/lpfc/lpfc_attr.c    |  226 ++++-
 drivers/scsi/lpfc/lpfc_bsg.c     |   89 ++
 drivers/scsi/lpfc/lpfc_bsg.h     |   10 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |   28 +
 drivers/scsi/lpfc/lpfc_ct.c      |   17 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  223 +++++
 drivers/scsi/lpfc/lpfc_debugfs.h |   11 +-
 drivers/scsi/lpfc/lpfc_els.c     | 1065 ++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   23 +-
 drivers/scsi/lpfc/lpfc_hw.h      |    2 +
 drivers/scsi/lpfc/lpfc_hw4.h     |  249 +++++-
 drivers/scsi/lpfc/lpfc_init.c    | 1402 +++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_logmsg.h  |    5 +-
 drivers/scsi/lpfc/lpfc_mem.c     |   15 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |   44 +-
 drivers/scsi/lpfc/lpfc_nvme.h    |    3 -
 drivers/scsi/lpfc/lpfc_scsi.c    |  187 +++-
 drivers/scsi/lpfc/lpfc_sli.c     |  770 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.h     |    2 +
 drivers/scsi/lpfc/lpfc_sli4.h    |    1 +
 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 include/uapi/scsi/fc/fc_els.h    |  106 +++
 23 files changed, 4618 insertions(+), 114 deletions(-)

-- 
2.26.2

