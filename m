Return-Path: <SRS0=msWv=XS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB41C3A5A6
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 06:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A52F2087C
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 06:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tf3LoB5A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392277AbfIWGBc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 02:01:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40467 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391243AbfIWGBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2019 02:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569218489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vdX8tdsz8p0cI70eNyOOHHqPsOCERsGcj5XIq8ZYihI=;
        b=Tf3LoB5AcFjrp+t5TCu0UdTg+rCsupYY81c8Vdy7a/NPbVegtjfVI3XuqSaXxLa4VXqfFE
        em+cqeoRE2kwETVEUYLbqqefs85Qbw4IQf3kWpkN5U1PSj8LiB2CnOA1tUlJ5WCOCeWijA
        euzjhkaEl+WHHU9RMj43U2UAtJo64tw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-tEGhy6SpPS6wk-ZiaBOReg-1; Mon, 23 Sep 2019 02:01:28 -0400
Received: by mail-pg1-f200.google.com with SMTP id w13so8715377pge.15
        for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2019 23:01:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=6whaabGHABPeYQY1Y8LH/wuL+jQ1IMXfQogkhGaUTG4=;
        b=JySCmIm3X5oL8dhbI2fjJfzcR+ombDzqz8qIDlxYkf7eqmZYCB/sHoS4SyXsNNmK3l
         zAZ5AMsWvzZovHxFg9Qlhxkve/BxjkvGS/QmEES59qvCAPPO1U9p6FcD9jIIK7EQHgWi
         aEoQekUBPItJzfl8Jj3P8r88MnLVZR+kaWspogzmEz7vFkMlB+vYrWZ0vKlSatQRQQCv
         3bv43H/DrjWSCDv8l5mBDFcMiKF8szmK6oDgvt87wS1eqvsOSTRP9F9nVrdhd08mkwOg
         8rbeT9HEiB2VaKGNCPopuJWiDAGD/JllnZsaOF3G7XCOCc+EymSXzR/wtKW5ZA6mNoAF
         UFQQ==
X-Gm-Message-State: APjAAAVBHPspLLGAFUMxxUegjlYJCvmrUnU9+XiiF0WrzzkMoGdbwoiu
        S2hqLsGbsJBJ2wSIKM04B9iCAfacUTGsd3APB6SMVrqbhRFt3O2lO3aw5vO3wrSEP2EdGn1P5Zo
        YIlrl0iljpVQjd16TH+5OnQ==
X-Received: by 2002:a65:4286:: with SMTP id j6mr28025369pgp.218.1569218487154;
        Sun, 22 Sep 2019 23:01:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyvR4MEfVgME/VvqMT+nE4Yv61JPtHdtmXLPt2MgBFKd99JPBW+AmK8Ul3rDdKdprEPdJMtSw==
X-Received: by 2002:a65:4286:: with SMTP id j6mr28025339pgp.218.1569218486738;
        Sun, 22 Sep 2019 23:01:26 -0700 (PDT)
Received: from machine1 ([125.16.200.50])
        by smtp.gmail.com with ESMTPSA id l72sm14191309pjb.7.2019.09.22.23.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 23:01:26 -0700 (PDT)
Date:   Mon, 23 Sep 2019 11:31:22 +0530
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
Subject: [PATCH] scsi: core: Log SCSI command age with errors
Message-ID: <20190923060122.GA9603@machine1>
MIME-Version: 1.0
User-Agent: Mutt/1.11.3 (2019-02-01)
X-MC-Unique: tEGhy6SpPS6wk-ZiaBOReg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Couple of users had requested to print the SCSI command age along=20
with command failure errors. This is a small change, but allows=20
users to get more important information about the command that was=20
failed, it would help the users in debugging the command failures:

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index ecc5918e372a..ca2182bc53c6 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -437,6 +437,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, con=
st char *msg,
 =09const char *mlret_string =3D scsi_mlreturn_string(disposition);
 =09const char *hb_string =3D scsi_hostbyte_string(cmd->result);
 =09const char *db_string =3D scsi_driverbyte_string(cmd->result);
+=09unsigned long cmd_age =3D (jiffies - cmd->jiffies_at_alloc) / HZ;
=20
 =09logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
 =09if (!logbuf)
@@ -478,10 +479,15 @@ void scsi_print_result(const struct scsi_cmnd *cmd, c=
onst char *msg,
=20
 =09if (db_string)
 =09=09off +=3D scnprintf(logbuf + off, logbuf_len - off,
-=09=09=09=09 "driverbyte=3D%s", db_string);
+=09=09=09=09 "driverbyte=3D%s ", db_string);
 =09else
 =09=09off +=3D scnprintf(logbuf + off, logbuf_len - off,
-=09=09=09=09 "driverbyte=3D0x%02x", driver_byte(cmd->result));
+=09=09=09=09 "driverbyte=3D0x%02x ",
+=09=09=09=09 driver_byte(cmd->result));
+
+=09off +=3D scnprintf(logbuf + off, logbuf_len - off,
+=09=09=09 "cmd-age=3D%lus", cmd_age);
+
 out_printk:
 =09dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
 =09scsi_log_release_buffer(logbuf);

