Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1DB50276
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2024 09:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732093505; cv=none; b=S9HdCAfcixqmbOg6NwsaXlmhF9DF+r3HOmMhUWWuEgr5w8QOoOtB1ZSyVfAIA5Y3Og1xbL2fxIdnjQyyEgoEbO5iTcXB3F0QW5rd3GfLuxKTg6sEsNNi3Mi6W+jgYGYJajx0/dSsbY9JmcmeQ+Yy4ne3Chm13RA/uIqbCUt1Hpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732093505; c=relaxed/simple;
	bh=LTsfuqobwOuYJTWSmPS2Is+RGXAY3qeHoSjZoR9SpVc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cBvSxxlvQDgGErNGROQyEuJ/e0d5FDQb8thLlx9wV34LyJqOOKHSk+SiCGODzFAQ6+Sv2NRNoB8PZG5cIJD33dOXkcTyV1Ma2NZvfh8LjQcw+ZYIWoCoXL2T0kJHsTJUYQQZ8MmBTe2qCraM/4pKbmZUUoj66FDq9KwmiPldNRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ab369a523so652006039f.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2024 01:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732093503; x=1732698303;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uvk3oMrAGU4iCjocAkLYzWcFnA6WrART8sfIGJYHVaI=;
        b=D0A+7qX1GIrUsV3ldMcRmyEoqbUCMm7KWlVnBg2bFDo5n0b3kJnMmCYmiLHOx1h2T0
         QfuycXKa67dLBze5XMV/YX0O90jwBM/MXu27/+oOxiPwzXoKQRlaHedS5lVpZbEUTxTX
         C0sTLCaXBGWi7YrF7UkwvTbAoLSmPS9ygeGhSDJrjUIRJrbTcHxIaFdXyAgtklgh39cK
         ayC89DCc6IRpPuN2x5awUGRVQ0ObvK7U3ekvvdLDEsHmu8nNN/Cq/d6d6CmMsSquzgyB
         fX5cEAuYwnMasn+Pk3aa4yU5TDF6HzMDpbH7VnxLZfX8ABM300CvT+gvOyza8hEPsMtD
         5HdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkrNADfAtE167MfyaEF4kui3C2PzynzzJqcO077+d2jbMBouTihfcXKcISnN6xCo+m3tUOQOJcY6Yu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6lqFMqDfp13n6uHn1XTtj3c9zv93LYo+za6PJSRy+GTnYsIQ4
	ccsHWEuzvR1aN1rZ+tFN3nXANoG7kmWb9KRi0xUSdcdyBspqX1dwMkOsmazVCt4h2j8X4I/qnKx
	xctq/BGuHU8nu0yomWafYp39AgT+APsTb3ipkDndvz+63bHI8OzUztA0=
X-Google-Smtp-Source: AGHT+IEiej89K/rL0pcqhadvsesMvYT0TZ6b2o8M1aBONEBQbpwXedWa6E+KeekSxx1bGhATHKktxe8x4hG6k51KxydDnMIi3fjI
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd86:0:b0:3a3:4175:79da with SMTP id
 e9e14a558f8ab-3a7865019fcmr18847425ab.13.1732093503157; Wed, 20 Nov 2024
 01:05:03 -0800 (PST)
Date: Wed, 20 Nov 2024 01:05:03 -0800
In-Reply-To: <CAHiZj8hBjro1gqmVt7L8La2vBBNTa0VUY1kdb1i1kNJ-x_Dazg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673da63f.050a0220.363a1b.0008.GAE@google.com>
Subject: Re: [syzbot] [scsi?] [usb?] KASAN: slab-use-after-free Read in sg_release
From: syzbot <syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com>
To: dgilbert@interlog.com, james.bottomley@hansenpartnership.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-usb@vger.kernel.org, martin.petersen@oracle.com, 
	surajsonawane0215@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
Tested-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com

Tested on:

commit:         bf9aa14f Merge tag 'timers-core-2024-11-18' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11373bf7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=48190c1cdf985419
dashboard link: https://syzkaller.appspot.com/bug?extid=7efb5850a17ba6ce098b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=106b3bf7980000

Note: testing is done by a robot and is best-effort only.
