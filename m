Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C273C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D61D217F4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgABPAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 10:00:37 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:60753 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgABPAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 10:00:37 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MF3Y8-1iy5eq3Xmi-00FPMR; Thu, 02 Jan 2020 16:00:16 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/22] compat_ioctl: bsg: add handler
Date:   Thu,  2 Jan 2020 15:55:29 +0100
Message-Id: <20200102145552.1853992-12-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20200102145552.1853992-1-arnd@arndb.de>
References: <20200102145552.1853992-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:/v9BoeMw07nWpYw7u0vnyk6+iF7B9Ivx59/dmMOCA43quUma0Cb
 LvLgvdr6nk111g9XSXmi72uMA3v10UdDlFT1nwsCVEGt5vo6q0GP3uEay7CQEp+2Bjxbbej
 b5IDipv+F8eqFr46BmUUI2g8OckLtnPOxuymbLTcB38VCY3+aEVgccCWvTzb1jacfZOgcrF
 Bu9ksi0IpGAWcsPQAVeWA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:iJ1ciBf4Kro=:ulm3L4FFhXfpjGZ9FP2kXX
 GRP7BlD+CAPrLeiwd3yqbkPYqdhqc0xp7s0sA3FbN/gmBxw+t+lTsy/SJYTXKsrrhpByqoheF
 XNkLZkrdKF6VahgIPO4Wlv0JyZd4JbZnebYEPEyTVylSSP44jdggR60kll84/R92BiVUaGhfP
 7H3f+mUkQeJZCo2uisJ9yL3khr7rM0mTRCPX0KzL3okPkjic6cWKN+EVU1EBs9c/fFYlHlBJZ
 R1Ol1e6FWQ2Ka/WINrAq3xpWSapauRQhPdFu3rcc98lfbXV2KYo5W+dn3OW0c38QMnu4gLPnz
 WxIRqTa2QgZgW2p4PMCdxQSKKLKIXvixbeHzbz/TZ8fjZqMgZXVVqE3J7PbYyf1wNdDLdlfFl
 IOee34z5uqxwApJ39i9waQVotAfHaZvgSDZxqjqzfyADFiW+c45Yz76ZD/SnQsWSuI8owcjLJ
 Ihq3f4J5ezbpzkzR1SFk/3DDNLbZlfQLpWWbMaHkh+bIvcn331kmD3GRjQtNXf/mrMXQEgb1S
 GMHSGRGFBW2hwQbOU+icy4JZSEIcIgdLCNXax3Nv0oFO0mgSq5BkfRLE1V6tkKiI/2CN4zU+M
 7OIwKWiL9L2dcDDGRoH1dxkGjADNbVzSiuvPF4kyrVPWzO1zRzTmcVNoi5kK9BTKHOBJmnZKW
 AjZhcEvjyWQhAheRoL/Njj3+miFC/SDyoPIUMJX7bBKkUPxmdAQ8G6z12cfJsnXTU46ZTYeQz
 i5n6UaK6gDbVwv2vV7h+A/sWUzVobF/7R9vBjZcrlv9ztJQNApCXQTJNXR0FU1jZDluas4CtG
 f8PUD3qzSi6YAo/UhTqUVLk2r0jUy/SuDyt7eGYrQFXd+2n3PAW01OzGuVpmqkysmw3U5Pt1R
 /AZ4VVxCvjfMJEIpNo4g==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

bsg_ioctl() calls into scsi_cmd_ioctl() for a couple of generic commands
and relies on fs/compat_ioctl.c to handle it correctly in compat mode.

Adding a private compat_ioctl() handler avoids that round-trip and lets
us get rid of the generic emulation once this is done.

Note that bsg implements an SG_IO command that is different from the
other drivers and does not need emulation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bsg.c b/block/bsg.c
index 833c44b3d458..d7bae94b64d9 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -382,6 +382,7 @@ static const struct file_operations bsg_fops = {
 	.open		=	bsg_open,
 	.release	=	bsg_release,
 	.unlocked_ioctl	=	bsg_ioctl,
+	.compat_ioctl	=	compat_ptr_ioctl,
 	.owner		=	THIS_MODULE,
 	.llseek		=	default_llseek,
 };
-- 
2.20.0

