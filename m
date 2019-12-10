Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E35C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 12:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D2E02073B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 12:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="hhBlP788"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLJMq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 07:46:56 -0500
Received: from mout.gmx.net ([212.227.15.15]:54749 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbfLJMqz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 07:46:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1575982008;
        bh=qd6qYQjvAd9VTFlGBK9Mkz5yHOz8UjRTgv5aTL5Cw3Y=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=hhBlP7887M824IbKa7I7yDYEPHAQfH3TMeebNPBLjGWljwdBv2FV/Fm6zl7Of3lBH
         Ollw67OrhmET+Irwo8BLaoU2YYWW5dDQk+jyLfYqQYqH0GKZgQSpFfloOpzKTfFmZU
         QGez7W/yJxwtOfYS+Ylc75lQurXYYAoh1I/8oppI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [172.17.64.14] ([192.166.200.216]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MOA3P-1iP2nZ039V-00OXRx; Tue, 10
 Dec 2019 13:46:48 +0100
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
From:   Arne Jansen <sensille@gmx.net>
Subject: [PATCH] bnx2fc: protect kref_put by tgt_lock
Message-ID: <fca82c66-89cd-58fa-22a3-da628f85d1ff@gmx.net>
Date:   Tue, 10 Dec 2019 13:46:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fzDZQzJWHugSdDAjPOMOchWakvhnamcnXmO126KB0Lus9WTmmDv
 wU/CcPvk4oobHEO7+ENQSuMQImQrWl6OnMTpApcbQgfnSTX5jbD4Eh1P9VK8qDComfZR/L0
 r3cu8P5OnOZJm0QyjWCp6qilcFs9Hu4hjjhp4YYrw+/iPRJtfVAYgbE5k/qFnLKkhKzpIcr
 txc0TMofgOf8U9Y7ZpZDg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QJOTFJrty3g=:oQzq05IhX8fJue3oJP8hQ9
 oYJD/7GfrHZXZDqlYM0GhG5MMKBVKaRkblmk2sF+fu+z1pNJqM1QtagW3pcmsvQmZ42nxV+KP
 n+NKAtqpEb2uJ0sQIzQCFM+/h/cUYRKkESwbRi4J3G8BDteyiBS8+lnMRDuGLVav6+kKp0lO6
 7IDoY+ffkETL4FB2aM9rr/hGY4r4KsBtp5C1BuVw7MWRDLOa43WF+SV+klYoo3rq5N5HITzEH
 diBLNwuu2VM2qWwVK7BO8lqZtYktj/puOJ1gkBWi4yzsC/iY8E5+mQKPx192OWGFRAIHgsf3X
 A1IUCYcGXw2S8/V0Mk67En8/x3nLJo5fZm8mV+8FBiqCNLXHIm47rM+6ZK0bOSqZXm572JTKG
 GgSK3SR8NKs9b2n9fySrE0pzXEVMIvFJcxTimSDTq20UTlJsgnkNwZgVvCyv7WyNKKHiLWuia
 IOB+gtNGamMoWcF/u5s+WEfF1ijYcAjU1CvINIoAJRiAuk66V4csYJ0ZxSDe2ZLvruMM3R9VG
 nfzkRSobJMREula6WVJq8VLrEN3NiQG/mP39dJ3gjMJr8t4NMbu82wqK3WW8utzfoeVpu1V4h
 VD1Z9v+UE1Z/NN1+JmZnMQT2DWxI+V5nbNi7Q/FQ0MaWF+Gutw003yvOKmNsw4AXA1SyIvvbb
 t5KV6jQYNKFUVdyMANrU9T6vt/Tp06wsOke/TybKzj5YVP2EwlsU1iYsHDoshHLJbbmPADkE5
 kSA7vv/P9+NEIlCvgqap3oQYPTiFweCLZ7xpMg3jswsYkLYsRc+gKlCeXNw31YdHepu4/O7DZ
 Y/ceqNrS0l8747AzKgT20K50CarGi0BiZ5kdlzTpuqNvUh1oU1Uo3BgWGKtT2qo+CyfYuUp8Q
 RpENnbNnDGnAZbd9IR3IKusnkcIRsJloEZY/i8WK70TA1zMgxoBMQKzFM1QqfK6Uf0qUbt3w6
 eN+TiPZDuwd9fqcuZLHJ+3c2hfZI93jgQagDjI9GPzF5b8rhOgxb0Gio9FiI6zwKKJp0I0Jni
 /arQAAGz+6J7OAkMpACFCEBJHuG2bbz06rJKL77A5bF/uWk5lLng5u+iVpQfiuYkginq8dKB0
 KBMBEEOuq6mgCOXAGhqsN1cgH6yLsHuDX8DvfSO1X4+Qs272wiUKhaOTBNV26avaYLZpBOtQD
 DRXgfx4KMJ1lOtYSc0R+dIuClTCGHD9fVimjtSpD9shomTmFJrPR3tJdX+zWcCLzFHU3jgBYs
 WwUoUWFalykYf/Tm2HNNNLLA5LYST/oaHgOwsMw8oxgBT7jSHBNa7o5JjEDI=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have seen several kernel warning about list corruptions involving
bnx2fc_cmd.link. Reviewing the locking of this element showed that
in one instance a kref_put on io_req->refcount has been called without
tgt_lock. As the io_req might still be enqueued on a list protected by
this lock, this patch adds it. This was the only call site without it.

Signed-off-by: Arne Jansen <sensille@gmx.net>
=2D--
  drivers/scsi/bnx2fc/bnx2fc_io.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4c8122a82322..d0d465271e5c 100644
=2D-- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1097,6 +1097,9 @@ static int bnx2fc_abts_cleanup(struct bnx2fc_cmd
*io_req)
          */
         time_left =3D wait_for_completion_timeout(&io_req->cleanup_done,
                                                 BNX2FC_FW_TIMEOUT);
+
+       spin_lock_bh(&tgt->tgt_lock);
+
         if (!time_left) {
                 BNX2FC_IO_DBG(io_req, "%s(): Wait for cleanup timed
out.\n",
                               __func__);
@@ -1107,8 +1110,6 @@ static int bnx2fc_abts_cleanup(struct bnx2fc_cmd
*io_req)
                  */
                 kref_put(&io_req->refcount, bnx2fc_cmd_release);
         }
-
-       spin_lock_bh(&tgt->tgt_lock);
         io_req->wait_for_cleanup_comp =3D 0;
         return SUCCESS;
  }
=2D-
2.11.0
