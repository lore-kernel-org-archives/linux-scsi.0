Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C37A3939D3
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266330; cv=none; b=L5+Q6qhMmeRDLEH8dRVxrPoUE3xqGO33yqm+QHNF8umivOAswW5hmLUPb6P2QGvSPzRLUXhZPN6/m8DmPmmEr/6rSW9zCvGKaB1H/+P0/nxWBAM+ql7XTSkEe7PfB/kABpwdmZf9UdUG0FHlpoH9HbCB0P/IjgV5vIeT7Jw9NAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266330; c=relaxed/simple;
	bh=xZXnXTQu+nNmTMo2NeQo2AqSpUPKIpEOf5+wGuEK+wE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8TcRc1aJdE/J9cc0z09/4XnhAfNNjVNgpbMj5eg5ZHi3qW8m3AiRx2vpyB+nzNnNMjxvZTkm5TaZb+PDS6JQ4jeMSSX5L2R6O1Pau3suGMuWsIHRCLeRMW3yKQgz0ue83ZOVg1ASDlk9PMDG3tSgH2kgfLX6SrWigwK2jYVEDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EZHy3rO5; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EZHy3rO5"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45f3cf907ceso481951f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781266327; x=1781871127; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8JIudbb8WRs2xMRnLfg5/I5LOwOVvsjnhdAtHp8jHEg=;
        b=EZHy3rO5HPNP+Fop98vb2zTsMOuvDn6AJ2vhQNTP6qlLHnttE22pHXNbFEQt3c3JSR
         /AMDUk3geoB2sMcru877/jp2DA7wTI4vrR8d7/ElGVu6S/nJGajBHFWe+/wegzl8Q3Rk
         1w9o/RVgUA9QFhdiEzxd3vgpj/r5MTvW1pQsDzCG8kK9CptumAtltvCfePkTskWkhCrY
         IXnGe5DLN491GpiNowN+KN+I02Tz4SxbLKMJZ/ARg8aSH3Eis4HTNi2yYwGN+MvH/GzW
         TGZT+k6HztyMlwBxSOOXqxwFh+GBUhF4IX2vkwkTXs/b7KMNUSMhJNTf3d71M6BLojbs
         hYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781266327; x=1781871127;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8JIudbb8WRs2xMRnLfg5/I5LOwOVvsjnhdAtHp8jHEg=;
        b=E2hBoYjjMVslhznBXTHOguaJoPXuXEWyK7e54MkxSzgoZSgr/djaZDTCPG+46CoiJw
         bjdgFAsHu75Zk8gE23OQen2SfvuihD9e5G438kCbMlbyz92uZ9WYJlazU1KbPnibmq0r
         blTM0yOo6tVziuB1YasrEx+2I9+bUcSGztgrHtGv1YfbdgGkZC5BTtOhrf/HW0qrwwCb
         /ZvIkLGM0JOa0UHBDA9MWQXb4lSCavIMArHykGnL+3RsztK1X7fEoqaqs4gg9psXUOYv
         NJFSEvUSTsdg8jq75CmFl21G8n6PBVuOHdvwHMfEqqOYq8+ieCprsMB5u1ccoahhsHZH
         8e7Q==
X-Gm-Message-State: AOJu0YzcKhUnkgPHPS7gv+sKb++B8ow8teGDV2VeCJrV8L+qetV9YHS9
	xShFW2zRmbOTvA9DIBQwx2sCnS5jtEpaYBL5G1tWE+q07Hj4dNcpXTUhAASwTXkQT6U=
X-Gm-Gg: Acq92OGWSgQpAPNXmZH7Sn+iCMqKPUUQXetgUYyaTEJzLmw1SbLmBzwmpwerr06147D
	G+1e1sa6ZquAoNu/kMVhF0BjwoD7cQYYVZu5BhG2GBtNp/bbiUokBk1rlsEgjbIen0EinLrF/EM
	nG4D9gIQp2Z7CtSdM1VDo1UVoCIIWPpvsToHJqywwZY/CfDtt768UJN+VdS/Db5RR6xv48CU+qW
	yMzr8Bwwxx6t1C89G8+g4p9zFUdERBuC598KTo9tB0f/8eBSxAYPQM8IDXtlYOYX/mSuKTVRxNZ
	N/yHM13oAQPMFxDifHj4507zuFVDNpz/Vg7g58fxnd1EaiCtqSgtAHjhCeu+GZExdrex29VdIBY
	E9QlqnLoQJ8eiBipeB2bHVpciVGQGsrpb71YqRA8CwIfctkAwbUGZkC754fmwLcwiYNuZVSNr+T
	8VWaM+gqrM/arLorEwHx9l5pGSyWS2xkIgARBpQiaz1Jc1sYTv8b4XyLog
X-Received: by 2002:a5d:5846:0:b0:460:660a:3647 with SMTP id ffacd0b85a97d-4606db9f166mr3840085f8f.25.1781266326620;
        Fri, 12 Jun 2026 05:12:06 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0d28sm5474368f8f.20.2026.06.12.05.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:12:06 -0700 (PDT)
Message-ID: <52237230-8a4e-4b3c-b392-8de1b445ef28@suse.com>
Date: Fri, 12 Jun 2026 14:12:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 29/60] scsi: qla2xxx: Update handling of status entries
 for 29xx series
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-30-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-30-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Modify the handling of status entries in the qla2xxx driver to
> accommodate the extended structure for the 29xx series. Changes include
> updating function signatures to accept a generic pointer for status
> packets, and adjusting the logic to differentiate between the standard
> and extended status entries. This ensures proper processing of
> completion statuses and error handling for the new hardware
> capabilities.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_edif.c   |  15 ++--
>   drivers/scsi/qla2xxx/qla_gbl.h    |   2 +-
>   drivers/scsi/qla2xxx/qla_inline.h |  45 ++++++++++++
>   drivers/scsi/qla2xxx/qla_isr.c    | 111 +++++++++++++++++++-----------
>   drivers/scsi/qla2xxx/qla_mbx.c    |  28 ++++----
>   drivers/scsi/qla2xxx/qla_os.c     |   1 +
>   6 files changed, 143 insertions(+), 59 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
