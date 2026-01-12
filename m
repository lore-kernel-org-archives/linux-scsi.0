Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCD828690
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768227935; cv=none; b=c61R5IJInq1EPQ4NBwPEZSEetAt0UHqQ2ThLXWysE330tNWEUGdomaEZZaAYQthTM9GvbNLBq83pr/Srz3VRz5GyCCR/do9WzqYYgwT9Mlh8qskCh9X3T2H6gBz8L15meHYvr7bpL1f8MLoYyA6UECgdtqnFXuD0lsGMGjyeWZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768227935; c=relaxed/simple;
	bh=Dtu9NM8+HJfeCcl1RM+uHFvZSgC+/57yNQdDaAKde08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZAceJDLZmM5hXQl2dqx+klvgP4FwSwSqYW7BFMRnN4XmMlQ9XtbbbybLmFA/0rP/F+zrnSelg0kAiPOzWYJmID5fyn+ZUnc8lVXLlHa6bVn1R65DD5qWwHfvD86VdyQZ+p85JVH2Mo0lYCpV0VuwY6f8JtcziSHshHrtrlXgl2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRPWi2lG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRPWi2lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4367BC16AAE;
	Mon, 12 Jan 2026 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768227935;
	bh=Dtu9NM8+HJfeCcl1RM+uHFvZSgC+/57yNQdDaAKde08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JRPWi2lGm9d0TArEjI5kGyhTFd/fS0ejmohlhigy1q4UnWKo7sNMypmx1Oxxmq2LY
	 7t3ok0r3q/ieOpv+Id3L/Vp9jCBLvexM6YkXLGitnxmcpQyU1+1R95XbSDO5a81Za4
	 ppuyVVCGjTE/amRJ0HLGoSyl7/2LWZz0dosErIM/XejlUSYjVrB+/ck+f7neRex/PW
	 RcNJjvlXBy19fLkiKeFjZ4BsR0kvWD3anN76vOmNlSO3RlGgDFVfmEmaDhvvuDiEmG
	 p6uGhnIhmsIFpHLU7zs0ssjq9HAorhVEf/j/w2BACOISDz/SW43yvu+IZhvzj+h9Wx
	 qy3uZRQXGVZpA==
Message-ID: <c6b01448-e314-4997-91fb-5d1937459ed0@kernel.org>
Date: Mon, 12 Jan 2026 15:25:31 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 6/7] mpi3mr: Record and report controller firmware
 faults
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
 chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
 salomondush@google.com
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-7-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260112081037.74376-7-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 09:10, Ranjan Kumar wrote:
> +static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
> +{
> +	struct kobj_uevent_env *env;
> +
> +	env = kzalloc(sizeof(*env), GFP_KERNEL);
> +	if (!env)
> +		return;
> +
> +	if (add_uevent_var(env, "DRIVER=%s", mrioc->driver_name))
> +		return;

All the returns in this function are leaking env...

> +	if (add_uevent_var(env, "IOC_ID=%u", mrioc->id))
> +		return;
> +	if (add_uevent_var(env, "FAULT_CODE=0x%08x", mrioc->saved_fault_code))
> +		return;
> +	if (add_uevent_var(env, "FAULT_INFO0=0x%08x",
> +	     mrioc->saved_fault_info[0]))
> +		return;
> +	if (add_uevent_var(env, "FAULT_INFO1=0x%08x",
> +	     mrioc->saved_fault_info[1]))
> +		return;
> +	if (add_uevent_var(env, "FAULT_INFO2=0x%08x",
> +	    mrioc->saved_fault_info[2]))
> +		return;
> +
> +	kobject_uevent_env(&mrioc->shost->shost_gendev.kobj,
> +	    KOBJ_CHANGE, env->envp);

Please align the arguments after the "(".

> +	kfree(env);
> +}


-- 
Damien Le Moal
Western Digital Research
