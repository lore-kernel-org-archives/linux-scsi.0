Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107448836
	for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 22:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406883; cv=none; b=OOKyL06eONwBXs4/SvBlqQCgRTQy5j3GbJAPPh8Waqs1j2HSOjXkHgE82Tipfp1puHH9bx1p8gR4U7S0Rhi0QfO5IE4V7dbIPS9pEweaJYrSu2tVlmKSWI5ailvGLmLzmehWl5eIxf3TqRJMZ24Kz73YRLh7XCJ8tgTLVXGLY/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406883; c=relaxed/simple;
	bh=zcXON7aALxMpqZ4dR3prei60gRR463oqpmsxOX4OBk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S3bkNTowfmHRWR1QTIxXC2Qx777/lbrsAuuItxtFcWxYVaOjTd55stG2p42APlP3VDD75yyOy/pqYESjavPcNYk6rnZWv8HAm3MRNQJ91xqt0FpAC4ysw1/HfHxU1n5qAFi8QccBA/wQ34wkmPjcPsYTRhKz32YlrPQn203K6Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e6b6f86975so3107419b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 15:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711406881; x=1712011681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vFYMCmuHPKpkkSE1yDhdo8I2idyWs/z9pDZfY3buksM=;
        b=b8bFt7FWFxRrSguGX7kH2BywlLGSb0bct4ce2qTITu6tbHLk8WnOAqZeFih+u5dkFa
         MzAq9RkHn0psesBM11HbvKwWuQSR7GXLcBKVlb2HrlIRwL3k7F8BV96e+Qbckrg7oDii
         VZQtwHFOUdt7BfStg0TjUTU6uP1ZAX6hogQ3cwLhSKc+l84t4Ymb3gzGW3E+5LcxgwHV
         eQnZsPnes+8veEBG1EQ32pwle8xytoTkQPxASpP6vLZ1xYLui5yYaseBbRJhZ9RAmJSy
         S5nKwY8WWNzJHB4LoL0Wh6ZETh+6Dw1WLmHYatAgIjXEkU/h9oAPwBFqFlLKy5l+Mu2q
         FBeQ==
X-Gm-Message-State: AOJu0YzmBsOcfsFtAvxHTHHoM1e2ov2ynhaJ9ECudcPIHptZz8goExVw
	rQqf50IhHsGLybmzPXyik6LocQ4PeqgdxOwrazV6orAPkk9T6whB0jvmqe5/
X-Google-Smtp-Source: AGHT+IGU4TjMnKRWmEAz7+SlSpWK/r7y/EsYFBzkdsrZu5RbG5gShHlY/BzZs8TJRd1AaRX2CeVJQQ==
X-Received: by 2002:a05:6a00:c90:b0:6ea:74d4:a01c with SMTP id a16-20020a056a000c9000b006ea74d4a01cmr10026595pfv.14.1711406881176;
        Mon, 25 Mar 2024 15:48:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id z10-20020aa791ca000000b006eaafcb0ba4sm1582565pfa.185.2024.03.25.15.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 15:48:00 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Improve the code for showing commands in debugfs
Date: Mon, 25 Mar 2024 15:47:52 -0700
Message-ID: <20240325224755.1477910-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.396.g6e790dbe36-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin,

The SCSI debugfs code may show information in debugfs that is invalid.
Hence this patch series that makes sure only valid information is shown
in debugfs. Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: core: Introduce scsi_cmd_list_info()
  scsi: core: Improve the code for showing commands in debugfs

 drivers/scsi/scsi_debugfs.c | 56 ++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 25 deletions(-)

