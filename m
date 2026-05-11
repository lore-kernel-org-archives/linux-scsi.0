Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFF61CD2C
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 04:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778473771; cv=none; b=aXDcJ2xEWJuz5277ofMOEx+tZsFiyHlVCzi1gdbPwhQtKm51dQdys5MazonRka5GiIKtpTwEYKiPzDUkwxWYr06uw/4aUHRLlelKMNpzObZSHrn0MI+m1SKHpdSB14ck5TgQeb0ex9WyPdhetgn8arcVKV6LVFcJq0RqPsrmGJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778473771; c=relaxed/simple;
	bh=8wVbym3Nco5ldXMQUCj1mNUk9+JG/UM3Du25WtqYJdc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VpiskCPZvTzY9opRzn5fVQ/R/VjcS8V3CB7Rc1a2QSXn83Ivx6k+VpAVXZqfaalxTpAHHkvT4s9mPKXETA9+8EY5WhCVukz5BJRxz1Nh+yDBhImVipOn4O438LsebrrJyYRqLukPyGYyrIRFbSGJykU006sIS7hpD9ksuaoIDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G6/gxob8; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6/gxob8"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5637886c92aso1779386e0c.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 May 2026 21:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778473769; x=1779078569; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EG2JTssm3b0KoVPX1o9BEZRYcYiKipSRW2CdGWwAkwY=;
        b=G6/gxob8sFWNT3dAORrjO/Ss6dcpNwORYsoUiKkqfrBUasvXVgeNCnBVrJsmCNP9t7
         3B5nQ6PjTQrHwurysqIrqhs8LLHOHAYmUCp5KOUxxPfYWB9iqc8Oh/XtYCoE7ab6BQ6t
         Eks4cQiXn9fkJdYryl6MPdANS2MSkzaurdR3RUVrTGBuhtviYmM36/8YVD4S0GDcJmWp
         eB6DqS5cnOjPYB75KGOe/Tahwi4W6/dHpP0WehVSKcDyO7zauJlfyr8RI++sc0wc7huS
         9JEA0jUuFd90Wgqg9IcVrSb9PryIJZeYk7Cra9j51jFrA6XNEGFzAk25+tfThIHB04jW
         WfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778473769; x=1779078569;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EG2JTssm3b0KoVPX1o9BEZRYcYiKipSRW2CdGWwAkwY=;
        b=EqyMH7qmfmXXREHiD7MqpZA8rOv3EPJxgc3LFLc6Bf6yo2dIo1p7NMPC6axOPv1awB
         Yh+nBS9jnm8HRNiVy6b3t6uSdeqOiYJS+pQvUnPtkRCBaq1XGnADTtsOBYcn3gYDXeck
         gdTTSUUBT+xMawCC+A5L/uKUNyq8/v/Njd7avc/IMp1puWvMFUIvqTkj8Mm1pYfOq8BQ
         xAonp8Qg404qmSV2qsvA+lb2kHMOedf+HT/LhCi2WjzSDD50fGVrFn3eXn74WVpwzt0t
         OrM5GUSlg6uwfxnmHfhjMk7pTaaQwzYou0t1hcX5LztkgzKy/lZ+KCB7JTaW7kpX+RJd
         HCtg==
X-Gm-Message-State: AOJu0YxvEpilGCz/GwUdHIOhbW2oSS9ES2PiDPjXAwr7k3ZgXCyBmT/r
	uhTGL7mQCyYv2xUXEbWSfZPay8P1//XweLo/D6QwuyeS6UKXZQmAp691
X-Gm-Gg: Acq92OFpN+998Xk4+t6iy7Ihq1TdVUi7cvVfLhKJ4xwL3F8AWZfq2xVPy6O7YXaa2M7
	2tay6ebT1LRvJBEhgqHWsDLrwG9N7e7Bc4aHxBxGlXn/jhSiMaDD4DwlNyV4gW2+ocjlVtlUzWM
	/fDWQvvvPs/D6fInAVNfEdqFF73HNFPZGZpd1Qc632wuSJueGT+3213Wa6/MGnee3xzI06FLfaQ
	rTAmtnscm4EtDyqtx8FJ4ndom2meNHgdurLO54C3BYMWcTSE1FvalpU7aClVg2lmPB4zgZTWTAK
	IAwAC+QAOXAA82bnc3HdIiGn1Gtv5DVT8XNGsCdnuvtjfDIP2BK1IGP72QXv+JLnC+WXetmjZI6
	UNBPcFymjjqfihE5Pwu7Zr03ArBP2TIpx8BqQe3TdwXwlcdP5LpqBV/dwSqb+l/+Zy2FvjsiD5W
	LKd+lXzrT4eQ3Xdbt/15AZ5zvxn/mK
X-Received: by 2002:a05:6123:a8:b0:56e:e7b5:17d3 with SMTP id 71dfb90a1353d-575595d06b6mr11556416e0c.8.1778473768980;
        Sun, 10 May 2026 21:29:28 -0700 (PDT)
Received: from localhost ([185.141.119.51])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-57596bbd81bsm3830932e0c.13.2026.05.10.21.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 21:29:28 -0700 (PDT)
Date: Mon, 11 May 2026 07:29:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: sd: Fix sshdr use in sd_spinup_disk
Message-ID: <agFbI7E6JQwd3wGW@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Mike Christie,

Commit b4d0c33a32c3 ("scsi: sd: Fix sshdr use in sd_spinup_disk")
from Oct 4, 2023 (linux-next), leads to the following Smatch static
checker warning:

	drivers/scsi/sd.c:2525 sd_spinup_disk()
	warn: kernel error codes cast to unsigned 'the_result'

drivers/scsi/sd.c
    2474 static void
    2475 sd_spinup_disk(struct scsi_disk *sdkp)
    2476 {
    2477         static const u8 cmd[10] = { TEST_UNIT_READY };
    2478         unsigned long spintime_expire = 0;
    2479         int spintime, sense_valid = 0;
    2480         unsigned int the_result;
    2481         struct scsi_sense_hdr sshdr;
    2482         struct scsi_failure failure_defs[] = {
    2483                 /* Do not retry Medium Not Present */
    2484                 {
    2485                         .sense = UNIT_ATTENTION,
    2486                         .asc = 0x3A,
    2487                         .ascq = SCMD_FAILURE_ASCQ_ANY,
    2488                         .result = SAM_STAT_CHECK_CONDITION,
    2489                 },
    2490                 {
    2491                         .sense = NOT_READY,
    2492                         .asc = 0x3A,
    2493                         .ascq = SCMD_FAILURE_ASCQ_ANY,
    2494                         .result = SAM_STAT_CHECK_CONDITION,
    2495                 },
    2496                 /* Retry when scsi_status_is_good would return false 3 times */
    2497                 {
    2498                         .result = SCMD_FAILURE_STAT_ANY,
    2499                         .allowed = 3,
    2500                 },
    2501                 {}
    2502         };
    2503         struct scsi_failures failures = {
    2504                 .failure_definitions = failure_defs,
    2505         };
    2506         const struct scsi_exec_args exec_args = {
    2507                 .sshdr = &sshdr,
    2508                 .failures = &failures,
    2509         };
    2510 
    2511         spintime = 0;
    2512 
    2513         /* Spin up drives, as required.  Only do this at boot time */
    2514         /* Spinup needs to be done for module loads too. */
    2515         do {
    2516                 bool media_was_present = sdkp->media_present;
    2517 
    2518                 scsi_failures_reset_retries(&failures);
    2519 
    2520                 the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
    2521                                               NULL, 0, SD_TIMEOUT,
    2522                                               sdkp->max_retries, &exec_args);
    2523 
    2524 
--> 2525                 if (the_result > 0) {

The scsi_execute_cmd() function returns negative kernel error codes and
positive SCSI error status codes.  But "the_result" is an unsigned int
so both negative and positive error codes are > 0.

    2526                         /*
    2527                          * If the drive has indicated to us that it doesn't
    2528                          * have any media in it, don't bother with any more
    2529                          * polling.
    2530                          */
    2531                         if (media_not_present(sdkp, &sshdr)) {
    2532                                 if (media_was_present)
    2533                                         sd_printk(KERN_NOTICE, sdkp,
    2534                                                   "Media removed, stopped polling\n");
    2535                                 return;
    2536                         }
    2537                         sense_valid = scsi_sense_valid(&sshdr);
    2538                 }
    2539 
    2540                 if (!scsi_status_is_check_condition(the_result)) {
    2541                         /* no sense, TUR either succeeded or failed
    2542                          * with a status error */
    2543                         if(!spintime && !scsi_status_is_good(the_result)) {
    2544                                 sd_print_result(sdkp, "Test Unit Ready failed",
    2545                                                 the_result);
    2546                         }
    2547                         break;
    2548                 }
    2549 

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
