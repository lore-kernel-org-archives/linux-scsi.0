Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8217138FA6
	for <linux-scsi@vger.kernel.org>; Mon,  4 Aug 2025 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754347032; cv=none; b=JuP9BHVNNHt1uMdxyfKnfWY1eEPDsJnRLexieIH18EKPxJ45tPuhStcJEpuPV+d7N8XiWgnFwfiJPI1GEr2odKuzyz1WSmCb2NuvRGpaI3qzQs8vPbhWpm3gQWmB/1X+n37BPhN1/sDUAZ26VgfBAV0V6nL03T0gNi7dK3ewMMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754347032; c=relaxed/simple;
	bh=rvOmNuRjrpYOCiRpzSFV6COwklfNpBPUa2nTcMAKkmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uTX9pvYRhhl/b/txvDFWVRf/I+HbjWrrOMFZEOVuuZuuQdwnX0Z6SSN295DY2h4P73MU9QZyUfH363qwYvJDvzVf+QTjVYJw8mY1RIJuvKukLLi3GCcan1wkTmiCia/1WIgsG4Esx/GVKcilFSCIIcmzsBgFsC77PP8rHhrxVS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+W/I/x1; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+W/I/x1"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e8fe5f3f340so2845936276.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Aug 2025 15:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754347029; x=1754951829; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x0awKfMw7P5tI2d1IzekjXr8z+pmeSfwL4Wb6NZh+0U=;
        b=Q+W/I/x1W3U62l6gApq4BoySzejYJ4O781jFT4V9i1NzGp/ndT2mw5X0jb720RBDCq
         F9Eut+md7gaKjMZj8b8v5+kvVaOWAn8FLILgYipWPVkAt3hZ33v75/OBwJXYt3XfxMdm
         m5IbbzHRN+/rI7FQeEfi/PLUE6G6qMpUaEbIkkD+oNGAi1DG5bADUthhJWq2lcNXJDqo
         zbiEawaFwS1ZHYDWpsmdh8m1BHQbHbHzRzglx6Lo7D4Sbi7vegaIvbnsO648aSvMn+Pr
         wV+qAklOcgqg1b8GIeGl7UK1IBKgs+4nLSjjOFFG2+yxRKzMRNP090qWdPToSbLu4AC6
         +lAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754347029; x=1754951829;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x0awKfMw7P5tI2d1IzekjXr8z+pmeSfwL4Wb6NZh+0U=;
        b=kcOUMdwo9ZAbIfp5r3jaxQlFojMnCLOy/0M4KY4avsg8hvfFsZ9dsCXSb9j7lsFFUY
         aWulbrwxL+qFCL0J0eJ47ZCiK48OpTlBgS+wmlzk7P129H+OkW1CixY97XE7HW20yinu
         YbEZgzqTVP5tDgYKs4JrsPse8nknFOF40Aa+Xt4TaG/uyznP/NJx1mWFCEvLqSYFszOV
         mTOumMrCUkXh88OpaFetr68NS9KFJG0fL80m+A6Tq4eNFb3bp38B+EvHq+fVxXxHoNds
         ltiJcaldb/2jWdlPAmqbVVfGDRr2UjwlbSMsxjzDFFopn/bD25Fl5N/wPyGf43ZnKVDm
         9Gew==
X-Forwarded-Encrypted: i=1; AJvYcCUVw2DNiGPwErx6HEiWPGNZpN00KFtIdljdG6GNIfryKynDUZ3m4BBlJAKeKMmGVR08up+nLpjmpYFj@vger.kernel.org
X-Gm-Message-State: AOJu0YzxrQPLjP3ck7CaL+5Y2dPnA6MXJ4kyeEgsjiv0v+DMTxdYyI/O
	jfW1yuf8A27XKnWxVn57WJI9atS7nUxecDyhArdxuf/qakegGhC9kMAVTfOj/8JRoyBPRMgEz+X
	leMWkbD5EmeIynHlcJ/9UNZEI9imu4U8=
X-Gm-Gg: ASbGncsYn/s4VTfa5AeEYe5bBXPg8N6t68fbPcLt5EZNlfd3oOxTNB8NidhFjnZOElw
	5U0EMg/YYM4rMm3gjfi1YE+IioCP7N5902ySOaxxA3MXczKdrd3qAAWIPeRihXyLtJG+N9hj9WR
	wLSxIp/l2ku/lAGDM8ZcHeOAv8q8o5VBsGV//5nab+Dk/kN80ZIkP1rrC21xsW7N5jYw4CIAhUY
	XCeAtse
X-Google-Smtp-Source: AGHT+IGq6c55SULzvfzKL17Xva7Iq87Ruhk7FOZVgJ6Kx6mk69ie5lek0QTV1PEhe+/x2/GuzwkwQjlKYXGEbrMpRLk=
X-Received: by 2002:a05:690c:7088:b0:71b:6950:c708 with SMTP id
 00721157ae682-71bb6ee9c21mr19487847b3.21.1754347029393; Mon, 04 Aug 2025
 15:37:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SJ0PR19MB459028F515C43C5B91E662B4B223A@SJ0PR19MB4590.namprd19.prod.outlook.com>
In-Reply-To: <SJ0PR19MB459028F515C43C5B91E662B4B223A@SJ0PR19MB4590.namprd19.prod.outlook.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 4 Aug 2025 15:35:44 -0700
X-Gm-Features: Ac12FXxQz4DIslq_ec2G8EnsTUcIQP_VhwWAfLmcM_rW-TroWdUFpL5qLvlcBsw
Message-ID: <CABPRKS8ja20chFQZmXTw2SOkzcMXMrust3HVu7Pq71ctuc9X4Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix eq count mask error
To: "Lee, John" <John.Lee4@dell.com>
Cc: "justin.tee@broadcom.com" <justin.tee@broadcom.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi John,

Thanks for reaching out through the upstream community.  This patch
pertains to specifics better discussed in a different setting.  I will
get in touch with you separately.

Regards,
Justin
