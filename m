Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D0C27707
	for <linux-scsi@vger.kernel.org>; Sat,  1 Aug 2026 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785591933; cv=none; b=GbTcAdWNy+xO18Ji9l5iHQCGdEekgLObiZf8KihS/7gUXgmhjftEzl4Vx9XBfp53kfpezigNc+CsQVmuy6Kgc3elsmUUAkMjSHUYyNS4n9neoBHrjwQ7uNDD/q5Ur78BlkqV8nqeKLzjBqT+LIPkbmCoYxUk4e5atadsOOEOx9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785591933; c=relaxed/simple;
	bh=/z0l2AsxUALhNxr3m4Q/CGyahlCDFPHoHyAylNoeHzU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JTHC1rY9h/39eGBlgK5LqgPzyGItijl/b9OH/RFUZ7YsMQ5Ho0FM5yqZku7QbXlXzv5CYICNf4W1q4s1IMR6J1MCERMBUSTOrWb44cwlG3Jsk+1QV4Lb2W3JEF4ATWyHvhC2UIHTWmzlLG9qaHsoeTdgJ15gqXxP34HWlE0lU7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qmAfrXmY; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qmAfrXmY"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47df6a5655aso224200f8f.1
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2026 06:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785591930; x=1786196730; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=L7AshIJQRoeFe1hdtN2kMRgq7K6HpWgxdv0tPhqkGQU=;
        b=qmAfrXmYhowfHk/2IUMNu+Yj5hY+7Phjo/L3QVxN1gqoxBEXiYQ36kwmqUFAMoW72D
         KftpN+ypxnlxOMXpfJu62dG28EN9E+1Ls0fMxjqDwEgaCmnhC0SUhKwGPsOuOte+FoY+
         bjvjVmCemSqtOvKbf/Ty5f1Oy/a3bHcgXyztYDKSo/H0DwdHsaDKeDlCNMhqoLrexU0+
         y/XHNq4M9BGGpDIXwefhBey7pr4rv331zII08Fw7jtT55Jlepyhn4WT2fsUdFWRJM474
         y4xe5Gg91Zy3MbfD3ZcMLNzeXFqF2Qs9W1NdtyZZL8Td8uBj3qYuZZ6gfzvqvfpakIMj
         1Vzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785591930; x=1786196730;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L7AshIJQRoeFe1hdtN2kMRgq7K6HpWgxdv0tPhqkGQU=;
        b=eqOa0ZytKnVRSbwLCgzzmmCCC5eyHjGKnveFq3gdl2gGJ8dGZt97rqhx+y5DdQvRHU
         YUy6F0KnObXwKrEtv+EB1L01hSfDjeomY2T+kduKPIy5ymUvrvPvqmU+D/hqaG8VObZB
         PkWYWZCKYWU0g314IcuayuwJNCT3jyxza2qCg6U+0PHWxtjX2Ltme8ZE2DvrZsgnwp6f
         TJ73l2JbeGG865FZ97eFYBdbdfkVrPZPqZZTRbw+VrdpuVWpvzSXi48lg+oJTYF++ON1
         ktSeqYCFXBISkNmf2L6eKC6K/EJVPX3qNjhn1PSkUiEoybLIqqy/qgwkCCWsimVkMdZb
         fqYw==
X-Forwarded-Encrypted: i=1; AHgh+Rq9z1lDvi1GS3zznvZxeL/hRxNJV7YYwo2QyoreF6XNkpAE5EJdZlAjl6T6uB2Rx9ALOGJdvaj2bUwO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj9kn90cK72R1Y1goFIeOBhPcrPIeGDFVbkn5mgrBmaDoXwc1o
	oBZn6tyacOy7qZv+gUWZYP0T0NdO1tbqC3hRD9w/kREzsUAOYdBYHOk=
X-Gm-Gg: AR+sD11czOr6xK9XqC+8VLua1ZVfT/dJb1VJsSqHKUGh5PXeWcNE7XHP0z66T6xYPlk
	ynaIS7K9OuYwYNKxvoxGqjU4+PzKmRdRNIJpVG8b67znBUsu+V7qbcgLc/9Z0m5lQgtRf0gLB7/
	8b1dZKilkxRrq1/fMVf0Jz1mqqykamK+WpypkpT/0Qs7IXthw+LS8kwOxSYOG5TU/FlPQ4Ykj8E
	r7nPLAfwh4BaMVf2NlYPHJkK0RZ8GRe7BvT6h87V3aMsAN2KOvEHh3Lpl2QRfDFDyyhY404Z+u4
	Jcso8esLWMX5leacG/f8bfOfAJlRL7NS5USoZ+E+b2ZtyxzF+F4Lvuil0ocMNtVAEHH6yFYMWrP
	ecPiWM9SR+fQuPvkOfoyVOX0fJbPuL0PY8U1Rzbf6YJt01x8UJPTvgNk4kwMU0gP3nTrD1bdZV1
	5uY6buRsUPCsz+HP4Hb6L7/9BBPH+co0onRmg13KN1LsStH3SZ80ZhdJaZaThHQTYxVVRDE9ZUk
	ir6ipegHrTwWZ4RK9RnBfKBEvPH4dzEHuY=
X-Received: by 2002:a05:6000:41d5:b0:47f:959f:d5e with SMTP id ffacd0b85a97d-47fd70631f5mr5881944f8f.0.1785591930071;
        Sat, 01 Aug 2026 06:45:30 -0700 (PDT)
Received: from localhost (156.red-79-148-213.dynamicip.rima-tde.net. [79.148.213.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd64eef60sm11309522f8f.16.2026.08.01.06.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Aug 2026 06:45:29 -0700 (PDT)
Message-ID: <b3e7b34b-13a3-4db6-b344-8bbb94c6d6e8@gmail.com>
Date: Sat, 1 Aug 2026 15:45:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [Announce] sg3_utils-1.49 available
To: Doug Gilbert <dgilbert@interlog.com>, SCSI ML <linux-scsi@vger.kernel.org>
Cc: =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
 Martin Pitt "<mpitt@debian.org>" Hannes Reinecke "<hare@suse.de>" Ritesh Raj
 Sarraf "<rrs@researchut.com>" Robin "H." Johnson "<robbat2@gentoo.org>"
 Martin Wilck <mwilck@suse.com>, Paul Evans <pevans@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>,
 Hannes Reinecke <hare@suse.de>
References: <65c9f013-eb13-43bc-a9b1-e98f05e19b26@interlog.com>
Content-Language: en-US, en-GB, es-ES
In-Reply-To: <65c9f013-eb13-43bc-a9b1-e98f05e19b26@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 1:33 AM, Douglas Gilbert wrote:

> It has been a while. I no longer maintain the sg and scsi_debug drivers
> in the Linux kernel but I do plan to maintain my user space packages.

Thanks a lot for your decades of work and dedication to the Linux SCSI
subsystem.

For those interested in the status of the sg.c v4 rewrite, Doug's last
patch series can be found at:
https://lore.kernel.org/linux-scsi/20221024032058.14077-1-dgilbert@interlog.com/

Also, considering the maintenance change, we should probably update
MAINTAINERS and CREDITS files:

diff --git i/.mailmap w/.mailmap
index 01453c5e1ab4..efb67c9158e5 100644
--- i/.mailmap
+++ w/.mailmap
@@ -262,7 +262,7 @@ Dmitry Safonov <0x7f454c46@gmail.com> <d.safonov@partner.samsung.com>
  Dmitry Safonov <0x7f454c46@gmail.com> <dsafonov@virtuozzo.com>
  Domen Puncer <domen@coderock.org>
  Dong Aisheng <aisheng.dong@nxp.com> <b29396@freescale.com>
-Douglas Gilbert <dougg@torque.net>
+Doug Gilbert <dgilbert@interlog.com> Douglas Gilbert <dougg@torque.net>
  Drew Fustini <fustini@kernel.org> <drew@pdp7.com>
  <duje@dujemihanovic.xyz> <duje.mihanovic@skole.hr>
  Easwar Hariharan <easwar.hariharan@linux.microsoft.com> <easwar.hariharan@intel.com>
diff --git i/CREDITS w/CREDITS
index 91c51c14e993..8dc2756f59c1 100644
--- i/CREDITS
+++ w/CREDITS
@@ -1388,6 +1388,10 @@ D: Major kbuild rework during the 2.5 cycle
  D: ISDN Maintainer
  S: USA

+N: Doug Gilbert
+E: dgilbert@interlog.com
+D: SCSI code, sg and scsi_debug drivers
+
  N: Philip Gladstone
  E: philip@gladstonefamily.net
  D: Kernel / timekeeping stuff
diff --git i/MAINTAINERS w/MAINTAINERS
index 5114e6db7307..81de82b900ae 100644
--- i/MAINTAINERS
+++ w/MAINTAINERS
@@ -24282,10 +24282,8 @@ Q:	http://patchwork.kernel.org/project/linux-rdma/list/
  F:	drivers/infiniband/ulp/srpt/

  SCSI SG DRIVER
-M:	Doug Gilbert <dgilbert@interlog.com>
  L:	linux-scsi@vger.kernel.org
-S:	Maintained
-W:	http://sg.danny.cz/sg
+S:	Orphan
  F:	Documentation/scsi/scsi-generic.rst
  F:	drivers/scsi/sg.c
  F:	include/scsi/sg.h

