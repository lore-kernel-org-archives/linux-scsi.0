Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301548;
	b=UwYJWdlagwcK0NYbfNN48cNJY99LE2J1wamodbhsgiRrmNySk51bA6QjmvMgFHIdyTxF
	 5N2/R3bvqQee0LfwWEHLxvqtFejvlgmW24t3AuQ1T/bOyGATYLgxNyjEZfm/kSM763kA0
	 wiMCNJZiPGNVyQVwwGNH6N1wcc+vg9UL+77cOAY/HocuU1KAYm0EmH2JYoma4KZ888hRv
	 zOQeesywAeZ02q1UrGLFtav7kO9N8aNMfQpRITnF8lZCsUaalwHeSrviO3Oe4i0s4hn5W
	 EGunvpNYJ7ftqxU+1Wphli50Pi0fEc++OqSNWnY5mq+YZUGbn4yZdWeD+ybr16H3vbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301548;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=OK9denJsYmTCyLolpT52rwyfXM56TL7yf+QKigAqDXY=;
	b=Y/ZF1i42QnHG6KzDAjgRQTeTe8sEhKONDMtOl02VRNXsEY52TADzlT5SmjCc+XNmnSuQ
	 kXbjHWhp3/zXpBDzvYkzJ7m3QWw862bm+cBe7UvFOc1zztOvIyDA+BQRm6wapxNSKJ+tw
	 c9bpVbG2SdzypWH7C03PSFUaYDD2w36TS/gFmMLVUiVhU5iGEtuRSe2vCjXwHok1h78Qy
	 pN3BlwuZmy5SwNmXqiM01w3Fbbx70gabUK9cUA1bkdIhD+v5e3YBNlaKG/mq8y0yHaLDp
	 Wmdva6mSBZEf9SJj5yuY2+4SSMHtRG+v7rdp9NUkapJzwwLGdYmG2mY3HJhqXaWuKLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rTp6QS1p;
	arc=none smtp.remote-ip=95.215.58.35
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B0E606A32E
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 09:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67B0E606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rTp6QS1p
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HDOxu6zXX3pmMziswx/K9hIQGw+W8txU+GPPJxltLSk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794301545; v=1; x=1794906345;
 b=rTp6QS1prJKB5Qj5y/Mp4lDGTaRPWcKvcniGGrcSc0SSgUolCKSmVtFl9ibXjqw9fQuzFtye
 eoL5CKE8x9D/2Svur2RS5rg6p05LcxsB3Ccwda1PLI+m5iBHOwFSjCukCrZj55ydRC/GaCtAhZV
 BAthYGUuEVW4khx7Iay8KJRI=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 711b39cf1d6a3c7d;
	Tue, 10 Nov 2026 09:05:45 +0000
X-Mizu-Trace-ID: 711b39cf1d6a3c7d
X-Migadu-Flow: FLOW_OUT
Message-ID: <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
Date: Tue, 10 Nov 2026 09:05:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
To: Laurence Oberman <loberman@redhat.com>,
 james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
References: <20261108204733.557995-1-john.garry@linux.dev>
 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 20:19, Laurence Oberman wrote:
> I have been testing v9 (your scsi-multipath-v7.4-v9 branch, on
> 7.4-rc1) on real hardware 

Good to know.

> and found two problems with ALUA arrays,
> one in scsi_dh_alua and one in the series itself.
> 
> Setup:
> - HP P2000 G3 FC array, implicit ALUA, two port groups (one per
>    controller)
> - 2 FC HBAs, 2 target ports each, 30 LUNs with 4 paths per LUN
> - scsi_mod.multipath=on, dm-multipath not in use
> - Under dm-multipath, the same LUNs show port group 1 at prio 50
>    (active/optimized) and port group 0 at prio 10
>    (active/non-optimized)
> 
> 1. sdev->access_state is wrong after boot (scsi_dh_alua, not this
>     series)
> 
> After boot, every path read active/optimized in
> /sys/class/scsi_device/H:C:T:L/device/access_state, while sg_rtpg
> reports port group 0 as active/non-optimized. No
> "alua: port group XX state ..." message was logged at all.

In this series, ALUA state really has been ignored. It was felt that 
driving ALUA state and sdev->access_state by device handler ALUA driver 
should should not be relied on for Native SCSI multipath. There had been 
considerable discussion on this on list. I already have the work done 
for ALUA support from some time ago and can be posted once this series 
is accepted.

> 
> Since 50759b881e1d ("scsi: device_handler: alua: Call
> scsi_device_put() from non-atomic context"), alua_rtpg_queue() only
> queues an RTPG if sdev->handler_data is set, but alua_bus_attach()
> sets handler_data after alua_initialize() has tried to queue the
> initial RTPG. That RTPG is dropped, and access_state stays at its
> zeroed default (active/optimized) until something calls
> scsi_dh_activate(). dm-multipath hides this through pg_init; native
> multipath never calls activate, so the series sees every path as
> optimized.
> 
> I have sent a separate fix for this to linux-scsi:
> https://lore.kernel.org/linux-scsi/20261109201120.1067815-1- 
> loberman@redhat.com/
> It is independent of your series, but without it, native multipath
> on ALUA arrays has no correct path state.

Ack

> 
> 2. ANO paths are ranked the same as AO paths
> 
> With the ALUA state corrected (by writing "activate" to dh_state, or
> with the fix above), I/O still went to active/non-optimized paths.
> scsi_multipath_sdev_init() sets mpath_device->access_state to
> MPATH_STATE_OPTIMIZED and nothing updates it, while
> __mpath_find_path(), mpath_round_robin_path() and
> mpath_queue_depth_path() rank paths by that field. Only
> scsi_mpath_is_optimized()/is_disabled() read sdev->access_state.
> 
> With numa, the first path in dev_list wins for every node, and
> dev_list order follows sd probe completion, so for about a third of
> the LUNs the current path was an ANO path. Example, LUN sdn, reads
> completed per path for a 2000 x 1M O_DIRECT dd (:0/:3 AO, :1/:2 ANO
> at the time):
> 
>    sdn:0 0sdn:1 2000sdn:2 0sdn:3 0
> 
> Every read went through the non-owning controller. From the code, for
> these LUNs the numa recheck of is_optimized() fails on every I/O and
> __mpath_find_path() picks the same ANO path again.
> 
> With the change below (a template callback so the selectors use the
> live state), plus the scsi_dh_alua fix, all 30 LUNs pick an AO
> current path at boot, and on LUN sdl (:0/:2 AO, :1/:3 ANO):
> 
>    numa         2000     0     0     0
>    round-robin  1000     0  1000     0
>    queue-depth 18039     0 13961     0   (8 parallel dd, 64k)
> 
> No I/O reached the ANO paths under any policy. This is a test patch to
> show the problem, not a polished change - feel free to fold it in or
> do it differently.

I'll check it. Sounds like a real problem.

As you may know, this code is really a refactoring of the NVMe multipath 
code. The ambition was to have NVMe use libmultipath eventually, so it 
would be good for any change to work for both NVMe and SCSI.

> 
> 3. Smaller points
> 
> - numa with equal NUMA distance uses one path per LUN, so with two AO
>    paths through two HBAs, half the optimized bandwidth is idle (sdl:2
>    above under numa). That matches NVMe, but users coming from
>    dm-multipath service-time will notice. Would round-robin or
>    queue-depth be a better default for SCSI?

Maybe, but round-robin may not be always ideal considering only a bio 
mode of operation is supported and no merging like dm-mpath RQ mode.

> 
> - There are no Documentation/ABI entries for the new sysfs attributes
>    (scsi_mpath_device vpd_id/iopolicy/multipath, delayed_removal_secs,
>    mpath_dev, mpath_numa_nodes, mpath_queue_depth), and the
>    scsi_mod.multipath and multipath_iopolicy parameters are not in
>    kernel-parameters.txt. I have a draft ABI file if useful.

Cool, I would suggest to post if and when this is merged. I would rather 
not post another version of this series. It is just "experimental".

> 
> - There is no userspace tool yet to show heads, paths and ALUA state
>    (the equivalent of multipath -ll or nvme list-subsys). I used a
>    small sysfs script for this testing. Ben, is native SCSI multipath
>    support in multipath-tools planned?

Well, the whole point is that we don't need userspace tools. However, I 
appreciate that there is no general SCSI tooling which could help here. 
I know that Himanshu M did work on a SCSI version of nvme-cli tool 
previously. Martin may know the status of that.

> 
> - CONFIG_SCSI_MULTIPATH/CONFIG_LIBMULTIPATH are only enabled in your
>    branch's x86_64_defconfig, so building from a distro config leaves
>    them off, and scsi_mod.multipath= is silently ignored. Maybe worth a
>    note in the cover letter.

I thought that the kernel warns of unrecognised params (which would 
happen for a relevant module disabled).

> 
> I have not tested failover or path loss yet; I will follow up with
> that and a Tested-by once done.

ok.

Thanks
