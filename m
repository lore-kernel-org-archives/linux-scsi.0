Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524A0C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DB012073E
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:17:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Hck6OZJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgFRNRA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:17:00 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.85]:58873 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728657AbgFRNQp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 09:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592486202; i=@ts.fujitsu.com;
        bh=xHb8gU/V2vBuZCfJoHsS/VcJK3etexaOF6lnSwpHx9k=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=Hck6OZJ2pCuRQRVgDOhAJpn87cEkD3NArGABqNE8S3L+s6vyU3IsWpKSRipQg5fdx
         DzYPRmROiyRc1thWZJap7uGvVit0bDN4QSK6BqBmpPb+ylDnHvAogTEI5Devof/6rg
         K1W1+eqy+IPs640g46DjldZR8IZ86q0jVZZyDvEQPsMayQrZcflCXYVeQT1Vx+vej4
         hVXLdYltizp2jyHX+/MfBeQeYyOA+G+B8ZbUo7Of1Jm7yIrUvPt0Au0w+67+GetI3m
         qZlCtLlVt3Q1Zu9DfhTcL4zkMx8ZeUJOn0d1JPhMqzKdpOOomrPfE4svePbjQol/G/
         i3WG/7xXyRp9g==
Received: from [100.112.198.209] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.eu-west-1.aws.symcld.net id C2/D6-29181-A396BEE5; Thu, 18 Jun 2020 13:16:42 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeJIrShJLcpLzFFi42Kxs+EI0bXKfB1
  nML+Rx+LwwjdMFt3Xd7BZzGgLs1h+/B+Txd9JN1gtWpe+ZXJg89g56y67x+OeM2weH5/eYvH4
  vEkugCWKNTMvKb8igTVj56TzjAUT2Coeb7zE3MDYzdrFyMUhJDCZUeL7k8fMEM50Ron9jd+AH
  E4ONgEDiRWT7rOAJEQE1jBKrLwzDyzBLFApcXvrdDBbWMBO4mp3JzuIzSKgKvF43XqgOAcHL1
  B86xchkLCEgLxEx4HJLBMYORcwMqxitEgqykzPKMlNzMzRNTQw0DU0NNI1tDTTNTI01kus0k3
  SSy3VLU8tLtE11EssL9YrrsxNzknRy0st2cQIDI6UgiNXdzB2v/mgd4hRkoNJSZQ3PPF1nBBf
  Un5KZUZicUZ8UWlOavEhRhkODiUJ3gfpQDnBotT01Iq0zBxgoMKkJTh4lER4ZTKA0rzFBYm5x
  ZnpEKlTjMYcL64uXsTMserA9FXMQix5+XmpUuK8+0AmCYCUZpTmwQ2CRdAlRlkpYV5GBgYGIZ
  6C1KLczBJU+VeM4hyMSsK8k0Gm8GTmlcDtewV0ChPQKVrhr0BOKUlESEk1MF2fIKC0oubYk5U
  sPiK2+6QuP0iXzcra9GifhNXSxDuap+R1amamhBepWIXzn5029WGcbNPzVxz2k6Yd6HLadSRN
  esnGLgHZfbFeclGnuye1XyrcVc6uu3Gu4ndD9WvtkkEKj649Di2/O33+Ial3191/K1l95D0Uu
  prNIn/FAw7pyMciAVe3BV70dLs0pYKlee5iDi7hT+9W1PC+mZEtvodb7eJOWSdhnnMX3S2f6R
  +p/xhQnz0z+MK/HS5zNL/UZ1jefvuWgW+z15+qprUqzxu8gtbuPyXO8nPlhqAHETsl+S5+unz
  IRN48p632oc/Df3GXHkVpayxMnnSvxS/C8H9DQN9mRs3ddv+e8MznLVZiKc5INNRiLipOBADw
  RuR/GwMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-4.tower-285.messagelabs.com!1592486201!195518!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 10217 invoked from network); 18 Jun 2020 13:16:42 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-4.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jun 2020 13:16:42 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05IDGfMh015472;
        Thu, 18 Jun 2020 14:16:41 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id D940E20300;
        Thu, 18 Jun 2020 15:16:40 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM
Date:   Thu, 18 Jun 2020 15:16:30 +0200
Message-Id: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This small series of patches consists of:
   [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
   [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range

Together with commit
   8c4e0f212398 scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
these patches fix crashes in tcmu on ARM.

The first patch of this series already was sent some weeks ago
as "PATCH RFC", since it was untested at that time.

Meanwhile I added patch 2 of the series to fix the crash reported in:
   https://github.com/open-iscsi/tcmu-runner/issues/627
   https://bugzilla.kernel.org/show_bug.cgi?id=208045

All three patches together were tested on ARM with kernel
4.19.118 and 5.7.2 (see github issue and bugzilla).

---
v2: sent with a valid subject line.

