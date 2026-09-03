Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8783938B7D6
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 20:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467578; cv=none; b=APfmzhpdbcMfVmK7hkH4Ll7/uG0363qvGFR4OU3tU53nDYm1iIOUCaXvVmDLDqtN1wmzO2hPjO/X1P/M3xWIUEgy9bN5uMSMqeMXORrS70Pk6PwNhuDuR8qcvT8FCfVCmoFYh0kX+8bOk1gipmjB59sCtbk3k05UpeN2yO4LQOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467578; c=relaxed/simple;
	bh=WHNrUCfnRz7m/hj7cjO+2IgflCsHFhVI7ERkCsj23/o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CkRRLk4JOWEGcRAp0qGQx97LD9B1o/2SUN1Zon65MPDz8JdGwkgFr6Sf5DrQz4Bzotc8OjAq7eAHvCW5Ygg0Jbq2/DZH1otIhnOada1XsAnYqEWfmPHDJKPDw1Jufjt7g5aFEucw8a2EqdTQHeY4V0G6E24JnNEQszJ5lpJT9fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BaSUZp39; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkRyeMnS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BaSUZp39";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkRyeMnS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788467568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H7heLBpWFoof/Lo8sLrlgN9gw1h8nebNbjFCGP84TXI=;
	b=BaSUZp39LzkjgcItRgqozQumd4/DAgEEx/J1+bJhnRwaJ1EOSPyvsugMmox9S5GrSJZCle
	vsABrfFFAmNhE00gfrMae63AvyfCqGAEw9EvniUsIop80ZBLk5OaJbKdKgsYR+Sw7WIgc2
	bLyX0B1lGF4PXf3yBbJBPJl4OUDf15Q=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-cfuTzIWCMimZ4d3Potr4qg-1; Thu, 03 Sep 2026 16:32:47 -0400
X-MC-Unique: cfuTzIWCMimZ4d3Potr4qg-1
X-Mimecast-MFC-AGG-ID: cfuTzIWCMimZ4d3Potr4qg_1788467566
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90e96bdbbdaso4867156d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2026 13:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788467566; x=1789072366; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=H7heLBpWFoof/Lo8sLrlgN9gw1h8nebNbjFCGP84TXI=;
        b=KkRyeMnS2uRGXoLfecwCMOKVqTev3UFLXiipjvFOCY1KUKgSvgx8XYtQBOEHo+xvp1
         kjiPijtvWMwPhCS3RqyH+KYlY9U3YG3CY+cVEMvkdpAn/GV7axkts39XzgkgTpq64iEB
         70hlLhVG5apfOCxz9jxM0OoDh3lZmuDuV5dX09Pff4MvNqKq8ePwR0xlubK55JNPI4Ki
         16wy4diyjtBS2eUe08+K4UeslvnendXAOHcCCK75OrPMavSARAY4Fq/7BiwaI1WZ+2FD
         K20Pi7qjoxDv63xVFVt50n4MLPKr7/xLdrglNZHt0+FseTG5b0h57gP4cBJcrj8OKShL
         r+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467566; x=1789072366;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H7heLBpWFoof/Lo8sLrlgN9gw1h8nebNbjFCGP84TXI=;
        b=PMAfN2kfZkvGYKlssQhYqPPbm59lOGlYsQ+o5acdYjv2DhnM1a9Uccv9VJ3UT+k8AO
         HUSX9jHQLiV47EdFjvo9CjoIukKc4S3JbGYwNSEoQN6JRtsq1SLgWVPnJErkknG2JhmZ
         LQckAlng6LySh3qp8PHqXwA6rykLf+9so0lemaeNh5BcFa1UNUCBKvq1KSzONC0DxBqi
         Sd3n7KLN1n4QDQvk20/bbAtwa+iY6fyupp/Z9SrJb8QiKNrlCKOZn0EZnx10rhjHc277
         tScqnLfPZWK3jKA3QCxouKKRmR+aZJc9Cp7C9rXNbMis58XSg43tV3tsifL6MwEDA3k6
         k6BQ==
X-Forwarded-Encrypted: i=1; AKwUvBxbyPsPKT3bqaBg0Lfn3fTn/B8yyIw3hdfFY3MMqPb2JIQrukkS5MHpspb5V6VL0lxIF0q54bYEWRZZ@vger.kernel.org
X-Gm-Message-State: AFuF++kEARi7sGAMdEQVSUHf0eP4t4hEeecZNSlnLoTWSL38cHb6BqSO
	MGA68+i2mAec/RAJ8NOkEcZOBPs4PhizmjwA3ibsdPk89kqwtMveWWPZLV86WGabQkB/uyWqvaN
	/eUbCaeyYMGAR0ZUL8CWw9plL28GoxcaRYj1Lei1FVHjgYY4fnvv2OZYXEn7L6Fo=
X-Gm-Gg: AYBFou1wg4qsb/WwVzrqzU9arbsRiMQykrBWiyEfEk4QwmzttKfJvacKMerx6YblIuA
	kLEOB7Hcypxcc9b4KN6HupjH5WfdS3KEh064WvWQ5NknlSzsqvQupqmDDP6lPBMSKi/Q/kzdjLl
	i2FFpexpgy8O1gPxAen5CISyJ5PWo+1T48jrxxad2v4mtKwXVn0LNklV572AW38PaWk5Dn1k/IA
	LPDlvlX61iuctpyFYa2iO9/u7xUKYSIrSojKW5B8S3HwZzpKaDk392Ojgj9ZDGuRUNWmQwzgFuK
	sAt1EqNSYBdqfnc4b6kHdZV55rhzKAWbSy50JhD58M0nkN/vM7lkcE2DuRVybsROJeYmVPSR98m
	lptHyBIoQe7Ys21Db4FUWK2alhv/yNeclT9a4
X-Received: by 2002:a05:6214:3301:b0:90e:7f1a:6e0a with SMTP id 6a1803df08f44-9103f0ccadbmr18266176d6.28.1788467566333;
        Thu, 03 Sep 2026 13:32:46 -0700 (PDT)
X-Received: by 2002:a05:6214:3301:b0:90e:7f1a:6e0a with SMTP id 6a1803df08f44-9103f0ccadbmr18265606d6.28.1788467565766;
        Thu, 03 Sep 2026 13:32:45 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406bf8c3sm3077256d6.48.2026.09.03.13.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:32:44 -0700 (PDT)
Message-ID: <7126726ef41117a1307b931fbccf40b826730e50.camel@redhat.com>
Subject: Re: [PATCH] scsi: fnic: Fix missed link-up when a critical IRQ
 targets an offline CPU
From: Laurence Oberman <loberman@redhat.com>
To: Arun Easi <aeasi@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, 	satishkh@cisco.com, kartilak@cisco.com,
 jejb@linux.ibm.com, 	martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, jmeneghi@redhat.com, 	revers@redhat.com,
 adakopou@redhat.com, lduncan@suse.com
Date: Thu, 03 Sep 2026 16:32:42 -0400
In-Reply-To: <20260903175547.57971-1-aeasi@cisco.com>
References: <20260903175547.57971-1-aeasi@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-09-03 at 10:55 -0700, Arun Easi wrote:
> When CPU Hyper-Threading is disabled, sibling CPUs remain present but
> are reported offline. Managed MSI-X IRQs can still receive affinity
> masks that include those offline CPUs. If a driver-critical vector is
> managed, it can be parked on an offline CPU and the driver may miss
> critical events such as link-up.
>=20
> Keep driver-critical vectors unmanaged so they can be migrated by the
> IRQ core when their target CPU is offlined.
>=20
> Since HWQ-0 is unmanaged now, in some queue combinations there can be
> no
> mappings to it in mq_map. So without the blk-mq fix mentioned below,
> system may crash during cpu offline/online tests.
>=20
> Fixes: 8a8449ca5e33 ("scsi: fnic: Modify ISRs to support multiqueue
> (MQ)")
> Cc: stable@vger.kernel.org
> Depends-on: commit 10845a105bbc ("blk-mq: skip CPU offline notify on
> unmapped hctx")
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
> Signed-off-by: Arun Easi <aeasi@cisco.com>
> ---
> =C2=A0drivers/scsi/fnic/fnic.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0drivers/scsi/fnic/fnic_isr.c=C2=A0 | 13 ++++++++---
> =C2=A0drivers/scsi/fnic/fnic_main.c | 41
> ++++++++++++++++++++++++++++++++++-
> =C2=A03 files changed, 51 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index c576a7f5083e..3ba1592940ca 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -31,7 +31,7 @@
> =C2=A0
> =C2=A0#define DRV_NAME		"fnic"
> =C2=A0#define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.9.0.0"
> +#define DRV_VERSION		"1.9.0.1"
> =C2=A0#define PFX			DRV_NAME ": "
> =C2=A0#define DFX=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DRV_NAME=
 "%d: "
> =C2=A0
> diff --git a/drivers/scsi/fnic/fnic_isr.c
> b/drivers/scsi/fnic/fnic_isr.c
> index 02856745580f..43149d8312ec 100644
> --- a/drivers/scsi/fnic/fnic_isr.c
> +++ b/drivers/scsi/fnic/fnic_isr.c
> @@ -245,7 +245,14 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
> =C2=A0	unsigned int m =3D ARRAY_SIZE(fnic->wq);
> =C2=A0	unsigned int o =3D ARRAY_SIZE(fnic->hw_copy_wq);
> =C2=A0	unsigned int min_irqs =3D n + m + 1 + 1; /*rq, raw wq, wq,
> err*/
> -
> +	/*
> +	 * Make driver critical vectors unmanaged, or else it can
> get tied
> +	 * to an offline CPU. This can happen when hyper-threading
> is off.
> +	 */
> +	struct irq_affinity affd =3D {
> +		.pre_vectors =3D n + m + 1, /* rq, raw wq, 1 ioq */
> +		.post_vectors =3D 1, /* err */
> +	};
> =C2=A0	/*
> =C2=A0	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1
> INTRs
> =C2=A0	 * (last INTR is used for WQ/RQ errors and notification
> area)
> @@ -263,8 +270,8 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
> =C2=A0		int vec_count =3D 0;
> =C2=A0		int vecs =3D fnic->rq_count + fnic->raw_wq_count +
> fnic->wq_copy_count + 1;
> =C2=A0
> -		vec_count =3D pci_alloc_irq_vectors(fnic->pdev,
> min_irqs, vecs,
> -					PCI_IRQ_MSIX |
> PCI_IRQ_AFFINITY);
> +		vec_count =3D pci_alloc_irq_vectors_affinity(fnic-
> >pdev, min_irqs,
> +			=C2=A0=C2=A0=C2=A0 vecs, PCI_IRQ_MSIX|PCI_IRQ_AFFINITY,
> &affd);
> =C2=A0		FNIC_ISR_DBG(KERN_INFO, fnic,
> =C2=A0					"allocated %d MSI-X
> vectors\n",
> =C2=A0					vec_count);
> diff --git a/drivers/scsi/fnic/fnic_main.c
> b/drivers/scsi/fnic/fnic_main.c
> index 9b3025007075..f13c381a66d7 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -744,8 +744,19 @@ static int fnic_nvme_drv_init(struct fnic *fnic)
> =C2=A0	return ret;
> =C2=A0}
> =C2=A0
> +static void fnic_mq_init_queue_map(struct fnic *fnic,
> +		struct blk_mq_queue_map *qmap)
> +{
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		qmap->mq_map[cpu] =3D 0;
> +}
> +
> =C2=A0void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
> =C2=A0{
> +	const struct cpumask *mask;
> +	unsigned int queue, cpu;
> =C2=A0	struct fnic *fnic =3D *((struct fnic **) shost_priv(host));
> =C2=A0	struct pci_dev *l_pdev =3D fnic->pdev;
> =C2=A0	int intr_mode =3D fnic->config.intr_mode;
> @@ -766,7 +777,35 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host
> *host)
> =C2=A0		return;
> =C2=A0	}
> =C2=A0
> -	blk_mq_map_hw_queues(qmap, &l_pdev->dev, FNIC_PCI_OFFSET);
> +	fnic_mq_init_queue_map(fnic, qmap);
> +
> +	/*
> +	 * Setup CPU to Queue mapping for all managed MSI-X IRQs.
> +	 * Q0 is driver critical and non-managed, hence start from
> Q1.
> +	 */
> +	for (queue =3D 1; queue < qmap->nr_queues; queue++) {
> +		int irq_num =3D pci_irq_vector(fnic->pdev,
> +					=C2=A0=C2=A0=C2=A0=C2=A0 queue +
> FNIC_PCI_OFFSET);
> +
> +		if (irq_num < 0)
> +			continue;
> +
> +		mask =3D pci_irq_get_affinity(fnic->pdev,
> +					=C2=A0=C2=A0=C2=A0 queue +
> FNIC_PCI_OFFSET);
> +		if (!mask) {
> +			shost_printk(KERN_ERR, host,
> +				"failed to get irq_affinity map for
> queue:%d\n", irq_num);
> +			continue;
> +		}
> +		FNIC_MAIN_DBG(KERN_INFO, fnic,
> +				"got irq_affinity map for %d:\n",
> irq_num);
> +		for_each_cpu(cpu, mask) {
> +			qmap->mq_map[cpu] =3D qmap->queue_offset +
> queue;
> +			FNIC_MAIN_DBG(KERN_INFO, fnic,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "[Q%d] cpu:%d <=3D> irq:%d\n",
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queue, cpu, irq_num);
> +		}
> +	}
> =C2=A0}
> =C2=A0
> =C2=A0static int fnic_probe(struct pci_dev *pdev, const struct
> pci_device_id *ent)

This hit an actual customer who had the hyper CPUS showing but offline.

Patch looks OK to me, I understand how it prevents the original issue.
Reviewed-by: Laurence Oberman <loberman@redhat.com>

Thanks
Laurence

