Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41763C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 14:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F7FF207FF
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 14:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfLIOpx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 09:45:53 -0500
Received: from ipmail05.adl3.internode.on.net ([150.101.137.13]:33487 "EHLO
        ipmail05.adl3.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727388AbfLIOpx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 09:45:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CV/QCtXe5dAG/sfAFkhkUSKoQCgl2?=
 =?us-ascii?q?GJow5hUiKCySHJAkBPAMBAREBNoN4AoI9OBMSAgcBAQEFBBABAQEyhROGKwE?=
 =?us-ascii?q?FI1YQCAMNCwICHwcCAiE2Bg4FgyKCRwMurCaBMhqFNYJLDWOBSIEOjE+BTD+?=
 =?us-ascii?q?BOAwDEYJMPoQpAQGDLjKCLK17H0MHgjFuBJUPgkKHc4QtA4d1g1gtjS6dKyG?=
 =?us-ascii?q?BWTMaLm8BgxGNQ44hLjSBHxoLixqCMgEB?=
X-IronPort-SPAM: SPAM
Received: from unknown (HELO [100.69.114.178]) ([1.124.236.111])
  by ipmail05.adl3.internode.on.net with ESMTP; 10 Dec 2019 01:15:49 +1030
Date:   Tue, 10 Dec 2019 01:15:46 +1030
User-Agent: K-9 Mail for Android
In-Reply-To: <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net> <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net> <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
From:   Arthur Marsh <arthur.marsh@internode.on.net>
Message-ID: <5E678754-A3E8-46CE-8062-DA717F2C098F@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, I ran the last good kernel with several boot-up, cifs mount, un-mount, shut down cycles without encountering the problem.

After applying the patch from <ronniesahlberg@gmail.com>:

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0ab6b1200288..d2658f51ff60 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1847,7 +1847,8 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
return 0;

- close_shroot(&tcon->crfid);
+ if (tcon->crfid.is_valid)
+ close_shroot(&tcon->crfid);


 to kernel 5.5.0-rc1 I no longer experience the problem.

Regards,

Arthur. 

On 9 December 2019 12:53:02 pm ACDT, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Sun, Dec 8, 2019 at 5:49 PM Arthur Marsh
><arthur.marsh@internode.on.net> wrote:
>>
>> This still happens with 5.5.0-rc1:
>
>Does it happen 100% of the time?
>
>Your bisection result looks pretty nonsensical - not that it's
>impossible (anything is possible), but it really doesn't look very
>likely. Which makes me think maybe it's slightly timing-sensitive or
>something?
>
>Would you mind trying to re-do the bisection, and for each kernel try
>the mount thing at least a few times before you decide a kernel is
>good?
>
>Bisection is very powerful, but if _any_ of the kernels you marked
>good weren't really good (they just happened to not trigger the
>problem), bisection ends up giving completely the wrong answer. And
>with that bisection commit, there's not even a hint of what could have
>gone wrong.
>
>             Linus

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
