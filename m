Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F06F3112BD;
	Wed, 15 Jul 2026 16:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132169; cv=none; b=CUWV7Ex5v6sakiq6lMU1kG81Csy4pCSmTwWxC2J/ahRfqo2C3UAeVRbuJb0zvyRhfJmgRItAN4EXRXH+IUYLD6bKTbVP2askfl7kwroZ3Vi/D8XEhrHDQkt5K41duBfWaGSvfnAfr9LiYjm5uY0ZReGxIvITzIkrViNR3Vwle3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132169; c=relaxed/simple;
	bh=RHw+Zu92z2vU+SInSoLaGPhtEOwBDLLcc8+z5FSYr/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPmlFbGvBwL9Ot6aB+wyhTl4TTjIEZGgCxkmk30z811tst4x+aHdUdAZ6N7EaonXTtGG7XLrGF2oM8o05zmqv6ZtKBhBGe+beo5xPyYmH8KQ309bJXfEMAX4QmCEkN650dBPlP3/3zeRtScTqNPlpLjnb75WAdQEkqjnaPHCYBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PylwNsx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PylwNsx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061891F000E9;
	Wed, 15 Jul 2026 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132168;
	bh=m3VXbV02Wz98HLoyX+MQu4ADSsP112KvbxLSUS7y3FM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PylwNsx82NXZ5jR76OEUExgfYuRZWw/judPaN8TIlQ6ngvSci3b54sUKDIR1YhBQL
	 p7mOwXnI6sWrnyXpCbrDoo1YN3HzNnumqxyQfwzp2bZxNYX/bDIPVYNFHK+EBbwChI
	 cdYKMVaikt1U32urOrQytls5WKh1+KPHHEOeuhG6Fodo3DJ+UBMxO+qxes8kN3zUSL
	 J6POIUFvH5RjHTnhfBlQKBc/r+a1d4BFr2A4IHDbpSoeRBoM2gJ3LCciAh3drOvGXZ
	 CeRmtMB7SOMozIbH6wepfxuFrbWI6/Hjm7H2FddE++ut80NQ2Vu5IuPQjbAUhHC7KP
	 DauxMdRfVbj7g==
Date: Wed, 15 Jul 2026 09:16:07 -0700
From: Kees Cook <kees@kernel.org>
To: Jesse Taube <jtaubepe@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	Jesse Taube <mr.bossman075@gmail.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix flex array member not at end
Message-ID: <202607150914.6C4DD9DE03@keescook>
References: <20260714152238.541704-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714152238.541704-1-jtaubepe@redhat.com>

On Tue, Jul 14, 2026 at 11:22:38AM -0400, Jesse Taube wrote:
> In qla_edif_bsg.h: `struct fc_bsg_reply` and `struct fc_bsg_request`
> have flexible array members, thus they must be the last member of
> the parent structure. Contininging in the effort to add
> `-Wflex-array-member-not-at-end`, move the structs to the end of
> the parent structures, `struct qla_bsg_auth_els_reply` and
> `struct qla_bsg_auth_els_request `.
> 
> Suggested-by: John Meneghini <jmeneghi@redhat.com>
> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>

It feels like this structure is part of the hardware spec? (and therefore
cannot be re-ordered.) I'm not sure at all, though, but it looks like
it's part of request serialization:

$ git grep 'qla_bsg_auth_els_request' | grep '>request'
drivers/scsi/qla2xxx/qla_edif.c:            (struct qla_bsg_auth_els_request *)bsg_job->request;
drivers/scsi/qla2xxx/qla_edif.c:            (struct qla_bsg_auth_els_request *)bsg_job->request;
drivers/scsi/qla2xxx/qla_edif.c:            (struct qla_bsg_auth_els_request *)bsg_job->request;
drivers/scsi/qla2xxx/qla_isr.c:                         (struct qla_bsg_auth_els_request *)bsg_job->request;

-Kees

> ---
>  drivers/scsi/qla2xxx/qla_edif_bsg.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> index 514c265ba86e..bcc35d149c1f 100644
> --- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> @@ -36,16 +36,16 @@ struct extra_auth_els {
>  } __packed;
>  
>  struct qla_bsg_auth_els_request {
> -	struct fc_bsg_request r;
>  	struct extra_auth_els e;
> +	struct fc_bsg_request r;
>  };
>  
>  struct qla_bsg_auth_els_reply {
> -	struct fc_bsg_reply r;
>  	uint32_t rx_xchg_address;
>  	uint8_t version;
>  	uint8_t pad[VND_CMD_PAD_SIZE];
>  	uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
> +	struct fc_bsg_reply r;
>  };
>  
>  struct app_id {
> -- 
> 2.54.0
> 

-- 
Kees Cook
