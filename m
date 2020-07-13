Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A8CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0785B20738
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGkgPIEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgGMR4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 13:56:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729681AbgGMR4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 13:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594662978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Je+/HhG/CXRgR2dd3j+j0MT0mdo3H47clbPI1vw1y3s=;
        b=iGkgPIEnHNgv52OzRHtHcUf6Ej0vzruQmc0uZTcmXAN2Hvjxy9oFNtSEuynBeJy3L7/RA9
        ZRckXHQBAFcH1zLrks4nRdeA3Ld1QxwLmjilKj2bAq3KH4FXwUWf/mV7GIrkTKZvDcQdIt
        kLyX2cQzR+TaXx42QRH5qTYjBm9Xnao=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-E3Syr-gQMB-YTIS6XFodvA-1; Mon, 13 Jul 2020 13:56:17 -0400
X-MC-Unique: E3Syr-gQMB-YTIS6XFodvA-1
Received: by mail-qt1-f199.google.com with SMTP id h24so10651230qtk.18
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 10:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=Je+/HhG/CXRgR2dd3j+j0MT0mdo3H47clbPI1vw1y3s=;
        b=GbeDCtdHLj8eEy02pSMvDYoBF1saltOqabvVj6sDpeSVcht/BHTnQ9WA0xfWXEKxQ9
         uhTHca2wF+sP4r7Wq8Kft6kVCu3UHWbxnEExHvVFaHU9XeoXZQmQigSASD+a7tkdIaLz
         rOSjCY6IVC/CIfWJg3tqZse/uo7mIb9ISo/Q1IPQSMRKdZ/JMbSWfnId/Z8GkQr7btUS
         RQ7pqP3FaLUt3fTsoZTTDl7/gvmaXeD2LbxDYoiYXXe5+uRGxfPrTM8O/0U6uefdIP3D
         BTpL9t3gTiGsvqwO57IlBsJjw04nNpAQ7qUI/a2GNvLwf+VoqlqHFcvuNJcK5BsNZ1c5
         MOlA==
X-Gm-Message-State: AOAM532SPmlDdYBt8sMmAn+JqIjrvu8lUWKhaGZAIPW7T2F471NuAhPV
        W4IhJQY65Ztvc1Ad2X/9PxBht3IcPn+uHJ0u9y0kmte3c02s8XVDmOaZ8Fx9xeZl4J6An6bhTHK
        BVmOdqTVeKjJrtxmS9VLhqw==
X-Received: by 2002:ac8:13c9:: with SMTP id i9mr556313qtj.284.1594662976263;
        Mon, 13 Jul 2020 10:56:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvjxX5ZS1v5m2fQrPrd/MDSDdfyqQsjPme+mfhv/vipcbw0a7DiQlMijlhqsZsI+TDza6qrQ==
X-Received: by 2002:ac8:13c9:: with SMTP id i9mr556288qtj.284.1594662975938;
        Mon, 13 Jul 2020 10:56:15 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id k2sm20321752qkf.127.2020.07.13.10.56.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 10:56:15 -0700 (PDT)
Message-ID: <e6d17b5941aab41b77fd0aee446e1df7ee6d79c9.camel@redhat.com>
Subject: qed (qed_int.c) "MFW indication via attention" SPAM every 5 minutes
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     njavali@marvell.com
Date:   Mon, 13 Jul 2020 13:56:14 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello

This issue seems to be due to firmware but its causing customers to be
alarmed.

ul 13 11:50:22 segstorage5 kernel: Linux version 5.8.0-rc4+ (
loberman@segstorage5.cee.lab.eng.bos.redhat.com) (gcc (GCC) 8.3.1
20190311 (Red Hat 8.3.1-3), GNU ld version 2.30-55.el7.2) #1 SMP Mon
Jul 13 10:37:23 EDT 2020

Jul 13 11:50:26 segstorage5 kernel: [qed_int_attentions:1196(sp-0-
5d:00.04)]MFW indication via attention
Jul 13 11:50:26 segstorage5 kernel: [qed_mcp_handle_events:2005(sp-0-
5d:00.04)]Received an MFW message indication but no new message!

Jul 13 11:50:26 segstorage5 kernel: [qed_int_attentions:1196(sp-0-
5d:00.04)]MFW indication via attention
Jul 13 11:50:26 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 11:55:19 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 11:55:19 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 12:00:18 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 12:00:18 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 12:05:18 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 12:05:18 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 12:10:19 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 12:10:19 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention
Jul 13 12:15:18 segstorage5 kernel: [qed_int_attentions:1196(host_3-
0)]MFW indication via attention

I am sending it here too because upstream has the same issue with
latest upstream

This simple patch corrects it but I need Nilesh to weigh in if this is
the right way to stop this.
If he agrees I will sens a patch against upstream.

diff -Nurp linux-3.10.0-
1127.el7.orig/drivers/net/ethernet/qlogic/qed/qed_int.c linux-3.10.0-
1127.el7/drivers/net/ethernet/qlogic/qed/qed_int.c
--- linux-3.10.0-
1127.el7.orig/drivers/net/ethernet/qlogic/qed/qed_int.c	2020-02-18
15:55:13.000000000 -0500
+++ linux-3.10.0-1127.el7/drivers/net/ethernet/qlogic/qed/qed_int.c	
2020-07-13 12:16:50.520069250 -0400
@@ -1135,7 +1135,8 @@ static int qed_int_attentions(struct qed
 			index, attn_bits, attn_acks, asserted_bits,
 			deasserted_bits, p_sb_attn_sw->known_attn);
 	} else if (asserted_bits == 0x100) {
-		DP_INFO(p_hwfn, "MFW indication via attention\n");
+		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR, 
+			"MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");




