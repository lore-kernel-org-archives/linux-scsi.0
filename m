Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113DEC2B9F7
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E05516135F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhE1Sf6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 14:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhE1Sf5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 14:35:57 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56ECC061574
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 11:34:21 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id m190so3186657pga.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 11:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=/yrjBpq1Br+7UVdxCS6pqA32p2k7FVLFCNbQsADfTuc=;
        b=MCmUrHJUxaCJIE9oCl3YWeGHGZef0wnkHvhTTfc5AcHrRavOFR28gAS2+9ZmIT6JvP
         x55deRN6t4LrOWOiqx69ImQ7SA+tYyXrmkFB7KgsLtgKhiqFNpiOD5Bre9E66IOEeXS4
         +NaVGvczwQsQfGWYNAjMKTuuqrSM4cHWa5yVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=/yrjBpq1Br+7UVdxCS6pqA32p2k7FVLFCNbQsADfTuc=;
        b=QNsMkJj2RdXUYwEpEb78mhJAYftJrR152Y/Xt0cSkoKWlxqEUGqKTkttBHfQ343fsM
         JpydO161HItSMMrVPMD0QeXi7Oo3iC89A+104CrjfK2WofpY69ugBWFVGxxeNAl4GVw7
         viYl4g39MxAEWRxbRieEtAJkYbnyBXABlIVtstcJuf4kUcXuHuScxZaeUc6JDEDzndIs
         jbAwFFsWDnXUUe7qVcuo8XK3WrRLBaHLP9jf3en9e37VsKFUn+O0/mrbrsq3DUAElNBn
         +vzTMVWBYfnyutHg/kdwe7rAv/o/Lfg0RFKKR/RLBJ4uyo9yJTPpBAsI8plQu9aGkpkT
         0vpg==
X-Gm-Message-State: AOAM531oSbIpf+2OcpeaqKaQRmn2B8LBzWaIrpG3zDOksGTioVFnPq7S
        0p03PPdi39sIO/lLUES2K97eCxPn01IDQV0KKTWBpjRwPUs2kbkHBkXZHzVRsfpV+bxZQDT9Wb2
        Z8F+29Oi6KxdWDnobqzUTYvXcuh+1uI5Y+gMBFvhzro7JLIoKR9RMtTRc31Xw59RPMVd5t8cRqe
        c8
X-Google-Smtp-Source: ABdhPJxAaRhPNpahk9pauN+EJcR0qiJi8CpjvN4sFMXkCy8Ji14g+qxdCD7N4t9TIlAi49ZwaHZVtA==
X-Received: by 2002:a63:6383:: with SMTP id x125mr10342757pgb.161.1622226860530;
        Fri, 28 May 2021 11:34:20 -0700 (PDT)
Received: from smtpclient.apple ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id i13sm5042570pgg.30.2021.05.28.11.34.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 May 2021 11:34:19 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: [PATCH 1/1]: scsi scsi_dh_alua: don't fail I/O until transition time
 expires
Message-Id: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
Date:   Fri, 28 May 2021 11:34:18 -0700
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not return an error to multipath which will result in a failed path =
until the transition time expires.

The current patch which returns BLK_STS_AGAIN for ALUA transitioning =
breaks the assumptions in our target regarding ALUA states. With that =
change an error is very quickly returned to multipath which in turn =
immediately fails the path. The assumption in that patch seems to be =
that another path will be available for multipath to use. That =
assumption I don=E2=80=99t believe is fair to make since while one path =
is in a transitioning state it is reasonable to assume that other paths =
may also be in non active states.=20

The SPC spec has a note on this:
The IMPLICIT TRANSITION TIME field indicates the minimum amount of time =
in seconds the application client should wait prior to timing out an =
implicit state transition (see 5.15.2.2). A value of zero indicates that =
the implicit transition time is not specified.

In the SCSI ALUA device handler a value of 0 translates to the =
transition time being set to 60 seconds. The current approach of failing =
I/O on the transitioning path in a much quicker time than what is stated =
seems to violate this aspect of the specification.

#define ALUA_FAILOVER_TIMEOUT		60
unsigned long transition_tmo =3D ALUA_FAILOVER_TIMEOUT * HZ;

This patch uses the expiry the same way it is used elsewhere in the =
device handler. Once the transition state is entered keep retrying until =
the expiry value is reached. If that happens, return the error to =
multipath the same way that is currently done with BLK_STS_AGAIN.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>

____
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c86c01bfecdb..8fd4f677f9c9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1395,7 +1395,7 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx =
*hctx, struct list_head *list,
                        break;
                default:
                        errors++;
-                       blk_mq_end_request(rq, ret);
+                       blk_mq_end_request(rq, BLK_STS_IOERR);
                }
        } while (!list_empty(list));
 out:
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c =
b/drivers/scsi/device_handler/scsi_dh_alua.c
index efa8c0381476..dd51200665b9 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -417,13 +417,36 @@ static enum scsi_disposition =
alua_check_sense(struct scsi_device *sdev,
                        /*
                         * LUN Not Accessible - ALUA state transition
                         */
+                       unsigned long expiry =3D 0;
                        rcu_read_lock();
                        pg =3D rcu_dereference(h->pg);
-                       if (pg)
-                               pg->state =3D =
SCSI_ACCESS_STATE_TRANSITIONING;
+                       if (pg) {
+                               if (pg->state !=3D =
SCSI_ACCESS_STATE_TRANSITIONING) {
+                                       unsigned long transition_tmo =3D =
ALUA_FAILOVER_TIMEOUT * HZ;
+                                       pg->state =3D =
SCSI_ACCESS_STATE_TRANSITIONING;
+
+                                       if (pg->transition_tmo)
+                                               transition_tmo =3D =
pg->transition_tmo * HZ;
+                                       pg->expiry =3D =
round_jiffies_up(jiffies + transition_tmo);
+                                       sdev_printk(KERN_INFO, sdev,
+                                               "%s: port group %02x =
expiry set to %lu\n",
+                                               ALUA_DH_NAME, =
pg->group_id, pg->expiry);
+                               }
+                               expiry =3D pg->expiry;
+                       }
+                       rcu_read_unlock();
+                       if (expiry !=3D 0 && time_before_eq(jiffies, =
expiry)) {
+                               alua_check(sdev, false);
+                               return NEEDS_RETRY;
+                       }
+                       rcu_read_lock();
+                       pg =3D rcu_dereference(h->pg);
+                       if (pg && pg->state =3D=3D =
SCSI_ACCESS_STATE_TRANSITIONING)
+                               pg->state =3D =
SCSI_ACCESS_STATE_UNAVAILABLE;
                        rcu_read_unlock();
-                       alua_check(sdev, false);
-                       return NEEDS_RETRY;
+                       sdev_printk(KERN_ERR, sdev,
+                               "%s: transition timeout (expiry %lu) =
exceeded\n",
+                               ALUA_DH_NAME, expiry);
                }
                break;
        case UNIT_ATTENTION:
@@ -1109,7 +1132,7 @@ static blk_status_t alua_prep_fn(struct =
scsi_device *sdev, struct request *req)
        case SCSI_ACCESS_STATE_LBA:
                return BLK_STS_OK;
        case SCSI_ACCESS_STATE_TRANSITIONING:
-               return BLK_STS_AGAIN;
+               return BLK_STS_RESOURCE;
        default:
                req->rq_flags |=3D RQF_QUIET;
                return BLK_STS_IOERR;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 532304d42f00..bdc5d015de77 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -735,9 +735,6 @@ static void scsi_io_completion_action(struct =
scsi_cmnd *cmd, int result)
                                case 0x24: /* depopulation in progress =
*/
                                        action =3D ACTION_DELAYED_RETRY;
                                        break;
-                               case 0x0a: /* ALUA state transition */
-                                       blk_stat =3D BLK_STS_AGAIN;
-                                       fallthrough;
                                default:
                                        action =3D ACTION_FAIL;
                                        break;


Brian Bunker
SW Eng
brian@purestorage.com



