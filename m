Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F28B19E999
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735814465; cv=none; b=TeKukGGpxko3wVa3MLFf2OnbktYGE/n6YO2XofJEHEPL1UxK+k3gmsDPYIc7+lPmgWvcyjaKUKVo4sFtdh2IqUtJujNeGgammMljy+nme94oaMDWimgxxFGZrrgFx6x1IRRgIHIKa+cWUX8drfcvz3fJr3DP9spsXd6XJn97ac4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735814465; c=relaxed/simple;
	bh=pMXZiRpBRPmiXly100IZhcwAkq4eNjiCbRiC92Qtw3g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WcfbpmsxIZyfu/ATBbO/g7Y5/8njMyivlNGd/bN5hVbJ/R3FMBvaFztx0gzCsxq+xGFriIcPaMIGkMu/Bd40tOdknUeFncI/nlXCp+gvatomFnTwKtptg1aYJWo+ARhDYFRiqKYRVJXVr2Jh04lT/RxOrxeYRvl6zR4E+eLhgdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a81777ab57so97333775ab.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2025 02:41:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735814462; x=1736419262;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hzyV7ZElCa83ikzcuqqoZD0xz4zHyxxfrWJ2R/1Mz00=;
        b=Pr8KjJ/zRKWznHKa8BCF56/cURD/sGyFmvX6h+DiZ4Ey92z9vnvO2b3nzioB+fpTAO
         kIJCxOleIaESrW6g/nUM8UnQw2RGJbaY2fxfiX7IiGzRfNyUIh+gbapnhIETQN/gtXGv
         K3NU7RjXEclSaNuISQazzw2PlEIvw0dvFq6fW8mPMjoenAjGRTpU86al0hsiqv+gAfzD
         kui2D32nKKpp0KfzcgPDSnjIBM0MyUTf1BXEGYZwuj/caul861WZ4o355Oe826Z2miHU
         pzjsXqRlLg6Vckd0wt8MYL3Q7nsuWKGKn35A152kwfkaQvtpzG10qWciF8C9TpptcvOO
         CKbA==
X-Forwarded-Encrypted: i=1; AJvYcCX67rRe90jsJPEUjFKayZp8Omi+eYM9h8GxZjTxA54g6U394PC5OvXt9FWIKzXBHvcJNceCrcNo/XP0@vger.kernel.org
X-Gm-Message-State: AOJu0YwkZLAeliFN+A/22RXf+G+aH4sKbDpve8DGxdVLU2Ec3bYtJBsA
	gPprJkR2jDHKzwjqh0YKkqgzXEoOTzN6FknKKY9+Evq/JaDkT+mrsCypQVCzbu5DBi9+SXDrFiI
	atGJLrDKKuEH6bhNuf/4UlzrM0cazmYWYHJicLOJt/rfE5FazAZd8GtE=
X-Google-Smtp-Source: AGHT+IGA47IBOBbWR6mdnglpI3uKmGDqxXLykYJo4Q03z3y7tq1aR+ciBFlNzYQC2yO+rKBanjoFhJopRY/m7KUMI3RP96hMqXnu
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1705:b0:3a7:e800:7d36 with SMTP id
 e9e14a558f8ab-3c2d2279c01mr369064545ab.10.1735814462620; Thu, 02 Jan 2025
 02:41:02 -0800 (PST)
Date: Thu, 02 Jan 2025 02:41:02 -0800
In-Reply-To: <20250102102816.1261-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67766d3e.050a0220.3a8527.0038.GAE@google.com>
Subject: Re: [syzbot] [scsi?] possible deadlock in sd_remove
From: syzbot <syzbot+566d48f3784973a22771@syzkaller.appspotmail.com>
To: hdanton@sina.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ming.lei@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

block/blk.h:728:7: error: use of undeclared identifier 'queue_dying'; did you mean 'cpu_dying'?
block/partitions/../blk.h:728:7: error: use of undeclared identifier 'queue_dying'; did you mean 'cpu_dying'?
block/partitions/../blk.h:734:7: error: use of undeclared identifier 'queue_dying'; did you mean 'cpu_dying'?
block/blk.h:734:7: error: use of undeclared identifier 'queue_dying'; did you mean 'cpu_dying'?
kernel/trace/../../block/blk.h:728:7: error: use of undeclared identifier 'queue_dying'; did you mean 'cpu_dying'?
kernel/trace/../../block/blk.h:734:7: error: use of undeclared identifier 'queue_dying'; did you mean 'cpu_dying'?


Tested on:

commit:         cbacbf06 block: track queue dying state automatically ..
git tree:       https://github.com/ming1/linux v6.13/block-fix
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd7202b56d469648
dashboard link: https://syzkaller.appspot.com/bug?extid=566d48f3784973a22771
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Note: no patches were applied.
