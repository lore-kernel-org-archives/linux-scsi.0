Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35C5207DE4
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 12:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733402765; cv=none; b=o0RdXKr/Ni/kIlPHcRFaqaOIFlwj/jdEnqu9cl8z2t6AMxVWXcyNjjOOtvpsUx8GQXdtqyH0hRFaeIU/KxLI13GF2Aw8cb0D+SLGKG8aTzmfkn6+226twUMEYXVn8HH631gTMIGwIm7+w6Cj5wnk9hG/YgEBqSFLVoM+u3ph6VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733402765; c=relaxed/simple;
	bh=eImJIpIF/KSB4uiwTOn7hdKg77lgYoGfVOXw0Hhbj5Y=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tu9HXFuKp5T95O790uPGkk73Gxzi6MGJqNCdZzAVn8YvMAU5GTIbATc9Huyj9sr0fTTVmHQEKLbGUdiCfRz2LyDK4DV37u5cYrAJvwoC34Ql77CU27EBbfF4FNZN2G5U2FQa1KhW3bOae1tb9TqmAguhLiGbkJbxPctHbFs9Jas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a77085a3d7so8556175ab.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Dec 2024 04:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733402763; x=1734007563;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0iaCAPdaKa9qoLnGhVA0Z5j3Ik/H4wNtiMhCICR7/8=;
        b=AIT5d5hIWTu9GnQP74UEMKOeFspPW0KmbaAxYpzeerx1WpSD/q3sORk5WXbKcC9//t
         avFtpLyMt+pqSkG2b6jio4bUwD5aI+xH7loZsgBIpT3XHOklGiP8b8oSTuPovQRlpUFc
         vzBT7shf4JV6pIfcv6vh9vXYM5xZ5ctS9uTk2f+wyFtoI+c2smRogsAqN5VcpDtPyOnp
         +2Bns+L6pMNwY9hN63/lnyETOz3apFsj6qxlRgP4RjUKtUwVEtcCLUbmsoGI/UtDJxC7
         GSmUediDSb4VbEXO4l4Xwdkd0R0RB1V61xIgojjFtSlT2KctuM+vGAKGYoHFB0tU+C0E
         VHEg==
X-Forwarded-Encrypted: i=1; AJvYcCUgIdLA22iQt6qesq/yD/PTui8xQPDgy3hv9oqlQ/ewfrDyC/ZcJJsWRRM5dcYtXTPddtZhj03f4+Sg@vger.kernel.org
X-Gm-Message-State: AOJu0YytZWZtBmy+mGlMqux3QyaSiuSQpKwBFka1jb8SL0tVkz00FJRR
	Z/MFxAPQjq+UUuq0vckQi3ZJU9AgcT7AsZiyAPjWzeVgAYfzVi7jK/NaeVJRO4Ro73Phd3+WA+4
	UYgUg0R3WsoPYlxgfXQOBfd3ZBGspEZPjFXZyo4ggMMuoSsGHR3CU7IY=
X-Google-Smtp-Source: AGHT+IFTvRfKxh9O+0cvI5lb/BT7auEzA7r36ebWM+MMTsGUSosowkPGFsx5Ci7/GOAOsm1aaFjR8MlQwx95i0rRr2TuoXxlTcy2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc3:b0:3a7:e069:95e0 with SMTP id
 e9e14a558f8ab-3a807576882mr27752645ab.1.1733402763106; Thu, 05 Dec 2024
 04:46:03 -0800 (PST)
Date: Thu, 05 Dec 2024 04:46:03 -0800
In-Reply-To: <20241205123216.2354-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6751a08b.050a0220.17bd51.00a1.GAE@google.com>
Subject: Re: [syzbot] [scsi?] possible deadlock in balance_pgdat (2)
From: syzbot <syzbot+ac962f01776f0d739973@syzkaller.appspotmail.com>
To: hdanton@sina.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
lost connection to test machine



Tested on:

commit:         c018ec9d block: rnull: Initialize the module in place
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-6.14/block
console output: https://syzkaller.appspot.com/x/log.txt?x=17441330580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6851fe4f61792030
dashboard link: https://syzkaller.appspot.com/bug?extid=ac962f01776f0d739973
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
