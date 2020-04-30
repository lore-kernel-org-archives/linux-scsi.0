Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873EDC47247
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 21:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B120214D8
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 21:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgD3VeK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:34:10 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:58935 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgD3VeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 17:34:08 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MekrN-1iw23r0YOj-00apFq; Thu, 30 Apr 2020 23:33:54 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Intel SCU Linux support <intel-linux-scu@intel.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org
Subject: [PATCH 14/15] isci: avoid gcc-10 zero-length-bounds warning
Date:   Thu, 30 Apr 2020 23:30:56 +0200
Message-Id: <20200430213101.135134-15-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7STMyUCnzNFORsOTFhBk+QO1wMd0aCQREYl9i/6g5djgitDUpZ6
 d1Cx+C01pHvqZt+aQoS8ab5L853K/yBtfnhyeugGSlvh7HKQ0PL0VPWymc4AUUryftBYEso
 OUGbikus/NGt12kseU7xwabsGAmxqrTKLyaGQy3cjPJ43HXWsVNNnuwv8J52mfRiGUTqkiy
 p2VouWvfbNWfatj6Qx9KA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bSMgVGjYJbk=:e3OoHoNyVrETSsb4hMOhs/
 AS0ivt9Xcb53jajnQRqZgv28gM4KSUsPE4/o60hKXktudnmPzwv7RW8Kj4AuCquc4xriwDklb
 xKB4Dxt0vhsg9WTFIyTiatKW/x6/E+2Nk8pLmNKGMItbeiWHT43Hwq6qvUgQzpoxRSAtI8K+c
 AbFuuj3Oam60e+HhGtj5h/CXSHXFlomhGukqvM1te61faABhg4P98Ria19e5qoPauXLU31Ir7
 uyL1FS3S/Pki/1dKyCc7sM6Ze1PWMD8JL99fDJsTBP/GpBfhDzFTAdNrCaOkVW4p63C2XUS1b
 csL4aTU4V1v07Popcn2+JRSVN/QvEmL1z9z+73jfAP3H4oshS/HrD1Ttx26cgkbqiV823bAPX
 ZhkZbjdTbcPzcEB/fsZEHN5B27L5aSM9MkkOVUbub1Ihc+pylki8sChmoY4/67R7FSVVwByPd
 J8Nz/BCBgevzfXFncJ4UPzc9CbgwT3Cbu8rokQWb9XVFywpOkgnas+iJg2fL949baMrHLRuV8
 xV3WIiGzMWBZQFDW8Ac3Ix3EbrfgS1K01zPWZNZFeF+3kf+l8QQ9HsgqFXQbOQ6mx+3uwTYYx
 /ol12IcZtrb7B6wpmHD1NPPwpwrDydQTJ8Dn+CHU4DYt3/OjzXb/4/KvoKwHe3/tLjE7iM6pt
 hrd1WgsjuRO9ZM5+aPlpnjsWOH/mx90oUd8XFgynTRngF97dbGjgqqiobJW+pvbZIV5+ZTjc4
 PM8Qk89cI6yabSO1NdqEAs9oCr5xwcoXbbP27xCCOsgQ1TG8rKyt8vvnm4wbtXZwD607vZvx2
 zUHvdw7DVW21QES1ntvMt/CqXvDLFzW6Q3TYBwZKF6Xm0K41d4=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

gcc-10 warns about accesses to zero-length arrays:

drivers/scsi/isci/task.h:125:31: error: array subscript 0 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Werror=zero-length-bounds]
  125 |    tmf->resp.resp_iu.resp_data[0],
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
include/linux/dynamic_debug.h:143:2: note: in expansion of macro '__dynamic_func_call'
  143 |  __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
      |  ^~~~~~~~~~~~~~~~~~~
include/linux/dynamic_debug.h:157:2: note: in expansion of macro '_dynamic_func_call'
  157 |  _dynamic_func_call(fmt,__dynamic_dev_dbg,   \
      |  ^~~~~~~~~~~~~~~~~~
include/linux/dev_printk.h:115:2: note: in expansion of macro 'dynamic_dev_dbg'
  115 |  dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
      |  ^~~~~~~~~~~~~~~
drivers/scsi/isci/task.h:111:3: note: in expansion of macro 'dev_dbg'
  111 |   dev_dbg(&ihost->pdev->dev,
      |   ^~~~~~~
In file included from include/scsi/libsas.h:15,
                 from drivers/scsi/isci/task.c:59:
include/scsi/sas.h:326:9: note: while referencing 'resp_data'
  326 |  u8     resp_data[0];
      |         ^~~~~~~~~

This instance is not a bug, so just work around the warning by
adding a temporary pointer.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/isci/task.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index 8f4531f22ac2..2d556d7b5292 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -98,6 +98,8 @@ struct isci_tmf {
 
 static inline void isci_print_tmf(struct isci_host *ihost, struct isci_tmf *tmf)
 {
+	u8 *resp = tmf->resp.resp_iu.resp_data;
+
 	if (SAS_PROTOCOL_SATA == tmf->proto)
 		dev_dbg(&ihost->pdev->dev,
 			"%s: status = %x\n"
@@ -122,10 +124,7 @@ static inline void isci_print_tmf(struct isci_host *ihost, struct isci_tmf *tmf)
 			tmf->resp.resp_iu.datapres,
 			tmf->resp.resp_iu.status,
 			be32_to_cpu(tmf->resp.resp_iu.response_data_len),
-			tmf->resp.resp_iu.resp_data[0],
-			tmf->resp.resp_iu.resp_data[1],
-			tmf->resp.resp_iu.resp_data[2],
-			tmf->resp.resp_iu.resp_data[3]);
+			resp[0], resp[1], resp[2], resp[3]);
 }
 
 
-- 
2.26.0

