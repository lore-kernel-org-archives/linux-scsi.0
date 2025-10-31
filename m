Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66AB2EC55C
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 09:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904614; cv=none; b=ZuTJMLzHMU4tlIs9TbvEk+6WuydA4g86AajpfdoY5tlzHfTlePdSZzkB4zWzg8u0eWwsULYsyeB15sk6/4yYqD0sHunWPB7nPfBF6xrww55kN4ggmkeXiNGrRQ9GJb66M4Vs74sfXAh4AqsjQa2hihuckDkwKMhCacRY4zEsGN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904614; c=relaxed/simple;
	bh=BYypTgcDigkcBmFHA4laiIndTxEdaEOD4+KOdapMVfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBy+As3YfSBvWXSnSK8qmV0JMUrOabx0LqmUPS9t14JCD6DXWbDchsSXEfANTZlmJlr7Ku6MixhMDO5b76TZNZvbRflyUiqNMRwWKH9/NaB61Fv7gjckxOJlZmzHIL+a3IYBuggWWhF/eF09sP3DP6lSyFjMW/uniA11gz7zUos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Lbiny0kJ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Lbiny0kJ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-470ffbf2150so18269535e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 02:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761904611; x=1762509411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGFmEOvar0Fpd4GQVUBKBaZSe79j0hdehGZvY1C+ml0=;
        b=Lbiny0kJCtAKKB6mGh7KJ47hjBn/r9xsX9FAWQ2Aph1Gaw+HouC+ns4SgiCL+Xd89V
         6Od1Jgpewx5w5ZxVXAjOuCJBfxT3huxuJa5LtJensXAdfti4Dxj17eWdbXO2RTWTbXei
         aaqV4EufcoVZVAhnP9jCaTwPTu/rUbNurc7F/MRDAcYLzjIQJqQUGQW3vh+Anm/nrtio
         T4mrQkF0Uly0A9bl4XO40H+fLjWaj220YIG1Uh5409NLrUM5pn3NZSUMgpoQGidYjASY
         bR1wLGEqAFExy2I1M0qmPsn6BTV7SWXQMEO9bo9RA8iv2VJa3Rk88vePDl31CvPIKgP7
         djPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761904611; x=1762509411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGFmEOvar0Fpd4GQVUBKBaZSe79j0hdehGZvY1C+ml0=;
        b=cp5ZCAQM9P4og75CAdn67berYoi/1wPvLEjQj8vUEka13Fb+ObBQL5wXqTl6edY6x0
         KkxRF/zE9GopqnCF+Kf34aINPB2fioAO8Gq61lsRVQdDrp7QNMJMPAHDtYMTGlBXGKuV
         ZXPLc1ae09NpN95CiDv6/Xr1PaWudlKss6N2uaye2QcHLOLeQIYOb9Xv60A4aMPUxQBX
         EG//MGkwrqoLct6cmf4iTTUGsS82jMcBw8sZ1RoKaR4FoxhRaAH047Yz3D7zIZPaYsPE
         ezj9d2pvUx1P+vY+pCtqyxG/xmgniOI0hfuyD0ZjA25UPHIS7d/pxW9/yNuZIgFPf+wg
         IW7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3QCW0un6AAQpXQY6jgrU+YvMDop6mN+/UlsMnZQY4SYaQhLIpHlfak/Zwwkvmr9uvF5ErGLNL/4Uo@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu/NVxvbRGbiaSuF5+dSAJsJ5v0GNoM8PxSlprUx+WyIDnW3Qc
	HhoDwldULrf3cmtA3E4DuRDLZcu1WjyE9CCM6q0xppAr+uPD72lIfZrb8KZ8KG7/m5w=
X-Gm-Gg: ASbGncsNcz/JqyGzbcGve3AtsbVsUYdaVitrfoGq0Y0nRlVihttHDcCb1byT5p3MHVw
	UE2LoFbG5slgX2BFm1KGjM9QivA/gy6IzlKMIiPJ76K0T8kX/5cnhVvBqmoZAAzawoSTD+kewVG
	O8SQnZ5WxmfBZ9CPayhYZw7aXvqx8nmRvPIz+LZuEAsWwP8Y/Xo25eBoGGj7aXCSTckZO2W0XJT
	1R013/TYkt+Wim6cAmCv+nPSeGz08MCoCVnVQ5QGU4/CYxpzYyp3VlTZoc8wKmdaxWcKaLMBOq0
	7lf6Kz+9oVYgHLoGCl09et+zCL9PcAZAeZ2c4GnoEX41wunrd9exuQd/xVIXnLXzmarE6XXeeN6
	hK8wM0Z1ABSHEKqXz+IipbYXS1R/Srd9yoWe2Zmy4uY1/yMiE0gfthQpk9AbN9fI3KkZJBB4JCh
	gPBMMVaNsvStLebDSE1UehD2xk9qG22a+NQCw=
X-Google-Smtp-Source: AGHT+IHqKtezdLexxMm+hURfDGbndrtBF0wPbPWMF+obXaFM6s3C8AmKAzgO4FIJwhNbgdUfeNWtqQ==
X-Received: by 2002:a05:600c:358f:b0:477:25c0:798c with SMTP id 5b1f17b1804b1-47730175fcfmr31042115e9.20.1761904611156;
        Fri, 31 Oct 2025 02:56:51 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772899fdfbsm81572335e9.4.2025.10.31.02.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:56:50 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/4] scsi: replace use of system_unbound_wq with system_dfl_wq
Date: Fri, 31 Oct 2025 10:56:40 +0100
Message-ID: <20251031095643.74246-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031095643.74246-1-marco.crivellari@suse.com>
References: <20251031095643.74246-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

system_unbound_wq should be the default workqueue so as not to enforce
locality constraints for random work whenever it's not required.

Adding system_dfl_wq to encourage its use when unbound work should be used.

The old system_unbound_wq will be kept for a few release cycles.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/qla2xxx/qla_os.c       | 2 +-
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5ffd94586652..d48d8671c18a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5280,7 +5280,7 @@ void qla24xx_sched_upd_fcport(fc_port_t *fcport)
 	qla2x00_set_fcport_disc_state(fcport, DSC_UPD_FCPORT);
 	spin_unlock_irqrestore(&fcport->vha->work_lock, flags);
 
-	queue_work(system_unbound_wq, &fcport->reg_work);
+	queue_work(system_dfl_wq, &fcport->reg_work);
 }
 
 static
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 743b4c792ceb..ed21c032bbc4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3961,7 +3961,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			list_del_init(&session->sess_list);
 			spin_unlock_irqrestore(&sesslock, flags);
 
-			queue_work(system_unbound_wq, &session->destroy_work);
+			queue_work(system_dfl_wq, &session->destroy_work);
 		}
 		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
-- 
2.51.0

