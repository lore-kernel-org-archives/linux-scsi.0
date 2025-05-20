Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4F27054F
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2025 18:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747766667; cv=none; b=b643NRsSZtF5nxzsm5ftpLlLnV436K/eVRAvb1Dxz5t/z/jrxrpDppo6JrWdDlLEyXkM42UdqkfFGXGiueZfxQGRVjHHkTRBb9rFF/zXJr7RcVvNM6SpMUFwp9t6Ue8RtnoFCUqMTStq00g/k4Sy6IR2ljCS2DbIvsekAb7YXiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747766667; c=relaxed/simple;
	bh=8NDAFaoY4CqzYnfhfFAD3AQ34cruUoT80RLVRAu4SrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CmPDlaj6SPZiMtBRhVCTS27JZJfh/jQlt+CzwI7S16oPUBWkvWuRBU9TANg1eZnJaP0/iIo3cgz0kSyDTD/uP32aSoED2wIG6Dg0V1VFqGEkN+JR5e5bSvymZu9C0ouqJHZP6KRN4hq0HbOHIxt3Z3ZMuftLCvrCB8ot6y5hFKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=YIoakkFv; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="YIoakkFv"
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
	by cmsmtp with ESMTPS
	id HPnkuN97aXshwHRvNup4NV; Tue, 20 May 2025 18:42:49 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id HRvMurRJKq3CNHRvNuSAyO; Tue, 20 May 2025 18:42:49 +0000
X-Authority-Analysis: v=2.4 cv=VpfoAP2n c=1 sm=1 tr=0 ts=682ccd29
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=efVMuJ2jJG67FGuSm7J3ww==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=TLs6ZzWtG3X6MRFYV_cA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xz4Zcy3wg7L8EA60dL5kL3syhAWL+nrdXMPY6Ck3yHQ=; b=YIoakkFv4seIF+yMGlaRLcNGrI
	l3l0xC027wrcy0Qg+FT8igN3CCT7GJUa/qMLf8xi2TDRXKH8GSvMfMMMDt2x7Cc8U4cB9kyDWsaaU
	MizEPCYURIAfdYqGeccbzAQXl9Qv/GvybwRkQOPDSDYKUD3of3B39KwCHx0J06/WUiXs/gdfMDUiq
	X4gNH4WfLxr1xoF1fCMN7K4XglqZYZkB5pqxMWpZsViH0Ylw6E/0h8uxZFjLu9r/5qtIKvt4caWKa
	frijC9r8UNTA0WM7FLnFNDcxW1WMAtQqy3zng8yzsfSx3JaGWzxZl66xycKol6tqg2et8fEhSy1Em
	okewS4tw==;
Received: from [177.238.17.151] (port=7880 helo=[192.168.0.27])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1uHRvK-00000001Zig-0gAj;
	Tue, 20 May 2025 13:42:46 -0500
Message-ID: <34aa97a5-745f-4207-8869-be846a42b8ce@embeddedor.com>
Date: Tue, 20 May 2025 12:42:27 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3] net: core: Convert inet_addr_is_any() to
 sockaddr_storage
To: Kees Cook <kees@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Simon Horman <horms@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Maurizio Lombardi <mlombard@redhat.com>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 Eric Biggers <ebiggers@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 netdev@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20250520173437.make.907-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20250520173437.make.907-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.17.151
X-Source-L: No
X-Exim-ID: 1uHRvK-00000001Zig-0gAj
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.27]) [177.238.17.151]:7880
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHtx8jg0knL48cfsSzTsdvjoCy5mAZGoS0g7p3TYGmLPieKOLAv1N0nbEpM+yh4RbmYYknooXafSC3NPpzGly94MLTKmu9AYfXVRBcVhK9vCNKUCvWxV
 TnqO7xCga+6WBSONuRzdEXi+Kr6bpmG0NTXzWxLX0bq/9OA0MDaKFrZqLw0puVPn5iGv1lMiF6ygNk3v2ZnZIDgstG+CkVbOFObCH3IHM4WMio5oxLY7C7ii



On 20/05/25 11:34, Kees Cook wrote:
> All the callers of inet_addr_is_any() have a sockaddr_storage-backed
> sockaddr. Avoid casts and switch prototype to the actual object being
> used.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
-Gustavo

> ---
>   include/linux/inet.h                | 2 +-
>   drivers/nvme/target/rdma.c          | 2 +-
>   drivers/nvme/target/tcp.c           | 2 +-
>   drivers/target/iscsi/iscsi_target.c | 2 +-
>   net/core/utils.c                    | 8 ++++----
>   5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/inet.h b/include/linux/inet.h
> index bd8276e96e60..9158772f3559 100644
> --- a/include/linux/inet.h
> +++ b/include/linux/inet.h
> @@ -55,6 +55,6 @@ extern int in6_pton(const char *src, int srclen, u8 *dst, int delim, const char
>   
>   extern int inet_pton_with_scope(struct net *net, unsigned short af,
>   		const char *src, const char *port, struct sockaddr_storage *addr);
> -extern bool inet_addr_is_any(struct sockaddr *addr);
> +bool inet_addr_is_any(struct sockaddr_storage *addr);
>   
>   #endif	/* _LINUX_INET_H */
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 2a4536ef6184..79a5aad2e9d0 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1999,7 +1999,7 @@ static void nvmet_rdma_disc_port_addr(struct nvmet_req *req,
>   	struct nvmet_rdma_port *port = nport->priv;
>   	struct rdma_cm_id *cm_id = port->cm_id;
>   
> -	if (inet_addr_is_any((struct sockaddr *)&cm_id->route.addr.src_addr)) {
> +	if (inet_addr_is_any(&cm_id->route.addr.src_addr)) {
>   		struct nvmet_rdma_rsp *rsp =
>   			container_of(req, struct nvmet_rdma_rsp, req);
>   		struct rdma_cm_id *req_cm_id = rsp->queue->cm_id;
> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
> index 12a5cb8641ca..5cd1cf74f8ff 100644
> --- a/drivers/nvme/target/tcp.c
> +++ b/drivers/nvme/target/tcp.c
> @@ -2194,7 +2194,7 @@ static void nvmet_tcp_disc_port_addr(struct nvmet_req *req,
>   {
>   	struct nvmet_tcp_port *port = nport->priv;
>   
> -	if (inet_addr_is_any((struct sockaddr *)&port->addr)) {
> +	if (inet_addr_is_any(&port->addr)) {
>   		struct nvmet_tcp_cmd *cmd =
>   			container_of(req, struct nvmet_tcp_cmd, req);
>   		struct nvmet_tcp_queue *queue = cmd->queue;
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 620ba6e0ab07..a2dde08c8a62 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -3419,7 +3419,7 @@ iscsit_build_sendtargets_response(struct iscsit_cmd *cmd,
>   					}
>   				}
>   
> -				if (inet_addr_is_any((struct sockaddr *)&np->np_sockaddr))
> +				if (inet_addr_is_any(&np->np_sockaddr))
>   					sockaddr = &conn->local_sockaddr;
>   				else
>   					sockaddr = &np->np_sockaddr;
> diff --git a/net/core/utils.c b/net/core/utils.c
> index 27f4cffaae05..e47feeaa5a49 100644
> --- a/net/core/utils.c
> +++ b/net/core/utils.c
> @@ -399,9 +399,9 @@ int inet_pton_with_scope(struct net *net, __kernel_sa_family_t af,
>   }
>   EXPORT_SYMBOL(inet_pton_with_scope);
>   
> -bool inet_addr_is_any(struct sockaddr *addr)
> +bool inet_addr_is_any(struct sockaddr_storage *addr)
>   {
> -	if (addr->sa_family == AF_INET6) {
> +	if (addr->ss_family == AF_INET6) {
>   		struct sockaddr_in6 *in6 = (struct sockaddr_in6 *)addr;
>   		const struct sockaddr_in6 in6_any =
>   			{ .sin6_addr = IN6ADDR_ANY_INIT };
> @@ -409,13 +409,13 @@ bool inet_addr_is_any(struct sockaddr *addr)
>   		if (!memcmp(in6->sin6_addr.s6_addr,
>   			    in6_any.sin6_addr.s6_addr, 16))
>   			return true;
> -	} else if (addr->sa_family == AF_INET) {
> +	} else if (addr->ss_family == AF_INET) {
>   		struct sockaddr_in *in = (struct sockaddr_in *)addr;
>   
>   		if (in->sin_addr.s_addr == htonl(INADDR_ANY))
>   			return true;
>   	} else {
> -		pr_warn("unexpected address family %u\n", addr->sa_family);
> +		pr_warn("unexpected address family %u\n", addr->ss_family);
>   	}
>   
>   	return false;

