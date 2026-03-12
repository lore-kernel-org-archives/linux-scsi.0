Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E8237DEAE
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349523; cv=none; b=dCPeyuAREyDZnd/kCmw9aMZnlXBcI4g3kDUsyHQ2JShbAT59abFwyE6vn/uUnZzLDbnKMsb3wBEpEf5JNqtIa7+2SeO29jO3XA1NvvejzmbAoWZf0/U/y9V8oS+EVVmxfLLZMqNJEZbloCC2U1t/p5A0icW9INgdQmbx2pgjGvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349523; c=relaxed/simple;
	bh=ZOGZLNz80LFnN03as665nlykWPmZKB7PUGLuZ8BYLrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=dmVh6BHKu2LJfY7aOXRaXKDFMIvL28+fkrCDdd0uC+Y9NNS2fdccbu13+BE61gCfRc+35gmwB2J4lUozSsnToAiLS/o7Ki2qhEpcSUtHZMf0gVRxmN6E7hTSGZr/OpBRalPdfDTx9n9Ov4xKKecv3EcaoITPMf//y3aSfsqk0+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7aDNDBG; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7aDNDBG"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4853589700fso760545e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 14:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773349520; x=1773954320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Kvczvfb6NHBT+oBoDYU/stDa9gqjgg6rGXeYbp7MTw=;
        b=e7aDNDBGd9cDBpTbpcSxgf20Sy4EgsM7IvFeQwQNGUB0o/rLqIBHR27/Qs+Bx3vH8B
         X78klDNXKg2mRYSzdAsY/uxVGfcIQ9Ec7XNpYJUprMWC+KaO2Xk+i99AApdbMIKEqxdT
         uO+VccSXiZqtHEBytMErMkWqz11f0sS8KJfvfl1oECAmbGA6MrTkEhBCriZNIfBPbOm1
         vF9WwQoaUZw+qzDe72OMOEHrgO/o3wVWTBqPD++d0k10fxU+R4ht4vHaxBeNXNDTs/rm
         j3g0SKtXEnKU3NLRjrM7a683tgBPivV+LzKHWTwuuD/obRewVW7MWnkFuQSwLR2V1BsM
         d+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773349520; x=1773954320;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Kvczvfb6NHBT+oBoDYU/stDa9gqjgg6rGXeYbp7MTw=;
        b=PCCtRway7EPzD5kZOcm/NuegcPhmAwAc4vmzbZoHCFJ6NhtmNMEkG7JaGsmIaWwGB5
         kywE6sH4vHZ+6XYks9S7iKXw2c3txGe1lUSDtZP+bS7bWuzlH0ihX6LlTUOTW/MWa7c7
         xKSrjLlrNCJ9HzZynmSUyw2LyWO5FhAchi6yaRjWwIGnBvVwqjP3AAEWFUkUBr9VDD/+
         vyJeVHx7VMnpbPwzu5m8QwwKRRIEE8Zlpmpc2tS2G+kSWLlixfPVsyKEUm8GymEOz5yg
         SBCby2Z6KFViqGgHH774p6VZzqA2CPpZ3GswucAFz63LzFhRgELrusQNrDi6oA19LC3d
         QFSQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4/oOUhpR5n9XKOnm8X2AG7NpvFvNeyyM5igwGD1hkjuw/gD8h7AZhDftteYIa/razPOj7ZGFhhiPk@vger.kernel.org
X-Gm-Message-State: AOJu0YxOrWIGzBxVXYnFPbf6VyPMHXxlZMWVMxzFEJ+5gQVwQNL7qa0W
	a/Ltd4vuGHWUT7mwtm7GIXc3FOiNCmIFdqeIm8cdxSyTiEuzoC2MezI=
X-Gm-Gg: ATEYQzwpLXgZwIV/j8h/so5fv2zFlT3kT534vaBs4OErVi3FXtiLp/3dDogv2ioaY2g
	J41fyRcMY266auUxLJqKfY11TIPblVcJS/cRFDiSimSFI+o/vGN7iY7Ys7PuXgrnXuiy37GH0rD
	XcWOrM1E8eiqIhQnEd6YOSxT1AYW3mq08PJ6a6SGZczh5IlUSxyx0tP/RMAxTEf/UeKKsjDsqcM
	izGWHFinVbGR9cv617EX+9k2HZTxtQNkeSpF0bizM9rdqZrHFJ/bVP/EVyeAaPqfQCPOFE5S1s5
	Q1GGAxR0ExfGHrgL4BR9LRyqt9WZ1xIa0UWJQfCh0E4UezEnhMr9ooEvFxEHWC4h6g1pGvxzMgI
	h0lXDzhx9KKVa47WnFdKE2mEwYHOcKy3iAXmCJGfBLR7UwAoiFSM+pFkHTBBIyj4ViK/z4EtLYA
	TDQU9lh7X1x5FwSTZyIylIjyhyl694O1tRDDTLSYKokMTfEwnzE3tdKh2+dlzf//OmHXc=
X-Received: by 2002:a05:600c:83c5:b0:485:2fe9:33a7 with SMTP id 5b1f17b1804b1-4855670529bmr6262535e9.3.1773349520219;
        Thu, 12 Mar 2026 14:05:20 -0700 (PDT)
Received: from localhost (219.red-80-39-142.dynamicip.rima-tde.net. [80.39.142.219])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b66e3f8sm156441785e9.14.2026.03.12.14.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 14:05:19 -0700 (PDT)
Message-ID: <2fb4a070-607a-4e59-9766-e793d4af49f6@gmail.com>
Date: Thu, 12 Mar 2026 22:05:18 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/1] checkers: add alua path checker
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
 Brian Bunker <brian@purestorage.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 John Garry <john.g.garry@oracle.com>,
 Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
 Yanfei Chen <vincent.chen1@dell.com>, heyi <yi.he@dell.com>,
 Nigel Hislop <hislop_nigel@dell.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Steven Schremmer <Steve.Schremmer@netapp.com>,
 Martin George <marting@netapp.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
References: <20260312001642.53321-1-brian@purestorage.com>
 <91ed7162-719f-4ff2-9951-913fe8096f08@suse.de>
 <bc54bb449129d0a026e69a502d82ef54793f33cc.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>,
 SCSI ML <linux-scsi@vger.kernel.org>
In-Reply-To: <bc54bb449129d0a026e69a502d82ef54793f33cc.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/12/26 5:48 PM, Martin Wilck wrote:

> Actually, multipathd could use TUR for checking unless we receive an
> event of this type. multipathd could listen to those events and then
> retrieve the new device state(s) from sysfs, without sending an RTPG
> command itself.
> 
> We wouldn't switch to the alua checker by default anyway, so the
> vendors that prefer the sysfs prioritizer won't be hurt even
> if that doesn't work.

Just one observation: currently there are ALUA arrays (NetApp E/EF, Dell Unity)
where their own checker is preferred.
As well as software-defined storage (Hitachi Vantara VSP One SDS Block, Linux-IO
(LIO) Target) where directio must be used.
