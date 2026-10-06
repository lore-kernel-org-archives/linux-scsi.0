Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C3238F64D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791312281; cv=none; b=Phm6+jiwgnblKnIKb/EWNeYWmXsNXXoiHFrErsspWzWoKLIcPXYpwGtmz3YmIH1CNpOUQjioDBxQGCgblrb01Ik29XbiiQ5RdhlGwhJuuHO4yOPGpjw5xq/A2N6HRAZR+LdHLrY57EJBgtdl1xEj/ACOapUFeewBIFbzYoWoW4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791312281; c=relaxed/simple;
	bh=ttFAmo7k+38OqXI/2s6BkT3oFeJ0ik/v+nBDSRpsPR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlVIF196nQCIYqQPBNDQ+j8s+mLvNHi6HO0/c8wnbfhtrO2tqia8D5354GzQUKD/WoXILN24NBuFirP+5v0m640jPyWtrv4Z2MEwaDU8nNqzkHYcUaYmffYrAdbTq0DurbhSnUuaJ5drxW/lyEDyYXPyzBebdE+J9Y8VYA21ISg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cmF0l7uF; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cmF0l7uF"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-31490970b97so1671624eec.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 11:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1791312278; x=1791917078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ttFAmo7k+38OqXI/2s6BkT3oFeJ0ik/v+nBDSRpsPR8=;
        b=cmF0l7uFZlTKa1MjQMSKOydWWshcTsx3VpRrO/cUF6a8UYmMimHgxegjri3tngWDyf
         aPRiUdXJi2IjuymHySzf+/6e+RosEjKRh2iQVW7ePzvQYrs5DXw3NaUjXQXP2NRNLSVw
         B+xdZ3RWLYTqjRTc/Em1g5tMdPLNeZzkk4rm1zAhSWyJweSNQ2Ju8yqfCllKvX+6xO56
         raVcTnZDci4svPMr699PM2GgX5pE/+ExgZFwuRDl49eG924ptnxvGNYm0gg2Zf0GyRxo
         +MnqE+s9Z9X7PFv9aubZrPbz9H/Bz24C2g1gwS+wKwlfEfgSd1zSMe5xHXdO0kUMalPy
         4XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791312278; x=1791917078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ttFAmo7k+38OqXI/2s6BkT3oFeJ0ik/v+nBDSRpsPR8=;
        b=NwKTGN1HqmO0rrIq0alJ6dX7gCxJcaHzvm29Q2ta87iMpP4f7cs2AJmgGg1yhJAS6S
         hzVYQiEvwb5X2B9qEKwGjTEezKqZO8oD1WLvcZOl6Kv7MbdOy8SCbLu8l1ogxaRUCZSD
         VUGnEKXke7ln9dlB8dtkVwPUPl/W2LE+zp2aAs+HyHMWSs0GNBhsowChclh3qpNsd9TO
         icfhAkeREZKzojp1GqxnqrSJdfp/JLaLtcx5ssWGWoOCoM1iaxz4EGJYu6SKj0CZheQD
         ot0wz+IdesrR2+CPrpadaXq/fD2BDuFoOWWnP5vv7b9k6pv9xi6FHU2OOzs1EoQAlAzn
         zs8g==
X-Forwarded-Encrypted: i=1; AKwUvBwEAsI5/V9vqx/FQ5ed/DjQt8y8X9R5h47vTd4QUcY6m+HLORiWFkNkMKUMd8L4yjAVEdefJQz4vmE4@vger.kernel.org
X-Gm-Message-State: AFq9FYKtj7dPBAzjzuKeGM4RXpQ827IGdzXZd2yaK2ZTeUW1y+KfsBzk
	EwHgr5jKFPenWPfie/ObmW5upuYXweHwZVU9nbmhk/EU6mFkU48QS3PVTLVKKQK7ywQ=
X-Gm-Gg: AYBFou0Yb3QfOTShZMA5YpNpowwm4+xnY/JVQNbVB7hu3YVQaSWWEH3fq/j7fwC/txK
	DilAQ34/oPLxNq/9JrUjnKYeIBfm6HbaUUR6N98/EDBPkiEbvId3EWUOc7MOA/SP6awf/Bgf6vv
	nYUTQaUVehRqPMw0l9mwsiA8wAE1tZiLvsJxiQgvqPy13DlqcR0rOr2D/mdfyRxRoHfllgqrNf4
	6myUknDyaVRMcKGyYGtlwQRmsdEUd0uky5DQumtsw1wu8BWUGyoLujhzz6AJHZZ7NnqKlXy+9BT
	zlr0DRltAD9TL5/rszYw8YE82ZB3SQb7E6Wt3AUqipb22eaD8wO/X5hQ7fPEwDown1Qeq0H0LfZ
	BT9LtakUQY8mavoHTAs2cMYPqnUwaGqeKFwbR1YmTpqk+VkvG1kMHXrzn9s2x4jNtsjtsN7JvPb
	Z8SAluaam6cOPq972HyjLacxAj+clAWzysnEbpxtX1jRnHUl8Uudh4yzwsEcSf3N37G8MkjLQKj
	3NNoLKyFHtud7MkRJlfS9HMFS+VXvE6vrAyxfaXJNbFup5iYlqQ+fhwqTMzV7uBiW+9WoZorHX/
	vgqnNwD3iovmgDsTzygpj5ACVYxENEEtBXivq4amci27DeQBcarHXjYKp2aSXf7DINfmYUU=
X-Received: by 2002:a05:693c:8207:b0:328:3cce:4b3b with SMTP id 5a478bee46e88-3514dcbf19cmr2655828eec.4.1791312277576;
        Tue, 06 Oct 2026 11:44:37 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.120])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3515b02d552sm603526eec.28.2026.10.06.11.44.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 06 Oct 2026 11:44:36 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v5 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Tue,  6 Oct 2026 11:44:23 -0700
Message-ID: <20261006184423.41204-1-brian@purestorage.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <yq1o6gbdhf5.fsf@ca-mkp.ca.oracle.com>
References: <yq1o6gbdhf5.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin,

> Applied to 7.3/scsi-staging, thanks!

It looks like this series didn't make it from 7.3/scsi-staging into
7.3/scsi-queue, and it's not in 7.4/scsi-staging either. Was it dropped
on purpose? If something needs fixing, I'm happy to address it.

Otherwise I can rebase onto 7.4/scsi-staging and resend. Patch 2 now
conflicts with the scsi_device_from_queue() export removal in
include/scsi/scsi_device.h; the fix is trivial.

Thanks,
Brian
