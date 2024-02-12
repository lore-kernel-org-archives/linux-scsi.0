Received: from mklab.ph.rhul.ac.uk (mklab.rhul.ac.uk [134.219.128.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE2B47F59
	for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2024 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.219.128.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707766505; cv=none; b=W78UHGUq1xQFg+B9VQD8ZZsgdlManWJISaqNPO2xBsPyyLce4uM99ftGuil5h6Bln1+VqhAkI2v4xJe+6KdF8O7R1/dw/BE4TTFzZpecQYInhWaVppEkT3i4UTe1QJ7eoBpPXhgZugeZI3J+emqoW0+gu2LZ2adEMMmZYUrr1/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707766505; c=relaxed/simple;
	bh=ZE15zecU0wpL/P1mwzNmjMMGuSS0AFAHwvs8hwbhFkw=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=DvQdi82A7oQGU0DoR2iUKmIr2ExOW1TU9fCaM/1zgqPeYoZW05Cn2zNwNXeNRg8KUx67f5siJjX8lTUZBRFiwUjSoRzU7TzlLruUIAd/jmM2CgfHT66ySlTzQ+hpJMixdkaeGhgLJcJY0wU7sZPNvgP8g0U03s8lvzOZmHwrC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=mklab.ph.rhul.ac.uk; spf=none smtp.mailfrom=mklab.ph.rhul.ac.uk; arc=none smtp.client-ip=134.219.128.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=mklab.ph.rhul.ac.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mklab.ph.rhul.ac.uk
Received: from mklab.ph.rhul.ac.uk (IDENT:4200@localhost [127.0.0.1])
	by mklab.ph.rhul.ac.uk (8.18.1/8.17.2) with ESMTPS id 41CJYwwN031710
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 12 Feb 2024 19:34:58 GMT
Received: from localhost (tom@localhost)
	by mklab.ph.rhul.ac.uk (8.18.1/8.13.8/Submit) with ESMTP id 41CJYvip031706;
	Mon, 12 Feb 2024 19:34:57 GMT
X-Authentication-Warning: mklab.ph.rhul.ac.uk: tom owned process doing -bs
Date: Mon, 12 Feb 2024 19:34:57 +0000 (GMT)
From: Tom Crane <TPClscsi@mklab.ph.rhul.ac.uk>
To: linux-scsi@vger.kernel.org
cc: Tom Crane <TPClscsi@mklab.ph.rhul.ac.uk>
Subject: Accessing discs connected to H/W RAID controller over SG interface
Message-ID: <8593326e-3a54-da70-237c-dae3802d8b1d@mklab.ph.rhul.ac.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

We have a system whose RAID array has performance problems.  We see I/O 
maxing out at throughputs far below the spec of the controller and even 
well below that of individual discs attached to it.

The RAID controller from Areca is configured with 2-off RAID volumes and 
has 4-off 6TB discs attached to it.  I would like to be able to access the 
4 discs individually, e.g. to be able to dd them to /dev/null to check on 
their performances.  I know we could JBOD the discs and do S/W RAID but 
this is a production system and in any case the point of having a H/W RAID 
controller is to avoid this!

This shows the configuration,

# lsscsi -gs
[0:0:0:0]    disk    Areca    ARC-1226-VOL#000 R001  /dev/sda   /dev/sg0    199GB
[0:0:0:1]    disk    Areca    ARC-1226-VOL#001 R001  /dev/sdb   /dev/sg1   11.8TB
[0:0:16:0]   process Areca    RAID controller  R001  -          /dev/sg2        -


I know that some access to the individual discs attached is possible 
because the smartmontools utility smartctl can do it, e.g.,

# smartctl -i -d areca,1 /dev/sg2
smartctl 7.0 2018-12-30 r4883 [x86_64-linux-3.10.0-1160.80.1.el7.x86_64] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, 
www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68L0BN1
etc...

I was hoping to use 'sg_dd if=<???> of=/dev/null' or similar. I could not 
find what I was looking for at https://sg.danny.cz/sg/ or elsewhere.  Is 
this possible? Can anyone give me some pointers?

Many thanks
Tom Crane

-- 
Tom Crane, Digital Electronics Engineer, Dept. Physics, Royal Holloway, University of London, Egham Hill,
Egham, Surrey, TW20 0EX, England.
Email:  T.Crane@rhul.ac.uk
