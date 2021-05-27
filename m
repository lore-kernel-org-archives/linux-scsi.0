Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78285C4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 08:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A7C61090
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 08:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhE0IDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 04:03:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54142 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbhE0IDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 04:03:03 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 71FAA218DD;
        Thu, 27 May 2021 08:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622102471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XiaoSC6yYiEgHrMWEHB8sKET+jJd2RbBFq8b0Rhw20A=;
        b=fZP/BjUp3zio0QQ5e/hsVy1rIPFCbD5tneyyzVMWd5dsLDyQOCQ7hFDJl3kdS2HS3KfuoL
        +4eenJEi/A4OkIcUOHO+sqbI5EDgcwZ3x8M2NLalSCgEMMfsNZoQXlzacVDgwMwcASVhKo
        2HFA11aeee8Lmnj/5i6pD1tfopqkbLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622102471;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XiaoSC6yYiEgHrMWEHB8sKET+jJd2RbBFq8b0Rhw20A=;
        b=AVN0AoaaVsTMciS7K2HV1IX6rYmzxRy0vT8f61PLQ10IVXzAS9OtzUhkfX6LFG9l0/S9sj
        9Km1W6lx4RXTedAg==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 62FA511CD8;
        Thu, 27 May 2021 08:01:11 +0000 (UTC)
To:     "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: [LSF/MM/BPF TOPIC] block namespaces
Message-ID: <a189ec50-4c11-9ee9-0b9e-b492507adc1e@suse.de>
Date:   Thu, 27 May 2021 10:01:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I guess it's time to tick off yet another item on my long-term to-do list:

Block namespaces
----------------

Idea is similar to what network already does: allowing each user
namespace to have a different 'view' on the existing block devices.
EG if the admin creates a ramdisk in one namespace this device should
not be visible to other namespaces.
But for me the most important use-case would be qemu; currently the
devices need to be set up in the host, even though the host has no
business touching it as they really belong to the qemu instance. This is
causing quite some irritation eg when this device has LVM or MD metadata
and udev is trying to activate it on the host.

Overall plan is to restrict views of '/dev', '/sys/dev/block' and
'/sys/block' to only present the devices 'visible' for this namespace.
Initially the drivers would keep their global enumeration, but plan is
to make the drivers namespace-aware, too, such that each namespace could
have its own driver-specific device enumeration.

Goal of this topic is to get a consensus on whether block namespaces are
a feature which would find interest, and also to discuss some design
details here:
- Only in certain cases can a namespace be assigned (eg by calling
'modprobe', starting iscsiadm, or calling nvme-cli); how do we handle
devices for which no namespace can be identified?
- Shall we allow for different device enumeration per namespace?
- Into which level should we go with hiding sysfs structures?
  Is blanking out the higher-level interfaces in /dev and /sys/block
  enough?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
