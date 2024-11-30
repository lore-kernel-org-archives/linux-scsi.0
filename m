Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9D24087C
	for <linux-scsi@vger.kernel.org>; Sat, 30 Nov 2024 10:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732960983; cv=none; b=lvfjm64nJsFXqI6ZmSnHVkys2ZUjtPjlR54E6OfFnVIetHICTFWyMlh2FIfoX52O+ISYW/9Rle4eFA5ql1q4gkupqY8J1KEoKP+Q1xjWJ2Fg45QjAS0MFA5wUm3O82mJkYRZ+t0SIwOVh6YWOyiZev3LsP/6kY509mj7idhvDwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732960983; c=relaxed/simple;
	bh=FHcGQBaRkW0QV+1EdNnjhY6pFMzZr7/s5Aj+Z6HfEhY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Dt1t/M30VBa4oLlbvCOFvSRk01aX0t/AQeKAIMmOuEi5PZ3s/3Noy7ITrNuzYb4kn9LtIA7aU8kxFesZDlX8B2EL5GQLjCl2cNutPxfrXm4HB1Hn2M+6vWB7C9hiGq2tZMuX7+ymXbhzXPlbfz4OL5PUt5ams4JjoJtyYlzByBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lRRaBgNP; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lRRaBgNP"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-434aa222d96so30337415e9.0
        for <linux-scsi@vger.kernel.org>; Sat, 30 Nov 2024 02:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732960980; x=1733565780; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tUSjny8lV8zXEJCshKiN4IFoow0xfVyMjpOxrIHAZpI=;
        b=lRRaBgNPP1V+v6pED3lO2cT/Cdh/iB7/nD1tntNMEx86zFn3Yipi4GSZPvmspSM85U
         FBPEFQb0lLyaqP0+GslXfkQmYOeh/z/P+dEPYPKQm6A3tl24pauglmRv+HT0BERI+BC/
         KSkdDSxmnjTfmwAexfc7Lgqpxq55m0iZdFwVSiaf+oHP+A9FoOtXFDpE6tyKah0RS4+C
         KjrodCDnlnd1qnA4IMT7ZwzovZXd6zU2k7c2ExdPbxt4wYsJ9tDr9GWwxEqfN2l+V3RY
         s2Ee8/Jeo7Q23SUDKtZfJSRCfKRpNK6ULeqjS0J07EKXSYdV4mQyJ+Q9SCqhKBnb5prH
         9Xpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732960980; x=1733565780;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tUSjny8lV8zXEJCshKiN4IFoow0xfVyMjpOxrIHAZpI=;
        b=fZbafG2HuJd71PHpYtptOI2Xlw4Fl4U2TivLNwSAw6vBiZPqvxsC3Wkz08EfjiKR87
         Qu1Up9y8Npc8Z4+h+0b0ygvl8J8vdSJ0yEtmTmZ6fC0JPeJlOeXbpK2CTXnzhsHlqe8I
         PwzxrnWQGkkxXQfMbxeEHXj1uY3RFWL3LGPUGeJ1QE6WNh13sU9X3sSglDrrzZF8bkOz
         jtG4BDDTyiXLy3caTRfKlezY5HyWH/apAISDTJMfRfbxW7utxYyNs9dyE2Wk/BM18WFI
         p08HTsfJDY2SqQ7P5d7f3QdD6fhKS48UGmuP/+riiEfrMH3cir4UdZylxVIMTnF65sid
         mJGg==
X-Forwarded-Encrypted: i=1; AJvYcCVRGht8gWbTolnftyoSWq0rWNXYW0dfeQ2+QTJhfPLECFli5jfd5zpfR32roVzSjWkBAhpNUGn6XzPy@vger.kernel.org
X-Gm-Message-State: AOJu0YyQOhWa1upYZSp8Yx9xFaCKsEciJjH73h/brkOjwYptAGb7y7zY
	dEBEq87T2/hjb8FL6SakOAbdkBpXDlpe2iXMU7SuSH0jOFSMwWwr6yU85nvi6dg=
X-Gm-Gg: ASbGnctJ30BuWYZmLiAgOrXH1Nnk9QY71pMAtNzWzNezVLsWAstAA3i7OYE8XblSdsD
	i8R2vcnlyms7id3zZZLrcc/Qw9f735AyiMBoHBm79sVMKg8Hinxt2ZSCOzfquwiX6jt1vJNjoy1
	e7NyocFjtz603Ij+4HiL5udG7bcMr3ewycsc5G+IbUuWxmfDCER8i1FDIpI09PzyVK0q10Gkbj9
	1MYc3JpfeskDI8/Pn1vVz0Xj4CeJX/Qr5388GukINfosha6VmTIFpnEB3++fyyjdIOqIJAf
X-Google-Smtp-Source: AGHT+IHs71kAYwenD3rmejVx1DT3G2P3qd0Q/PAn7I4VjVL2cLAnBqs8ox5OjQ53hiHzQAZR/Rtpzw==
X-Received: by 2002:a5d:64e9:0:b0:385:e8ce:7494 with SMTP id ffacd0b85a97d-385e8ce75e1mr693291f8f.31.1732960980289;
        Sat, 30 Nov 2024 02:03:00 -0800 (PST)
Received: from localhost (h1109.n1.ips.mtn.co.ug. [41.210.145.9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c11d0sm261875266b.16.2024.11.30.02.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2024 02:02:59 -0800 (PST)
Date: Sat, 30 Nov 2024 13:02:56 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Nilesh Javali <njavali@marvell.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Subject: [bug report] [SCSI] iscsi_transport: Add support to display CHAP
 list and delete CHAP entry
Message-ID: <01b69135-e06b-4797-bb3f-95e537e06689@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[ This code is obviously really old, but the warning may still be worth looking
  at.  -dan ]

Commit 6260a5d22122 ("[SCSI] iscsi_transport: Add support to display
CHAP list and delete CHAP entry") from Feb 27, 2012 (linux-next),
leads to the following Smatch static checker warning:

	drivers/scsi/scsi_transport_iscsi.c:3341 iscsi_get_chap()
	warn: potential user controlled sizeof overflow '56 + chap_buf_size' '56 + 0-u32max'

drivers/scsi/scsi_transport_iscsi.c
    3319 static int
    3320 iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
    3321 {
    3322         struct iscsi_uevent *ev = nlmsg_data(nlh);

Smatch marks nlmsg_data() as untrusted.

    3323         struct Scsi_Host *shost = NULL;
    3324         struct iscsi_chap_rec *chap_rec;
    3325         struct iscsi_internal *priv;
    3326         struct sk_buff *skbchap;
    3327         struct nlmsghdr *nlhchap;
    3328         struct iscsi_uevent *evchap;
    3329         uint32_t chap_buf_size;
    3330         int len, err = 0;
    3331         char *buf;
    3332 
    3333         if (!transport->get_chap)
    3334                 return -EINVAL;
    3335 
    3336         priv = iscsi_if_transport_lookup(transport);
    3337         if (!priv)
    3338                 return -EINVAL;
    3339 
    3340         chap_buf_size = (ev->u.get_chap.num_entries * sizeof(*chap_rec));

This warning is for 32 bits but it affects 64bit as well because chap_buf_size
is a u32.  Potentially this "ev->u.get_chap.num_entries * sizeof(*chap_rec)"
multiply could integer wrap.

--> 3341         len = nlmsg_total_size(sizeof(*ev) + chap_buf_size);

Then nlmsg_total_size() has some addition and the + sizeof(*ev) as well and len
is stored as an int.

    3342 
    3343         shost = scsi_host_lookup(ev->u.get_chap.host_no);
    3344         if (!shost) {
    3345                 printk(KERN_ERR "%s: failed. Could not find host no %u\n",
    3346                        __func__, ev->u.get_chap.host_no);
    3347                 return -ENODEV;
    3348         }
    3349 
    3350         do {
    3351                 int actual_size;
    3352 
    3353                 skbchap = alloc_skb(len, GFP_KERNEL);
    3354                 if (!skbchap) {
    3355                         printk(KERN_ERR "can not deliver chap: OOM\n");
    3356                         err = -ENOMEM;
    3357                         goto exit_get_chap;
    3358                 }
    3359 
    3360                 nlhchap = __nlmsg_put(skbchap, 0, 0, 0,
    3361                                       (len - sizeof(*nlhchap)), 0);
    3362                 evchap = nlmsg_data(nlhchap);
    3363                 memset(evchap, 0, sizeof(*evchap));
    3364                 evchap->transport_handle = iscsi_handle(transport);
    3365                 evchap->type = nlh->nlmsg_type;
    3366                 evchap->u.get_chap.host_no = ev->u.get_chap.host_no;
    3367                 evchap->u.get_chap.chap_tbl_idx = ev->u.get_chap.chap_tbl_idx;
    3368                 evchap->u.get_chap.num_entries = ev->u.get_chap.num_entries;
    3369                 buf = (char *)evchap + sizeof(*evchap);
    3370                 memset(buf, 0, chap_buf_size);
    3371 
    3372                 err = transport->get_chap(shost, ev->u.get_chap.chap_tbl_idx,
    3373                                     &evchap->u.get_chap.num_entries, buf);
    3374 
    3375                 actual_size = nlmsg_total_size(sizeof(*ev) + chap_buf_size);
    3376                 skb_trim(skbchap, NLMSG_ALIGN(actual_size));
    3377                 nlhchap->nlmsg_len = actual_size;
    3378 
    3379                 err = iscsi_multicast_skb(skbchap, ISCSI_NL_GRP_ISCSID,
    3380                                           GFP_KERNEL);
    3381         } while (err < 0 && err != -ECONNREFUSED);
    3382 
    3383 exit_get_chap:
    3384         scsi_host_put(shost);
    3385         return err;
    3386 }

regards,
dan carpenter
