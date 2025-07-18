Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236661F92A
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752877835; cv=none; b=mEfrNtYHdB65mRFhTxpOY191tlyc9bghu5ebB4SWQYSSt7GR+Owiw+RcZs+6JzgK3WWMpUklF3u7gV9vXwtkpt/ct2+tTutawOJ7OMpMKeUQrj3ew9BUB1/NGnKaU6JM/QcK3PCkI0Io7UogrpbI1IrQVDVw7FZgrJnmyehWrqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752877835; c=relaxed/simple;
	bh=sY4aNr1nWbzTlGAUHHYl9MCtomdJQVQxN0BsHVGrBAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h79R39XR1q7nj238nW922CeA5nOj2XhX0Ko35aANDM9udxCLTtKnUbt1hXnK6rNAl85DtSC0YtMi3QrycPYPCqgUX7aeMNco3DnaC5oPG7TqMmnG+UzhmaAzrQ54iATaNmErmQLGsG8sTQCYYmXl0vZQKNNzPYqn0Ps3R45+27w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x83kpwzR; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x83kpwzR"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-235e389599fso65885ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 15:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752877833; x=1753482633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I7Y2FANJDjjPo+eW8s3VGBQISkavgLkmlT1I0QKOxbM=;
        b=x83kpwzR49ogYcN/DHtCYq4eR7PsfWezfpDnfJp/vBOsFqPclBQrwHR0LJ0hEAHgXb
         UuA3YjM3iIjfE+I++S6aV+bIEabn/M38Ix8Z8NkwWy2LhiP4Ls9YQPhhuXRCauXtUtNh
         9M4pH9Ys16s66BEUi44vI7R60VVy7DWiERO8KyBa2AzFXwVXMdaOzuc68LTwTpcMRfly
         U5ayPL0dvNF63S3lKLI3yvAzVHaj7X+x8rsMhJnJqQQr7tFULmQoGGR5lp2BCH6usFKI
         jxSLCvlt5f7Z1RNtwv4hshi5D1DoGGl1szthPp/X/4bXgb1Y8o7RaB5EdThtVjU43sg1
         1wpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752877833; x=1753482633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I7Y2FANJDjjPo+eW8s3VGBQISkavgLkmlT1I0QKOxbM=;
        b=FDh8bxuHeKMyxWsPXW0DrtIzyhe9ah0/rFXOi8wkvO8u6v9oqj/s13bNnY0Ky7ttxs
         Rj9S+NZUXaZZyRsLDKWKdcpLIoO6KSPP8Silkohbi8nquRg7D4yb+w9qK21p+ZFWkhl5
         OyTWbBhmHpZgX5FiJVrdDpmh7/198uA4sV0BzPH8HmAeBbcqj4njE2s6Fjl/lij/uCnu
         GID4kr0i3mBRwD1edtdHFbkpo7LmswZz5SEuFbLawI55qjuEGJVSPHncUZi0XPbzT3YP
         B5NE/Y2bbaqz2ovI6O0iI0wLS2LQ983KmUa3rjGLVs5SKwac2OmBMvfdCYgipU9E0DvF
         kbeA==
X-Forwarded-Encrypted: i=1; AJvYcCWYW4oto9lST3zRvLmmeRq1sYhjOiIRtGTizm1lg0Wt5VytElVXYGCJv0uXtbkG9aSCzHJ4MXDuUUae@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn3bowCruoGMBZmGd142SkOL7BQFJTgEO27nRTWyJnLbqRF5/D
	17TXgkTSjD++I1ZBncAK+utoIm2pEfZjNrlVzhI56sOdrYnk6dHrr1zh5hHq4WZpOA==
X-Gm-Gg: ASbGncvQ4hbxDZki7bQf+PeZPm67etURSppKFHE9RnwNljnxtJmNgOac2CB/MmBf3+c
	FB/U5raquTGPO/jrZKSUus0Mr1n2CbCYNpFrhG+RfJcspEQ/p9z3GHMIcHDa1HvQ+jU0i9BGOzj
	IpYtek510oM5E7pwxuR7x7fPsDxzBYyoae3NE0Fs4povtsnKNwPjlmq+uTLthQenmSyPmu+OYgL
	3t1XeJZa3zoLW1bXxxQKIfOvzSZA1b1UIPAztN85iQNDf/krtY1/LWHuNRQMjRqFd/gBLfLYQBG
	jAvpN/bZcup9gtCT0e0o96HSABNjbPxE69fnu9VIoPSSfneMUQKTjlTu9D5kliX4w2OTm3c0OsQ
	h0RsA8T0GYfapiPw5o8nfXUDEBn7Bv1BNNY8+xlf2na4WkM+HZ9ZPOm1SdQ==
X-Google-Smtp-Source: AGHT+IG8y9t/nm0Z/zrPUvlMrgFpg5qaSZFfVFBfgRmS9zniPLDy5B2S+lbOyzbzpR8SXJBKgtVZmw==
X-Received: by 2002:a17:902:c949:b0:22e:4509:cb86 with SMTP id d9443c01a7336-23f72bebe3dmr336315ad.19.1752877832671;
        Fri, 18 Jul 2025 15:30:32 -0700 (PDT)
Received: from google.com (166.68.83.34.bc.googleusercontent.com. [34.83.68.166])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759cb678d0asm1761991b3a.113.2025.07.18.15.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 15:30:31 -0700 (PDT)
Date: Fri, 18 Jul 2025 15:30:28 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
Message-ID: <aHrLBPunX8Fuv1zz@google.com>
References: <20250717165606.3099208-2-cassel@kernel.org>
 <aHlpNRsPbmrTgv0O@google.com>
 <a09dea31-0de3-4859-95d9-2d83fc1ccc73@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a09dea31-0de3-4859-95d9-2d83fc1ccc73@kernel.org>

On Fri, Jul 18, 2025 at 01:35:13PM +0900, Damien Le Moal wrote:
> On 2025/07/18 6:20, Igor Pylypiv wrote:
> > On Thu, Jul 17, 2025 at 06:56:07PM +0200, Niklas Cassel wrote:
> >> This reverts commit 0f630c58e31afb3dc2373bc1126b555f4b480bb2.
> >>
> >> Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") causes
> >> drives behind a SAS enclosure (which is connected to one of the ports
> >> on the HBA) to no longer be detected.
> >>
> >> Connecting the drives directly to the HBA still works. Thus, the commit
> >> only broke the detection of drives behind a SAS enclosure.
> >>
> >> Reverting the commit makes the drives behind the SAS enclosure to be
> >> detected once again.
> >>
> >> The commit log of the offending commit is quite vague, but mentions that:
> >> "Remove sas_find_local_port_id(). We can use pm8001_ha->phy[phy_id].port
> >> to get the port ID."
> >>
> >> This assumption appears false, thus revert the offending commit.
> > 
> > Thanks for bisecting and reverting the commit, Niklas!
> > 
> > Let me review the changes and send a proper fix that takes into account
> > drives behind a SAS enclosure. I would appretiate if you could test that
> > new fix since I don't have a setup with a SAS enclosure.
> 
> s/enclosure/expander
> (the important point here is if there is an expander between the HBA and the
> devices, not how the devices are installed. E.g. a simple enclosure may not have
> any expander and act similar to a fan-out cable connection)
> 
> I think the issue is that if you do not have an expander and use fan-out cables
> to connect drives directly to the HBA, you essentially get HBA SAS port ==
> device port and it works (My setup is like this with an -8e model, so 8 ports, 0
> to 7). That is the case for "if (!pdev)" in sas_find_local_port.
> 
> But if there is an expander, you can have multiple devices per HBA port, so you
> need to search backward using the parent device until you hit the HBA device
> itself, which gives you the port to use to communicate with the device.
> 
> So not sure if we can simplify/remove the loop in sas_find_local_port(). Maybe
> if we add "local_port" field to struct domain_device ? But then any topology
> change event would potentially need to update this.
>

Looks like there is no need for sas_find_local_port() because child devices
have a reference to the same port?

struct domain_device {
...
	struct asd_sas_port *port;        /* shortcut to root of the tree */
}

https://github.com/torvalds/linux/blob/c7de79e662b8681f54196c107281f1e63c26a3db/include/scsi/libsas.h#L168

During discovery, child devices inherit parent's port:

https://github.com/torvalds/linux/blob/c7de79e662b8681f54196c107281f1e63c26a3db/drivers/scsi/libsas/sas_expander.c#L826

and also

https://github.com/torvalds/linux/blob/c7de79e662b8681f54196c107281f1e63c26a3db/drivers/scsi/libsas/sas_expander.c#L936

Hey Niklas,

Could you try the following fix with your expander setup, please?
The fix assumes the problematic patch is not yet revered.

$ git diff
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f7067878b34f..cd9513c23c71 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -503,7 +503,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
        spin_lock_irqsave(&pm8001_ha->lock, flags);
 
        pm8001_dev = dev->lldd_dev;
-       port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
+       port = dev->port->lldd_port;
 
        if (!internal_abort &&
            (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {


Thank you!
Igor

> 
> -- 
> Damien Le Moal
> Western Digital Research
