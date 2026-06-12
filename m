Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F3438D41A
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269437; cv=none; b=t6zkOLNJrf1SXAHF1IvuJiWoCERl2phvBu92sBIVPj73+9BLRNDKIRY6xyvtXScIad/smudP9V3vhLhR8zlvQmkhQg22o5GF25GdnkKjIpn44MqqcbnpFBw79M2/wl7fq9rUXhfu+cTtgfAZqYbYj5WFNaXHJ1TnuQSSTg54kzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269437; c=relaxed/simple;
	bh=cYhppFdbm0ESulyQLjhe2Ov8L+iGOFu+32tuKCeWPC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b8nyOpxVAhHL2YAHa9bO033SidTDfZA5SzA5o2kxk5KVWQy25ZeggCfeynunQcneOjCX8m4OGkVFfChOLAMGGhcFxVP3tnKrqVUQpMBi9Zo8iBOugJVeZhqJBZs6J1aBSMZIDMRza3OpL9jLnuIcwrhqsMT+Ut1luK/TslqYQco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JdSEmyFO; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JdSEmyFO"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45eecb8bf67so706888f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269432; x=1781874232; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X0bhK6BQlZ9qeM733Pp+VdvzhDFWiKLAbzt+HUqgaVU=;
        b=JdSEmyFOHgut6jlaxLgxh2ylED4b+3UuOXieWoqeqzkgDuffpfFPZk/XAf78ZoJz2D
         DQnReNd2rvcCBcz2oKx4yScKG1BWlvD0S+Oga+bgaw7M80uXW8R5mHA5oz2Yvo0yAhod
         qlJx3ZErICeL+E8q5oTtNqr6BTGZm8laHdijMKbAExCCCnTS14wWbDH92UkEmCOHcdtQ
         fTpOK6oVNhMwhAdFEIdUdfGUy9xyNc+Z8pImnQELkk3poMBx6JFoYADOta4wJZ/ySZ4D
         3oKCxpuOZEKkfGXT8rQ//MMfDc2BFa6iyOD8xtRA+bB1LQ4ivAXrCsu8LAtmS/fRibzz
         R8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269432; x=1781874232;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X0bhK6BQlZ9qeM733Pp+VdvzhDFWiKLAbzt+HUqgaVU=;
        b=Ad2dhXRFRdud0dUzYlPuQZ2vPrmDQaxPcZM1x9vbSpnPKi+aq/JItb94QNKLcVPfqD
         nMDdTUT2zMKvRVwIhnzTXlcdJd8YkzROUMuS+6vpFZY/NBs8Caew9xxj5rpSt+SK97wf
         hUiV7C1X4LpJZ9KZN5HKxmZBNWlFgOAN55gSOpleFTFD/nx0cv9zbfy1IeY0XsWODc3j
         myiiyfpLkPhH/nX62r4Vljv3RSZ89r4fHLBVaBkBKPOrZP5rZhT+uRLRF9m5cTnbquSN
         UivL5VwrI7y+FHkdKj6Bu6zKybu4g6Cet8tIOINIdjXjjUsz2cek7a+6ACuKFPcBXN/H
         WmzA==
X-Gm-Message-State: AOJu0YyNN6oxliIAgg9gH1xlc0Yw3Tf1hOS1ac1bsSVzOPaBNTjkpT6/
	W9VcSyF090BnbzDgni0sNlffCXcwG1Xd4SIWaH/LcfBcDPGEO+vi0e9iXTBNGWA5DyU=
X-Gm-Gg: Acq92OE/sMDBa1jy5bduJIn0KpuNGkN4LakKSKVitnbKwQ+cWABIuII0V8qTf48FScW
	c8zIuM9ZBVJZQLNpMlp1VQGotmTWZ3Zjg2+fRmqRg1xRqwOXMmOIXcUj+NLAVy6j1nlZXFq9CpG
	6gXPVbraq97GlYuLfEtHzoyXBLdnZOmqurM/6ICF1Wldg4QwCQ8bx9Wz8HvBBtsXgpaqBo5I/NK
	YpPMmVwNZkaxUCu6iNwlio+Zr1BsX+qqT2d72AKLUR/lfPnhctuQ8rr348M+y5pHgj4Wuvpl6cP
	+BntPMIixwYqPE7G5yu+lG0XWuj6XA+EMWV6BD4rsF2r/yGs7PwKscOa0dc70q59b2PVENImfRq
	vHid54vAGX8cVtnyYQj9WggZPON2/irTLtosCdXEPlsf+loLTJdLDjS70xEw9RQpLp5x9Lv30TS
	WGcBzDSVuocnoEdanoq6URfy5HsGmBWDw+RN1ppUTylXC24Jo2oobAecvl
X-Received: by 2002:a05:6000:1a88:b0:45e:b215:12e9 with SMTP id ffacd0b85a97d-4606da69f9emr4177757f8f.6.1781269431916;
        Fri, 12 Jun 2026 06:03:51 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f23fsm5721807f8f.9.2026.06.12.06.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:03:51 -0700 (PDT)
Message-ID: <58b040c8-50a8-4ad1-b9e9-790beb909d1a@suse.com>
Date: Fri, 12 Jun 2026 15:03:51 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 50/60] scsi: qla2xxx: Fix 64G link speed reporting in
 get_data_rate
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-51-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-51-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> qla2x00_get_data_rate() skips updating ha->link_data_rate when the
> firmware returns mcp->mb[1] == 0x7.  That value was a legacy sentinel
> from before 64G hardware existed, but PORT_SPEED_64GB is now defined as
> 0x07 and ha->link_data_rate is decoded with the PORT_SPEED_* encoding.
> On a 64G-capable adapter a genuine 64G link is therefore dropped, and
> the port speed is misreported (port_speed sysfs, fc_host speed, FDMI).
> 
> Only 28xx and 29xx support 64G, so accept 0x07 on those adapters while
> keeping the legacy filter for older ones.  Also drop the duplicate
> copy of the check at the end of the success branch; it repeated the
> first assignment with no intervening change.
> 
> Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 5a5d33e8ee7f..d661662aed26 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -5793,10 +5793,11 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
>   		ql_dbg(ql_dbg_mbx, vha, 0x1107,
>   		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
>   	} else {
> -		if (mcp->mb[1] != 0x7)
> +		if (mcp->mb[1] != 0x7 || IS_QLA28XX(ha) || IS_QLA29XX(ha))
>   			ha->link_data_rate = mcp->mb[1];
>   
> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
> +		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
> +		    IS_QLA29XX(ha)) {
>   			if (mcp->mb[4] & BIT_0)
>   				ql_log(ql_log_info, vha, 0x11a2,
>   				    "FEC=enabled (data rate).\n");
> @@ -5804,8 +5805,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
>   
>   		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
>   		    "Done %s.\n", __func__);
> -		if (mcp->mb[1] != 0x7)
> -			ha->link_data_rate = mcp->mb[1];
>   	}
>   
>   	return rval;

Please merge with the patch introducing the IS_QLA29XX() checks here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
