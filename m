Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46931223DFD
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746197584; cv=none; b=FbOtBsfYwBOjUmhB+izbSm9gEEv5IaNGx7FtYz2Cb3AwDs6YEDDJ2iCuPVSOJSTGjSLUqSTggOMmPchmcUV+Vt+Rp5RmvPUqFZP2YdPhKaVKfNNZ0dayRVk2YcNPm4hRIak8QEx+KoGPziF5CIHAsqUvRjbpSgDe3W7blW6KJxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746197584; c=relaxed/simple;
	bh=RpJVwCDKSnByw8jtUR+cMwoe+OU/wu1hEclu+sJDocE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=rVauF8YJMPPwe1SGXjjRhXELUCepm0IcCQuc9vd/g6FmoXi4IY/kTuCUjJsTy4/lOJIf3qaPGldTTRSnjqUMhF5FilxP3c5fOA7lzQR3hj/IbFR6BewjpAHOcRP214FD6g60o+xjEPhmYNkB21xR60ir6h0XJnp9wQcQ3rZGVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E6rWrHVi; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E6rWrHVi"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-af579e46b5dso1492730a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2025 07:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746197582; x=1746802382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :reply-to:date:from:to:cc:subject:date:message-id:reply-to;
        bh=APu7gvDG+GWIH3CqaZfGtDjeCKACn6athf5zXmMCeek=;
        b=E6rWrHVixZk/2yR1CEZxwQereb+nOa30Dn9AZT1dB8ojt44o/TvIOmqc/eF59/37B7
         9Tcu3EQ3n+cN9Kt7TQfXHLCkpdtyW6jMzrKSKTXbQVcu9/0Htlbs0dno5JBh29RbEYsS
         pDisAqT+5U4aJIu1OXX/spewdsgmARy9MnkYkqqX764dGZ940sNk4+OH7Y9XfBWyrSrx
         qNWI6U62ZkPOk4k1XMOcK0ldPyDW7dZBZ4gd5kCPqs80c7Aa7mS110nU07spGvofLRAS
         eMOxX64tgvv2s2uhONTWw5qvucurjusMJs3BUqxC8PEfNvPA0+lUSubt1bfpcVSvsiqb
         091Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746197582; x=1746802382;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :reply-to:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=APu7gvDG+GWIH3CqaZfGtDjeCKACn6athf5zXmMCeek=;
        b=sm68vy686Kp1TpiZ5PDeXkfwzaIRxxj65N7X2TqQ5DVSnNjEMfaf7YYnQl7h9xl9D8
         nmXLFi0YHeW5C6PILnDvXTkYzvlYSD7JDDMcSrA16mSgSv2xcA76luopFSpgWVwxRFPh
         HQKSBBu7cXKl3fZhgJ58iq/rH4QVWBHlrn2Rk8XCwR5oEB5uZIVfY5cApRsHQUHcoods
         8YQA5kSSVf8HNq6OHgvPbwYv6oqTCdc1IfJndmwCKlFZqqYlnzIMRWPzXqoY6UuVPZtQ
         KgPMt1YoTXf+r4g28vuYAYuq9+AjqOHoP9TzFjJPLNSoq97LBeebiRJac9epD7GV9IEE
         cKTA==
X-Gm-Message-State: AOJu0YxZVbmLU7Yrh/OwBwB6Z2lSKV53iO+rPerkq64Nq6NLs3G8Qddo
	RABRtxWBSMNK8TF3KJg9P2tyGHU7S6NbETtkelgka8wVwLAPcEa4xIfDDgb8
X-Gm-Gg: ASbGncs457cEym95dBSeRVYAp5/Qr5uRsEI8Nux7zHWxNkqOWAyqYqnmAOizfWwY8AU
	rU1qnybJ3wfPv0VsdNH7hf5pvfFLXL6sa1ZBIosk5bxWLDJKpYttha5s4jMVLe8evSOv351kod+
	TX3CfDvV2PBMTPKdKmoYXgSyQTQpl13Di7DUjhdv9dKQRxN8wRPJuB54xnFMh7YK8uVR0NhQxeL
	b1w87R/lpszqGcpV2b0cKzQS3BVECAfMhCnEugqeHfczGaH0N8NtdlVZPQo+YFpGAP3vWKcHu/m
	tp/5BS8fDR82Nv/q6bWdB81PG7Vd30ReQND3bZP28ZoZY8nnvZfswN6YWfA67TWSy6Om3vc7v+C
	WHRKk0GAdKUNKPhI4
X-Google-Smtp-Source: AGHT+IE85sxy30u3hFnnBx+/nR9pizKb8PF9fcs2r33kUrwvwE8IqYV57h04ORlIQO4DjvlrggSD5g==
X-Received: by 2002:a05:6a20:12d3:b0:1f5:75a9:526c with SMTP id adf61e73a8af0-20cde85d1demr4840097637.13.1746197582091;
        Fri, 02 May 2025 07:53:02 -0700 (PDT)
Received: from 179-190-173-23.cable.cabotelecom.com.br ([179.190.173.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059021e13sm1637552b3a.89.2025.05.02.07.52.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 07:53:00 -0700 (PDT)
Date: Fri, 02 May 2025 07:53:00 -0700 (PDT)
X-Google-Original-Date: 2 May 2025 09:52:58 -0500
Reply-To: sales1@theleadingone.net
From: Winston Taylor <sglvlinks@gmail.com>
To: linux-scsi@vger.kernel.org
Subject: wts
Message-ID: <20250502095258.AFCDF341E747EA73@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello ,

 These are available for sale. If you=E2=80=99re interested in purchasing=
=20
these, please email me

 960GB SSD SATA 600 pcs/18 USD

S/N MTFDDAK960TDS-1AW1ZABDB

Brand New C9200L-48T-4X-E  $1,200 EAC
Brand New ST8000NM017B  $70 EA

Brand New ST20000NM007D
QTY 86  $100 EACH
Brand New ST4000NM000A   $30 EA
Brand New WD80EFPX   $60 EA
 Brand New WD101PURZ    $70 EA

Intel Xeon Gold 5418Y Processors

QTY $70 each



CPU  4416+   200pcs/$500

CPU  5418Y    222pcs/$700

 

8TB 7.2K RPM SATA
6Gbps 512   2500pcs/$70


960GB SSD SATA   600pcs/$30
serial number MTFDDAK960TDS-1AW1ZABDB


SK Hynix 48GB 2RX8 PC5 56008 REO_1010-XT
PH HMCGY8MG8RB227N AA
QTY 239 $50 EACH


SAMSUNG 64GB 4DRX4 PC4-2666V-LD2-12-MAO
M386A8K40BM2-CTD60 S
QTY 320 $42 each


Ipad pro 129 2021 MI 5th Gen 256 WiFi + Cellular
quantity 24 $200 EACH

=20
Ipad pro 12.9 2022 m2 6th Gen 128 WiFi + Cellular
quantity - 44 $250 EAC

Brand New NVIDIA GeForce RTX 4090 Founders
Edition 24GB - QTY: 56 - $700 each

 Brand New ASUS TUF Gaming GeForce RTX 4090 OC
 24GB GDDR6X Graphics Card
 QTY87 $1000 each
=20
Refurbished MacBook Pro with Touch Bar 13 inches
MacBook Pro 2018 i5 8GB 256gb quantity $ 200 EACH
MacBook Pro 2019 i5 8GB 256gb Quantity $ 200
MacBook Pro 2020 i5 8gb 256gb Quantity $200
MacBook Pro 2022 i5 m2 8gb 256gb quantity $250 EACH

 

Refurbished Apple iPhone 14 Pro Max - 256 GB
quantity-10 $35O EACH

Refurbished Apple iPhone 13 Pro Max has
quantity-22 $300 EACH


Apple MacBook Pro 14-inch with M3 Pro chip, 512GB SSD (Space=20
Black)[2023
QTY50
USD 280


Apple MacBook Air 15" (2023) MQKR3LL/A M2 8GB 256GB
QTY25
USD 300 EACH


HP EliteBook 840 G7 i7-10610U 16GB RAM 512GB
SSD Windows 11 Pro TOUCH Screen
QTY 237 USD 100 each


 Best Regards,

300 Laird St, Wilkes-Barre, PA 18702, USA
Mobile: +1 570-890-5512
Email: sales1@theleadingone.net
www.theleadingone.net

