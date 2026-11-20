Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175094;
	b=oMoDIGu3PsVc+Jww/TINO715j/osgsXmMy4RObvEhjFG1v/7WaS6Gdb64PSoDoKbf5Yf
	 oUwOosWR3fsFhgFIF177IvlVOX8oEby4nn4D5o8dNOpblRMHFc7A6fpLNm/cl7VOYlebz
	 TGnSuDY9ly3VTgcq25VweYZOOpxhchUvqxW3RAEeRkRcCylSVApSAmWjXBkVNR2RRW6BG
	 bwtKkfFNnPfBVaNEbIrbpgqht1GxFazeAbtROjC4UyX9+VgPZbKz3uAngVBoXEO1KnWen
	 yGPY0ZMZBesiubvGLC/XmsqKvNV3HCFw+0uiT52Om2fxKGo/l+UwK8gfIZq1fJDBtgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175094;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hYltVfrQnjlF4EF9xtYm6MjuhO3wsKtp0+5xIybN6k0=;
	b=tK8j411cwiyqqsHR35MBvZ5WHDsQQpzqPqVohMl8EVGlDlh9gDBIMGej9uyBfHl42XTC
	 e3I952XYxQPVrpu71AChw0shAB+hCdR/jpBSdZ2D4F1rVZ+RFP9EO9bdxTUxwmj7zZ6/8
	 y/1EAIObj1AYoDGtZcJZHs5DbAPV6rd7O/KQUOKKBlvQptWISiI67CyjcSdG46ofRC1IX
	 4AHQEAQUNVegb5MmwyC0RqtjbKTvLI45iiI+PPo+iN0Nmiar5gyKOBKmfLIJEqP76Amla
	 FkmPhGDWXrdAkFx+nqtiCo4OGF3cFPIMJX3M2MTR4fD5mbLdy+asm26CwlWs27lAkcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OsVStg42;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350F3606AA5B
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 350F3606AA5B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OsVStg42
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ccca948203aso864429a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175093; x=1795779893; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hYltVfrQnjlF4EF9xtYm6MjuhO3wsKtp0+5xIybN6k0=;
        b=OsVStg42bmwcFe4BZTgkvEzwvKHskb7TIK4K+13XH5z9MSy9bwHJ7NrtVOjNwU4Hd8
         B7AUsa4Fjyvt4OA2XVQcEipNiMdYGgnZnb69MB+2cmDuODtE5foceBpQgIAh8DqXtuk4
         wQlktAfbV5V+tR2ZZQ+QJEHaTLQKHCaAkYh8t5Hm92+cjPlNSRGGcBzoYuay8zEjtWFc
         1cRMdiFAZ0ST0zIyD9ynPi8jE07Q4E3WvYmlcGlH8R+eQwu11KBnlg+M99HE6gYUTlWP
         T4dA5tsxxPpMx2aLhVBQN0pK9l7gtUiL9U4MN4O0dIVHywYQhkZ9ZWPAwtnDX+B14Ua8
         gxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175093; x=1795779893;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hYltVfrQnjlF4EF9xtYm6MjuhO3wsKtp0+5xIybN6k0=;
        b=xHPvei7kxdxaue8OkjzzIph5X1OVfL9ydpyCSpWoko9dWpYZMJ+21FiGIdEVn4DsWv
         f+DcU1aydqKEwV9Lqfwul3yXuhuCieiyobJp4K0u/jPkg19ffvzA2zY51YqxwBIm0Ccq
         6bKj9uzOXO7T3oMowtcbvnVtx+TlDrRJrhxxYEGgmV1J4J3SZccMIV7IDp5WK3peb/Qt
         KIyerAeKnPS83CbfGEGC434sVimqF3WotAxVSes8L7Q73c/7+alrHG9iKlKW4mhUQ5Vg
         imn82A7FSH9o5k9W4Y0Ui0zS84JMuCRL/DR6r6c21i6rlNQ2mO9hIVCMrLwsMCQhfmH6
         oFFg==
X-Forwarded-Encrypted: i=1; AL+hErEY30J6SeuaLwwi5t0HpGmtwytjYvGMqb5v0wkx8FP8fqCf2TmLBVC0Rr/NtcRgvM96QtdftlF3Mpi/@vger.kernel.org
X-Gm-Message-State: APuU4Z/uvPYTrAAEciAtXwpU9TJscl8pS7K1d8tuUhfRWY5wKVz0cTDQ
	1C9Z0FokFST+aXx9203szJnuhE/4Ct8PVywGFTiLrtYoE7DzVSwMMXoc+eBk8ZgqwYg=
X-Gm-Gg: AYBFou3QzYtAQwp8Td40OrPOxb72BwMT8hh3L+mM2+S82+kj3uDr95IDu0zYJ3U8uaA
	/3gj3pYJr2dOnc5kaEuir1LghnQnn86HfzUp68168vHHN4nz70jJblymvBvSuYQSx1O9I3z8Isp
	r5QMhmojpuCZC9CUHhaFO2i7ubclW0nstgsj8EJ/UKi6JwfLz42fJFdJH0G7D7nIbmDCzEoZ1m+
	+k345z3qcky4SMKZYhQDhfQlKbPCooxI4OH9HvbixvRI8RQQHl73jO4xTLCs4sUujbJPG/+DeVX
	f7gBXRCQbdMdPtHO+9KY7vphZ6FaoNVDT+rZnhwyKJv3xR1ubomckqOcnoOZFFhAGH1/jrCPvgd
	WksZmwttt744q7qXMNsjTBZ1rdE783MHBZyoxYE2/ovkfOP/HSrR9IhQohAONFHZr+aZ7WApdSe
	NSsJR7yfg6i6qbX6aNcwDn/57vAtARrCkQb0Pz9qUl1pln49TwoU9kw26lAmLMZNtcs9675d0CC
	i9Ih8ZpgTWkj4iqF3b3g4OlRl7i3WA+tjRnQqQ0D1qM/xNfnoQP4HFCPt+ZlT6XvCLMuplfS8aC
	G0lqxDpgfvFtzvyw6DJrQYcyVt45AZWpyig5nnVzDZpxelZSChEw+oY3+7H08rCMjH29mrKTYbT
	wn1GdwP1MPw3tzwjGh1dTT75FySPM/zEo71LB
X-Received: by 2002:a05:6372:a713:b0:3de:7bd5:fb47 with SMTP id adf61e73a8af0-4014d1590ccmr2473352637.39.1795175093626;
        Fri, 20 Nov 2026 03:44:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d02ba46sm1138936a12.21.2026.11.20.03.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: jgross@suse.com
Cc: sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH] xen/scsiback: unbind the IRQ before draining in-flight requests
Date: Fri, 20 Nov 2026 20:44:48 +0900
Message-ID: <20261120114448.3072673-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr>
References: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20261113110036.146860-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
