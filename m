Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3228312FF86
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718034578; cv=none; b=FFiCGah+z/Uf0cRa2DjgemV4GPwcl6ky5U5cWYfZcXskN+BxBKNnfW3bYaVQYYjJSFeTHAH5JuFGrsrqSLFYgWDWlJ4kgh9/h237Ye47OF7X2pXAvGGBTS1nuEJ0JGve1L/1bH2bbw9LSIHbQZ3Eh1PlUdIIeawcoP4+b6K6g1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718034578; c=relaxed/simple;
	bh=K2JojQYRfXnkGgwySR9cTTZR6EtwxwNq0Is23KW+P8M=;
	h=Date:From:To:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dABgY0llIbXMBhciyj7EHKM4vLmIn1rrWaQ+JvQItMyHQGDpYVilE3yJrMvbIIH4GxR1NX1Yqt2XYryBG6RvKzddAx+veCL3sap1Kg10lXHY96x6YSxz2UwIo68Ev7MP19VhvxswbVS+JNyRBaEI0pQ666wgCz4/fBOgQeqqraA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W+1iC72k; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W+1iC72k"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1ee5f3123d8so329785ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 08:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718034576; x=1718639376; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K2JojQYRfXnkGgwySR9cTTZR6EtwxwNq0Is23KW+P8M=;
        b=W+1iC72kW8dNWo0Jwtc36cd4V1MfSEtBxBdQFc94KGaJCYObz0WYhluJPK1cg2hZfb
         5Y50NPEXXj4YY1+W9h2Np5hWbRRo/yR9RghSpejSg/50lv299o1BiVi2CGjJHu/Hbt6F
         rfO8V+8/aPl9yJoLisCvy4yGVKyZ6RU+yyVjYvdwhJ/M7F/9jgBABsB2DJK+ny5NLiFz
         4V3QPt0+nKrSAkXCr9K3xXsL5HzE9524bxcXobU1WaNlbaWt0OmHYSdcB9NscAa48EX1
         +SqhLa/X/BGJAu3q2EUi4sK+DcXoJOZcq6OjYj2jG4yQQ/1EG7ofKiWIb59vWKeoKD6c
         mCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718034576; x=1718639376;
        h=content-disposition:mime-version:message-id:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K2JojQYRfXnkGgwySR9cTTZR6EtwxwNq0Is23KW+P8M=;
        b=iFrAk+YV8ZjlPxD3/45B7NKxDNintkLceJ7tAQ4Qf7o93VUFu/Ta9EW+g2T3pFJgkT
         hjE8V1L/ETyGQshsKXFfny0ZWeHOdha7lhrA9n7tVZTHVZ57YYDP6YOzOjlDR/6nEIBB
         HA6gOEI/+FfFmPA7CvlmOUWtijbhFoPgmK8DoklrHz2pfuShwVZFRuK+cXhPpIbhwtGS
         mk0Q6sGlUqwDhK60qPV7f4XQyqDiV9wsGlzA3PCB5cDBponuUV+eDBPsCfrBKhn8eHMc
         v0O0qTXuEU0sA6iJ+X1E4d4g4N7yqBSaWvabsdlF1qJNQCQTTVVIpc0L60ugHQi+dr+H
         XUig==
X-Gm-Message-State: AOJu0YyjpdJhcg6+lt8ZWHhLyZzAumFwrTEFlWw4aiUCj658IB1xsSDh
	cSV2hAtJI23ytAkfUyTRZ0VtSLS39w4WiSES+fhK3me6UXB+hAj9mRwuERWwpKFEepBPTwVlrTL
	APg==
X-Google-Smtp-Source: AGHT+IFQXDyjcq6txiIPp+Qac7tKvl/ndTugIAbm8ckwRMymv+grZLLoPEAAMctJ2LQUvePKBGYFHA==
X-Received: by 2002:a17:902:854a:b0:1eb:7285:d604 with SMTP id d9443c01a7336-1f6ef217771mr5610035ad.6.1718034575691;
        Mon, 10 Jun 2024 08:49:35 -0700 (PDT)
Received: from google.com (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-704383abb2dsm2525394b3a.151.2024.06.10.08.49.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 08:49:35 -0700 (PDT)
Date: Mon, 10 Jun 2024 15:49:31 +0000
From: Terrence Adams <tadamsjr@google.com>
To: linux-scsi@vger.kernel.org
Message-ID: <a6veurdtffpdbk7ios64zmujnqyvdp5yl327s74zwufnpqfver@owzlyhqzfl6r>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

subscribe linux-scsi
