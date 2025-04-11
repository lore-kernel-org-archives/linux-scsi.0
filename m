Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658C7278E4A
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744370356; cv=none; b=pcWEYkznsNio1/JC0QCQHdsTC9tV2tGxsgASF1muiP2jkF2CMeFc/+ALAAlTBkh4pI6CDPQJX3qqx2xKBi0Bl0ZHTFe5V7DWKfbY1TnwbQO2ox3JW0O+zJ1n1t1HPGOsVzHaYHV9x/SxBztoSknmhhah6L+IRWHNIyCJb3rwsCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744370356; c=relaxed/simple;
	bh=D7CU2DU/sTRsRWB5aVwABd4FEIbADeDN7tDUgndG6Qc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KJObc0e6odrMKH06hF6+/K//CGfrkUgi0kIBN29R9tebX9yB4GgzVK65PKseAOk9SsgLIA+aeiFh9GIZQfpHUAVQ7vPhVzA2pw6bKpWHmz10iJiL95x1pNKwFa9izeNtbNfwqPOG72hAMdXDOSmYDlqiLT+jkajGWGIru1/l6Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=XOLeJZjO; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XOLeJZjO"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736ad42dfd6so1483961b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 04:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1744370354; x=1744975154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r4FdmvztfP+IKv1MtxZLM8otWk5N8qw+E+MwR/UgByM=;
        b=XOLeJZjOBh6JdsVUi1lektcufaS5mSeu9wkJ/qvw7nffIFuUviYkEZTgXX8FA0B6bl
         WtIJqTVKkHwkayiFcAVVu553mq4/Mq1FyK3QwRa3GdGCTEpcPYsQYMAtHUGHGU9qtLkT
         /UNlqx7NCH+bva38NKggXZFVjcduM9nSYHqOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744370354; x=1744975154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r4FdmvztfP+IKv1MtxZLM8otWk5N8qw+E+MwR/UgByM=;
        b=dlrVfeTiRI1+Ioo8LM3rsVfykusAYRIsSVQBNXg3UH83ZQgsAerQmreCzlfzj3WbUD
         tQqh1ugUH+y0eJ3gbZHe3Pbij/LPK3mKw7Nhp6x+6Cc8W6DMJK0JK0iuPFK6R0EGOew6
         j3RKnsRW4NGwWqNwKYwj7T25BFYS8b//ALWNvSsTuLzJVIacObjR4JNzc35OFOIyUipU
         HjqIY5HaGmGSwTBhPkUU60En8ovnoD+PF+kfSZ9FBoKOmTbw7yXQPY63JGs+cr68paIU
         Xs2GXrwcyAmLwPN2+ivBncaGaOuTUjRIgts/9Pa67HypGpbdB99ZRxMvw0gkeUtn8llw
         +8Wg==
X-Gm-Message-State: AOJu0YywjyBrD06GZVIZURr9VlTOfzlj7bi14QZ33KeNk/3sMXRQLLt9
	V/VKWazFDEM8pv/qYiGeaSW4DWsgwRiWOcNaHcTy88L5syh/ncSuma1hJXRa4EI37fgpQN/Qlub
	rgkjv4tMVbIJqLT2rpchB2LzCEfQ94ggzhdj9HNQip3wkDpUSa9RHCHvH8t8EeJInqn8599M2Tt
	ewy81GJkYcBOC0DPOni5irlKHaXjgWpGJg6FW6F928lt2i5w==
X-Gm-Gg: ASbGnctOS3XwgMgXP/GGY/nC7R7mDlSzPBJBTLjJlimWh4y5x6D4SUNMFmJNjN7K6Il
	8NYLyGg03XJqAUkc3oE/bMl0G4O81DdOLIKkg33b0GcRhhGydjOMGnTRitI9Hyo5mudVOZO7jvj
	PFauOvWzy9OI2EvEtWqE4P9KaiCgJZ7gXMwPs6VjnErHR58dDoj54S8sXnp2izVbS50iZ1Nt24B
	OfYF0SkjB7adEOcNVsxJizoc8Ag6cgYyk8VP2Eo078ubdpnBSCrlEXpyu2Zp73x/7B1Akjmb6TD
	bf7iEW1TjKsSi8f+yGnzX9NLXDrn/+To1wSkIr02kjqIbZIzhssWP1RzFnMwITSRTE4phwhhRAL
	mxLN4Sjkd
X-Google-Smtp-Source: AGHT+IG52lL5FwLxFwDAsFDy2iTPCdjhypCuRND+WhpHTp/l1ISk/0/YYZNAe3QxPyjkAe9g78paxg==
X-Received: by 2002:a05:6a20:43a3:b0:1f3:388b:3b4b with SMTP id adf61e73a8af0-201797a193bmr3629080637.15.1744370353534;
        Fri, 11 Apr 2025 04:19:13 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd21c65c9sm1266920b3a.61.2025.04.11.04.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 04:19:13 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	tadamsjr@google.com,
	vishakhavc@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/2] mpi3mr: Few minor bug fixes
Date: Fri, 11 Apr 2025 16:44:17 +0530
Message-Id: <20250411111419.135485-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Few minor fixes of mpi3mr driver.

Ranjan Kumar (2):
  Regression fix: Fix pending IOs counter per reply queue
  mpi3mr: resets the pending interrupt flag

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.31.1

