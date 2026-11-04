Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822729;
	b=bweH65iNEqyUrSh6ZccMgdw0JEtW2l4uqwTPy5dE9DibluEikD3TedjSdmrl+45hid9Y
	 jA4WHuU5rlvS7G+xwdZvBKUC81W27ymw7v/TboAj3c0E2s57rR7iL9CJwMqKMYW1qXD78
	 1GbcQxzuEVjk1X4TTCg8RwuPHaNgv84AHkQyxorG9YR1D54Jv3WLJXILfWnPvpBPhA9KY
	 ppRQYdVJazuDRN0yeZeruM16AWDSTei2gH3QhdNDZYyo+2biXUiGRgxi72/Gj62sg4Njc
	 u63y2DAwv9rqAeIy3wm0JB+1W1xmbJr1AwOcVWM+AIEDkI65rNoK5aDAZJj+RaWQFvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822729;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
	b=Z/VSycHWa9gCnQhsirtWwrYWCkIWtsPNZxIwBXYy3XgwIXlukQB7q4c6Ux53rh00zGAT
	 wuq1AAb+DLVr+UXczDp+Db8dmINxMXnG7L2JXGBChR+HO2swzaXDHg26MQYeNloJIEq3V
	 g9SsIIIDNxfMmJYLu8BTGQ1dyaAn3FeIF36CvA6Ee8fmIvWy6Fhh2I85noP+V/bpgvuY6
	 FwELlJHxTy1ejRun51Xfu3zH/IhXcqxY39YyTJwIjPSHIBDX4BwL6pMMBAVSUG73KVRxc
	 LJyXDjCLjFddqA89NFdwPYFFFv+ALsjlxSQ0YJjCeQwjPTBl2kVUHPRi+EHZcaufdnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Vbn8zn5w;
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E443F606EEA6
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 20:05:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E443F606EEA6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Vbn8zn5w
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b570ff3dfdso598379a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 12:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793822726; x=1794427526; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=Vbn8zn5wXq9szXTETpo/o9yTouDrdEdVo/iYCUNRt5NdRh8qngBWm3dzC1gz/fcJOj
         G4KR4j7wBedIrKAO9AbhaDOwly2R0ZPjT5cpsqJsbOhpqi2h/JfSDPhcCWkw3/T+qpQS
         3u596Na9iIQSnXibyRNSccUvE1boUtmpz/8mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793822726; x=1794427526;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=NVPutzLpTQC7JF54WgdSTRuez6sW9nVgtRa0hi6b137X56U2eLxTiyJqiUuLVmeiWI
         OP+83/VYCvqbASKe63Wr4uTtUKGx8+9TkXd8Z8oFmBf5qNAzYNHG1Mobm7MDH30JS4et
         XvSTNmOA0ve1mqrNLWcJkiLoodt/clzojS5g7WubNvunMLPw1tCFdEYU4ReSrwdoiQDx
         uMPnlg6oBBS5IBZY5s6TzXAeEQtn0n9cvKfB/mxAcB3oXAZ77b9TPCfDjxJFn5pl87w5
         jDLy+JFmuphxPNY3jCJZPcmqW1XG8rKLOKHfwpHkfJbvdXvja09FM4FTi0CQ1oHBqPRR
         dnwA==
X-Forwarded-Encrypted: i=1; AKwUvBzEVzEKV9+Hu46Ok1XoegYC2Hq7Mi906BhavBSRa7gqCv+nqcdxKVmdALheDkMOczIi9B3qF7hyHkfy@vger.kernel.org
X-Gm-Message-State: APuU4Z8YQyVXYticwcr2dUio6tIgL+fKFjn9Ki7o9S9eexON2YGOwoUd
	nyZxDKmS4bY/DUP5VpHJ0IA8YgyYjwo6vgpDkyF6YVkl6yPy+EtozHBCIeMsifUs37ZOEwvE57E
	dknbH+M6EhQ==
X-Gm-Gg: AYBFou3Tagpb/gk66s5iJtHk9luIQHsePTlJ/t6mg0Qj7BDJjkAa8btkhbvlWshwJ7H
	DRGqzhLQiD6g/jMITdAX5B6+q1z3kkVCdNmyo14zjEpOfrUZ8zn37t8fN6ywDQ60lIkT52vqRTj
	/UZyYyBpzzqjACx/zOBOwgHinY3OE3QgREGLWN6SqbAzW/zt4M7T/B0jeQSqO8yK1sB5XWjx3eG
	Ii/qDyxHhx1g1808aJHTYyM//m2ljQWRsT/ytcY3vTwYOs1FXvE6n2PvqVB85cno1pm5X2Jo7Z6
	64u0tnEpVwrlp0UCvFXtdQy8vWtLtlOxY9mU6W9R5vbk9CXz1iZHmC8Qk9I5bjqre0Ouzi+qlvi
	LByj1VUgs3beJMAoHZ2Sp3wvHU548CVlU3LmZCMXoxYUkuFcp5RplRLkRH7iM26qIctTxPHQ9XT
	U1YeIgd3OV3IXVuq30hvBC739Qd/42/Ui9/nEU8hJocuABq2ggUfiN4ATdQwAbOYUMbWD26Gwb7
	7p53NjQhEcj4CFgFn8mxYQQCYQScEfKxbu7v5ydlH9zP0ykHDYVEMMbNMrtHpo5x4DBPWLTXhEE
	6vGRCaW0sSeiVq+zq+iS7VBVBaQJ2Zgx1CyQYCk2p2P7qGe+VGX2xsyoq7NJoAq6tu2ElPl5gts
	tXw==
X-Received: by 2002:a05:6402:c9:b0:6b4:12df:8243 with SMTP id 4fb4d7f45d1cf-6b4d468ad29mr9833812a12.20.1793822726365;
        Wed, 04 Nov 2026 12:05:26 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b55ac442bcsm1135200a12.6.2026.11.04.12.05.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:05:25 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c418e215671so166821166b.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 12:05:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByshUh1zLeHJ6fdswz9vaRbzy05baZEhg8LS2G9EmfPpk6Agp2Vb+ZKFu3vxiJlGhhPsjCEJSbP5F4A@vger.kernel.org
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr1973235866b.3.1793822725121; Wed, 04 Nov 2026
 12:05:25 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner> <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Nov 2026 12:05:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Gm-Features: AclHuK9j_YIgrwhhpWOlnull6heAULBd4dgTqoOhUQQjFm_MgoIgrL1vgPfefvI
Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
>
> Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2

Christian - way too many patches, re-sent much too often, cc'd to way
too many people.

Nobody is going to read these repeated resends, and all you are doing
is clogging up peoples mailboxes.

             Linus
