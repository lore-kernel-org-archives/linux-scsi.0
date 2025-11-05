Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD1030F7E8
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762358210; cv=none; b=iYH1vl36py2UcC19QQ6GuT5feYKlLt2Q3CYI5c5jln2r/lkSlOiP5XqOrUTFiyd0ZNMzkhpf1/ZaSH/w95w0ke73outb+IpbCMXwPl9VTMTskj0L1bJb09+Tg7cm0V71KvVywwdRDW//nVmx35KbBz55JuXflnbTMbydJ4ey2IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762358210; c=relaxed/simple;
	bh=ALc0RQfMjYqxgWA3Uf3kqlyFfMFHuF0hCO/fgNaIuQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vCVZpEjsaVa+Z5IBQUAUOxyec0ze+JVFi/BSPWpjKS5mvfhgFtc9EshIFtD3sSWe/wua3mXkUEKifIbDTiJ2L+zLQQIvYm7dIvqamLx4fJKLIoc6OGRAR795VufKrKYvnDS3N8vEOqQcNJjQIGKPZb5DoR5ynBV6FUMWDFfklhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LGNCdh7e reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGNCdh7e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762358207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Akz/o72H9FWNAwQc14kMnuPRHIo9xAL+ahC7clSIZ9w=;
	b=LGNCdh7ehVDXnDAIbkAbC0DLMSDYqEfxGOPjdL1mWEelzLNJuUxU8NvzGJUq1ZGztttMYj
	XwrmPsKpK+5LnBa8txpkUng9/yrC/YNZkH1R+G0n3ENjFZ6aER+MyQZ1kc+i9SZhcOXR/u
	mSXKKUSNAn5N31VgrDYjhww7yx1nlmY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-WFEnBvXaNnerja_eKwKI8Q-1; Wed,
 05 Nov 2025 10:56:44 -0500
X-MC-Unique: WFEnBvXaNnerja_eKwKI8Q-1
X-Mimecast-MFC-AGG-ID: WFEnBvXaNnerja_eKwKI8Q_1762358203
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E05F119560A1;
	Wed,  5 Nov 2025 15:56:42 +0000 (UTC)
Received: from [10.22.88.66] (unknown [10.22.88.66])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7911300018D;
	Wed,  5 Nov 2025 15:56:41 +0000 (UTC)
Message-ID: <cb673c0e-74ca-4275-b6d6-5401a2159494@redhat.com>
Date: Wed, 5 Nov 2025 10:56:40 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] st: separate st-unique ioctl handling from scsi
 common ioctl handling
To: David Jeffery <djeffery@redhat.com>,
 =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org
References: <20251104154709.6436-1-djeffery@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20251104154709.6436-1-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This diff is difficult to read.  However, in reviewing this code manually by reading the results of this patch and comparing it with
the previous file I believe this change is correct and functionally equivalent to the previous code.

I've also tested this patch with my new and improved tape_tests and reproduced the failing scsi ioctl(idlun) problem with this patch.
So this confirms there is no functional change with this patch. It isn't pretty but it should provide a safe, bisect-able change that
prepares for your next patch.

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

/John

https://github.com/johnmeneghini/tape_tests

[root@estor-t560 ~]# grep -E "TEST.FAILED|TEST.WARN|sg_reset|Power.on/reset.recognized|Unit.Attention" /root/tape_reset_tests.log
--- sg_reset --target /dev/sg2
--- sg_map -st -x -i TEST WARN : device /dev/nst0 failed on scsi ioctl(idlun), skip: Input/output error
[  247.493571] st 1:0:0:0: [st0] Power on/reset recognized.
--- sg_map -st -x -i TEST WARN : device /dev/nst0 failed on scsi ioctl(idlun), skip: Input/output error
--- stinit -f /home/jmeneghi/tape_tests/stinit.conf -v /dev/nst0 TEST WARN : The SCSI INQUIRY for device '/dev/nst0' failed (power off?): Input/output error
--- sg_reset --target /dev/sg2
[  265.727311] st 1:0:0:0: [st0] Power on/reset recognized.
[  265.727357] st 1:0:0:0: [st0] Sense Key : Unit Attention [current]
--- sg_map -st -x -i TEST WARN : device /dev/nst0 failed on scsi ioctl(idlun), skip: Input/output error
--- stinit -f /home/jmeneghi/tape_tests/stinit.conf -v /dev/nst0 TEST WARN : The SCSI INQUIRY for device '/dev/nst0' failed (power off?): Input/output error
--- sg_reset --target /dev/sg2
[  285.860196] st 1:0:0:0: [st0] Power on/reset recognized.
[  285.860241] st 1:0:0:0: [st0] Sense Key : Unit Attention [current]
--- sg_reset --target /dev/sg2
[  310.125953] st 1:0:0:0: [st0] Power on/reset recognized.
--- sg_reset --target /dev/sg2
[  351.444178] st 1:0:0:0: [st0] Power on/reset recognized.
--- sg_reset --target /dev/sg2
[  992.210217] st 1:0:0:0: [st0] Power on/reset recognized.
--- sg_map -st -x -i TEST WARN : device /dev/nst0 failed on scsi ioctl(idlun), skip: Input/output error
--- stinit -f /home/jmeneghi/tape_tests/stinit.conf -v /dev/nst0 TEST WARN : The SCSI INQUIRY for device '/dev/nst0' failed (power off?): Input/output error
--- sg_reset --target /dev/sg2
[ 1002.023106] st 1:0:0:0: [st0] Power on/reset recognized.
[root@estor-t560 ~]#






On 11/4/25 10:46 AM, David Jeffery wrote:
> The st ioctl function currently interleaves code for handling various st
> specific ioctls with parts of code needed for handling ioctls common to
> all scsi devices. Separate out st's code for the common ioctls into a more
> manageable, separate function.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by:     Laurence Oberman <loberman@redhat.com>
> ---
> 
>   drivers/scsi/st.c | 85 ++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 62 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 74a6830b7ed8..87f0e303fdd6 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3526,8 +3526,60 @@ static int partition_tape(struct scsi_tape *STp, int size)
>   out:
>   	return result;
>   }
> -
>   
> +/*
> + * Handles any extra state needed for ioctls which are not st-specific.
> + * Called with the scsi_tape lock held, released before return
> + */
> +static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *STm,
> +			    struct file *file, unsigned int cmd_in,
> +			    unsigned long arg)
> +{
> +	int i, retval = 0;
> +
> +	if (!STm->defined) {
> +		retval = -ENXIO;
> +		goto out;
> +	}
> +
> +	if ((i = flush_buffer(STp, 0)) < 0) {
> +		retval = i;
> +		goto out;
> +	} else { /* flush_buffer succeeds */
> +		if (STp->can_partitions) {
> +			i = switch_partition(STp);
> +			if (i < 0) {
> +				retval = i;
> +				goto out;
> +			}
> +		}
> +	}
> +	mutex_unlock(&STp->lock);
> +
> +	switch (cmd_in) {
> +	case SG_IO:
> +	case SCSI_IOCTL_SEND_COMMAND:
> +	case CDROM_SEND_PACKET:
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	retval = scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE,
> +			    cmd_in, (void __user *)arg);
> +	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
> +		/* unload */
> +		STp->rew_at_close = 0;
> +		STp->ready = ST_NO_TAPE;
> +	}
> +
> +	return retval;
> +out:
> +	mutex_unlock(&STp->lock);
> +	return retval;
> +}
>   
>   /* The ioctl command */
>   static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
> @@ -3565,6 +3617,15 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   	if (retval)
>   		goto out;
>   
> +	switch(cmd_in) {
> +	case MTIOCPOS:
> +	case MTIOCGET:
> +	case MTIOCTOP:
> +		break;
> +	default:
> +		return st_common_ioctl(STp, STm, file, cmd_in, arg);
> +	}
> +
>   	cmd_type = _IOC_TYPE(cmd_in);
>   	cmd_nr = _IOC_NR(cmd_in);
>   
> @@ -3876,29 +3937,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   		}
>   		mt_pos.mt_blkno = blk;
>   		retval = put_user_mtpos(p, &mt_pos);
> -		goto out;
> -	}
> -	mutex_unlock(&STp->lock);
> -
> -	switch (cmd_in) {
> -	case SG_IO:
> -	case SCSI_IOCTL_SEND_COMMAND:
> -	case CDROM_SEND_PACKET:
> -		if (!capable(CAP_SYS_RAWIO))
> -			return -EPERM;
> -		break;
> -	default:
> -		break;
>   	}
> -
> -	retval = scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE, cmd_in, p);
> -	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
> -		/* unload */
> -		STp->rew_at_close = 0;
> -		STp->ready = ST_NO_TAPE;
> -	}
> -	return retval;
> -
>    out:
>   	mutex_unlock(&STp->lock);
>   	return retval;

