Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0018435677E
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792243856; cv=none; b=kX6A3mM/2OGTNzBUYO5+yJhSj/G/Ev6WHpsezTUhEBSIHhMHeNouCDDggCQ3g2xKW2SrE4snh7d/25ocAqeKHeCQA87RRvIMZ8b9Ro2VPlOupDvsLWB+56Tzsg3CzuiokrXvesDXMDxIL+U4zmnuy87tRcABQnc0uSHHXkS0ld0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792243856; c=relaxed/simple;
	bh=FQMJxj30Jbh8Y1kO8a4BCGr9W3VcLELopHi5oh2lXiU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mw0s/bXqyvtox2zJqYgI8DONpl3xRdUAkzBD0AB9qTrIoFmXVzwbt8GzwaDJyoBORPd5ZhPUSYRW+KK7rKNz4mxdJ2nVgfg/NvNjdcSQMbZWXGJqxlKIbeGHmdRmzfQ+XNx/Rvicz0CtbjRiKG8na3NEf0ZMjdcyl9hnQnNnDlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZZ/9JNdv; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZ/9JNdv"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so594695a91.1
        for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 06:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792243852; x=1792848652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7HdD63cIO1sGwME46dAp51tBAKzD7lOoAch50AxvXAQ=;
        b=ZZ/9JNdvROD2022jkf0P/0i9VRnIky1kthf4IBkA7L7MOLg3jOdWIpubmscKhXabhv
         6dmctlfM6BTjwyuXhjWRAyvWfDK2Aj4ThCt+aHkQLPUCMCL+xADpP1szhySA2O7zuDzz
         6Jh4PgmskpQpdb10B0ixrYw/+XxxaJkIAqgws+c2Mv0sBgqdXbPeuEWocFuWutOt2Rh2
         o5Wig1ImLL49XUDwsappFMy98fBewODCuroFcKNyg6UT+Q0uwhRyfunIU9qKBJmbjton
         SSCayQnzFzkTJEaHhiPZTMjF+UADEyRUEhM675S1gwveQtMUhs8txG/nH+Bzh4Pds4a1
         Iw2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792243852; x=1792848652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7HdD63cIO1sGwME46dAp51tBAKzD7lOoAch50AxvXAQ=;
        b=tpCjVSwEWXW2NApD/miz/gG2dfjP34EDSiPXtpCJqpaheaNXC6yNlyBwHlV6U8lmJY
         AviVLwhBzqRjci28Opma59ogE85GElZi3Nb7Jd5PKTQW/DVHXmlUVlLGLDl+OhpafFhM
         AoZEs2J6jrs1V34t4HHtZ+UMF0/Boofmv+MfdvpC7U8xEK6bN9fls5zBu4QRdThORETD
         8F0yGZaaEnSdhoA6I/giwAvRT1MIsPqvRORnWM/YIhzT1CR06CKPVPWAcvGz2HF+HjMt
         FxOUT2hRAjsyzVPDd1YcnveXgc4RZL2nrHV6/Hsr05ldVIpZ8p0ojQpdfyCEoyxYIjll
         lKKw==
X-Forwarded-Encrypted: i=1; AKwUvBxPfGmCgbdJBPd+kTYKbPXXl1hdrkoKnU26EBc/EdO10fFiu6KiWd+hnbcJ9dtYB8g0PPGs+UsPsjHH@vger.kernel.org
X-Gm-Message-State: AFq9FYJMK2TVG5uKZ1SSeKze4g6fkx36U6eH0pKLVulXvX8WZ7BIMs9f
	1zKaBTmd/1rCFWqnyLmZS17HdicFCvQ2D9m/kKqb0eDD7n+6DSCZjik1
X-Gm-Gg: AYBFou3VN+JluqKi9mGnIGiRQVZmOJH3NS95YuH9VdCzvzF+B4MXQxZtgD9gJEfr0Fs
	OEIWf1gawT7gZW/h3ht6Pg96NwmMu7ovZiW0NVkHBZ7j4EptcDGqLVAUmE/N1mK6WEiAi3hIovp
	F9yo+j3q1zBW80VGwEY6GeU8I9f9IjWKQvh48caNlqWwCtOhi74VFkL9mWNKU70yytJsV7Lg9AN
	xM8EiLEqjz3WYtH/xzEoc4S6d9pLa8KmYBfhgvzX+wk6u+PhpSOJQL5oxh5+F6XsaHfm11L+dLr
	LlCgl48/jmFllBQDkcokxvStL0VvVfw4V3ZDSQ/hE5nrcBJt7JkJ3PVkIwqRNJXvfNLisEcUcG4
	wEXc2M5MR7Ue86l86VYDXp9oDZj6pxLb5B7+tLL8VC6WjhVja8KSyPSME9MOfulB2KLbKpIe9mg
	XqkFt2qXmaqlsxsRCek0yeX9tJyjkvMXKEF3UuEKEQp8TIsCFzHJlPhkieDPEMkoB7DpYeGvtK9
	o7Gb+cUqIGJDw0EMo6rY+9RMkXVnkqIDk1pmlfSgfPHAbalLM20SCG0bJ3Y2Fy5ghmdYnuH8Vyj
	JM/8JNAkNxwLYbHxVi4yWR1107eCIc+f9dx1ZB06aCf69YSD
X-Received: by 2002:a17:90b:3e85:b0:3ac:36c7:c144 with SMTP id 98e67ed59e1d1-3acef2b4edamr1516587a91.28.1792243852151;
        Sat, 17 Oct 2026 06:30:52 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9474b52fsm14952942a91.9.2026.10.17.06.30.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Oct 2026 06:30:51 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: release SAM task attribute on the abort path
Date: Sat, 17 Oct 2026 23:30:42 +1000
Message-ID: <20261017133042.54305-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A command that has started execution and is then aborted is completed
through target_handle_abort() (target_cmd_interrupted() ->
target_abort_work()), which bypasses target_complete_ok_work().

target_handle_abort() never calls transport_complete_task_attr(), the
only function that releases the SAM task-attribute accounting a command
takes in target_handle_task_attr() at execute time: for a SIMPLE command
the dev->non_ordered reference, and for an ORDERED command the
dev->ordered_sync_in_progress state (cleared, and non_ordered
resurrected, by transport_complete_ordered_sync()).

The normal completion path (target_complete_ok_work()) and the failure
path (transport_generic_request_failure()) both call
transport_complete_task_attr() before handling the command; the abort
path does not, so aborting an in-flight command leaks the accounting:

 - Aborting an in-flight SIMPLE command leaks a dev->non_ordered
   reference. A later ORDERED command then waits forever for non_ordered
   to drain and every subsequent command piles up on
   dev->delayed_cmd_list, wedging all I/O to the device.

 - Aborting an in-flight ORDERED command leaves
   dev->ordered_sync_in_progress set forever, so target_do_delayed_work()
   never makes progress and all subsequent commands to the device hang.

Call transport_complete_task_attr() from target_handle_abort() as the
completion and failure paths do. It is a no-op for commands that never
set SCF_TASK_ATTR_SET (e.g. task management requests) and is idempotent
via that flag, so it is also safe on the failure path that already
called it before dispatching to target_abort_work().

Reproduced over an iSCSI session to a demo-mode LIO target backed by a
dm-delay device: an ORDERED WRITE held in flight at the backend is
aborted with ABORT_TASK, after which a follow-up command never completes
(device wedged); with this patch the follow-up command completes
normally.

Fixes: ed1227e08099 ("scsi: target: Fix ordered tag handling")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
---
 drivers/target/target_core_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1111111..2222222 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -870,6 +870,8 @@ static void target_handle_abort(struct se_cmd *cmd)

 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);

+	transport_complete_task_attr(cmd);
+
 	transport_lun_remove_cmd(cmd);

 	transport_cmd_check_stop_to_fabric(cmd);
--
2.43.0
