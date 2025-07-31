Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4152D24BC09;
	Thu, 31 Jul 2025 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753980784; cv=none; b=Gr/bdj7Wf7tUHZEka5unrE54aZTlM/yIgBSmBxQbUtlpO5Nfhu9ckaMDoJiquXL58ZXthNyfeL6cDKNF7kgv2RLhcXZtSNerHuHaHz38NV8u9950BuIZd1r7x77Mwu2qJga6pKXgdi4ebUrw+Mgf4Vlin50MPK3QdHr4wUap97c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753980784; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MOXJpVR/J+bdbG6gO6FRFvxsZDCY202PA74ZRWlhnJQrn0/xvy9qA1afeSn/wPsZOP6Q5pyiPy4z68HGX7bYIKVGRSnUlWfPbFR4SVa10Cx4DNnSM9ieY/xxl4wZvRDnQqdxfhVWE4qgQaSYwQwmNTp7+h7DjyVMLk7uDM7ADDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JM48qgJD; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JM48qgJD"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e8e014c1d19so963369276.3;
        Thu, 31 Jul 2025 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753980782; x=1754585582; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=JM48qgJDdpBThpJTDXfAq78NJCGcyHUNmMqiEFYbJdUjLr3EEhsWaFopdSoAQZ9tcm
         Glx0Amt6FGDg7YffrvAaDniutwmFLoKdG54qpiEWgev/P6fEiiSpkgVgREaPnH6aHnR0
         slP8dCbRqu+yXbzRUBkHMhtInbF2TrZZGe4Q1Jm6qcJsjepfEgcgfLSn11r28I7OXh2w
         dxOkNJDth757GkVHL5MYi4DE/p6gm/Yz0GrOGD93D5cz54Ip6pf2JK6Pa87AVEAzgNuM
         e+zLwWCWHcMwFsvmGaufVGbNpVuN/X9qW3g2FMQG90+ChOhu4VTL54AANSrkYqCPAsKe
         6Zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753980782; x=1754585582;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=g2KVMZ+UkVhZvzBY1ZQBJWuxUT6QqKlgQaW9Z9C94Mc4poVyNJ4e8xIJQHKhOzst+J
         AqhNUT3e8NV2Dtldwyi0ngPnUJTveenVuVSwwmeydM7a1wPzVRhgvNdPGQDyoM4QNiky
         ReY3YksKYX89Lx6PReRGAlKWCE876/eOnS/BzVp8g0dh1p/vSzTSvlXMpTCkOfzwOLFA
         VrF5K/NtZJAXfjTdnwWjkAn5huk1lHmj9wWHcwKNl40c8Yy1kgEFvgQbKjkMzwANWjNX
         WGm2UKFS98c9tdCSOuehSbranmLJIzSMUOUVOflTgHnT02w89hYYydKYxNq5lM+K8JVP
         TDUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEsa2XHcACmbhoxUH4uxWiHijP+iJRJYNX8EUEaoTb8xkD3Dm8mbV+X46gD4n+ESXaZ875KUEZi8S2nFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNpUvfavfcQCRtBajR57XI/d9WPa8jrg449uX0icmuNSKSTsLs
	yqU5WSz3bD0KYWVo01FvL5RiiM37L5fj69R0Mr5hpGFjvQZuJke7X1kk+j6J275+UODcdpoTCCq
	MXDxr8J4SyWRpy3KIzkkLHsogqgWcOGQ=
X-Gm-Gg: ASbGncvbY/uDr6wKkf9yvpFpP9Oyy+RIethEI1LotdRzzajk+nspo2JuHutj9qKQBMh
	WdUjUWm1wfGv66SCkrRvlISivKsK2/IWvP6wUcmrJer1OBw4eURY0oRUYg9xaH2ve7eSsYdBQyt
	ve8fojILNbJ4XPZSCBRpghAOr6x+AAGq3taQJqKNJ3TDXVcDqX2bu0wyDLobmoLfqCy+q3XhiAR
	SDMQGuE9e26QCRomJo=
X-Google-Smtp-Source: AGHT+IGG7jDXqdUvjVgGITVdC1V3/YSkkYuOC0wnwU1VV2FsJ94rRReKf3bN54SUFBzXT6JQMTm+EhGQfwVz8PlYn50=
X-Received: by 2002:a05:690c:f87:b0:71a:2065:525f with SMTP id
 00721157ae682-71a465f3075mr116714527b3.8.1753980782250; Thu, 31 Jul 2025
 09:53:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250731133311.52034cc4@endymion>
In-Reply-To: <20250731133311.52034cc4@endymion>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 31 Jul 2025 09:51:40 -0700
X-Gm-Features: Ac12FXybp4pgZpZXLIRPRfHGdWaGmxo_TZx534y5ah3VYvQh-vmf27OVsB-q2Ts
Message-ID: <CABPRKS_SV7H6S_NyyUmYPt6MzWFEs1zuFCR7dXHV2A=Z0hSkMw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix wrong function reference in a comment
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, 
	Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
