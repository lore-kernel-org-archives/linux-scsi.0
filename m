Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E943A31F981
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776440539; cv=none; b=fqZHsS5/eQxbS1EccSNOzZKprBUmqB9khq274NONIlZtIV/hRZwCn3r4DEv95/zKP7r649dspF0Vcqv0NckzDZ6Bz1Ko3ri3dgy5nxrIQmPjAPDQJCZscevb6c/QMjE9NlcOJ/J+TOUYupCmeNCxpwFCZOsy6MDmLaZB9Ddn6XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776440539; c=relaxed/simple;
	bh=Au3gddlChuJAxf28hrBbIBJztJG6r8R2Y790yic9qqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e0iv32DUT6lEby3nnok51qrIFZzKlZyYgoNIR3E262YM3I+XYBQ2o0UxQieJ30fijsJlP4UHQhP5XIXSYExyYy7nV5HmPdxfhNWOcR19AYJt+0kGpG9MwBLfEAU+V4wL8mDbz7liVfGtXh8buId57i3D7+WRQLfHnlelQe9Jqmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mmhUhGib; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mmhUhGib"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48371104ffdso951305e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 08:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776440536; x=1777045336; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UO8vh9pHse8+Kfcg/S3p9ZpoP91MJgu3G3fPZGQktvk=;
        b=mmhUhGibfDcJMPDu5mk0oJBxyDBKw6LiPGsMAbMOWX3btrM/gVB+x05DgYK0mzRmFE
         kkdzObhnxOwqqBiTnu53LkEl8fI+OZCCgAdXS9GhYoVbOofIDwWk3Fcs9Me+cX++T4j8
         BXZ336UkXTDtkhWiDOOpPftNk0kNZEppEIn0Fu7RKo2GXZOGOrk2U4pRAK5uE+oCZPZ2
         SRva6g0Zc/0ga/Wkt8aJSIhYNgOV6EuqZVkZP8HIgOYCffAN5Rpk9ffsdjJTFaUuSgpN
         0IGFGLMRbyaCJfbGwb8tKGRIwfhokxv2NHk82vn2YdN4rNhYZcDw1o/ETAqTOA2B4LnH
         trPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776440536; x=1777045336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UO8vh9pHse8+Kfcg/S3p9ZpoP91MJgu3G3fPZGQktvk=;
        b=pD8WaQnKOI05+4feGgM+NtAvHVrFwjUsGIj92TBflGqqMYhh5Y7KMvcCmdkcqKuIo0
         vD055a9HrWJnkTH9wIaWoSEODaJmp8jUz5v/g1yQ77Nvjreigb+7QLgaw9r5bcOB9pyn
         WxyYz8yOYX+SK8XUrGoKuqYI4u1GL18SBs0Zy9KtkXq8k815ckij/hNhOUMxH1/JW+8p
         xfr42U42SSgMO103Jx1dTUwW3O4F4vi1ZzVHuzF9uhatQEw312DPegkEaBd5/dvFzycz
         UIWswow3NZpdoItW8vZCxO6m4unV0dwP18YDme9RdytSOE0b1Vcb4h0jJnpdaLl7/z/p
         OHEg==
X-Forwarded-Encrypted: i=1; AFNElJ+B78XOsbrbnBO2N9f2f2Mk1/qjmwSp/ln756QXOSZaS9E9raqF2I3NPL+Q9glNcZPzeB7Xp7T/q6Uw@vger.kernel.org
X-Gm-Message-State: AOJu0YzGZ/iNEZUjY+d/3kQjQCKe3eDyrPznij/IGoYw3HOLQgU6O/p7
	PN3I2vadNbAk45gXhTcSxODyH0AX3eMH11GrXnhIVQfwtGnW8JUNLe3A5ehrsNqxjg==
X-Gm-Gg: AeBDies7o6AAPe8zrUp6CI/wI/lyfXg0gEf5rTd2FfcdU1qskPAyAdYM2RRwVN0E5Ii
	H4cR/HyGrOTnT0anxOq9q94ZGCabYsZhXpm/OvxumVNhkX0fjURzHwRRpbLWZgjbiqYhjadIZoQ
	tUe1oLCqYEc/k6NpN1URU860luM17vVqWlVSU4mzpyZSsQabITMU5nGt8Mb1RiiCm3jfoUkwlUO
	3l6sYpFCo9FjrT11d8X69TCv9GQkt0fLFXqBjS1k4dKVL/LCNBpn0tmtSKQOSuAxMtmgfyZrAxv
	4AiYz5KHNiZc74wwmFF7XUilL20/RfJX5I2XLtkRsOi5K7ErgYT0kM29/zZVpFjH9MZSbK235t9
	YSbG2KvvoY0E15TStPN3Qw9N6aOJxs39SUPctmTqUGWDGGtrxAb0F0b7Dc/t3NpOKsiqiGGxuAW
	qe08JHxjnfLeFS1LOGsa85s9J/vqJr7SfaxD8xwpzWMpOA3aAqae/HU72GmzQs9uFaDTxknte5F
	OQ=
X-Received: by 2002:a05:600c:3b85:b0:488:a39a:24c2 with SMTP id 5b1f17b1804b1-488fb73e120mr28884175e9.1.1776440536104;
        Fri, 17 Apr 2026 08:42:16 -0700 (PDT)
Received: from localhost (29.red-80-39-139.dynamicip.rima-tde.net. [80.39.139.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1c96b4sm88948895e9.13.2026.04.17.08.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 08:42:15 -0700 (PDT)
Message-ID: <9aec9557-b619-437b-a11a-bf65a238b69e@gmail.com>
Date: Fri, 17 Apr 2026 17:42:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: ( was Re: linux-scsi project on GitHub & SCSI user space utilities
 maintenance) sg v4
To: Martin Wilck <mwilck@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>,
 Douglas Gilbert <gilbertdl@gmail.com>
Cc: Paul Evans <pevans@redhat.com>, =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?=
 <tbzatek@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Lee Duncan <lduncan@suse.com>, Martin Wilck <martin.wilck@suse.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Mike Christie <michael.christie@oracle.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Chris Hofstaedtler <ze1ha@debian.org>, Daniel Horak <dhorak@redhat.com>
References: <e99744196d8a0ca2bffec1d13109eea071c99096.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <e99744196d8a0ca2bffec1d13109eea071c99096.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/20/26 4:01 PM, Martin Wilck wrote:

> a while ago you created the linux-scsi organization on GitHub. Thanks
> again for that. I think it's time that we move forward with this
> organization. While we have clones of the repositories there that were
> previously maintained by Doug Gilbert, we haven't applied any changes,
> or moved any issues or PRs yet.
> 
> IMO the main problem is currently that people are lacking permissions
> to access the repositories in the linux-scsi organization. I assume
> that you have full admin rights. I think that we need 1-2 more people
> with maintainer rights, and a few more people with write permissions,
> to share the work load.
> 
> In private communication during the past two weeks, Red Hat and SUSE
> have collected a few volunteers that would be willing to join this
> organization:
> 
> Paul Evans <pevans@redhat.com> @pauljevans
> Tomáš Bžatek <tbzatek@redhat.com>, @tbzatek (as Paul's backup)
> Lee Duncan <lduncan@suse.com>, @gonzoleeman
> Hannes Reinecke <hare@suse.de>, @hreinecke
> Martin Wilck <mwilck@suse.com>, @mwilck
> 
> IMPORTANT: This is NOT an attempt by Red Hat and SUSE to take over the
> organization. Quite to the contrary, we would be very happy if other
> people and organizations / distributions joined in. I've added some
> people the CC list who might be interested; I'd be grateful if this
> message could be forwarded to others as well.
> 
> We'd be grateful if you could grant permissions to some of us.
> 
> None of the volunteers above will be able to devote a lot of resources
> to the maintenance of these projects, but we hope to be able to
> maintain them such that bugs get fixed and reasonable PRs merged.
> Unless some additional and highly motivated volunteers show up, I
> suppose this means that the tools will remain in maintenance mode.
> 
> Once permissions are set up, we'd start to migrate the open issues and
> PRs from Doug's repos to the linux-scsi ones, and then start working on
> them.

I’d like to bring up the current status of sg v4.

Douglas was working on the first of two stages: "[PATCH v25 00/44]  sg: add v4 interface"
https://lore.kernel.org/linux-scsi/20221024032058.14077-1-dgilbert@interlog.com/

However, it seems no one has taken over this task since October 2022.
