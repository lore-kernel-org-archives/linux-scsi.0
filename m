Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03134EB86E
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166106; cv=none; b=SMh51wCl7VjpCtCYtU7wtwe17T44QmAVdhb8/aZ7Z/qkBaGGi1QRgXfXyX1QMNqk5y+1/bS5DQuSKwnZIjwyh8XmxBEruKGsQmxvdd9GNSyDqQKm/+XjWNIoNcrujhjeyslMdfNLrpuds5uKtDzfSgnfSnln41Zk9txh1lnkNXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166106; c=relaxed/simple;
	bh=xfVM7Ixl3z8eH7OKX8v58pshYLTN3UD5jO2NLrcsdwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKIGhC3lNu2prJ0O1YsGK9WDuKPoHje0UVFnWDQKLc56WcReTGZiDg9Hx3LEvE7mLLoqCU4uDit3mYsCInWsyN6ICaSKJY9MjjvXsMW0rdICY/r4rQCCy3v52a80je62xdDXnxoL7CvS5ujzQv3rll36BOm/b+E0sc62abE77cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=jQErxRhT; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="jQErxRhT"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so108357a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792166104; x=1792770904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M3tJFqfVV3/Mnehr3W1CL8ME0NqIUxGcTffK89eXBjU=;
        b=jQErxRhTEYF0DBOizAbVwDMJ1JffeXYFdCEwR4m2wwhWtl/OQXwFUKoQKP77KsEaip
         RKGKTJnR5gnnFnuIgRpx+YXOKbJtBWDkCeDR8iRX8UohV+O0DNiVtGwM0I6ORgNS4eZv
         J4+0KJH84fPBU3QJytuMW03sOF/uSp7JvbaDMriKE9RLbgrvgT3oJ+m0vZpXBLY9UWZT
         vR3JndN5tDp0uSjUDF39enzyFzFBwKdboDSBTGrHXupKEeTPEurWyAW0WE79OUE/mlEV
         d+xyH/qwl0ZE2j17aNktmCHmTHHhfVjM2w2z8TwqXnXGgsR+OSSzRn6kkFwZH33AYAdq
         0idw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792166104; x=1792770904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M3tJFqfVV3/Mnehr3W1CL8ME0NqIUxGcTffK89eXBjU=;
        b=1u4e6FISY+D4z1f04ibnCcXDpoL6BNkuah5iutnje7+/B7pEkw4XYl13hkj/3MqEN4
         6T29UQCREreyOdLgOWRtMWuG7RgalMYgmjQl2lh1yZ17KIIRwGSCqfLMhS28GM1mQ8cB
         lTrZbM9ne879o+8lPQEChiH9q7rR7myKzhcn2ucxhNM2aUatgNw4/69CsHQQYzisucSW
         R36OmmuPdAtt+RbDl1M/3two/CXUtdgC7GIyx1HCVmP2o8SAawEPwC3xSA7cfne3gJPp
         XPTv2orSEYUliz86UOElW0jwrz7HsOHDtifeglNq55LnqKYL/ajn1pG71eam7ac/ceLH
         bktA==
X-Gm-Message-State: AFq9FYL10HUnTk9hQdt+2PIPHVLedgYByI6LRw93GSyPWmWuKezNQkTw
	P1gHA0Thlgc9MRXfRw9juN46RXBq9NP553Qia1vnakxDdOQwc+Yn66cxTYKWQmr5Vx4=
X-Gm-Gg: AYBFou2iBBxvbCx4boReMY4p9/m82KlM3OztzS81YqEkLwQXkT1LYptYqtn56q8Cbsd
	0fEjLHnAYc1twqu4FrtVIzKx2j323zNJDxBlZddD3ixV7Wkjyf98tziAYLfm60PGRGnSQ1BS999
	KZx/8om98SovhieZ6eoyJDNOkB98csvBUeht1193JhxGk9RrlwTcPjx3O/Mik3AkYStOiBP6t26
	6RPsKNzDSmfpoqKq2QVkgo6eMAkP7Kqn9WNnzMR5nBbie46NDmapxBxq1nUCRX1wzSMJdtQV0uj
	2xTeJZsKpTuHoH1cTRdogVFMHlVbwzaZNSnVsRG7HLYnZNwrXwUYnreq+U5TlJRORU2GyOdzgpw
	V3j880+5jjfn6KkGtlNzaSOe2iiKHVo0Rq461PncfnOk1GOPuUrNg5vdwyGbE+Ieah4KxztS8rI
	snwhhJGl3jbnZB6nsG1ZrHCYLK9sraJim0zjq2y8Wx4YtadHgLRA5h6qWjYJ6TEQmYjn4T/AHu2
	3NmelW9nRerplOkvwFM8Cc=
X-Received: by 2002:a05:6a21:1506:b0:3de:ab1e:a63e with SMTP id adf61e73a8af0-3e2021c03f6mr2641865637.39.1792166104144;
        Fri, 16 Oct 2026 08:55:04 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:5e7a:332f:f584:a3d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65ab63cadsm983076a12.4.2026.10.16.08.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:55:03 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 2/3] scsi: bfa: drop unsolicited frames shorter than the headers they must hold
Date: Sat, 17 Oct 2026 00:54:40 +0900
Message-ID: <20261016155441.1607196-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
References: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bfa_fcs_uf_recv() keeps the received frame length in a u16 and hands it,
with a pointer to the frame, to every unsolicited frame consumer. Two
lengths are never checked.

The frame is not checked against the FC header that every consumer reads.
bfa_fcs_fabric_uf_recv() takes fchs->d_id and els_cmd->els_code out of it
before dispatching, and the handlers below take the length as a size. The
worst of those is bfa_fcs_lport_echo():

	pyld_len = rx_len - sizeof(struct fchs_s);

pyld_len is an int, so a frame shorter than the FC header makes it
negative. The memcpy below is skipped because the comparison it guards is
signed, but the value is then passed to bfa_fcxp_send(), whose reqlen
parameter is a u32:

	reqi->req_tot_len = reqlen;
	...
	send_req->req_len = cpu_to_be32(reqi->req_tot_len);
	bfa_alen_set(&send_req->req_alen, reqi->req_tot_len,
		     BFA_FCXP_REQ_PLD_PA(fcxp));

so a six-byte frame asks the firmware to send roughly four gigabytes
starting at the fcxp request payload address. The response side of the
same function sanity checks its length against BFA_FCXP_MAX_LBUF_SZ; the
request side does not.

The frame is also not checked against the virtual fabric tagging header
it may advertise. For a tagged frame the function steps over that header:

	fchs = (struct fchs_s *) (vft + 1);
	len -= sizeof(struct fc_vft_s);

and a frame too short to hold the header makes that subtraction wrap, so
the length comes out near 65530 instead of going negative.

Drop a frame that cannot hold the headers it has to hold: the FC header
before anything reads it, and, for a tagged frame, the VFT header plus
the FC header that has to follow it. Both drops use the idiom already in
this function for a frame whose virtual fabric id is unknown. A normal
frame is not affected; the FC header is always 24 bytes and a tagged one
carries it after the 8-byte VFT header.

Fixes: 7725ccfda597 ("[SCSI] bfa: Brocade BFA FC SCSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/bfa/bfa_fcs.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 9b57312f43f50..8bb92f935a40f 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -1527,6 +1527,14 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 	struct fc_vft_s *vft;
 	struct bfa_fcs_fabric_s *fabric;
 
+	/*
+	 * every consumer reads the FC header, so the frame has to hold one
+	 */
+	if (len < sizeof(struct fchs_s)) {
+		bfa_uf_free(uf);
+		return;
+	}
+
 	/*
 	 * check for VFT header
 	 */
@@ -1550,8 +1558,13 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 		}
 
 		/*
-		 * skip vft header
+		 * skip vft header, which the inner FC header has to follow
 		 */
+		if (len < sizeof(struct fc_vft_s) + sizeof(struct fchs_s)) {
+			bfa_uf_free(uf);
+			return;
+		}
+
 		fchs = (struct fchs_s *) (vft + 1);
 		len -= sizeof(struct fc_vft_s);
 
-- 
2.43.0

