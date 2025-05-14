Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083951C8614;
	Wed, 14 May 2025 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747228163; cv=none; b=Y9EvifGQLFbg+/v44h9lo3a7XI4o9aFCOeVpuNnn/ky8KszTujnbxbIqkLVp2rz8xH/bEsrRsEPSMgO+nEFIU4/pKFjn/mfyZpAcaxtkNxFk58J29P8KRnARxYyag5Zs0O+1VjBl8EIQ8uX5m5cxlF2k5Zc/eYhrfdcT+GpcfhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747228163; c=relaxed/simple;
	bh=bvv/ekVRGHtSOlXYxLi/KP3Hr2rGaANe0rB1GhlSPfc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKQccAOZrB1oWFXkFQInn53aF6XfuoBnRwDycDhKvuWPoEvOjbXVL7KxyuJ++gN7A5LHW67HeHeLtSVBP8hjFbU0EZ6/cC4aFse9rW6d8TF0H5EwFtPgfLiJJ+ZG5RSiHeBUOzuBgq8yo+Sb1DgwfbX7J2u88kW4vsyiGl0d2X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCEBC4CEED;
	Wed, 14 May 2025 13:09:20 +0000 (UTC)
Date: Wed, 14 May 2025 09:09:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kassey Li <quic_yingangl@quicinc.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
 <mathieu.desnoyers@efficios.com>, <linux-kernel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: trace: change the rtn log in string
Message-ID: <20250514090917.0fd363d5@batman.local.home>
In-Reply-To: <20250514074456.450006-1-quic_yingangl@quicinc.com>
References: <20250514074456.450006-1-quic_yingangl@quicinc.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 May 2025 15:44:56 +0800
Kassey Li <quic_yingangl@quicinc.com> wrote:

> In default it showed rtn in decimal.
> 
> kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181
> 
> In source code we define these possible value as hexadecimal:
> 
> include/scsi/scsi.h
> 
> SCSI_MLQUEUE_HOST_BUSY   0x1055
> SCSI_MLQUEUE_DEVICE_BUSY 0x1056
> SCSI_MLQUEUE_EH_RETRY    0x1057
> SCSI_MLQUEUE_TARGET_BUSY 0x1058
> 
> This change shows the string type.

Nit, but would an example of the new output be useful in the change log?

> 
> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>

Other than that,

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
