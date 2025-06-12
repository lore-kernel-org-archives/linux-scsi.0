Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A31C2139B0
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 07:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749714159; cv=none; b=rAHDmiXXlsf5Ks9GVd2eAQB8sVyhkgObz8OEahPsAFacoXsaNqJB+4xBUZWdD4L7fTsG5zvYhnXa269Ms5mhNeUKNwZvRDRr0D9AMNUnyPWZrsBJBxAtamwOb/hbQw6iJO9ajRu9bMVTSJFSQpgAr73qX112f+MKwjsecrp2fLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749714159; c=relaxed/simple;
	bh=liD84H33mldJ5FwcAo5b42k0QKzep4H4rmYW/0tE3Po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cao71x+NKDBtKeYvEQThryLpb3Z8Hs4MWAS3dJlnm4UoOpjE01xSZl43Vhnej42IwO2lg6RRIeLNGdEJh4CWi0lkc29HQZ7OzPf7nZY53+Moojd6xxaMqZQOsFL8BrQnzMCtpQIRnK5R7v2ApJ4CrHhd2ukyg52F0JBDgN21LC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RB7mHz2P; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RB7mHz2P"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a503d9ef59so579138f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 00:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749714154; x=1750318954; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pOjdW6tvwIHGvqgEBjcYXxpqXXP0mM93Bi1E5VHKi0I=;
        b=RB7mHz2P2F0km9hNYYtu3w9W1j0fp/y1iV6+QIlaCDcvOSzig+rw9sfzzBLqoNB9My
         FC0BFiaK7emHFD9TfA3KoCEgVCMmooWs5v8kXWeJxYp0GXatPBKkxRo96PLPF6be1G70
         wLKRi4UcC1JJWBC9uNDWrtn9j2csf4afhir3kvjc+p4qP6Xck5DJsdbimN2+fS8KekDG
         wMVUbeTYauqAoKxVs/4Ljj2jEwi44JjRtkG58FmM7ZcHmw+95RfQ+1ZkGYPgww5xTQUV
         u7aKlNpEpnGPTunoHhOsXFFONPmfcpcL0onPOS4cxzaEC+EgcOJnsj8re5KGWIqnoJHj
         M2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749714154; x=1750318954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOjdW6tvwIHGvqgEBjcYXxpqXXP0mM93Bi1E5VHKi0I=;
        b=uSeGXCeRM3gaRmLcGvJ8tUcVat/1KgbufNTwlCFTmrpk4u/MN4tVPm2LFFvelNxBdi
         4mqsDRZT1pZNagb6A1eD2lH2FL6nwfdcHeFeEN9ivTAXqKE+zSjg2HNnrTR5vssluwVE
         c0bqVzC3j26+fJ0WJxKW4g4IMk6J58hyYcQXWALlmkALa42wB41zL8KmmWRcYONc9oB2
         ub/hSVUSVYTUObmo40CfJ/m5WnfGpn/sAke22TUXw+trg2x6SeBHmUbrW8DDbZ7TH3Vd
         mAgcvLDvh4PDabJiJBKSlp8N7GcUoban52es68gToANg/OT4saskfSW/JQD2m5RcJQEx
         iklg==
X-Forwarded-Encrypted: i=1; AJvYcCVgXze8WE1IQRzym2gNmjFYuJC4eef/XnOA26OywgCHTuYVbpB5CirTJcN+jlXEk9I07FghUlo3ei1b@vger.kernel.org
X-Gm-Message-State: AOJu0YyunAXBg3dV0/SVG2uvWOtDBYwcigR/C6ObkFS2gFOgLukL/eR9
	ammCUKFZwcwl9YYzwwL6tQObMFyeL0LYqACGz3WL60os/LP1dI8m8zxEA23GiNg5/dE=
X-Gm-Gg: ASbGnctI8au4GDDkJ0LS3edCL5k7oMRn7FJXZ4UMpObxjm+DOvMy5BImaBz0L9SLQ39
	JJ8kUaiMCOfGjGVpYlCdUeotFjpL4c+2jUg2yW3jyd7tkLmnh61NzIR50/BSitG9zGHEeeF6jyD
	bZJWAkfhYY7kF1NEeaWIGN/u0zCRQ6M4BRIw7t1a+ojfCtEDEFyeH0+krI2cwfsfHWtmeH5XZgB
	ncfQNHtkkozNgrmyyC+Q7HhUE+EiDVYC3/CQXTyVXyDjqQ8u+bzb58ixFPOA1F34XPm2Mznh8um
	9V7vPR83sCUmlTTx6c0yvgt+P+iKWuknDikqEYSpVkCbQCZLY0vv9hYSfR6MgEg7Ars=
X-Google-Smtp-Source: AGHT+IHK4uQuCn2XQWMjU/bTqraytEDLe7/LB0UXdjlju8466jLpB8n5+oghPZtv4fc6nLejDkqEyw==
X-Received: by 2002:a05:6000:2308:b0:3a4:e740:cd72 with SMTP id ffacd0b85a97d-3a56127883dmr1425617f8f.13.1749714154457;
        Thu, 12 Jun 2025 00:42:34 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-453305a0d9dsm3836115e9.21.2025.06.12.00.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 00:42:34 -0700 (PDT)
Date: Thu, 12 Jun 2025 10:42:30 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com, revers@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler
 when FDMI times out
Message-ID: <aEqE5okf2jfV9kwt@stanley.mountain>
References: <20250612004426.4661-1-kartilak@cisco.com>
 <20250612004426.4661-2-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612004426.4661-2-kartilak@cisco.com>

On Wed, Jun 11, 2025 at 05:44:23PM -0700, Karan Tilak Kumar wrote:
> When both the RHBA and RPA FDMI requests time out, fnic reuses a frame
> to send ABTS for each of them. On send completion, this causes an
> attempt to free the same frame twice that leads to a crash.
> 
> Fix crash by allocating separate frames for RHBA and RPA,
> and modify ABTS logic accordingly.
> 
> Tested by checking MDS for FDMI information.
> Tested by using instrumented driver to:
> Drop PLOGI response
> Drop RHBA response
> Drop RPA response
> Drop RHBA and RPA response
> Drop PLOGI response + ABTS response
> Drop RHBA response + ABTS response
> Drop RPA response + ABTS response
> Drop RHBA and RPA response + ABTS response for both of them
> 
> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Tested-by: Arun Easi <aeasi@cisco.com>
> Co-developed-by: Arun Easi <aeasi@cisco.com>
> Signed-off-by: Arun Easi <aeasi@cisco.com>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Cc: <stable@vger.kernel.org> # 6.14.x Please see patch description

I'm a bit confused.  Why do we need to specify 6.14.x?  I would have
assumed that the Fixes tag was enough information.  What are we supposed
to see in the patch description?

I suspect you're making this too complicated...  Just put
Cc: <stable@vger.kernel.org> and a Fixes tag and let the scripts figure
it out.  Or put in the commit description, "The Fixes tag points to
an older kernel because XXX but really this should only be backported
to 6.14.x because YYY."

regards,
dan carpenter

