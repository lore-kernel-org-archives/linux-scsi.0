Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234484F5EA
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 07:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719473901; cv=none; b=KzAHOUho2orZidJrRRUHmk0zz/m+/MXW62WM594uiqxjRyeCCjZv8kfeyNZ1WpQz/8oFrWe2kIW7uLZu4WNDLhtgePZBzYhRsYC5mX0I0orkPgK8qr03OBRipSO+VBB0i1Z3YZTZpDVp60Ae58UJIjuDwgbQHidauQ3PDRhjCoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719473901; c=relaxed/simple;
	bh=+U5mA+YFoEzrnXBzyyVT5/UDFLnrLXRfHLfUwllxth4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jyYhF1YiaFPvRjN6UOR5rJHdDTcN13oRG3a9WM5ggre9Mlf1EZ4Pxu5N8lKukd5gOTMqsFgjIdwBCKtWjDPqxtzReFw6GF5SQtKH+ZiRO4rfoX/lXaNBV6fDlKf+hXbsUr7ighxibKinP5HXDxzTtI4MwRBGGvylgZVXahu1Pl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R29l+hiU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R29l+hiU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719473899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAoqz+TnqKF1slnV64acOkvn7HfwIQt/oETa4j5Ovcc=;
	b=R29l+hiUrwEkABaUI/3GDL/v/wX1Jp4I/L2uXgO7OjWVlfn4WXeuwNvEh2ycCGUTRLHhye
	BXKBK1p/Nh7+5dvxG+zfIZsYRWBo1M3oVVRLUHgTdb2p1mdRFl4iaI7+2W7MwQyWswdZhE
	sofg7oTXRZYgJzPfnCpzTofJWkdOqIU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-TECi8OpBPuS0pqZNImVnJw-1; Thu, 27 Jun 2024 03:38:17 -0400
X-MC-Unique: TECi8OpBPuS0pqZNImVnJw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-363e84940b2so3296964f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 00:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719473896; x=1720078696;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qAoqz+TnqKF1slnV64acOkvn7HfwIQt/oETa4j5Ovcc=;
        b=OATDqjwb/gNRGtUIbkP+QwqftI2dfjry2xRZQwkuxTBcvEMbeAvu2k33wi2crcyVB7
         BgIyddWDKii7gSgIHyFQEldw5lEBIMzYneiy+E4fsMGyTUTFS7n4Q83s8OMtJk/+I7u8
         c2SPioI6KeDKF+wdIrQQU/7p+5qMfb1x+epXCHDb0Xv/OYwjnGiTVitxZgNSbNe808wV
         ahEd5TBFqWF49lD0vqLnNYHExO12VmS4RII+m/fADlniL0Mmva9DjJt6QGmLq4BAWSzi
         w9W6YQfL8okP0xfyxF033QcUW0Rlg5Q6A6FG262JHoI5/833fZcNjo3ltRPWIz5rYNv7
         Sz1g==
X-Forwarded-Encrypted: i=1; AJvYcCU1dwFhAvKTai0qFtzJSlL16ADFXXZMT+aaw6fJWMZRs2uiQ6b5dJR+8d1EObiRJFtPEHjEzopAEGzq+6oe45+p+2u2S611ozgk4Q==
X-Gm-Message-State: AOJu0Yy00MA/7e0w1N5CRJyC+86MttyBInwYKx11GQEjRykwUZ+ifMLA
	5fkss8jeMtt4g3eqGN/L/o7yOThVg/Ag/6fi52rnwdFPbCDcIbbPyLfqQ4V2BWWR8ZxZurjShsZ
	ZziJ2JAKYrwagmFQYMFrDXEphZx2EY7Aj7Yw5xZ7T55j1v2KHl5wHALtFruo=
X-Received: by 2002:a05:6000:1e8e:b0:362:1b7e:8e66 with SMTP id ffacd0b85a97d-366e7a73ec7mr9054078f8f.71.1719473896147;
        Thu, 27 Jun 2024 00:38:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxrtOUDrjv1ZwifKRIoROc5zQGB5cOG3d9ajy1DJqwrEF9z4ehhcqJjmB7s8zigBf7rrLgOg==
X-Received: by 2002:a05:6000:1e8e:b0:362:1b7e:8e66 with SMTP id ffacd0b85a97d-366e7a73ec7mr9054062f8f.71.1719473895540;
        Thu, 27 Jun 2024 00:38:15 -0700 (PDT)
Received: from [192.168.0.111] (85-193-35-125.rib.o2.cz. [85.193.35.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3674369eb9fsm953579f8f.95.2024.06.27.00.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 00:38:15 -0700 (PDT)
Message-ID: <6c4fa7e4-fda6-4f46-9780-c0768afb7288@redhat.com>
Date: Thu, 27 Jun 2024 09:38:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] scsi: mpi3mr: Sanitise num_phys
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <d5823d3c-3761-457f-82e9-a910c7c9aee2@moroto.mountain>
Content-Language: en-US
From: Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <d5823d3c-3761-457f-82e9-a910c7c9aee2@moroto.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/24/24 12:23, Dan Carpenter wrote:
> Hello Tomas Henzl,

Hi Dan,
sorry for the delay, I was offline for a longer time.
Thanks for pointing out the issues.
> 
> Commit 3668651def2c ("scsi: mpi3mr: Sanitise num_phys") from Feb 26,
> 2024 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	drivers/scsi/mpi3mr/mpi3mr_transport.c:1371 mpi3mr_sas_port_add()
> 	warn: array off by one? 'mr_sas_node->phy[i]'
> 
> drivers/scsi/mpi3mr/mpi3mr_transport.c
>     1352         mr_sas_port->hba_port = hba_port;
>     1353         mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
>     1354             mr_sas_port->remote_identify.sas_address, hba_port);
>     1355 
>     1356         if (mr_sas_node->num_phys > sizeof(mr_sas_port->phy_mask) * 8)
>     1357                 ioc_info(mrioc, "max port count %u could be too high\n",
>     1358                     mr_sas_node->num_phys);
>     1359 
>     1360         for (i = 0; i < mr_sas_node->num_phys; i++) {
>     1361                 if ((mr_sas_node->phy[i].remote_identify.sas_address !=
>     1362                     mr_sas_port->remote_identify.sas_address) ||
>     1363                     (mr_sas_node->phy[i].hba_port != hba_port))
>     1364                         continue;
>     1365 
>     1366                 if (i > sizeof(mr_sas_port->phy_mask) * 8) {
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This check is wrong.  It should be >=.  But also ->phy_mask is a u64
> when probably it should be a u32.
The test should be corrected I'm about to sent a patch.

Cheers,
Tomas

> 
>     1367                         ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
>     1368                             i, sizeof(mr_sas_port->phy_mask) * 8);
>     1369                         goto out_fail;
>     1370                 }
> --> 1371                 list_add_tail(&mr_sas_node->phy[i].port_siblings,
>     1372                     &mr_sas_port->phy_list);
>     1373                 mr_sas_port->num_phys++;
>     1374                 mr_sas_port->phy_mask |= (1 << i);
>                                                    ^^^^^^
> There are a bunch of "1 << i" shifts in this file and they'll shift wrap
> if i >= 32.  Then the ->phy_mask is tested with ffs() which takes an
> int.  So everything above bit 31 is not going to work.
> 
>     1375         }
>     1376 
>     1377         if (!mr_sas_port->num_phys) {
>     1378                 ioc_err(mrioc, "failure at %s:%d/%s()!\n",
>     1379                     __FILE__, __LINE__, __func__);
>     1380                 goto out_fail;
>     1381         }
> 
> regards,
> dan carpenter
> 

