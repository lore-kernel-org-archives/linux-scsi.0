Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80E93A7582
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849190; cv=none; b=hFhGTvlecIBzg6Sx/rs5f1b4hA3epk/0SbWgsfvDYsRAs98hBqWZtFyFrUTw4+0rbo3hdAbdQfc/Ngb33AqgmWvm9DEkPlMqJ+Y9l3L95GSiVLLUmvI/ZwdxJfp3+R/Wj+2G/RMQ+jch9Qn03B9FiUN/tYPAFBaW0/QuG6AGws4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849190; c=relaxed/simple;
	bh=5wBdeGUnPAlm7PBZLEkjecF6ym2mtXkA8mkpgg0ky1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V0gAZuxwXB5OQsxT8rZw0wE57dEq+KbmUfDqb88Syg3c60GkUu0NHSmSZIK5+99JSq5XlNMSScMFGQfRcjF/i5nlyorjJITeqZW/1HEwyqxvejylLpjigSeUCNXmnyqiQSYA4PFYpB+Roc8ae/40WBSlFxWRf58dWTSp9uIWJp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9hy/OsA; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9hy/OsA"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33e6279a1d7so1341787eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849188; x=1792453988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1I552Ew9/tzes0NUtZGCP4YdNjd/3XBkede6vP0o/Sk=;
        b=I9hy/OsARx1EUp/wbowfCJNL+uQNT0t4V4PPK7IFdxi5mWqRGWUFahsW5TpnMFs1K6
         qHlb5X/OyaSgItjCLBoQdxnFngEvo9NCAKcAT9KMQQwP09aC6mmnBax4LXHqcsLyIiJi
         7PC5KhBU1dfLc69+Pl/5MW1O3yOGiCc6V3vSC4H5PnshldfFlWw4ZLcLHOt7zJ9U58LV
         xxba/ps10SaNEduk1UN857oJWeIJMez1bCUyO+fW9vWl4LSVzN3z5K7OMjzPsjQSxP7F
         iHzijic0adzSshTL34zN5RL67JmdwMQ1AxX8a1CiT0gwAZBVaA3MKiKO7Ok0eAZg7/bx
         aF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849188; x=1792453988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1I552Ew9/tzes0NUtZGCP4YdNjd/3XBkede6vP0o/Sk=;
        b=qeE0j8uSa9dJNq5TkBLoIvD0+Z5sBytsqy7ptpOtnEsyQrpEKfadd/zjPAyIkiCYnx
         yiytcSz0nAZzx3XHW1CbVZ/WpDUyRF7tCEa/tnTzfHxUVPKysmmjNdClPMHBp7LU6hWc
         u42VhryfMTl+ViDXcnWtvq0tStXVk96OzY/EBSgsAS5n7tqTVArs4iRSp4+RlGNCQagj
         rpPsIoOpBM8OR50Dsz6bmGtmj2oVNj0uuEYEHGDqt7ZFNtqiACXjvH1jcuTN9C7Cmg3+
         fQrn2GWl1L44NsED8v3DjHhr+LIR8qqR54RmEGjvJcYtgh5rSH1K6wk5Ch9w2ay2op6/
         JDQw==
X-Gm-Message-State: AFq9FYIGPu7EQy5bI6o30U9gBilusgcX0PfQ1xVF1iqaD2srJDeIuEzb
	Y7L2Rn9uT20GERX7+vFI2KqzMIRrzmvg0j+j6DjajvWgF7YEU/TmbYBCSpUDImdB
X-Gm-Gg: AYBFou3I5/z7rKQ1tlvm7x0lO31prNaP2qPVwiwP7JUnXNN5BmQdH0nf1fOYxHVeLh7
	ePnzKfXPEZFez0oiyTksAkSIaGC4uo9/31wqkhaG2OgBw4mhja3tXoiOnS2nXAovGUmxRKEMvY5
	2wEvagBaVWEqAexZsgWesvkMsYDfa0PR8TJc/MdRSZzyM4uV2VlPKLCe/9AW6Fo9UofOEUZeiz8
	40sNsOj9INk4O0ewIs5Yzu3/1+pJwuMvenjVUDBMxYdpCHHW8vKhLrJcmP1jwLMMsb6Ogu/RqTC
	u4IlPW/LmZMhDGw5k3vc9OFloBDxUSj7Z+uratAm51V/cdWyprmUOcXC6q1h+iQLz0gljS0Ct+P
	gC6lrPTFh54BHXTR5B2eYBqg4VK1Qe/2Rb/CCJCu+PeWwl4GvN3I929Ow1SQXRTVGKLL6pt/Afl
	5bWOyAh2p8cR8HIXz4NmnMs0o4dQ11VpCF5+++5bkO4J/cgg5rnnvPuKv3Ysd91t4huS11jFLHq
	ZfxaigGCWhy3BoDC/wbOiuPv5GveZcInXdFrTXEVVHuzJDtu/Zj64H5NB13csfUMMoV
X-Received: by 2002:a05:693c:8959:10b0:35b:da8b:f88c with SMTP id 5a478bee46e88-35bda8c2195mr2276856eec.41.1791849187811;
        Mon, 12 Oct 2026 16:53:07 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:07 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 2/8] lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
Date: Mon, 12 Oct 2026 17:16:42 -0700
Message-Id: <20261013001648.62289-3-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is possible that a dev_loss_tmo callback fires during an hba reset.
The ELS pring structure is cleared by the hba reset path and the
dev_loss_tmo callback executing lpfc_els_abort could be using a stale ELS
pring pointer. To significantly reduce exposure, check if HBA_SETUP flag is set
before proceeding to use the ELS pring pointer in lpfc_els_abort. There is
no point to issue aborts when the sli port is not setup anyways.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>

---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9c449055a55e..2c8d995a45bf 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -227,6 +227,11 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int retval = 0;
 
+	/* Exit early to prevent race with queue teardown. */
+	if (unlikely(phba->sli_rev == LPFC_SLI_REV4 &&
+		     !test_bit(HBA_SETUP, &phba->hba_flag)))
+		return;
+
 	pring = lpfc_phba_elsring(phba);
 
 	/* In case of error recovery path, we might have a NULL pring here */
-- 
2.38.0

