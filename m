Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFA3EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 03:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjHIDa4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjHIDaz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 23:30:55 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3225AE0
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 20:30:54 -0700 (PDT)
Received: from localhost.localdomain (unknown [39.174.92.167])
        by mail-app3 (Coremail) with SMTP id cC_KCgBHLYoUCNNkDKuEDA--.19823S4;
        Wed, 09 Aug 2023 11:29:24 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     ketan.mukadam@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, michaelc@cs.wisc.edu,
        JBottomley@Parallels.com, jayamohan.kallickal@emulex.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v2] scsi: be2iscsi: Add nla_len check after nla_find
Date:   Wed,  9 Aug 2023 11:29:18 +0800
Message-Id: <20230809032918.767465-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgBHLYoUCNNkDKuEDA--.19823S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1DCw1UZrW3Jw48CryfZwb_yoW8CrWDpa
        4Fg34Ut3s8uF10gF1DJrWIqF1Ygan8ArW7KF43ta4rursI9a4rZFyjga4j9FWDJF93ur13
        XF1FqF1vv34vyrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r48
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
        WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb2g4DUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The previous commit discussed at link
https://lore.kernel.org/all/20230723075938.3713864-1-linma@zju.edu.cn/
adds length checks for the manual parsing loop in
function beiscsi_iface_set_param(..) hence ensures the attribute being
parsed has a valid length.

However, the child function of beiscsi_iface_set_param,
beiscsi_iface_config_ipv4 calls nla_find to locate and parse attributes
ISCSI_NET_PARAM_IPV4_ADDR and ISCSI_NET_PARAM_IPV4_SUBNET. That is, if
these two attributes are placed after the ISCSI_NET_PARAM command, they
can bypass the added check and still cause an out-of-attribute access.

Add extra nla_len checks after those two call sites to nla_find to keep
malformed attributes away.

Fixes: 0e43895ec1f4 ("[SCSI] be2iscsi: adding functionality to change network settings using iscsiadm")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
v1 -> v2: resent because the mail failed to reach public list

 drivers/scsi/be2iscsi/be_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 8aeaddc93b16..acd3e587455b 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -374,7 +374,7 @@ beiscsi_iface_config_ipv4(struct Scsi_Host *shost,
 	case ISCSI_NET_PARAM_IPV4_ADDR:
 		ip = info->value;
 		nla = nla_find(data, dt_len, ISCSI_NET_PARAM_IPV4_SUBNET);
-		if (nla) {
+		if (nla && nla_len(nla) >= sizeof(*info)) {
 			info = nla_data(nla);
 			subnet = info->value;
 		}
@@ -388,7 +388,7 @@ beiscsi_iface_config_ipv4(struct Scsi_Host *shost,
 		 */
 		subnet = info->value;
 		nla = nla_find(data, dt_len, ISCSI_NET_PARAM_IPV4_ADDR);
-		if (nla) {
+		if (nla && nla_len(nla) >= sizeof(*info)) {
 			info = nla_data(nla);
 			ip = info->value;
 		}
-- 
2.17.1

