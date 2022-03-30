Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0283DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 10:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242282AbiC3KND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiC3KM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 06:12:56 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D792D15E88F
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 03:11:09 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 481B63F8D4
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 10:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648635068;
        bh=Wr5cnF6Wo1fv2bl+DDbGCAzsAfmDm2PkbazjLBhDedo=;
        h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type;
        b=KR91eHQ/Iq4PhntbNfgQYEPeYNtAY6/MA2IfKb6i7ewDm4HMCExZDHDJ+lCMKrO1O
         8UANu393O7ZhKhDmJjKuWkcsH3KsO77XNhVhxylFiYdfHnGAEddBdUmM3nYqb5LW7m
         Q+LrkhKNTEEjdfYZmtuY73TH9alRX5lSTTH421uLP81PYz4h1M7UZM9v7b0C3ALQYi
         SX9QNGbIL6z0yuJVvhKo+fZXUmWmvTSoZRkTQVFqVSpseRPMy+2x3bck06ptvS7ohY
         6MFUBgNXgUPn9hTu5kSOZotD1PyRMCw+TNAZ2mpIkZOa1qN8iEMUcFdJRIFjmNTSb0
         EkfTmfWdbR3JQ==
Received: by mail-ej1-f70.google.com with SMTP id mm20-20020a170906cc5400b006dfec7725f3so9565070ejb.15
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 03:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Wr5cnF6Wo1fv2bl+DDbGCAzsAfmDm2PkbazjLBhDedo=;
        b=i+ECnO1dUzpUBa2o57RRtmfSjIRSfXf6T+UjMrF/aXrjSJn9yyFl+yOsGFGspEQGkB
         ClYl76r0kYhn64mpgaw5qsl3aRSSe46OoNo9GrA7jlc1n6l6ymbC6JpnCrKrvvQ5HcTv
         Tx76cMyKx7UTM9hW5Gw2AnBQF/itvt5YvXl6IoN4wj4PWWmEhos6p2GxMaE9l+hOth/Z
         7rYoONZAdvg8ZKzaTu+vf1ArSL3m5RGi+rtC/gPGiz5m0XH4FyCSZvj4x/0EtiZwjfOz
         3kXDjPEBlbaXQxsTFHqR4S6IGlvyxB/42/wlNKZJIvgIsC7tBehtjX872l7X3k7bxGnL
         nZOA==
X-Gm-Message-State: AOAM532vu/wBXWCu5oLbdA7AVEceoVO9Ezsb0cLPslZOIAZXCppArg/j
        BWd9QwVqwANU3p1AATgtemWNOZ9WBH/V02Kp5nnCIwC0DAdsgCXrPbpY5bUlg82i01ZOhM3dDxC
        9Hogr3jtGQquxMFZlzOmfB82ZeODtGeGYxkosbTU=
X-Received: by 2002:a17:907:16a2:b0:6e0:dc75:eb5a with SMTP id hc34-20020a17090716a200b006e0dc75eb5amr23623720ejc.508.1648635067975;
        Wed, 30 Mar 2022 03:11:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrtp+ahE3zPsf6Vc6tKusbmMySKU3iBqHiDdu0z06iIgdQGERPeTc0fRaFx53ZEIF98lJPQQ==
X-Received: by 2002:a17:907:16a2:b0:6e0:dc75:eb5a with SMTP id hc34-20020a17090716a200b006e0dc75eb5amr23623705ejc.508.1648635067731;
        Wed, 30 Mar 2022 03:11:07 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c1b6])
        by smtp.gmail.com with ESMTPSA id o17-20020a056402439100b0041938757232sm9797742edc.17.2022.03.30.03.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 03:11:07 -0700 (PDT)
Date:   Wed, 30 Mar 2022 12:11:06 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Martin Wilck <martin.wilck@suse.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: filesystem corruption with "scsi: core: Reallocate device's budget
 map on queue depth change"
Message-ID: <YkQsumJ3lgGsagd2@arighi-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

after this commit I'm experiencing some filesystem corruptions at boot
on a power9 box with an aacraid controller.

At the moment I'm running a 5.15.30 kernel; when the filesystem is
mounted at boot I see the following errors in the console:

Begin: Will now check root file system ... fsck from util-linux 2.36.1
[/usr/sbin/fsck.ext4 (1) -- /dev/sda2] fsck.ext4 -a -C0 /dev/sda2 
root: clean, 99646/122101760 files, 11187342/488376336 blocks
done.
[    4.636613] sd 0:2:0:0: [sda] tag#257 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.636655] sd 0:2:0:0: [sda] tag#257 CDB: Read(10) 28 00 00 00 4c 10 00 00 08 00
[    4.636689] blk_update_request: I/O error, dev sda, sector 19472 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.636734] sd 0:2:0:0: [sda] tag#258 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.636772] sd 0:2:0:0: [sda] tag#258 CDB: Read(10) 28 00 00 00 4c 18 00 00 08 00
[    4.636796] blk_update_request: I/O error, dev sda, sector 19480 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.636840] sd 0:2:0:0: [sda] tag#260 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.636877] sd 0:2:0:0: [sda] tag#260 CDB: Read(10) 28 00 00 00 4c 28 00 00 08 00
[    4.636901] blk_update_request: I/O error, dev sda, sector 19496 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.636944] sd 0:2:0:0: [sda] tag#259 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.636971] sd 0:2:0:0: [sda] tag#259 CDB: Read(10) 28 00 00 00 4c 20 00 00 08 00
[    4.637005] blk_update_request: I/O error, dev sda, sector 19488 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.637049] sd 0:2:0:0: [sda] tag#262 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.637085] sd 0:2:0:0: [sda] tag#262 CDB: Read(10) 28 00 00 00 4c 38 00 00 08 00
[    4.637118] blk_update_request: I/O error, dev sda, sector 19512 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.637161] sd 0:2:0:0: [sda] tag#264 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.637197] sd 0:2:0:0: [sda] tag#264 CDB: Read(10) 28 00 00 00 4c 48 00 00 08 00
[    4.637221] blk_update_request: I/O error, dev sda, sector 19528 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.637270] sd 0:2:0:0: [sda] tag#284 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.637306] sd 0:2:0:0: [sda] tag#284 CDB: Read(10) 28 00 00 00 4c e8 00 00 08 00
[    4.637332] blk_update_request: I/O error, dev sda, sector 19688 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.637375] sd 0:2:0:0: [sda] tag#286 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.637411] sd 0:2:0:0: [sda] tag#286 CDB: Read(10) 28 00 00 00 4c f8 00 00 08 00
[    4.637444] blk_update_request: I/O error, dev sda, sector 19704 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.637481] blk_update_request: I/O error, dev sda, sector 19664 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.637485] sd 0:2:0:0: [sda] tag#282 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.637487] sd 0:2:0:0: [sda] tag#287 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    4.637491] sd 0:2:0:0: [sda] tag#287 CDB: Read(10) 28 00 00 00 4d 00 00 00 08 00
[    4.637491] sd 0:2:0:0: [sda] tag#282 CDB: Read(10) 28 00 00 00 4c d8 00 00 08 00
[    4.637494] blk_update_request: I/O error, dev sda, sector 19672 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[    4.747771] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.

If I reboot multiple times fsck requires a manual fix and I get dropped
to the initramfs shell. Some times the filesystem gets corrupted and I
need to redeploy the box.

If I use the same kernel with this commit reverted I can reboot as many
times as I want without any failure:

 813c6871f76b ("scsi: core: Reallocate device's budget map on queue depth change")

For now I've just reverted the commit, but I'll try to add some
debugging and collect more info.

Let me know if there's any specific test that you want me to try.

Thanks,
-Andrea
