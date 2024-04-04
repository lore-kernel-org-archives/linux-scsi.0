Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0F55D73B
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 08:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712217971; cv=none; b=pYiu6+Ik/cnvfEfsZuRoeCeqbJPnbpUD0QenuqunycRHuO6k9EfQyfafO0QvMALX0SXKDMqvbn7wFS2Qgijy0zSz6kqEC2ISY6H+gxIqLxC8AgAXqf6+PpaHBL6YnqSm+DmO4Pnbj/mOmzmfq8B9s5ztXsWa4ZYSVDV8HR5DS+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712217971; c=relaxed/simple;
	bh=+wHpL4ELB4tfY8mzxRYQtTI5PgupGQUzD7JeK2UYRc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=INfkxXS9FDkMm9o9cPeapcsnzvkPTGYo6C5PIvOeBW/AJii0rTxhvLEfq7Hd0UH4TRdv6BDSolw2Tt5C5gydz0sq5OzDAVVtVI1lgnD+WWwciB6/Tt9Hyg0PMrWFfx4PZVNTusOIlD9kLVj9Tns6gf+bkPdHFTeIcewUBuEL1tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MO8NHEjd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MO8NHEjd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712217969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wHpL4ELB4tfY8mzxRYQtTI5PgupGQUzD7JeK2UYRc8=;
	b=MO8NHEjdOT59jMwV9vJCLiu3I6hXHfu22YBhqrJ+ka0QTOg96SohokllvQywWQWWAxoNOI
	m37uKUaUSk5Qj8LRpVru4TlY8vd75idCRqRmcq7zooYmFUmAv8k7PfEKgUpWpHZig0OfEp
	c4AbqMc6LtEe8PCzkh+Lr4cV+k5jyJ4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-UYPTYBspN9qlv0OOHA16hQ-1; Thu, 04 Apr 2024 04:06:05 -0400
X-MC-Unique: UYPTYBspN9qlv0OOHA16hQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2a25f6ca48dso635716a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 01:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712217964; x=1712822764;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+wHpL4ELB4tfY8mzxRYQtTI5PgupGQUzD7JeK2UYRc8=;
        b=YUMW6a2FeZxC2oBjr3+Lbt6FdgcZ+dQcGyvbKYTv9jmKs/mZLB2FltCXX4rh2QPFLo
         yYYCjOCkiQUqJgypg5yW75KXG8vBtzfdjaPgWJSZUU9/ITwJDURZfrAwFdaXzzZ5EtLv
         U5Npn6gmJOJTgmpmQOgQnYCbfen4IFPBYZ8fOOPtTwIVdUD28yuPtUBbdNIXcbiy+LNR
         HTtrWpfd0oxWkb53y9kITbqWGMRRbYq0r+anXKk1V1B1pmXAUWusuUd1SohDyfKbn4LS
         vm27w6/gwOjx7Os/gwct73055plLkCytw6QoJ49vQ7wUL479JDW1FaiU2v5Lwgoq1rvs
         PZ1w==
X-Gm-Message-State: AOJu0YxDhqN82Si/RmIYAyQz9CMQhewcDojiwfHGkS+532F8Oy7glS4t
	LXs/YXMXyLhKlu5b1PjblswU8OVrcVM6IkJtcu/Twaja0lr+/3wwkYKjXGrn37hGdtkq4s3P0kv
	6xgFlIvtAFDKKyszofQJWVZFCep36PBmOflJgxVPzNEUGtasZFMifVl4CkIILKjXMQ1D+44jlNV
	76DaPzn3MEeb6SWiOCQs4JSKEoHJfnE3vucG7RFqHqX1qljxg=
X-Received: by 2002:a17:90a:ec0d:b0:2a1:2506:b937 with SMTP id l13-20020a17090aec0d00b002a12506b937mr2226151pjy.23.1712217964030;
        Thu, 04 Apr 2024 01:06:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkKHO/cONwvuFdkQZiZKtVE1dkpTD6nsu31UXIKLCeKirfB5PxDLdPI3NngPMfmQ8LHQ7Nn+2aaHLhjliCgYc=
X-Received: by 2002:a17:90a:ec0d:b0:2a1:2506:b937 with SMTP id
 l13-20020a17090aec0d00b002a12506b937mr2226133pjy.23.1712217963719; Thu, 04
 Apr 2024 01:06:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+VPe31d8=Uf=6TwY2v_P-d33kJKxHJPd-zcwq2hz0-3WA@mail.gmail.com>
In-Reply-To: <CAGVVp+VPe31d8=Uf=6TwY2v_P-d33kJKxHJPd-zcwq2hz0-3WA@mail.gmail.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Thu, 4 Apr 2024 16:05:52 +0800
Message-ID: <CAGVVp+VTfZ4HorQQWR74-BR9S1CCaKJKnG_1R-CJxG3w4XMJmA@mail.gmail.com>
Subject: Re: [bug report] WARNING: CPU: 2 PID: 987 at drivers/scsi/sg.c:2236
 sg_remove_sfp_usercontext+0x1bc/0x1d0 [sg]
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

looks this issue the same as
https://lore.kernel.org/linux-scsi/81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com/T/#m5ac1793fccfc9ea8fe5d1f0df582830ce1ba17fe

