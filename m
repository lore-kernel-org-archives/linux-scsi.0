Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B82C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 10:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9170D610A2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 10:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349029AbhICKKV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 06:10:21 -0400
Received: from mail3.swissbit.com ([176.95.1.57]:34742 "EHLO
        mail3.swissbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348987AbhICKKU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2021 06:10:20 -0400
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 8EA27462120;
        Fri,  3 Sep 2021 12:09:19 +0200 (CEST)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 7E0A446211D;
        Fri,  3 Sep 2021 12:09:19 +0200 (CEST)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail3.swissbit.com (Postfix) with ESMTPS;
        Fri,  3 Sep 2021 12:09:19 +0200 (CEST)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Fri, 3 Sep 2021
 12:09:19 +0200
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0792.015; Fri, 3 Sep 2021 12:09:19 +0200
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: AW: [PATCH] sd: sd_open: prevent device removal during sd_open
Thread-Topic: [PATCH] sd: sd_open: prevent device removal during sd_open
Thread-Index: AQHXoAHu4he04cmBqECW8DEEUakoBauRmZAAgAB7+j8=
Date:   Fri, 3 Sep 2021 10:09:18 +0000
Message-ID: <771b391322c142baa6c15db458b81e8d@hyperstone.com>
References: <98bfca4cbaa24462994bcb533d365414@hyperstone.com>,<YTGmyp0kzhVsuk5K@infradead.org>
In-Reply-To: <YTGmyp0kzhVsuk5K@infradead.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.154.1.4]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-8.6.1018-26384.007
X-TMASE-Result: 10--5.980700-10.000000
X-TMASE-MatchedRID: TMsvcu6/L5dbRbA/K/rHzPZvT2zYoYOwMDmYaN/e0lZgDDNFig+GrOVJ
        pKzRFX/CiqKFBc8lvzajhXQGpGiFkXrSP9RtGZYo0wmR34xRQc/5qGeseGYAlIsYz77JTJ+IUAr
        JnwHoG3R+keJMZ3NCNpBi242iWIRSePs/Cx1DJd15zXLXCu83xRfJTYLG2XFvK+euk6MYlDZvIa
        Mtw0Pio4psmNGAE/yp1y6ttzFWrvdMi6dAAjypotMfKJ+BrWfHTJDl9FKHbrkrhioeAJKilQ6UK
        9Ft+LyUNFHfw012zdN/JgN7Aw6tALVQu1GNZ+sisjvNV98mpPM03E8a2eQGboPHZ0sZfvcz0cm+
        1kT6rGJlSUEmQtntakEkNtY/j9YoftwZ3X11IV0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: e8dfb5c0-1be9-4ce3-b84b-f46cbe580018-0-0-200-0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On Thu, Sep 02, 2021 at 01:57:13PM +0000, Christian L?hle wrote:
>> sd and parent devices must not be removed as sd_open checks for events
>> 
>> sd_need_revalidate and sd_revalidate_disk traverse the device path
>> to check for event changes. If during this, e.g. the scsi host is being
>> removed and its resources freed, this traversal crashes.
>> Locking with scan_mutex for just a scsi disk open may seem blunt, but there
>> does not seem to be a more granular option. Also opening /dev/sdX directly
>> happens rarely enough that this shouldn't cause any issues.
>
> Can you please root cause how the device could not be valid, as that
> should not happen?

The device is being removed physically, the driver e.g. uas calls
scsi_remove_host while user-space opens the /dev/sdX.

>>
>> The issue occurred on an older kernel with the following trace:
>> stack segment: 0000 [#1] PREEMPT SMP PTI
>> CPU: 1 PID: 121457 Comm: python3 Not tainted 4.14.238hyLinux #1
>
> .. preferably with a current mainline kernel as things changed a lot
> in this area.

I will, but might take a while to get a setup to reproduce the issue.
(The setup where this occurred actually powerfails the usb device repreatedly.)=
Hyperstone GmbH | Line-Eid-Strasse 3 | 78467 Konstanz
Managing Directors: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

