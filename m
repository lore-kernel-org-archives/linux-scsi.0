Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59D533F6;
	Fri, 21 Mar 2025 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742576025; cv=none; b=CT0y/3qafkt/boTkaw1Tgvz7+PZHEUOlGPzjFHdtvEKmqlrw1I3njyFGoKIcPJLK/qd01SjCVYSwHBGbWwaMztwIj1n0u/HLND7Qdah+6sjM1lZCaqvVPqyzQmRKD2g2AdzppnHQMBilXN3TN2LXIb4NND7884ilrcYPijAjmJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742576025; c=relaxed/simple;
	bh=rjggehHb3/ek/UW076JgUNyTQpz9HIchaQMIUiRAH0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPTHbNVtbhMWCkzKKQZnxH7D85OP4Ryu661ufsU7g23QMFNSkW7KL29tI1I7dqdo6gOVdtBTMeTkKPmQvhw+uNwhTZ1hflGp62dkcw5SV9a+JNQnT4VU9vZj6/EuJghiWXcfrjOUmlrrhks7EnfsDLW7rIJbUYaeTAufMFT2LzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LFNdauyj; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LFNdauyj"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZK7nL5x5Gzm98ny;
	Fri, 21 Mar 2025 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742576021; x=1745168022; bh=SJAYLF2VqFzb7FR4PUAr9bM6
	2F70h9KmZMsNQV3U3WI=; b=LFNdauyjVIAbrYrNtvMsTR+OZUX82PmT4pfcB5x/
	bXAZawy32QYkfh/AhmX8C2WV0ujgpyNDWXo+0mJGvYZYvd4hFXXZmMyRJhxHrLsm
	nW+I5olAe7BvHiZyHWcy7ew53hZkFhNyX88CI9ZR4r37NTckuyJE8agWXWdvwcxD
	y/1DvwXTkOKezYyUh4Mc+TXHoecGhzNP4pNkRPyG+bnAF61V5BmixVn7uf8Rbh96
	sa8iluAeNzyesJ+2z7G/P/aumqwY9I3qlZHAaEg6Ud7yNWrtT85C+4CI1VeUGaF2
	uKCv5jBNFoJQftB4ONMTIR0xk6HnWZiZliLGsfVyfvDQ0g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LgDOEkYWSJOp; Fri, 21 Mar 2025 16:53:41 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZK7nB2ZJZzltP0t;
	Fri, 21 Mar 2025 16:53:32 +0000 (UTC)
Message-ID: <a0da2dc5-80e5-4fd7-92a0-69c399f2a171@acm.org>
Date: Fri, 21 Mar 2025 09:53:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: crypto: add host_sem lock in ufshcd_program_key
To: ZhangHui <zhanghui31@xiaomi.com>, ebiggers@kernel.org
Cc: James.Bottomley@hansenpartnership.com, alim.akhtar@samsung.com,
 avri.altman@wdc.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 peter.griffin@linaro.org
References: <20250321044455.GB98513@sol.localdomain>
 <20250321074524.126338-1-zhanghui31@xiaomi.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250321074524.126338-1-zhanghui31@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/25 12:45 AM, ZhangHui wrote:
> I have checked the device_shutdown process and it seems only wait
> for the resume that has not been processed to be completed, and
 > then continue. It does not seem to cause pm_runtime_get_sync to return
 > an error.

device_shutdown() is a kernel function. File systems must be unmounted
by user space code before the device_shutdown() kernel function is
called. The sequence followed by systemd is as follows (see also the
systemd source file src/shutdown/shutdown.c):
* Call sync().
* Send SIGTERM and SIGKILL to all running processes.
* Unmount all filesystems, deactivate swap devices, detach loopback
   devices, stop md devices and detach dm devices.
* Call sync() again.
* Call the reboot() system call.

 From kernel/reboot.c:

SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
		void __user *, arg)
{
	...
	case LINUX_REBOOT_CMD_POWER_OFF:
		kernel_power_off();
		do_exit(0);
		break;
	...
}

void kernel_power_off(void)
{
	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
	if (pm_power_off_prepare)
		pm_power_off_prepare();
	migrate_to_reboot_cpu();
	syscore_shutdown();
	pr_emerg("Power down\n");
	kmsg_dump(KMSG_DUMP_POWEROFF);
	machine_power_off();
}

static void kernel_shutdown_prepare(enum system_states state)
{
	blocking_notifier_call_chain(&amp;reboot_notifier_list,
		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
	system_state = state;
	usermodehelper_disable();
	device_shutdown();
}

>> Or does the UFS driver still need to check
 >> ufshcd_is_user_access_allowed() too? If that's the case, I'm also
 >> wondering whether it's okay to nest host_sem inside
 >> pm_runtime_get_sync().  Elsewhere in the UFS driver they are>> 
called in the opposite order.>
 > I found that ufshcd_is_user_access_allowed is used in many places in
 > the ufs driver code. What is the historical reason for this?

My understanding is that ufshcd_is_user_access_allowed() is only called
from sysfs and debugfs show and store callbacks. I'd like to remove that
function because my understanding is that access to sysfs and debugfs
attributes stops before the device .shutdown() callbacks are called.

Bart.
