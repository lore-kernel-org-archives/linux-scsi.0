Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915721474A7;
	Fri, 29 Nov 2024 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894820; cv=none; b=snmbHGcFMKCVxq5dg6P8FSxh5q/yEDZfVeb0ffDiHlYTsBOwM2VpljGXwb44qrHaCtx3YXJ0e2q5DFIUFipibN5XQNqm1R3l84Rj3W/bg7qRNGdBpdU3pzvIvdpotVMtn5t3dnmDGNEuAkHlyaZ064QPKYEzQS1dZb6uklZs3lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894820; c=relaxed/simple;
	bh=u47Q1gvKgMH1kh0jdeBwgYwFLlNjhNN70siucFhyyQY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOMXHzyPvD8Fiqsfof/7qYAjrAmQq7tYuD+8AljqUabGA0bw1+F12IyzDjbO7//fFRu6AoVJiguDiZkHXyyb8k/oGIm3XO+mlbIHw/CUyBACGiZSn0H80sFp60Dy+t1wrZ6dnoxagw9tXTVYk0Gpgyb922q31DS107FnSX/iZHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=HTerLWPG; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=n+PHglEY; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="HTerLWPG";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="n+PHglEY"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 65E1AE0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894341; bh=1GHSVwHV8orouQzHEaSSA/svRPRNvDLZ5fteFZvZcMY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=HTerLWPGnZxU8SvHr1CkTd2FXlS8nyiQeu2GXoD+JHj6VQxwcc76uTAL2fLhQjhP7
	 oiSM03GsGtqEv6cPCJ86nHs/DnlgIIe8TsPvDF84w2JzwIrdqwCzmhR4I7tPxm+da4
	 MGxbro7fngdGUD8lhNOGxGHmKeCy5mOz3Qq8JmH0uiLsprdtqR2kd4clt57CgG4twG
	 8A29GCZ6vpyTCNPoUayFS7kvYNv3LTZ5k5G12phiRpXF4HnMIJbGREIaDaZ59oohqp
	 90UCaGi+0P+aJtKJn2Q1QAQkauJJfWylCPoig0Ly0dGVo0hXXW6d+DbH8SIe5Mq0Xr
	 tXqjh7GQH6QsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894341; bh=1GHSVwHV8orouQzHEaSSA/svRPRNvDLZ5fteFZvZcMY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=n+PHglEY0012IhvX0L3pHQIQAYr7rG06nuoh0tqOY1p19iF+6L31IfbR2F8nTDhLv
	 xyfNDPV+1WTDWx7dMqzU+X8UbRUK7wCsmpDuIHY3WsnQWkwu6tQpW2QvsM7mvSNU3A
	 D9IoIv+7pOenGofWoS3C8Fg1XzgEvAkYxF81ZKct1zNlTKwapbKJ3n0ujChh4Uw6S2
	 wnexxhmf6rbBxFT/nbINpikFKpxzRpaKOwx3JJJJQEaXFvwdgMajWuxkKggsT2V6Iy
	 rHVzpbZMFUE7w67iwFli0YKlhPFR6fCaCnKLrgYhfdqSjg5PWBGapg93QjCgXwwESy
	 wQkbfS6hoJzJQ==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 01/10] target: core: Improve SCSI target logs
Date: Fri, 29 Nov 2024 18:30:47 +0300
Message-ID: <20241129153056.6985-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-Exch-05.corp.yadro.com (172.17.10.109) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Introduce a new logging wrapper.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 include/target/target_core_base.h | 92 +++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 97099a5e3f6c..da4c09d3698b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -11,6 +11,98 @@
 
 #define TARGET_CORE_VERSION		"v5.0"
 
+/*
+ * Unified target core logs
+ */
+#define target_sess_log(LVL, SESS, FMT, ...) \
+	pr_##LVL("target " TARGET_PREFIX " (%s -> %d): " FMT, \
+		(SESS)->se_node_acl->initiatorname, \
+		(SESS)->se_tpg->tpg_rtpi, ##__VA_ARGS__)
+
+#define target_cmd_log(LVL, CMD, FMT, ...) \
+	pr_##LVL("target " TARGET_PREFIX " (%s -> %d/%lld): " FMT, \
+		(CMD)->se_sess->se_node_acl->initiatorname, \
+		(CMD)->se_sess->se_tpg->tpg_rtpi, \
+		(CMD)->orig_fe_lun, ##__VA_ARGS__)
+
+#define target_lun_log(LVL, LUN, FMT, ...) \
+	pr_##LVL("target " TARGET_PREFIX " %s_tpg[%hu](%d/%llu): " FMT, \
+		(LUN)->lun_tpg->se_tpg_tfo->fabric_name, \
+		(LUN)->lun_tpg->se_tpg_tfo->tpg_get_tag(LUN->lun_tpg), \
+		(LUN)->lun_tpg->tpg_rtpi, \
+		(LUN)->unpacked_lun, ##__VA_ARGS__)
+
+#define target_log(LVL, FMT, ...) \
+	pr_##LVL("target " TARGET_PREFIX ": " FMT, ##__VA_ARGS__)
+
+#define target_sess_debug(SESS, FMT, ...)  target_sess_log(debug, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_info(SESS, FMT, ...)   target_sess_log(info, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_notice(SESS, FMT, ...) target_sess_log(notice, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_warn(SESS, FMT, ...)   target_sess_log(warn, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_err(SESS, FMT, ...)    target_sess_log(err, SESS, FMT, ##__VA_ARGS__)
+
+#define target_cmd_debug(CMD, FMT, ...)  target_cmd_log(debug, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_info(CMD, FMT, ...)   target_cmd_log(info, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_notice(CMD, FMT, ...) target_cmd_log(notice, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_warn(CMD, FMT, ...)   target_cmd_log(warn, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_err(CMD, FMT, ...)    target_cmd_log(err, CMD, FMT, ##__VA_ARGS__)
+
+#define target_lun_debug(LUN, FMT, ...)  target_lun_log(debug, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_info(LUN, FMT, ...)   target_lun_log(info, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_notice(LUN, FMT, ...) target_lun_log(notice, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_warn(LUN, FMT, ...)   target_lun_log(warn, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_err(LUN, FMT, ...)    target_lun_log(err, LUN, FMT, ##__VA_ARGS__)
+
+#define target_debug(FMT, ...)  target_log(debug, FMT, ##__VA_ARGS__)
+#define target_info(FMT, ...)   target_log(info, FMT, ##__VA_ARGS__)
+#define target_notice(FMT, ...) target_log(notice, FMT, ##__VA_ARGS__)
+#define target_warn(FMT, ...)   target_log(warn, FMT, ##__VA_ARGS__)
+#define target_err(FMT, ...)    target_log(err, FMT, ##__VA_ARGS__)
+
+#define target_sess_debug_ratelimited(SESS, FMT, ...) \
+	target_sess_log(debug_ratelimited, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_info_ratelimited(SESS, FMT, ...) \
+	target_sess_log(info_ratelimited, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_notice_ratelimited(SESS, FMT, ...) \
+	target_sess_log(notice_ratelimited, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_warn_ratelimited(SESS, FMT, ...) \
+	target_sess_log(warn_ratelimited, SESS, FMT, ##__VA_ARGS__)
+#define target_sess_err_ratelimited(SESS, FMT, ...) \
+	target_sess_log(err_ratelimited, SESS, FMT, ##__VA_ARGS__)
+
+#define target_cmd_debug_ratelimited(CMD, FMT, ...) \
+	target_cmd_log(debug_ratelimited, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_info_ratelimited(CMD, FMT, ...) \
+	target_cmd_log(info_ratelimited, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_notice_ratelimited(CMD, FMT, ...) \
+	target_cmd_log(notice_ratelimited, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_warn_ratelimited(CMD, FMT, ...) \
+	target_cmd_log(warn_ratelimited, CMD, FMT, ##__VA_ARGS__)
+#define target_cmd_err_ratelimited(CMD, FMT, ...) \
+	target_cmd_log(err_ratelimited, CMD, FMT, ##__VA_ARGS__)
+
+#define target_lun_debug_ratelimited(LUN, FMT, ...) \
+	target_lun_log(debug_ratelimited, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_info_ratelimited(LUN, FMT, ...) \
+	target_lun_log(info_ratelimited, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_notice_ratelimited(LUN, FMT, ...) \
+	target_lun_log(notice_ratelimited, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_warn_ratelimited(LUN, FMT, ...) \
+	target_lun_log(warn_ratelimited, LUN, FMT, ##__VA_ARGS__)
+#define target_lun_err_ratelimited(LUN, FMT, ...) \
+	target_lun_log(err_ratelimited, LUN, FMT, ##__VA_ARGS__)
+
+#define target_debug_ratelimited(FMT, ...) \
+	target_log(debug_ratelimited, FMT, ##__VA_ARGS__)
+#define target_info_ratelimited(FMT, ...) \
+	target_log(info_ratelimited, FMT, ##__VA_ARGS__)
+#define target_notice_ratelimited(FMT, ...) \
+	target_log(notice_ratelimited, FMT, ##__VA_ARGS__)
+#define target_warn_ratelimited(FMT, ...) \
+	target_log(warn_ratelimited, FMT, ##__VA_ARGS__)
+#define target_err_ratelimited(FMT, ...) \
+	target_log(err_ratelimited, FMT, ##__VA_ARGS__)
+
 /*
  * Maximum size of a CDB that can be stored in se_cmd without allocating
  * memory dynamically for the CDB.
-- 
2.40.3

