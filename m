Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7722E41A504
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786534185; cv=none; b=N4HHHOhccBBq5Bs8cAGdhII5jZuyuH+EW/K2spKLTLshjaEbajbld8siqpYdj/NeewjqowRbhF8nZnR2w3aNDwBtNb2vu9+0girV0MP388JGPhfeiWr/TYvsvxOJTKshmIbkcc/u97fTuLEkXeiIGYkomG4LZqg09t2G0AVlY0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786534185; c=relaxed/simple;
	bh=J5qQg2sgPSp5ug0RQjQNqqEcAlSDBcR8J0nLpJRI3n8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8fR3XBTsyGiiGrUCehuqBrSCXjweSXX1vATiB6iRqxYQVXbsfYvBjuQC/SV7K21Z4iYlmzewHkVeVHOhTgydU7XWy5u42TDce/MdssjFCM0LjH2LGcNNUqmSRzLmM6YA9ccQ5P+4VY6D81PCu0ZcVPBdGmsmloVM7qORFbm93Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IAkiRLW3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g7Wy9xoV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IAkiRLW3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g7Wy9xoV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786534182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Au0NrUwn9ekws0t3rfHDWqY58j+n7hjhM+HaCR8gx9A=;
	b=IAkiRLW3Zxc1Lspt04KHuZIOvPGUcVRN/VhFAdoCkmGo4M+l9qqecKM127HV0/ETZGUcpD
	8BtCkZlNkUP6XLfPNuFlI81w5j1ep+Ohi7tm+wuPYql3cZlDRnROb4mBsIohILbh60i59J
	6a64Eh1GCDSr+QOVUI+J/BRkx/5PUWw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-OTi_-H6GNqWwWFR_grWnaQ-1; Wed, 12 Aug 2026 07:29:41 -0400
X-MC-Unique: OTi_-H6GNqWwWFR_grWnaQ-1
X-Mimecast-MFC-AGG-ID: OTi_-H6GNqWwWFR_grWnaQ_1786534180
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1577751a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 04:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786534180; x=1787138980; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Au0NrUwn9ekws0t3rfHDWqY58j+n7hjhM+HaCR8gx9A=;
        b=g7Wy9xoVvhjujO2yolwl4BodhQzNfxn2lVFrEit6Oi9r+CCsB3hF7LtpGHRdlaNkpS
         eCJra0l93tI9kRyFn+fUsPD9TkjFzvulO7fPwR31Em/UeqdF5yOrVzB9okDE9PIOd92R
         n2eRYsXup1BGD/CXMihxjjh3leGnGuZY49MCHLoS5dmRP6Mp4e6nmjOycX/Pi2ZLXfvO
         OaHAmYhN27Vcv13vUamrMht36uVp9eNl/3kaLY/P/ss08gxyXly+U6kEzylScvxZ6fsZ
         wPUFJ9Q9WmZapKK25eifDvx8j2SIJofmUqZ4YjqrNbVyQD5C2eueOz+96nzJ4ojM6QjM
         7MfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786534180; x=1787138980;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Au0NrUwn9ekws0t3rfHDWqY58j+n7hjhM+HaCR8gx9A=;
        b=l/yvacYBvX67GCl5JGbTzcPjB8mmGXml8Zmli/6bFueC/SrEEdTSpFefpm1+gyNo8M
         imj+fIqmVhgtqCPUcqrV7MPFeb/jqodx/CJk+hFa/lhKc0n+d/AXuXsgg3kTpgH1L92o
         rQyrNxmVY/eM6c4ou353r4iMidwSehH66xMlUBEQ7AieA285b4FyoTLMKnJ/WwCAKaNQ
         tEqvabvXPZJi9199uHhnR3Ny1yKzW0YibhxUaBjjNrBgTqCuLmSCHhURBHYU/wmo7GSX
         Q5TRUEhwg9JMk084yr6w9PR+bYc1B6lZxqmUenzIsGJnZ00y0MJTwbExB25LJWKLjMGb
         5MXQ==
X-Gm-Message-State: AOJu0YyaIAx8aQSxoWYw5xsxxXlxkKnfcjVrkFjD1jmCR/k2Xg6X8weS
	28fBZ2qSkZ8cKZe6SxKtUh972Db/7bUVoJL8WRmBERZoNiWQwKk92wq9d02mAiUjMia6JlJCmcg
	kY1Jis4bs0B2IWs/amdlwpFUYDyRUVu+IXIQseeQh7IH8sqcvtA0STe6kUHENne4=
X-Gm-Gg: AR+sD10DF6B21XPwh9y0/Uenflll6edZzF7d0smTMQ1MFMG0amilny6Amm1IgpTCfF1
	lR9FcGHSXtJFsT57/CELEKlXdYge3tPI9TJqp54dY/Og2ul71NAXTDrESDijsbIizaxNYmixdmb
	gm9ml7Wcey1u7qXpbX7ofFXPyKZV4lS3fUKnEd7L9BH6HFHJ5fwpY2LkNxq+kT+U9lLnXoAN1Ga
	Hp5Ib9IBuDe0GkpfbKtdqdS+9gzR5xeSwQN4DEfiWuX+rNzUWJkss9zy16bmQiHrJxBYou/eqhb
	5Wclqoq+mjhnzk9gRDQbBtn6Jcz/s3rd9aX2pIk03+nhm3zDL4jezcT5n5ZPJdD6hCAPoD2wHiF
	VW3VJlSWisg9Wvv7sPcUVUR2518BGjf66upbBPjyH8PF4ZZu8XGXzZXrtXjqGyGZVjcmv
X-Received: by 2002:a17:90b:5828:b0:38e:5964:97a8 with SMTP id 98e67ed59e1d1-393014c10cemr5553485a91.16.1786534179966;
        Wed, 12 Aug 2026 04:29:39 -0700 (PDT)
X-Received: by 2002:a17:90b:5828:b0:38e:5964:97a8 with SMTP id 98e67ed59e1d1-393014c10cemr5553407a91.16.1786534179387;
        Wed, 12 Aug 2026 04:29:39 -0700 (PDT)
Received: from mgandhi-thinkpadp16vgen1.punetw6.csb ([2401:4900:88fa:3d3d:2349:1310:a2eb:9912])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392fe4f9079sm829631a91.3.2026.08.12.04.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 04:29:38 -0700 (PDT)
Date: Wed, 12 Aug 2026 16:59:32 +0530
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH 1/2] scsi: mpi3mr: Fix NULL pointer dereference in
 mpi3mr_sas_port_add()
Message-ID: <anxZHBo9tOMvbmcu@mgandhi-thinkpadp16vgen1.punetw6.csb>
References: <20260812103344.174247-1-mgandhi@redhat.com>
 <20260812103344.174247-2-mgandhi@redhat.com>
 <20260812104334.CDC5E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260812104334.CDC5E1F000E9@smtp.kernel.org>

On Wed, Aug 12, 2026 at 10:43:34AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Missing NULL check for the return values of sas_end_device_alloc() and sas_expander_alloc().
> - [High] Ignored return value of sas_rphy_add() leads to a resource leak and invalid system state.
Thanks for the automated review. 

The flagged rphy NULL check and sas_rphy_add() error handling are
pre-existing issues in mpi3mr_sas_port_add(). 

I will keep this 2-patch series focused on fixing the sas_port allocation/free 
bugs and target device refcount leak, and I will look into addressing the 
rphy error handling in a separate follow-up patch.

Thanks,
Milan
> --
> 
> --- Patch [1]: [PATCH 1/2] scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add() ---
> commit 52d7de23ae9ec8ed8dec5b684daecf405f00a60e
> Author: Milan P. Gandhi <mgandhi@redhat.com>
> 
> scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
> 
> sas_port_alloc_num() can return NULL on memory allocation failure, which
> causes a NULL pointer dereference when passed to sas_port_add().
> Additionally, if sas_port_add() fails, the allocated port is leaked.
> This patch adds a NULL check and calls sas_port_free() on failure.
> 
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > index 240f67a8e2e3b..ea2c04384a0e1 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > @@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
> >  	}
> >  
> >  	port = sas_port_alloc_num(mr_sas_node->parent_dev);
> > +	if (!port) {
> > +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> > +		    __FILE__, __LINE__, __func__);
> > +		goto out_fail;
> > +	}
> >  	if ((sas_port_add(port))) {
> >  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> >  		    __FILE__, __LINE__, __func__);
> > +		sas_port_free(port);
> >  		goto out_fail;
> >  	}
> >  
> 
> Further down in drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add():
> 
> 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
> 		rphy = sas_end_device_alloc(port);
> 		tgtdev->dev_spec.sas_sata_inf.rphy = rphy;
> 	} else {
> 		rphy = sas_expander_alloc(port,
> 		    mr_sas_port->remote_identify.device_type);
> 	}
> 	rphy->identify = mr_sas_port->remote_identify;
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but does this code lead to a NULL
> pointer dereference if memory allocation fails? If sas_end_device_alloc() or
> sas_expander_alloc() returns NULL, it appears we dereference rphy directly on
> the following line without checking it.
> 
> 	if ((sas_rphy_add(rphy))) {
> 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> 		    __FILE__, __LINE__, __func__);
> 	}
> 
> [Severity: High]
> This is a pre-existing issue, but does ignoring the return value of
> sas_rphy_add() here lead to resource leaks and invalid system state?
> 
> The failure is only logged, and execution continues without aborting or
> cleaning up the rphy. If we leave an unregistered device in the state
> structures, could it cause an oops during teardown?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260812103344.174247-1-mgandhi@redhat.com?part=1
> 

