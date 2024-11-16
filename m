Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBAD1422AB
	for <linux-scsi@vger.kernel.org>; Sat, 16 Nov 2024 15:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731771649; cv=none; b=TB1aQ7L/8xSdyU131ftM33yvc/ZOVYgdPwNBV1vSLomEJ0QTM7kaqqrXeQ31T/uKRU+ZHuO7bU3N5zOC0kj2+JlhgTIvCM/TwwPch/Uzs3YzC0Bk/J+hQwX41wVn7ZHoJv5yc+jIpikbsy4n8SoYLWkzqL/wokNyfA+MynGnhZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731771649; c=relaxed/simple;
	bh=Wd+7kLQISUZlzyPvYmSUTVOb8NV4Vyd3OpsFXw6X7a0=;
	h=From:Message-ID:To:Subject:Date:MIME-Version:Content-Type; b=ugs9rm4bv9usle1aFVBXq/KlFAw7Z45tZucpYM7YVg+uRnjcfaBh7li/Oo3K1bc78n9qXB40iKdvTlUGueLdTON9N7cff/sww3l6a7G6Tgc+HDsYAVbgTdLrRZ7KOETGryrd0KOYYfr08WDQiBqQig4YseCuX08Nb3CjDejCuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9yMRJK/; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9yMRJK/"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20cbca51687so4735555ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 16 Nov 2024 07:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731771647; x=1732376447; darn=vger.kernel.org;
        h=mime-version:date:subject:to:reply-to:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=f9yMRJK/9Xq48KjT/mYTccuc8d5hDfENNn005S3qh6tzTJ1UTzz/i0DOgM/8YmvHL/
         MV7JMW5sCmZGU5RmUIhMDzZikx6EpZ2mOgoLKHL/KUI6qA2gdAjWwyTo5QK7FQlfKKVH
         kbMArrOSYtcbMHp/on4StFvvNXWMI0nmw4SEp1SESAXlmO9pdpXXGu03K7oy8xHdqmO2
         Jswd2Em1piYDsuRx7ikACo8ypOi1BZLp2H71LJwEGbCQPNR88Nh59t58FJF0Jpej2MlV
         cqU4cKRc1HvPQ4Jvv1jZQp0bP9MrwRWV0kv5gafPijef5hJAtkOaMFYx3YkkCLinV0Rk
         Oi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731771647; x=1732376447;
        h=mime-version:date:subject:to:reply-to:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=hJSR3OJWc8XA5GlQRDDQPlYC158pj6ncnjoOUsz4Ic1pf6Zb8CdWFTOHK66DhKGNJB
         ps/PtNCID1ezikI+C/Gqui8t8Iv9P6OoLy5dRBRrFP6MNPcVeMH4EBP/VOB6RenN7hco
         nksxHgH7tDAuo951/kPGFv9MCjV5aBupjByogDfaKKY4BJ4hJ3IrPrdq4BytHDEK3qpu
         UuRejRP26pMy3QRtEKuxl5JQhRKh2gIoJb4qWjvcw07usQ/RPVXcZ7YJD1J6TDrElxS0
         8FRBQvukNMQ7S5Hx1UtUpUNFfhU55Ey23gAq6FWnk5oUDHW/0/sGrL6phPL14fQi+mc5
         y84g==
X-Gm-Message-State: AOJu0YxMAdleD/NGk7gHGUhAM/bLa4uT3kJQQuoFRNVQEoYFEIDRcyr8
	gzWfdkeTohzpIwyV8LfO9VXHi8wpNHfabtb4T02VU4P9EkkEp1qvz06k
X-Google-Smtp-Source: AGHT+IFbYKMozm3z2509r0FZ7WDf0wAnXCBZAP81rTyAOQW7UaXBSa8+na8NMWGteQiCA7cZVnIDpA==
X-Received: by 2002:a17:902:e891:b0:20c:7796:5e47 with SMTP id d9443c01a7336-211d0d6f702mr87983225ad.4.1731771646946;
        Sat, 16 Nov 2024 07:40:46 -0800 (PST)
Received: from [103.67.163.162] ([103.67.163.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f6182bsm28740265ad.277.2024.11.16.07.40.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Nov 2024 07:40:46 -0800 (PST)
From: "Van. HR" <madinaradjabu911@gmail.com>
X-Google-Original-From: "Van. HR" <infodesk@information.com>
Message-ID: <9d47eedb4397c10c284425a1e0f11ebba5c33c1bd4ccca12f274ec7d2fd4d589@mx.google.com>
Reply-To: dirofdptvancollin@gmail.com
To: linux-scsi@vger.kernel.org
Subject: Nov:16:24
Date: Sat, 16 Nov 2024 10:40:44 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello,
I am a private investment consultant representing the interest of a multinational  conglomerate that wishes to place funds into a trust management portfolio.

Please indicate your interest for additional information.

Regards,

Van Collin.

