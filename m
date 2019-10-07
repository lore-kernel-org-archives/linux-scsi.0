Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C97ECE58E
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DDFC2133F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:29:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="FbVL8CFN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbfJGU3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 16:29:11 -0400
Received: from mx3.ucr.edu ([138.23.248.64]:16702 "EHLO mx3.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbfJGU3L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Oct 2019 16:29:11 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 16:29:10 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570480150; x=1602016150;
  h=from:to:cc:subject:date:message-id;
  bh=hr0Akqt2j/UPUDcEP3WW0avFGJ8Jp7+/QzCVG442WG8=;
  b=FbVL8CFNjMXPtFGt3EYzZsvmK7WxmBVg6mnS+VGeaJlE07hbz1cIZGUl
   r04r8CB2mpn/gYM5DHoWttJRtEj0t/jZg9v5t7ec3h6Zgpdw4+nMaO8hm
   SANRwgYjj52kbTvc+ffIoSSoCaYP1/DYmtXtQL+m4//METTQQvbTcmsXm
   6DJKz1tqVZnHyIuEym1evfJUD8DZA6WVFPMe7NgchB5vfj3k75yfNd20/
   Y7TIRorjQ+dfJ+wsPO6uYnZC3GmDyvT5CWH6wWL471WoWQDZWJgeEN1vy
   Qt/eFmitSagC+4dlViFPFdk0Z1Pw6Toew2pFRJ378LvJcc9kQ7BMbYL6+
   w==;
IronPort-SDR: xM/XhAk1UR6HqHWXE1i2uG8/jHkeSSq4QVxxwc+lLbxngTuWPkr/qtBkERYYLOgxq7sjfu3Zbn
 5c8qid7pczsWXoO7jO4irqPxHtzbQ3420kN8zgefNOTCX8gAqUxRIb2H8DPh4AXBCA7+rEEs7p
 H3kWFp509uNMR1grHho/6OtU/W9T3kBof6VLZbYzeKdQEfCQnUArFLUQgoWNBBo7zuIptVz9RW
 RZwGvQZap/54wpfCE3udxxHmuRaJu26nDlesYbctAXIv9YDR9tfEL0ddPUegB7Kj8Pi6knjX+b
 468=
IronPort-PHdr: =?us-ascii?q?9a23=3Ay4j43BZuLJdY8PzcKtV4vvP/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZr82ybnLW6fgltlLVR4KTs6sC17ON9f2/EjVbvN6oizMrSNR0TR?=
 =?us-ascii?q?gLiMEbzUQLIfWuLgnFFsPsdDEwB89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ?=
 =?us-ascii?q?/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL9vIhi6twXcu8sZjYd/JKs8yg?=
 =?us-ascii?q?bCr2dVdehR2W5mP0+YkQzm5se38p5j8iBQtOwk+sVdT6j0fLk2QKJBAjg+PG?=
 =?us-ascii?q?87+MPktR/YTQuS/XQcSXkZkgBJAwfe8h73WIr6vzbguep83CmaOtD2TawxVD?=
 =?us-ascii?q?+/4apnVAPkhSEaPDMi7mrZltJ/g75aoBK5phxw3YjUYJ2ONPFjeq/RZM4WSX?=
 =?us-ascii?q?ZdUspUUSFBB4K8b5AUD+oAO+ZYoJT2qUUXoxCjCwmsBf3gyjtViXTr2aE33f?=
 =?us-ascii?q?gtHQTA0QMnA98DvmjYoMjsOKsOTOy+0a3EwSjDYv9T3zr29YrGfQ07ofyUXb?=
 =?us-ascii?q?x+b9ffx0csGQ3ClVictZDpMimJ2ukXr2SX8+xtXv+vhW49rAFxpyCiycUtio?=
 =?us-ascii?q?jIhoIV11fE/jh+zYc1JNy4SFR0Yd+4HJdMuSyXLJZ2Td84Q21ypik116AGtI?=
 =?us-ascii?q?e9cSMXy5on3wbSZ+Kbf4WM+B7uV+acLS1miH54ZL6znQu+/Eyjx+HkS8W50V?=
 =?us-ascii?q?JHojBbntTCtn0BzQLf58mdRvZ/8Uqs3yuE2RrJ5eFeO080kLLWK5smwrEtiJ?=
 =?us-ascii?q?UeqV/DHirqmEXui6+Wa1kk9vCo6+v5ZrXmoYeRN4puhQH/NqQig9S/AeolPg?=
 =?us-ascii?q?QXUWiX5OCx2b758U32R7VKifI2kq3Hv5zAOcsboau5DxdU0oYl9Rm/Ey+r3M?=
 =?us-ascii?q?oEkXQDNl5IexKKg5L3N13TPPz0F+qzjlCvnTtzwvDJJLzhApHDLnjZl7fheK?=
 =?us-ascii?q?5w6k5dyQoz199f5o5YBq0PLf/oR0/+qMbYAgUnPAOp3ubrEM992Z8GWWKTHq?=
 =?us-ascii?q?+ZN7vfsVuJ5uIpPumNa5YZuC3hJPg+5v7jlmE5mVADcqmzx5cXa263Hu5gI0?=
 =?us-ascii?q?qHZXrgmNABEX0Fvll2YvbtjQizUCxTenH6C7Mu5jg6UNr9JZrIXMagjKHXj3?=
 =?us-ascii?q?TzJYFfem0TUgPEKnzvbYjRHqpRZQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EmBAD8nJtdf8bSVdFmHgEGEoFcC4N?=
 =?us-ascii?q?eTBCNJYYyBosogQmFeoMNhSiBewEIAQEBDAEBLQIBAYRAgl8jNQgOAgMJAQE?=
 =?us-ascii?q?FAQEBAQEFBAEBAhABAQkLCwgnhUKCOimDNQsWFVKBFQEFATUiOYJHAYF2FKJ?=
 =?us-ascii?q?qgQM8jCUziF8BCQ2BSAkBCIEihzWEWYEQgQeBEYNQh2WCRASBOAEBAZUsllQ?=
 =?us-ascii?q?BBgKCEBSBeZMTJ4Q8iT+LQwEtpzECCgcGDyOBMQOCDU0lgWwKgURQEBSQNSE?=
 =?us-ascii?q?zgQiQZAE?=
X-IPAS-Result: =?us-ascii?q?A2EmBAD8nJtdf8bSVdFmHgEGEoFcC4NeTBCNJYYyBosog?=
 =?us-ascii?q?QmFeoMNhSiBewEIAQEBDAEBLQIBAYRAgl8jNQgOAgMJAQEFAQEBAQEFBAEBA?=
 =?us-ascii?q?hABAQkLCwgnhUKCOimDNQsWFVKBFQEFATUiOYJHAYF2FKJqgQM8jCUziF8BC?=
 =?us-ascii?q?Q2BSAkBCIEihzWEWYEQgQeBEYNQh2WCRASBOAEBAZUsllQBBgKCEBSBeZMTJ?=
 =?us-ascii?q?4Q8iT+LQwEtpzECCgcGDyOBMQOCDU0lgWwKgURQEBSQNSEzgQiQZAE?=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="85808314"
Received: from mail-pf1-f198.google.com ([209.85.210.198])
  by smtp3.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2019 13:22:03 -0700
Received: by mail-pf1-f198.google.com with SMTP id p2so11908532pff.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Oct 2019 13:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WiOjGK2UEBGulgrQmuu8TZAB1seQgp4rv89oyowfPPw=;
        b=c3p59NrWYbjiEaUOcNhV/UO51wL+jHTzkC1pkkEeXIKyQoGSAeceiSewbdArJOuuzr
         K/3sgsmT3oHgFRkm+tXym5VniAQ9wB4pCm1mQEubEbPr+SrIAtwjd17towQfB096h7LW
         gasGQ3VMSZD2rCqYIf7ue3RJ6btwtiZIBuq+5j4FAILeY2m+x7ewqtibWCcow3LCx+CP
         8VpMNcWJBRJU2pfNGdoLNOGESaXb1TgnL5msy3w+yEmDXYzEKpsZ0Wv2hzEv7BGPKGKb
         d3w8agZrFK0wHmbNheIssO4OQGlTsXWnYsrRmYLlHOKOp58tfAghsbu8HZpEmGZgOUmJ
         HiWQ==
X-Gm-Message-State: APjAAAVYilwB4naBk/5pfi5bCbkn7JT43x0KBaQ2biIy8p0/fJV/AcM6
        0AbCIyMzVRBNR1ORly45h0kK2odlByHWIZ6uY5mX1rKnU+z3O1nl3PLJF71os51PvPf1wB57biP
        18kf+WF0ic97VQ4EJMx366oE=
X-Received: by 2002:a17:902:14f:: with SMTP id 73mr32102210plb.57.1570479723396;
        Mon, 07 Oct 2019 13:22:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxzujMvcuvfmr8yz99HLunQi0qdiMtJiJpDOd440zlu836xRN4VmA6fByQcRvdMogFrD2OzAQ==
X-Received: by 2002:a17:902:14f:: with SMTP id 73mr32102189plb.57.1570479723072;
        Mon, 07 Oct 2019 13:22:03 -0700 (PDT)
Received: from Yizhuo.cs.ucr.edu (yizhuo.cs.ucr.edu. [169.235.26.74])
        by smtp.googlemail.com with ESMTPSA id h4sm15150797pgg.81.2019.10.07.13.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 13:22:02 -0700 (PDT)
From:   Yizhuo <yzhai003@ucr.edu>
Cc:     Yizhuo <yzhai003@ucr.edu>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi_transport_sas: Potential NULL pointer deference in sas_rphy_match()
Date:   Mon,  7 Oct 2019 13:22:48 -0700
Message-Id: <20191007202249.29830-1-yzhai003@ucr.edu>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Inside function sas_rphy_match(), dev_to_shost() could return NULL,
however, the return value of dev_to_shost() is not checked and
get used. This could potentially be unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
---
 drivers/scsi/scsi_transport_sas.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index ef138c57e2a6..04d83cbc35f2 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1328,6 +1328,8 @@ static int sas_rphy_match(struct attribute_container *cont, struct device *dev)
 	if (!scsi_is_sas_rphy(dev))
 		return 0;
 	shost = dev_to_shost(dev->parent->parent);
+	if (!shost)
+		return 0;
 
 	if (!shost->transportt)
 		return 0;
-- 
2.17.1

