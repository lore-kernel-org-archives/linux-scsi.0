Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF32F547F
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272986; cv=none; b=d9qxuyYZ529O4fvI/FSORD+vou+xN/vKaGRdUNU6qLLAXnvP502TGWub0SMsUeAaErBEYZQ3fS6FPJ2CLMF7tQ4N9FqOcUIzBFcDuMZt1P0gkkERILFnARRoihq0csoRJbIF2wcuxjqIPLtty3jgejeFZVQ7qZSgV/JwBdM+pyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272986; c=relaxed/simple;
	bh=jJyNwQ0q5fKEYZb3gE+gYofzRsOZVPwkGCUhRyjNc2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cP7PKYhibm30+4HEmjfRb/0nJlUhVgGec1Mhbty+7GntHb7JS1nWHjp8zc2AnGovvDKN7N8m22/Q0++gVErvLEz/vee/hjnj0+N958o7JAfFnMFQ06KQBvpR4nGQWgaNMvcy/N8Dn9evh219DRv2+9vAC7KsddF5WFrZ1FyAW8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WA1q1Tcl; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WA1q1Tcl"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b2c2c762a89so36982a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272984; x=1750877784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSKadprwSCdVy1AYrfoWwIan2DzP1ZOdkFNmuHYQerU=;
        b=WA1q1TclSl2VfZckoC2qH+936P0K6sy0jZixjFPr+Xdq66eYUWfgP6fJosCXuYQ728
         6qCd3eRrTzLXsAHcKjz3ZGLFf30ojtPRcRk9v5QJBWGpFztN78eA8ffZnO0+PSZ627O+
         931PNly2Jd7xlMG8dTcBHY6EuRK2Om6qj7dkjyw1c8gjS9g4LqHZPgJKyC9R6Xe0ewsO
         yEtXzq8Lz68w9OPLHwFUSrK0RG+9gCSRaXlQWcJHhLrsqHAHrh8yhRL9ya6cxk9mUu49
         48KTVSkbV4eLY7pr4ztnSDIXc668OnzEYlA5ZVaja93BoLn6GNcstM1jhoN0myLA5n2X
         K7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272984; x=1750877784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSKadprwSCdVy1AYrfoWwIan2DzP1ZOdkFNmuHYQerU=;
        b=FWGw+KqnV2IWzZIlUbvfX5ZbOD25AmWhF6rnitx+zwLbn7R/6PDEdkiGG3CCcPl89f
         3b6AiInD10J6OaWqjmV90STZqrxP30lDnrVG966L8EIKYum0GqADKlKaPrwRro5rZdQQ
         PSaQxFEavkkqGzs8FYiQkTi0WR64I53srV7WK9V4750ZucXFWka984iTvA+Ae/Ozs4eM
         Q6Efk9xKgi7vWMJ2jrSAeJdD4PY5Ixeql/kHvCd4T4apbqKHO17Ssj6JpiivWqqmXZVj
         OczU1JA0XBAI1qFFH8fT+aGpKnYg0X/8q2WUc2YWizBijCto7AdHrac0utC5ShTPvLAy
         vO1g==
X-Gm-Message-State: AOJu0YxHZ8ARDUHZnxS8dS6xp7DvB+S4VXsz6Bu0KCpRxoyhgx4rDVzS
	QuxNfB9yE0Trj6zhhsKalaXJtR2Ej7v7hNRhJEW/2Tfo+e5Xpkw5+PCIXNNsKw==
X-Gm-Gg: ASbGnctdCmlzUNOR7BznUQ3ui4bBcGWNtZrP480YIn89Aw/uEHysi4HbBU/p3atyng5
	4YqgyrAvQXhS5HLyWhlg0IFmtJKR3X72b7bpmNNbgZBIzkT8+YqFk+k9g4NLfuzAyBQ8uFZgPYA
	lX/RbT83u0X2HOVQX4hmqmjGYliTHEReC+AhoWkm22HP5/wAxAstu7H0bVH3RdAbv41Im0pCTzn
	j3bcG20PLafI4vEhaPW/z5dvSCm0NSWU0qdj6z+UWcRe68gI7rIvCesj1Duvxl0EFL5MAMDKHC0
	w5TYWONrAGk35jK9UOZKrAYqADgTDRft8Nvcu9T+fAHjRx1MV+rqKVlx/xlXyJKnYwgbntr6r6M
	P/uCmwLhWzeUX1Exr38gV67oE2/RPGrek9qVwtzu27d41+vnG2z5qj/CaOA==
X-Google-Smtp-Source: AGHT+IHag+HtWHcTvjTrX2ffpimNF5oxIqAS3F1ho5beyzCPlARuy6Tb3GZuiB8cH6nFTJqXKPde6A==
X-Received: by 2002:a05:6a21:7702:b0:1f5:8678:1820 with SMTP id adf61e73a8af0-21fbd4c8aacmr23927126637.12.1750272984226;
        Wed, 18 Jun 2025 11:56:24 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:24 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 13/13] lpfc: Copyright updates for 14.4.0.10 patches
Date: Wed, 18 Jun 2025 12:21:38 -0700
Message-Id: <20250618192138.124116-14-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2025 for files modified in the 14.4.0.10 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 drivers/scsi/lpfc/lpfc_hw4.h     | 2 +-
 drivers/scsi/lpfc/lpfc_scsi.c    | 2 +-
 drivers/scsi/lpfc/lpfc_sli4.h    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 6baf1916d827..f93f8dca65bd 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 061a5e4e525d..2c7d876c64c7 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2007-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index dd9f170fbdc8..bc709786e6af 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 46bc7b8041df..508ceeecf2d9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index e42b44fcc7f6..fd6dab157887 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

