Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C041D63D2
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885945; cv=none; b=V1HNRogdIJ82hRcTIuAuWW8i8TRKy5YXGjyQkfNKe7/Y0SEX9P+oeqoZuxMSuQa+VaBUBL93LKfcLRzC7VuXCXmwDWrZPjLtMUMkVd15dP/3EZgcVtfXPATDbaN/5c1eC0nkiwGgV7mcsrA3H3M5Q6LIVyy+dKPHCV1DGpXjXn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885945; c=relaxed/simple;
	bh=jY1MyyQ6CBg/d7B1++LcX40duebZ3GfatJWLh6QK22Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UptGGzs7Rs1r8qhpo+KgUBR5eP2+OgC2aUn5WQw43UAyuEEWvlgJVpEoFLDgbdqyW4P27Izvt1YZIS7mmYDPW2R5Y0OGjec7p9odcEe+qvNnbVb3QdkDTwJZZR1KgyFT3mGEZkXGnjhi7pUtYPFjy8ZI4OrLwp63dC3BPhCiqt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3ba4fcf24so74754955ab.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 01:39:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730885942; x=1731490742;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ggduSk2H7lz1GLlAbI7VY3J3qCqRKz2N+b+WCUpGlws=;
        b=K7zbRBTXgLogXEJzLv0oXx8g+yWhgBj2RJ9Y4S1GZrYwCG6il31pUZgPE5IKI0cuUm
         ZwWaj7/Lx1o03jY9tYTYxKb+zBOGEv4VkJWW3j32EwcNVoIeWTdNhNpZ2Oz9G+8svG2q
         qT8/YihfyX9hGy2HfYBWiADM1ttjGdVf6QjgNTy5TvfuX//DhOiAoTxwPPZ55wUNPZhB
         b0kId49rjJu/Ur0z+qymgIEOuGHVyHjZTbCHhNbCEayd5UK4t17GuaJSoWgvpV4XXnnM
         ZNobxRM4SsUtncO4mvsr32iPGpm89vObj92FXTwmFKmNWRepVrLtGCo+2Hfm5XRbpFWA
         pvuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVg8arOdlMkpx6rXEV0KxEtNcfK0jHBsxi1l1X/8TRIEitGCyWoxWhLD+17Lv89VVVwl5pWWVQLBtU@vger.kernel.org
X-Gm-Message-State: AOJu0YwzBj/rcJP8Tq7cANT8/3zmDUzZ3C/tiF+05cbBLNkH91cypz4p
	mPiLa7TUtUvAju6BZHLkKH5a3pwk37sjmkmh5VaeqW5X0phMtFK/WUoXQvQowO9w9sGOHgbaHje
	sDL8IfBBU1+9r1qsNniC0unfPdXR/kWhV3L3enqYId6s6A0oXWQbZGac=
X-Google-Smtp-Source: AGHT+IFocSTtVZsydWbv/7AnXMugilw0SsT0pPAXS1AZGxg1inErNOhFtUhS3cdY2SKEJKWy7Araxix/wKCQ4XVHqNDAQn0KjzbN
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1645:b0:3a5:e250:bba1 with SMTP id
 e9e14a558f8ab-3a61752ae86mr225559535ab.18.1730885942507; Wed, 06 Nov 2024
 01:39:02 -0800 (PST)
Date: Wed, 06 Nov 2024 01:39:02 -0800
In-Reply-To: <CAFj5m9LSOvbaOdM8Gvgt8HVprB_DAxiFDOW3Qou8bfAtEz_e8g@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672b3936.050a0220.2a847.1ba6.GAE@google.com>
Subject: Re: [syzbot] [usb?] [scsi?] WARNING: bad unlock balance in sd_revalidate_disk
From: syzbot <syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com>
To: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	martin.petersen@oracle.com, ming.lei@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com
Tested-by: syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com

Tested on:

commit:         72697401 block: don't verify IO lock for freeze/unfree..
git tree:       https://github.com/ming1/linux.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10a15d5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dfea72efa3e2aef2
dashboard link: https://syzkaller.appspot.com/bug?extid=331e232a5d7a69fa7c81
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
