Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B956A3CB551
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846026; cv=none; b=SZuXynxHMnMlPzJtW0/vFz/Lr2eSu3PlenkW7OgrDmAn84Xnts9ofN6FmZcJO0WmepJu5/hJY0xTluYMvI1kMNQdGc85zsQaWERUgU06K68AJTJ6gV3V073GhF5G0fRLq4dzq8GNSUOIn+fD64jB/J6Z+RKCcAVxr2w5UFd26WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846026; c=relaxed/simple;
	bh=CJntl5vLVbYMLsA3KBqUJDcMecoNCBVdlHh6cm6Lojw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFAFkV+uCsUSS4yKlIhoMgPbLijfakVFoKDtw7iu9uLx09wuQVFwEkE6FSEv8SI9IzvYUPOcRsYN2W+X/8XVuCb5NnW0iRTGeehRmYl9lVNYYJbiZqHlQTVe8J3guGmjAigMrgh6avXh8GYc5Cc9X0oWXGYhn/kP3VpSkbLN3SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=F4F6MMxR; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="F4F6MMxR"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso1012962eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791846022; x=1792450822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8BFdvYSISp8AAXKvEuQiO1EpCQWSnukAZdzABGNTMg=;
        b=F4F6MMxRB63hR7L7UuWdBg59TxAVOOlV7uUWPnyOySMYgB+iVydutSDuhWSht/qCSw
         pxqjN9EwF+AFcK5LkgJttmNIIuhS+Y2BJ1Otjrqs9jCAAUhjR2XM2B0Dp8h1EOjMf0R5
         l3BNzv0bDofaLK5ID14CprdcRRt9NhzJ4pcgb1pj4uksbAWNfTTp44Bjx3m1A1RV31OF
         IL5UdLf9tfINu/8yeE4/8XqpOi/NAp3w2dsDJC/cZzWGEhbdfxqZm5ZLyBrGc3sZB6Wj
         gnUzC4FA12bGb8baGrFH9KibhPDw6fQqd6q3Jok/opLYAEScFr8hzPfwIg5U+XREPtOB
         5jag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791846022; x=1792450822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8BFdvYSISp8AAXKvEuQiO1EpCQWSnukAZdzABGNTMg=;
        b=URWZJ0wuKYFYuSbnFcTHSwDClCo8EI8gbXxQvMgwF6R9mkAertPGBXLeNLaMv+7bP+
         rf95IUeY2uGfFkYg8EhY8WcOghuf3fh7aKBBtb4D8vSoxrtHCpo1E/R55zpCLEabCpR+
         UT0Eyq+QB4A2wqbPDKtCceaWVDOB1r6TpJzpI923ISJH5jOzWbMv41j0BGk2NUBdHpdh
         o5+8QA0/3EfnW5MC/QpN0QShM75W4A/UxK3NQsnhVwETfZ1w9V6YCY4IqSCpkuZAoDWw
         PwFQz74v6RI4KpbWW3bMqvv+dUELe+UXqBzUP+tIBrBIJvCI+a/q6fODhG0O5fdAPeSu
         DAYw==
X-Gm-Message-State: AFq9FYL2cGCVGEu9mkBscYa51jv8AvjURRjCh/Bz57pnYsYnJApRR0Lg
	6/s3ynCIiXmKWdwTGoW+HINNrQR/rotM9DLBnIkBD8focmlGfg0xE/XrbvoR1ZUcaYrxgH8gluG
	1F9ctRPKDRg==
X-Gm-Gg: AYBFou3SfRFhXiDXJMy9gQm4LMq+TUdhvxB2QneCwL7EPQmaIYQ9WM3qQBLwQlMrDa3
	XWakf7i82eCbxe+w0ZoDmexOnXKzfFBPgp9thcaaWT9jHROLxnl56h9ZXB+UVpCE+dSCL3Vr5ua
	Hs8lUt7vcbTkf3TEJQRFlqU7OusgZcKc5FVjDDKTi7moWpRjlRAmRO4BkUdHML1UeJZbK5+Noii
	ofnmYTKYOgM+tzOtrBRq8xOfVudQ6Q3tvKIB7TS8X23KiFc0YM+4NdE1zZ+2IEY6FGFO2qbdLkI
	MegHeclaTw6x47GbcU1sFUVubtApAk9giTjTRln7BIL9n5hPDyexiV2ZrmOVvbQFpGfupPqgS3D
	+5GRDsPunkTp+uX2dIVmLh6okuNTG1adehB4kgxt7kmez2mzEZnLjpSMcbgTz94rIDKrzs7SOrt
	YdTr1T4bhmPypCJPsoeqMYx+DdfdRlGTYNrgVDWy8vvsYVaJGN772JBE7hfSr2oR5p1sVytXi8j
	yGFV6SOot7TWnyjnIHs2Q==
X-Received: by 2002:a05:7301:7d16:b0:350:2a5c:56c with SMTP id 5a478bee46e88-3537e08eee0mr15713738eec.20.1791846022251;
        Mon, 12 Oct 2026 16:00:22 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-358de54fe47sm24149748eec.31.2026.10.12.16.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 16:00:20 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: mkp@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Tue, 13 Oct 2026 08:00:07 +0900
Message-ID: <20261012230007.2457828-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-168364@kernel.org>
References: <20261012153502.2435483-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-168364@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the careful read.

On the lock: a command's write-data frames are not delivered concurrently.
A target write-data frame is a sequence request (EX_CTX/SEQ_CTX clear), so
fcoe_rcv() steers it by rx_id onto one per-CPU queue and fcoe_receive_work()
drains that queue serially; one exchange is one rx_id, hence one CPU and one
work item.  ft_recv_write_data() for a command is therefore single-threaded,
which is why the existing cmd->write_data_len accumulation and the
== se_cmd->data_length test have run unlocked since the driver was added in
3699d92a4d7b.  write_seg[] is updated in the same place under the same
guarantee and adds no new shared state.

On the FT_WRITE_SEGS limit: a lost frame makes the byte count never reach
data_length, so that command already fails without this patch.  The only
case newly affected is pure reordering that keeps more than FT_WRITE_SEGS
disjoint ranges open at once and then completes; the libfc initiator keeps a
single contiguous watermark (fsp->xfer_contig_end), so four tracked ranges is
already more than the in-tree initiator.

On the dropped frame: it takes the same path as the four existing drops in
this function (no REL_OFF, DDP without SEQ_INIT, runt frame, offset past the
buffer) - the frame is freed and the initiator recovers the command by
ABTS/timeout, as for a lost frame; tcm_fc arms no receiver-side timer.  I
would keep that consistent rather than make this one drop abort on its own,
but can add an explicit abort if you prefer.

Thanks,
Yehyeong
