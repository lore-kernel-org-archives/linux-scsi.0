Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F51C39060B;
	Tue, 12 May 2026 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778598737; cv=none; b=qTqX7ptoAjCNEAF58fuMxnmoQFtN3VTHdUD67s42q22h5P6N/wy/gEFWhe4uWLbBwOaazdeoZpeVeAuDfF5kGk9HQcDP5PpeAlKT2spWnTWaXKxkJyVX6QSi4qNXXTee9UsnFGuicz6RbhHwGVV0FZMaESam6zTfwXTCcqkcezg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778598737; c=relaxed/simple;
	bh=Wa4dKKiW2Oo3LzEjzTkXopNujWyAkKB4u27BZYXjI7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ajdyLOur+Khx9jEXRWwMPav7dScDw1Qc/7A24UnauD63kPJGZzgN80xm3aakDrlOeCqubz8+gcbACi6+VF9fQ/Lg+F1JIkYVBAjbySIJRmlRz8PyCT6E9sxwgiLLaZeMMcl9J3GLn/C5aAU6tFf/By+sxuXEiajGqvycUeYDe0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=aDHGJviI; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="aDHGJviI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1778598728;
	bh=Wa4dKKiW2Oo3LzEjzTkXopNujWyAkKB4u27BZYXjI7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aDHGJviImheqMsZ8ukTK3iKMIIMEvFow9C/bVe6ybQyFUOAXKd8ki4lYU1nZoW4h6
	 8GZ4Y/1Fs1lM0TfgJjUD+SXBG5OiZ4nSdDtt3oMcfgMLC7dBESGUl1VBQIN+9sEozX
	 r5qCwNa6fQ6jwzL0bwpqO67S2kHLHme9CxxkGY/M=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 62666BD345;
	Tue, 12 May 2026 15:12:08 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 25F305FADA;
	Tue, 12 May 2026 16:12:08 +0100 (BST)
Message-ID: <6223b3e1-9aee-496d-8d56-071263282de9@philpem.me.uk>
Date: Tue, 12 May 2026 16:12:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] ata: libata-scsi: add atapi_max_lun module
 parameter
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260506234548.1974603-1-philpem@philpem.me.uk>
 <20260506234548.1974603-2-philpem@philpem.me.uk>
 <7f7126d4-0c8d-4f88-9ece-5bbfac2b47c7@kernel.org> <agL6n9aXd84YPgFA@ryzen>
Content-Language: en-GB
From: Phil Pemberton <philpem@philpem.me.uk>
In-Reply-To: <agL6n9aXd84YPgFA@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/05/2026 11:02, Niklas Cassel wrote:
> On Tue, May 12, 2026 at 10:46:39AM +0900, Damien Le Moal wrote:
>> On 5/7/26 08:45, Phil Pemberton wrote:
>>> Until now libata has hard-coded shost->max_lun = 1 for every ATA host,
>>> so the SCSI layer never scans past LUN 0.  This blocks support for
>>> the small handful of multi-LUN ATAPI devices (Panasonic LF-1195C and
>>> COMPAQ PD-1 PD/CD combos export CD on LUN 0 and PD on LUN 1; old
>>> Nakamichi MJ-x.y CD changers expose one LUN per disc slot, up to 7).
>>>
>>> Introduce a libata module parameter, atapi_max_lun, that controls the
>>> upper bound of the per-host SCSI LUN scan.  Default is 1, preserving
>>> current behaviour exactly: out-of-the-box only LUN 0 is scanned.
>>> Range is clamped to 1..ATAPI_MAX_LUN (8, the SCSI-2 ceiling).
>>>
>>> Subsequent patches gate actual LUN>0 probing on BLIST_FORCELUN, so a
>>> device must both be on the SCSI device list (or carry the appropriate
>>> quirk) and run on a host whose atapi_max_lun has been raised before
>>> any extra LUNs are scanned.
>>>
>>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>>> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
>>
>> Looks good, but this does not apply to libata tree for-7.2 / for-next branch.
>> What is this based on ? Please rebase and resend as I would like to run some tests.
> 
> Tip:
> When using "git format-patch" you can specify --base <SHA1> and
> then the base SHA1 will be added at the end of the cover-letter.

Thanks for the tip Niklas, I'll do that on the next round.

This is the base for the patch set:

commit 3036cd0d3328220a1858b1ab390be8b562774e8a
Merge: 86782c16a81f 105c42566a55
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Apr 7 10:33:49 2026 -0700

     Merge tag 'ata-7.0-final' of 
git://git.kernel.org/pub/scm/linux/kernel/git/libata/linux

     Pull ata fix from Niklas Cassel:


I'm just rebasing it onto for-7.2/for-next and will send shortly.

Damien: Thanks for the offer to test.

Thanks.
-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
