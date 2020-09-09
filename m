Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52E4C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 06:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3138A21532
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 06:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="hjFoOkkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgIIG50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 02:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgIIG5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 02:57:25 -0400
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0590C061573
        for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2020 23:57:23 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id 0F8E550E277F
        for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2020 09:57:12 +0300 (MSK)
Received: from mxback5q.mail.yandex.net (mxback5q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:b716:ad89])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 08EC5CF40002
        for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2020 09:57:12 +0300 (MSK)
Received: from vla1-00787b9b359d.qloud-c.yandex.net (vla1-00787b9b359d.qloud-c.yandex.net [2a02:6b8:c0d:2915:0:640:78:7b9b])
        by mxback5q.mail.yandex.net (mxback/Yandex) with ESMTP id wzO8VrN1LO-vBdCwwmh;
        Wed, 09 Sep 2020 09:57:12 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1599634632;
        bh=3zKgb8mf59vCRVaCjdzm/1w5Ui3dwA9pSRDp9QvvPUY=;
        h=Subject:From:To:Date:Message-ID;
        b=hjFoOkkfsJlxk8emNDj7MtAqRGh0CP9qPSY9y3XZdDrktkXlrmwrE67ZHTq4ufmPX
         XI8cnS3ftx3rp/t4Ec+VzcFUC5ZGfZuSgz/4RDDnztJUP5RsWpCA0H/VwF7oHVLiZH
         bfHJI6l7vZ7JyNu0TOXeFeMsdWy2qxMszwZ4fRG8=
Authentication-Results: mxback5q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla1-00787b9b359d.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 3Ty8NU3s1k-vBlmWWit;
        Wed, 09 Sep 2020 09:57:11 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     linux-scsi@vger.kernel.org
From:   Dmitry Antipov <dmantipov@yandex.ru>
Subject: Using MPI2_TOOLBOX_BEACON_TOOL from userspace
Message-ID: <2c7f7718-e9a8-3d20-4877-3ee08d132945@yandex.ru>
Date:   Wed, 9 Sep 2020 09:57:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Is it possible to issue MPI2_TOOLBOX_BEACON_TOOL messages from userspace
(doing ioctl() on /dev/mpt3ctl, using sysfs entry, whatever)? I would like
to use this feature to control device LED lights, in the way similar to
LSI's (well, Broadcom's) proprietary 'lsiutil' tool.

As listed by 'lshw', my device is:

description: Serial Attached SCSI controller
product: SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon]
vendor: LSI Logic / Symbios Logic
physical id: 0
bus info: pci@0000:03:00.0
logical name: scsi0
version: 03
width: 64 bits
clock: 33MHz
capabilities: storage pm pciexpress vpd msi msix bus_master cap_list rom
configuration: driver=mpt3sas latency=0
resources: irq:29 ioport:7000(size=256) memory:904c0000-904c3fff memory:90080000-900bffff \
            memory:90000000-9007ffff memory:904c4000-90503fff memory:900c0000-904bffff

Thanks,
Dmitry
