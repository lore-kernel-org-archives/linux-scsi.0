Received: from smtp.smtpout.orange.fr (smtp-24.smtpout.orange.fr [80.12.242.24])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7147271476;
	Fri,  5 Sep 2025 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757091392; cv=none; b=HuU5khpp0Y62tttsTysED0UyEBReE5EjGuL/k06OoC0f6S+7A5m3OnG+ar4br5EDhb6K1dud0ICVvoswqz0kRKc4LZ3rVlyS2RbPESuWB7cXE+tX8nf5/qI91Ppf4wkTIGlvD1COHOEKU/ubUtdGi473FNXeCrSIwueTTuRrnz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757091392; c=relaxed/simple;
	bh=TuRbWA+paLP80gqnHWXiSfdala+EjdV4QRw8DUB/WZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pWfE/svXet3IBBGtzDjqFSnEAzglw8pceIiuPNlH1BQMS9+MOrcyUrRpvp3+AieFw+i0MJ7VO5c44D3FD3rynurJzhr5pwnMWf0QtHw8jazyEAF5xNZhEJSMA2N7AnuQpSJmDSeiCg3E9zgIrHE5f7cgk9icJxw9HZ8B/J0Z3TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=gBi2zOEu; arc=none smtp.client-ip=80.12.242.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="gBi2zOEu"
Received: from [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
 ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPA
	id uZb1ug1sx63svuZb1uhvjB; Fri, 05 Sep 2025 18:47:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1757090852;
	bh=4Xobza1waQZY33Kz6ZkMF8GxQ6TDexbRjSgDFCeZnPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=gBi2zOEu92MrFceinj3plnCpwcktoY05krToBRPT2t7o2kb/XRJz7aLZKq70Vf+gs
	 GyGjV2v1Oowk7svTtX4sCA1Zan4A5twaWTBXi9uOJWAM3R04chjrsofdc80ZIX6wjJ
	 UOilxLf7bmnDdvX/DVn4GenkGdAOKjcooF+Ra+MequZKxbMZVLrwJ+Le4atDEiN7tv
	 NT17gtRB5WVaVk4j1XhgqIY3XiSKs8P/OV/4LiZ6OflZ3ljFMUbM6RxPG2e4Zm776c
	 9iMS3yRNiXFRiF9UPagE87gIy3ndXd9vpGJP+1sGKxwLGyhawPXqcegOmf351L7s0G
	 5EgQTQcfBK04A==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Fri, 05 Sep 2025 18:47:32 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
Message-ID: <5e63e836-5611-4198-9d83-d289f727bcce@wanadoo.fr>
Date: Fri, 5 Sep 2025 18:47:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Replace one-element arrays with
 flexible-array members
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250905014345.7054-1-pedrodemargomes@gmail.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <20250905014345.7054-1-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 05/09/2025 à 03:43, Pedro Demarchi Gomes a écrit :
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element arrays with flexible-array
> members in multiple structures.
> 
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   include/uapi/scsi/scsi_bsg_mpi3mr.h | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
> index f5ea1db92339..9e5b6ced53ab 100644
> --- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
> +++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
> @@ -205,7 +205,7 @@ struct mpi3mr_all_tgt_info {
>   	__u16	num_devices;
>   	__u16	rsvd1;
>   	__u32	rsvd2;
> -	struct mpi3mr_device_map_info dmi[1];
> +	struct mpi3mr_device_map_info dmi[];
>   };
>   
>   /**
> @@ -248,7 +248,7 @@ struct mpi3mr_logdata_entry {
>   	__u8	valid_entry;
>   	__u8	rsvd1;
>   	__u16	rsvd2;
> -	__u8	data[1]; /* Variable length Array */
> +	__u8	data[]; /* Variable length Array */
>   };
>   
>   /**
> @@ -259,7 +259,7 @@ struct mpi3mr_logdata_entry {
>    * @entry: Variable length Log data entry array
>    */
>   struct mpi3mr_bsg_in_log_data {
> -	struct mpi3mr_logdata_entry entry[1];
> +	__DECLARE_FLEX_ARRAY(struct mpi3mr_logdata_entry, entry);
>   };
>   
>   /**
> @@ -307,7 +307,7 @@ struct mpi3mr_bsg_in_hdb_status {
>   	__u8    element_trigger_format;
>   	__u16	rsvd2;
>   	__u32	rsvd3;
> -	struct mpi3mr_hdb_entry entry[1];
> +	struct mpi3mr_hdb_entry entry[];

I think that the -1 at [1] should be removed, and struct_size() used 
instead.

The same kind of issue is maybe also relevant for the other changes, but 
I've not spotted such places myself.

CJ

[1]: 
https://elixir.bootlin.com/linux/v6.17-rc4/source/drivers/scsi/mpi3mr/mpi3mr_app.c#L1245

>   };
>   
>   /**
> @@ -416,7 +416,7 @@ struct mpi3mr_buf_entry_list {
>   	__u8	rsvd1;
>   	__u16	rsvd2;
>   	__u32	rsvd3;
> -	struct mpi3mr_buf_entry buf_entry[1];
> +	struct mpi3mr_buf_entry buf_entry[];
>   };
>   /**
>    * struct mpi3mr_bsg_mptcmd -  Generic bsg data

