Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DBBC432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 09:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF82214D9
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 09:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hTyCZYT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504281AbfIXJhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Sep 2019 05:37:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45526 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504261AbfIXJhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2019 05:37:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id u12so734842pls.12;
        Tue, 24 Sep 2019 02:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Fk/UaCgnTILFJleUu498uCJn9UxWpH5XQY4VNGTGDLo=;
        b=hTyCZYT9lVPFMWGnYjJu2Xz8UN2LdOqqKyrJda6baRd7yNK/iH6uG7fd64y30tdysf
         MeHA+qniRDZwlGr1LChPrhIFpTUoNsk+FtQsKjXtzu5XIKTSIr2LBF+F9UTXs7UzApei
         jeDVTZAYtlSLhjNiXln4IrbdbfwZrVmb4j/uWsOBUtIftt0fhkelJn7Wl1B9C7muOIIn
         jdxLrSOfTyson6LWHAyqVG+xJ2mQ4mVCByNqS2XGDdQI0tX6bhsMyQ6u2xq80uImQ6cQ
         7RV0asWl6a6YMeLkQ5gE7bsIaBnoBsSm5sUSQEpsLwEKQmKZUGxj3fH6+VTZqRjNP2H2
         zKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Fk/UaCgnTILFJleUu498uCJn9UxWpH5XQY4VNGTGDLo=;
        b=aB+y2GcvFw39EMFuCpV4KW+BKOLE/xtunw0Is5Zp3gC61vAZ8cAEFzGkTxSohP57VR
         hjumA2Y4H8rS1QKFbI7PCqFhlcjuClAa4y554dvzxAFOYJoUBqN/yjbUOdmyYlqnxn2S
         OV841Y2WQb//0+LClBbb9++Tpowr9y1m+e2fBuqlPDUspu2uAiCfgtDsbU9GEolT9kvT
         SHOu+jzJCbo1bq6uUvqy4CdW6wqCWBBDwmK7ialrKLx5v2+3S/0b5hgFNNPCULHWH2we
         AQUFO3PaG0PDe9bKGi4Glyq+nS20rJ5wTjf97xkxYVWkBYaO7keI8z9nWCHeTL2k8426
         HwWg==
X-Gm-Message-State: APjAAAWBQ1hB5EKyComAbeybhnF8ph+qmj4cxkI3uMWDcq6pa6h8xwEp
        QnvxtTZKHEQDLcwJg+bgc7A=
X-Google-Smtp-Source: APXvYqz9jyTbeCgHh6Wrpcl5zxHoL8/3QLIRqBEQqde29TpxO/32t5v3LWPSJ8raCNs6yEZH98YIEQ==
X-Received: by 2002:a17:902:aa08:: with SMTP id be8mr2244253plb.82.1569317841957;
        Tue, 24 Sep 2019 02:37:21 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id a18sm1435746pgv.5.2019.09.24.02.37.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 02:37:21 -0700 (PDT)
Date:   Tue, 24 Sep 2019 18:37:16 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        varun@chelsio.com, axboe@kernel.dk, davem@davemloft.net,
        austindh.kim@gmail.com
Subject: [PATCH] scsi: libcxgbi: remove unused function to stop warning
Message-ID: <20190924093716.GA78230@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since 'commit fc8d0590d914 ("libcxgbi: Add ipv6 api to driver")' was 
introduced, there is no call to csk_print_port() 
and csk_print_ip() is made.

Hence kernel build with clang complains below message:
   drivers/scsi/cxgbi/libcxgbi.c:2287:19: warning: unused function 'csk_print_port' [-Wunused-function]
   static inline int csk_print_port(struct cxgbi_sock *csk, char *buf)
                          ^
   drivers/scsi/cxgbi/libcxgbi.c:2298:19: warning: unused function 'csk_print_ip' [-Wunused-function]
   static inline int csk_print_ip(struct cxgbi_sock *csk, char *buf)
                        ^
So it had better remove csk_print_port() and csk_print_ip() 
to stop warning.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 3e17af8..0d044c1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2284,34 +2284,6 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *cls_conn,
 }
 EXPORT_SYMBOL_GPL(cxgbi_set_conn_param);
 
-static inline int csk_print_port(struct cxgbi_sock *csk, char *buf)
-{
-	int len;
-
-	cxgbi_sock_get(csk);
-	len = sprintf(buf, "%hu\n", ntohs(csk->daddr.sin_port));
-	cxgbi_sock_put(csk);
-
-	return len;
-}
-
-static inline int csk_print_ip(struct cxgbi_sock *csk, char *buf)
-{
-	int len;
-
-	cxgbi_sock_get(csk);
-	if (csk->csk_family == AF_INET)
-		len = sprintf(buf, "%pI4",
-			      &csk->daddr.sin_addr.s_addr);
-	else
-		len = sprintf(buf, "%pI6",
-			      &csk->daddr6.sin6_addr);
-
-	cxgbi_sock_put(csk);
-
-	return len;
-}
-
 int cxgbi_get_ep_param(struct iscsi_endpoint *ep, enum iscsi_param param,
 		       char *buf)
 {
-- 
2.6.2

