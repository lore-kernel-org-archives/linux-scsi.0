Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407E1328635;
	Thu,  7 May 2026 05:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778130230; cv=none; b=QQwXHDCDXCz7waK267Sxzla76cYZotIBDBtXr/k+z/9rQYdZuspJXMAyqLCs5ySGZUrX/HLQsJTjv30fZLDJOb+TOyyXyTyTniQ0e4hOV/B6DclDnkMDOXz5C4xdDc+ex1JxHWyXSJbTel9v9hKTbb2RNPhyGBz5viPRfpPaKw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778130230; c=relaxed/simple;
	bh=UfEZIz4u9GmO49T+7q31Mxw4W7lFHl+z+b25UihONIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XYxTAhckQN66Yjt/PERPu4tGvBIzxYQtkWUcxi0lD/bZzxEG8N7oXqdPI/TglovhnFdkQMEkw/DEkottgUftqpSR+uwUvhl1ki2E2CgLcA637Tx7B9vgiersSpbVfTBLkpwk/f1hjwHocD1aAn/2IlBn02sSiKzxORlDq+uGqdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QybpMf5p; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QybpMf5p"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6473VpU8599575;
	Thu, 7 May 2026 05:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=T0m3Ac
	6XJRdq96S57B0lNRvlvn4pYMufaClu6J1gUaQ=; b=QybpMf5p9lzeTyDA/8Ef89
	jVVpzFwyGsGnZ05PdTGLomRfG8QA1BVLOKZyaT//GbgIcNrvDRM+An8v4Dh5NAgf
	7qfAPncpSKSqTbOsaei0I7KNf8WxB8yPVnw3CjAO/TZivVh4dfTW4KPBUa6O7U8w
	JToXAN20HhncE0t85pGeaKM8H4oL+6QnDycXokW1MjPlB8wL8degdcgtICs9MCJg
	ijkgIMiQAdNWMcnpXVb+cC5X+K1fIgX6ldEe+f01N+RpMiTxhFsbxc0zBjxt5nJW
	etrrErvvHj0KjtWeqHJL12j5FvLkU4vc6Ham7u2jjsz3O814fQnwNKQ+4ePR6gZw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1m7pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 05:03:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6474sPXu023258;
	Thu, 7 May 2026 05:03:25 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtghaxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 05:03:25 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64753NLs66584984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 05:03:23 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53A4E5805D;
	Thu,  7 May 2026 05:03:23 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D84D58056;
	Thu,  7 May 2026 05:03:22 +0000 (GMT)
Received: from [9.61.92.155] (unknown [9.61.92.155])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 May 2026 05:03:22 +0000 (GMT)
Message-ID: <e8dfa3f2-2b2b-43c0-97a1-6bccb748ca6e@linux.ibm.com>
Date: Wed, 6 May 2026 22:03:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] ibmvfc: make ibmvfc login to fabric
To: davemarq@linux.ibm.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
 <20260408-ibmvfc-fpin-support-v1-3-52b06c464e03@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260408-ibmvfc-fpin-support-v1-3-52b06c464e03@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: O4FU4vKJAIBRKBCBLiwvs0Fo5TB24Pso
X-Proofpoint-GUID: rEccag-TcjiCl_ur0fMsexDdZbCUZiXq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDA0MiBTYWx0ZWRfX0CAiCHUusuu3
 pM5XsrXz9Vw0IGyMknDh1y6TES7YrVVbZxZ1HMO2owwW9aBBvNby2c4m1PrwgVIHy77ZhGfi9fJ
 hhfcpkuEeaa82X02kn7DiFb1dilyimKnzlV3G2AwcIbvUr37qda8c7X1WXvWvLgIor9D7ytjB29
 VKlasEtS5h276KegOM/sCfGgaeDDKSwkgSgHCpuDzPnV8q+QiLo3GMPahL7b+75AxhsxPT1nNzU
 LwHQd5qJLHpwl0tVsLSUzQWSs2vGP5YiW6PbEgNz1HFNbwfDqQxJRHj/8ldWkih0Zm49ikf/h/t
 8dllzNOzDq9+3QtaHhZvXgZ/MXViV+rSFQthDtFSBfjMV3JPihId90afa7Wbo9n8M4KkK8S+dq3
 odbzMpKWPZNeS51KRgyr29hh6j8ZI2hx5K1W3kVkdeGKXDb64GOP84gvVM776nQFvF5V33ylTlK
 bs7GiCz2rfJBMR5qFUw==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69fc1d1e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=pTCXBxehswPr_EMUh3oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070042

On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Make ibmvfc login to fabric when NPIV login returns SUPPORT_SCSI or
> SUPPORT_NVMEOF capabilities.

Again better commit log message here and developer sign off tag.

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 100 ++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ibmvscsi/ibmvfc.h |  20 +++++++++
>  2 files changed, 115 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 808301fa452d..803fc3caa14d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -5205,6 +5205,89 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
>  		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
>  }
>  
> +static void ibmvfc_fabric_login_done(struct ibmvfc_event *evt)
> +{
> +	struct ibmvfc_fabric_login *rsp = &evt->xfer_iu->fabric_login;
> +	u32 mad_status = be16_to_cpu(rsp->common.status);
> +	struct ibmvfc_host *vhost = evt->vhost;
> +	int level = IBMVFC_DEFAULT_LOG_LEVEL;
> +
> +	ENTER;
> +
> +	switch (mad_status) {
> +	case IBMVFC_MAD_SUCCESS:
> +		vhost->logged_in = 1;

I'm not sure I see the point of setting logged_in here since we already set it
in npiv_login_done.

> +		vhost->fabric_capabilities = rsp->capabilities;

The way this is currently spec'd out there are no linux relevant capabilities
coming from fabric login. So, I'm not sure there is a reason to save them at
this point.

> +		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
> +		ibmvfc_free_event(evt);
> +		break;
> +
> +	case IBMVFC_MAD_FAILED:
> +		if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
> +			level += ibmvfc_retry_host_init(vhost);
> +		else
> +			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +		ibmvfc_log(vhost, level, "Fabric Login failed: %s (%x:%x)\n",
> +			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
> +						be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
> +		ibmvfc_free_event(evt);
> +		LEAVE;
> +		return;
> +
> +	case IBMVFC_MAD_CRQ_ERROR:
> +		ibmvfc_retry_host_init(vhost);
> +		fallthrough;
> +
> +	case IBMVFC_MAD_DRIVER_FAILED:
> +		ibmvfc_free_event(evt);
> +		LEAVE;
> +		return;
> +
> +	default:
> +		dev_err(vhost->dev, "Invalid fabric Login response: 0x%x\n", mad_status);
> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +		ibmvfc_free_event(evt);
> +		LEAVE;
> +		return;
> +	}
> +
> +	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> +	wake_up(&vhost->work_wait_q);
> +
> +	LEAVE;
> +}
> +
> +static void ibmvfc_fabric_login(struct ibmvfc_host *vhost)
> +{
> +	struct ibmvfc_fabric_login *mad;
> +	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
> +	int level = IBMVFC_DEFAULT_LOG_LEVEL;
> +
> +	if (!evt) {

I think we need to hard reset here or we are dead in the water if there are no
events.

> +		ibmvfc_log(vhost, level, "Fabric Login failed: no available events\n");
> +		return;
> +	}
> +
> +	ibmvfc_init_event(evt, ibmvfc_fabric_login_done, IBMVFC_MAD_FORMAT);
> +	mad = &evt->iu.fabric_login;
> +	memset(mad, 0, sizeof(*mad));
> +	if (vhost->scsi_scrqs.protocol == IBMVFC_PROTO_SCSI)
> +		mad->common.opcode = cpu_to_be32(IBMVFC_FABRIC_LOGIN);
> +	else if (vhost->scsi_scrqs.protocol == IBMVFC_PROTO_NVME)
> +		mad->common.opcode = cpu_to_be32(IBMVFC_NVMF_FABRIC_LOGIN);

The VIOS won't return NVMF support unless we advertise it. So, I think its best
to omit any NVMF releveant changes that are spec'd as they aren't being applied
in a proper workflow here anyways. If the driver advertised both SCSI and NVMF
support the current code would never do a NVMF fabric login as it would never
fall through here.

> +	else {
> +		ibmvfc_log(vhost, level, "Fabric Login failed: unknown protocol\n");
> +		return;
> +	}
> +	mad->common.version = cpu_to_be32(1);
> +	mad->common.length = cpu_to_be16(sizeof(*mad));
> +
> +	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
> +
> +	if (ibmvfc_send_event(evt, vhost, default_timeout))
> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
> +}
> +
>  static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>  {
>  	struct ibmvfc_host *vhost = evt->vhost;
> @@ -5251,8 +5334,12 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>  		return;
>  	}
>  
> -	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> -	wake_up(&vhost->work_wait_q);
> +	if (ibmvfc_check_caps(vhost, (IBMVFC_SUPPORT_SCSI | IBMVFC_SUPPORT_NVMEOF))) {
> +		ibmvfc_fabric_login(vhost);

Again drop the NVMEOF code.

> +	} else {
> +		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> +		wake_up(&vhost->work_wait_q);
> +	}
>  }
>  
>  static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
> @@ -5443,9 +5530,12 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
>  	vhost->host->can_queue = be32_to_cpu(rsp->max_cmds) - IBMVFC_NUM_INTERNAL_REQ;
>  	vhost->host->max_sectors = npiv_max_sectors;
>  
> -	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS) && vhost->do_enquiry) {
> -		ibmvfc_channel_enquiry(vhost);
> -	} else {
> +	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS)) {
> +		if (vhost->do_enquiry)
> +			ibmvfc_channel_enquiry(vhost);

I'm not sure I understand expanding this code to a second if block as there is
no functional change.

> +	} else if (ibmvfc_check_caps(vhost, (IBMVFC_SUPPORT_SCSI | IBMVFC_SUPPORT_NVMEOF)))

Again drop NVMEOF and NVMF related changes.

> +		ibmvfc_fabric_login(vhost);
> +	else {
>  		vhost->do_enquiry = 0;
>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
>  		wake_up(&vhost->work_wait_q);
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
> index cd0917f70c6d..4f680c5d9558 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -138,6 +138,8 @@ enum ibmvfc_mad_types {
>  	IBMVFC_CHANNEL_ENQUIRY	= 0x1000,
>  	IBMVFC_CHANNEL_SETUP	= 0x2000,
>  	IBMVFC_CONNECTION_INFO	= 0x4000,
> +	IBMVFC_FABRIC_LOGIN	= 0x8000,
> +	IBMVFC_NVMF_FABRIC_LOGIN	= 0x8001,
>  };
>  
>  struct ibmvfc_mad_common {
> @@ -227,6 +229,8 @@ struct ibmvfc_npiv_login_resp {
>  #define IBMVFC_MAD_VERSION_CAP		0x20
>  #define IBMVFC_HANDLE_VF_WWPN		0x40
>  #define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
> +#define IBMVFC_SUPPORT_NVMEOF		0x100
> +#define IBMVFC_SUPPORT_SCSI		0x200
>  #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
>  	__be32 max_cmds;
>  	__be32 scsi_id_sz;
> @@ -590,6 +594,19 @@ struct ibmvfc_connection_info {
>  	__be64 reserved[16];
>  } __packed __aligned(8);
>  
> +struct ibmvfc_fabric_login {
> +	struct ibmvfc_mad_common common;
> +	__be64 flags;
> +#define IBMVFC_STRIP_MERGE	0x1
> +#define IBMVFC_LINK_COMMANDS	0x2
> +	__be64 capabilities;
> +	__be64 nport_id;
> +	__be16 status;
> +	__be16 error;
> +	__be32 pad;
> +	__be64 reserved[16];
> +} __packed __aligned(8);
> +
>  struct ibmvfc_trace_start_entry {
>  	u32 xfer_len;
>  } __packed;
> @@ -709,6 +726,7 @@ union ibmvfc_iu {
>  	struct ibmvfc_channel_enquiry channel_enquiry;
>  	struct ibmvfc_channel_setup_mad channel_setup;
>  	struct ibmvfc_connection_info connection_info;
> +	struct ibmvfc_fabric_login fabric_login;
>  } __packed __aligned(8);
>  
>  enum ibmvfc_target_action {
> @@ -921,6 +939,8 @@ struct ibmvfc_host {
>  	struct work_struct rport_add_work_q;
>  	wait_queue_head_t init_wait_q;
>  	wait_queue_head_t work_wait_q;
> +	__be64 fabric_capabilities;
> +	unsigned int login_cap_index;

Lets drop these as they serve no purpose for Linux. If the spec changes to
introduce capabilites releveant to Linux we can add it then.

-Tyrel

>  };
>  
>  #define DBG_CMD(CMD) do { if (ibmvfc_debug) CMD; } while (0)
> 

