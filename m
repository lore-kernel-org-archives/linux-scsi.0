Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111ED1A6813
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150445; cv=none; b=ORz2eUoGkfF9IMmwB7yuv2vL5LdnshkXt43uXjTXpXYvq+oEcy8LQIs8fO/U3/jzLnA7yLYESo2aiTflaK3iTG9aKBX+cW3s5xA9R1Ed7btXQENFxqyxJ0MbX1qXi44f9td8t+9ZnSCe1bRDnFnHLksjI9lJsJ21VfNq4BA7U74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150445; c=relaxed/simple;
	bh=Yfg2juP1184JKO29G87l8Y7ne38kjTz0flE1V8LpoGg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=czsLpPVbGz/McrANaSB8KERTGNq5wnIz+Q45bbPj0LTXPrYTkag5ildqc3j6xPAE6ugwa8K/31g79KlZ2J4vq9wglMXLtkfXYnEfzdcJIC+TsXaoyTsaw5CVVEGAJbF+B9rXqfZ/aGPWsbpO2Rq0O813T69MPEtJpNGYvI4e9iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab8b4887d4so851238b6e.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 11:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789150442; x=1789755242;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JSjM91GH08wn6prgIRPH6mHdt8AOOF1Y9SfqXTBzxyA=;
        b=dGaWfSTXfnFV35pdKyerdxl12cKZaap/aXlTBRI2sdJhkAOS4n2o3mvV2ubortpihn
         RvI+pSNxfcmdU2izdrtLoTfVUIGjr9CAbLntGlsIyF0o1SUwAbl3RA4K/TkSxfLk2HSK
         KaSWRcdtM6bb0OTCvNRZ4Kq2/oK4sKL9tJ8Mp4+ex+u7he0YZ5hLBrNaND+bCToCEmhC
         ZBuXEp7pOkGshTY150wNEdk9macD6sX7lDjs6P2UjjD0kC5+LQq2J8AokGfo0HZPpHRj
         vJcpzrHnZihRGEIf7An04SXoTjtprt4ZsO22rGCFMw07UNYjHtjqj3hV1CRbhAO5ehH+
         3GTA==
X-Forwarded-Encrypted: i=1; AKwUvBwWLL9CJQgUNrcgSN0fgqCI6M0fp5sQTTBwG2m1Qm1pHzTiO2GXEYS8lWRrSV4l3dGzGH/I4n/oBK43@vger.kernel.org
X-Gm-Message-State: AFuF++khYS8QR77FmQm+TSDhOvTAn2ajWoCImzW4Ap4Rfg/gE3C9iI3+
	copyTln96GVyTTUELkUaJu87/gE6yaXTDBnciM9hrIO5P1dt3Xg/D9/gaONH/yAw0QOpEOqiDFK
	elepiwc7Lt1ZVYLpl4WguP51Tq8WiZnoLQOf7AX7WqDynQ8oZyCDaGSyoXrw=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1620:b0:6b1:464d:4d1d with SMTP id
 006d021491bc7-6c0b9274492mr3995719eaf.11.1789150441967; Fri, 11 Sep 2026
 11:14:01 -0700 (PDT)
Date: Fri, 11 Sep 2026 11:14:01 -0700
In-Reply-To: <fcabab93-13bf-47da-91ac-5e7fcaec6362@acm.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa444e9.f2639fcc.29487d.0033.GAE@google.com>
Subject: Re: [syzbot] [scsi?] INFO: task hung in scsi_scan_host_selected
From: syzbot <syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com>
To: bvanassche@acm.org, james.bottomley@hansenpartnership.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mkp@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com
Tested-by: syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com

Tested on:

commit:         74786683 scsi: core: Make SCSI host scan interruptible
git tree:       https://github.com/bvanassche/linux/ scsi-scan-syzbot
console output: https://syzkaller.appspot.com/x/log.txt?x=1242a1f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=1f678bd2872aefb11d8a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
