Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F80C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 21:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82BD64EB3
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBRV7E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 16:59:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229620AbhBRV7A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Feb 2021 16:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613685452;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=NssRbP94TC5srIoM+rBsE8Noo9FeHqIvEgyf6HZQRK4=;
        b=Rvb4mXZCpq9NWiv+y6RYiQFr+yFo+5YP/U/kIMTmVzyKIJJB8MlRpEyGHUn5Ff4v8/cd/w
        ELVUGtKfK2RmVRzgw0Yt/IFaf/dkY05vcAnBAzm/9lXjMv3CaYIDhdr8HxkN4FZi3Nacsv
        ADU3Rof4Z6iRktGXHbyzoVvcP8jJPkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-URNHQSXXMP2ZfnAhVbSJ6w-1; Thu, 18 Feb 2021 16:57:30 -0500
X-MC-Unique: URNHQSXXMP2ZfnAhVbSJ6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9289710CE781;
        Thu, 18 Feb 2021 21:57:29 +0000 (UTC)
Received: from [10.10.112.124] (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2FB05C8B4;
        Thu, 18 Feb 2021 21:57:28 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
Subject: BusLogic driver with spurious logical units
Reply-To: tasleson@redhat.com
To:     khalid@gonehiking.org, linux-scsi@vger.kernel.org
Organization: Red Hat
Message-ID: <5a74cc0b-65e7-c5f8-edc5-80746fc38be7@redhat.com>
Date:   Thu, 18 Feb 2021 15:57:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using Virtualbox (6.1.18 r142142) with Buslogic & IDE, I booted a fedora
33 (5.10.15-200.fc33.x86_64) server ISO and I find *many* targets with
size 512 bytes which is incorrect.  To get another data point, I used
same VM and a NetBSD 9.1 ISO and that booted with the expected
configuration.  Although, it still could be a VM hardware model issue.

Expected:
1 80GB IDE disk & CDROM
1 2GB SCSI buslogic attached disk

Found:
1 80GB IDE disk & CDROM
120 512-byte SCSI disks


snippet of dmesg
...
[    2.910331] scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12
September 2013 *****
[    2.910332] scsi: Copyright 1995-1998 by Leonard N. Zubkoff
<lnz@dandelion.com>
[    2.935623] scsi3: Configuring BusLogic Model BT-958D PCI Wide Ultra
SCSI Host Adapter
[    2.935625] scsi3:   Firmware Version: 5.07B, I/O Address: 0xD280,
IRQ Channel: 21/Level
[    2.935626] scsi3:   PCI Bus: 0, Device: 21, Address:
[    2.935627] 0xF0808000,
[    2.935627] Host Adapter SCSI ID: 7
[    2.935628] scsi3:   Parity Checking: Enabled, Extended Translation:
Enabled
[    2.935629] scsi3:   Synchronous Negotiation: Ultra, Wide
Negotiation: Enabled
[    2.935629] scsi3:   Disconnect/Reconnect: Enabled, Tagged Queuing:
Enabled
[    2.935634] scsi3:   Scatter/Gather Limit: 128 of 8192 segments,
Mailboxes: 211
[    2.935635] scsi3:   Driver Queue Depth: 211, Host Adapter Queue
Depth: 192
[    2.935636] scsi3:   Tagged Queue Depth:
[    2.935636] Automatic
[    2.935639] , Untagged Queue Depth: 3
[    2.935639] scsi3:   SCSI Bus Termination: Both Enabled

[    2.939422] Adding 2009084k swap on /dev/zram0.  Priority:100
extents:1 across:2009084k SSFS
[    3.049353] scsi3: *** BusLogic BT-958D Initialized Successfully ***
[    5.106302] RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters,
10737418240 ms ovfl timer
[    5.748255] snd_intel8x0 0000:00:05.0: allow list rate for 1028:0177
is 48000
[    5.839188] scsi host3: BusLogic BT-958D
[    5.839661] scsi host3: scsi scan: INQUIRY result too short (5), using 36
[    5.839663] scsi 3:0:0:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.839723] scsi 3:0:0:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.839788] scsi 3:0:0:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.839875] scsi 3:0:0:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.840351] scsi 3:0:0:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.840723] scsi 3:0:0:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.840929] scsi 3:0:0:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.841139] scsi 3:0:0:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.841213] scsi 3:0:1:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.841274] scsi 3:0:1:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.841329] scsi 3:0:1:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.841378] scsi 3:0:1:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.841425] scsi 3:0:1:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.841974] scsi 3:0:1:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.842047] scsi 3:0:1:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.842494] scsi 3:0:1:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.842555] scsi 3:0:2:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.842704] scsi 3:0:2:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.842837] scsi 3:0:2:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.842933] scsi 3:0:2:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.842993] scsi 3:0:2:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.843050] scsi 3:0:2:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.843164] scsi 3:0:2:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.843600] scsi 3:0:2:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.843870] scsi 3:0:3:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.844043] scsi 3:0:3:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.844202] scsi 3:0:3:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.844321] scsi 3:0:3:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.844394] scsi 3:0:3:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.844457] scsi 3:0:3:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.844536] scsi 3:0:3:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.844740] scsi 3:0:3:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.844799] scsi 3:0:4:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.844851] scsi 3:0:4:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.844915] scsi 3:0:4:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.845640] scsi 3:0:4:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.845776] scsi 3:0:4:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.845833] scsi 3:0:4:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.846214] scsi 3:0:4:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.846285] scsi 3:0:4:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.846349] scsi 3:0:5:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.846410] scsi 3:0:5:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.846466] scsi 3:0:5:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.846517] scsi 3:0:5:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.846566] scsi 3:0:5:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.846626] scsi 3:0:5:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.846681] scsi 3:0:5:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.846736] scsi 3:0:5:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.846792] scsi 3:0:6:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.846843] scsi 3:0:6:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.846906] scsi 3:0:6:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.847436] scsi 3:0:6:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.847494] scsi 3:0:6:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.847549] scsi 3:0:6:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.847596] scsi 3:0:6:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.847659] scsi 3:0:6:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.847723] scsi 3:0:8:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.847785] scsi 3:0:8:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.848173] scsi 3:0:8:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.848226] scsi 3:0:8:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.848325] scsi 3:0:8:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.848389] scsi 3:0:8:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.848445] scsi 3:0:8:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.848498] scsi 3:0:8:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.849166] scsi 3:0:9:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.849220] scsi 3:0:9:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.849991] scsi 3:0:9:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.850055] scsi 3:0:9:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.850274] scsi 3:0:9:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.850380] scsi 3:0:9:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.850477] scsi 3:0:9:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.850602] scsi 3:0:9:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.852462] scsi 3:0:10:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.857171] scsi 3:0:10:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.858541] scsi 3:0:10:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.858661] scsi 3:0:10:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.858762] scsi 3:0:10:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.858864] scsi 3:0:10:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.858958] scsi 3:0:10:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.859020] scsi 3:0:10:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.863336] scsi 3:0:11:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.863438] scsi 3:0:11:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.863536] scsi 3:0:11:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.863793] scsi 3:0:11:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.864117] scsi 3:0:11:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.864224] scsi 3:0:11:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.864388] scsi 3:0:11:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.864485] scsi 3:0:11:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.864567] scsi 3:0:12:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.864812] scsi 3:0:12:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.864879] scsi 3:0:12:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.865400] scsi 3:0:12:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.865509] scsi 3:0:12:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.865770] scsi 3:0:12:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.865865] scsi 3:0:12:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.866851] scsi 3:0:12:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.867193] scsi 3:0:13:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.867312] scsi 3:0:13:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.867417] scsi 3:0:13:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.867660] scsi 3:0:13:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.867719] scsi 3:0:13:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.867824] scsi 3:0:13:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.868226] scsi 3:0:13:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.868328] scsi 3:0:13:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.868420] scsi 3:0:14:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.868507] scsi 3:0:14:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.868599] scsi 3:0:14:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.868653] scsi 3:0:14:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.868733] scsi 3:0:14:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.869178] scsi 3:0:14:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.869311] scsi 3:0:14:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.869378] scsi 3:0:14:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.869472] scsi 3:0:15:0: Direct-Access                 PQ: 0 ANSI: 0
[    5.870097] scsi 3:0:15:1: Direct-Access                 PQ: 0 ANSI: 0
[    5.870849] scsi 3:0:15:2: Direct-Access                 PQ: 0 ANSI: 0
[    5.871028] scsi 3:0:15:3: Direct-Access                 PQ: 0 ANSI: 0
[    5.871138] scsi 3:0:15:4: Direct-Access                 PQ: 0 ANSI: 0
[    5.871229] scsi 3:0:15:5: Direct-Access                 PQ: 0 ANSI: 0
[    5.871319] scsi 3:0:15:6: Direct-Access                 PQ: 0 ANSI: 0
[    5.871744] scsi 3:0:15:7: Direct-Access                 PQ: 0 ANSI: 0
[    5.871998] sd 3:0:0:0: [sdb] Sector size 0 reported, assuming 512.
[    5.872000] sd 3:0:0:0: [sdb] 1 512-byte logical blocks: (512 B/512 B)
[    5.872001] sd 3:0:0:0: [sdb] 0-byte physical blocks
[    5.872026] sd 3:0:0:0: [sdb] Write Protect is off
[    5.872027] sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    5.872051] sd 3:0:0:0: [sdb] Asking for cache data failed
[    5.872052] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[    5.872836] Dev sdb: unable to read RDB block 1
[    5.872838]  sdb: unable to read partition table
[    5.872840] sdb: partition table beyond EOD, enabling native capacity
[    5.872873] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    5.872922] Dev sdb: unable to read RDB block 1
[    5.872923]  sdb: unable to read partition table
[    5.872925] sdb: partition table beyond EOD, truncated
[    5.873051] sd 3:0:0:0: [sdb] Sector size 0 reported, assuming 512.
[    5.873177] sd 3:0:0:1: [sdc] Sector size 0 reported, assuming 512.
[    5.873179] sd 3:0:0:1: [sdc] 1 512-byte logical blocks: (512 B/512 B)
[    5.873180] sd 3:0:0:1: [sdc] 0-byte physical blocks
[    5.873201] sd 3:0:0:0: [sdb] Attached SCSI disk
[    5.873210] sd 3:0:0:1: [sdc] Write Protect is off
[    5.873211] sd 3:0:0:1: [sdc] Mode Sense: 00 00 00 00
[    5.873236] sd 3:0:0:1: [sdc] Asking for cache data failed
[    5.873237] sd 3:0:0:1: [sdc] Assuming drive cache: write through
[    5.873362] Dev sdc: unable to read RDB block 1
[    5.873364]  sdc: unable to read partition table
[    5.873365] sdc: partition table beyond EOD, enabling native capacity
[    5.873405] Dev sdc: unable to read RDB block 1
[    5.873407]  sdc: unable to read partition table
[    5.873408] sdc: partition table beyond EOD, truncated
[    5.873507] sd 3:0:0:1: Attached scsi generic sg3 type 0
[    5.873525] sd 3:0:0:1: [sdc] Sector size 0 reported, assuming 512.
[    5.873594] sd 3:0:0:1: [sdc] Attached SCSI disk'

...

-Tony


