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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E13C00454
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 14:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BA1B20836
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 14:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MoeXIuQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfLJOVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 09:21:18 -0500
Received: from mout.gmx.net ([212.227.15.15]:60369 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbfLJOVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 09:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1575987668;
        bh=l1pRmOq+rpXSKUIG2EqcAf4rtoRv+wFY83lHK/cc0ss=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=MoeXIuQ9aoji2vM/cBGhRbGcw5PFEnIzgr2TGYFbQaKxOIo440i+kinAxB3Vvl6hB
         GQeurd3BVO2tbT8eUtI7n1JVHvj/WPY6QFRgFmN7YXyYZIU6UqHgKaw0symMDuJxGV
         tYQjI3/jvc2kqbvg+7WAKDaYtntIIptftCH5cZZY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [172.17.64.14] ([192.166.200.216]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mkpf3-1hsNwp24qN-00mL6u; Tue, 10
 Dec 2019 15:21:08 +0100
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
From:   Arne Jansen <sensille@gmx.net>
Subject: [PATCH] scsi_lib: ratelimit printk in scsi_prep_state_check
Message-ID: <ed19f704-ed33-66dc-ff37-2f686b66dbd6@gmx.net>
Date:   Tue, 10 Dec 2019 15:21:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kBrkFfIaI15TPM1yAM1i/LI3rFsPSOELhgHQ3tMx16sfCOTd2qm
 unORwUNeOwrhwkrLBt8IhPxtSJIKrR77XZb95as8xDhICmuopXcteJNC4nyQnD6Hxyy0wbN
 XO1Fpa+4Lw4LAhAxn8pz6WpcA5yEOYDuIFxA7lgIvJ5nbqLUsRzFmcmOArAByY9N0Gvezrm
 Wgp6P/7D26r7OZhUAXBAQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tevy09w2tzs=:PerOjC1B7+FXqVAbkGXzJy
 EhAE3G31EvOf6r5xxQEp2YBCIGTd2fDP5Us9C0QvqaahxfKJTnyqORc+XV7BFAf3Z9xukFYpO
 22PQzNXgj16m3i24apJnAu1FCJEUyZGyuh3vnOUK+nr/RtT+rLpvuAZD3cUPhdIttAOB1Zle6
 6H77Jh5Z/VWFlpinUQq8M7Y6MVjUkaCApPXzOZbb2xSL7zxaLOMIDcYLDZs61yvIP4EPKluEH
 V/kYL0k7e37BfcpaHOVjODWOD4IZAxb+WYx8drH3fXNG6qTQlUvH1qmYW+EWU6lIHvXEyLnZX
 GHe6o7ADRqbj179fd72JA0nBgcL7bVG3kL5VrtiItEAz3e5Z7B5jRZ4uuAMX1x6MHEZjAvk3b
 Lec8IkaUwzYvt3iVknGdl+qYz6glnlkoMZrwO8iLcV7gF5I1qAiYHBMKsVeBq3Uj8lIDjAqhz
 WmGEIK1fJRJAIC0+fDNO4TmaUuF83wKKL3Airf2DVJPBjC1y6fQSgVkjaSP3VckluWoJU8Y/b
 RHrN/gbdEnzJRCm2YaaAD+nidvDKXak4BaUFLFjTfb5yltAizUvRE0U7kzMYZymF/kNU+TPys
 f2NDGj8pc8QeLZHq1oe7fuGRD2Rvfv6TBnNAjyDGA785pCBgqRNQFF0T0yhoj/WWTEIsko1UC
 lRnuymy8VJsBC79uJpRuNvmNeP3g4x3Uk8FKvpUF93st8QkE+zMSwba6kjhK4EPs6DB23H+QW
 nlqbF8u29de9vEk0M8O8pYeLcC6Mc/CVUtra7xu1J7UWAgssFBToEK5ecYTIQ25uEEwmuezhi
 MLkAdVacrtryxenistqwBcLLwJB9p+RwtOxFmLJQKIvlTXkR/NP7b3UNZvMK3yUFR000SgZrT
 Rcyzn+QR0Abq9H3CvxPzEezdwJjwdq+rYgc61mlGWK1HRy5Oq0hZSBj3OU86JbEjDjqTXCfuK
 lGHdqtDnya/k7YnzOq0brndMlh1asMehXLl5N2uU0cu7ir0hLRmFumEJTmCxWtznDPzWtM4tj
 VMx5llVEXFYZ+JMx6Xw8AhGhfXw/NHUCVRH5b2xPJH/U8nHH8oqObqfEFyjACyqCKu4GpcF74
 kfSIBof9SCRoFQUde8GciSmBv+8CqEEO/oAkdvYDQyG4BgphIYeKta8T4pwgrfS7+9G1KqBic
 KFr/QIil3PmLRZ8mm3J5m1EMx4la5VCID+wt3YDX1hIkt+tgJ2Bd6NkEdkPAu36hh0tLp1p1j
 wkpXBlgGCzYoiSs9eu/59RKNyzypP6gaKKH2ycCPqsVme52KXP9eJoy8pl3Q=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_prep_state_check is called with the queue_lock held, called from
scsi_internal_device_unblock.
The same lock is also acquired in softirq context from scsi_end_request.
If the output overwhelms the serial console, the machine effectively
comes to a halt, even triggering a hardware watchdog.

This patch ratelimits the output.

Signed-off-by: Arne Jansen <sensille@gmx.net>
=2D--
  drivers/scsi/scsi_lib.c | 14 ++++++++++----
  1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3e7a45d0daca..33432108d6aa 100644
=2D-- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1232,6 +1232,10 @@ static blk_status_t scsi_setup_cmnd(struct
scsi_device *sdev,
  static blk_status_t
  scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
  {
+       static DEFINE_RATELIMIT_STATE(_rs,
+               DEFAULT_RATELIMIT_INTERVAL,
+               DEFAULT_RATELIMIT_BURST);
+
         switch (sdev->sdev_state) {
         case SDEV_OFFLINE:
         case SDEV_TRANSPORT_OFFLINE:
@@ -1240,16 +1244,18 @@ scsi_prep_state_check(struct scsi_device *sdev,
struct request *req)
                  * commands.  The device must be brought online
                  * before trying any recovery commands.
                  */
-               sdev_printk(KERN_ERR, sdev,
-                           "rejecting I/O to offline device\n");
+               if (__ratelimit(&_rs))
+                       sdev_printk(KERN_ERR, sdev,
+                                   "rejecting I/O to offline device\n");
                 return BLK_STS_IOERR;
         case SDEV_DEL:
                 /*
                  * If the device is fully deleted, we refuse to
                  * process any commands as well.
                  */
-               sdev_printk(KERN_ERR, sdev,
-                           "rejecting I/O to dead device\n");
+               if (__ratelimit(&_rs))
+                       sdev_printk(KERN_ERR, sdev,
+                                   "rejecting I/O to dead device\n");
                 return BLK_STS_IOERR;
         case SDEV_BLOCK:
         case SDEV_CREATED_BLOCK:
=2D-
2.11.0
