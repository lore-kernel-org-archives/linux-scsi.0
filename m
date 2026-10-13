Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2858754280E
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 20:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791921718; cv=none; b=QLq1CmoBw7k/aTERGkukErFcVgHeagsYRn64CGXGURyQOa7Mo3+Do/DiU+R1zBLNhQcmFiSxKI5VLJ/poFRN2YOYqJjeoHjGhMaxAEVjqgJ+YkzLA3ks1VyjHmy4OUv9Pyaf1rwmSGxsg5IU/8KotJXD8zm+1HcbHiAXm8awo9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791921718; c=relaxed/simple;
	bh=/izqz40VXBlpW0qcM4QF3vYtb+/PT5jDDQQIqDej7xk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W2TlBtAlWFClGW+H6VemSr50pQt943lkLUyaQBAb2RqEmx5oEeX7NuRvIL6b0WcnR4Q5jiUrDJcHVb2vy9NDLf5Twae3+tUXfqzdw2g+tIVS6SFswrdw/7ZFaxCAbTdWTsB43pzzfpc9wmkqNPUSh93s7Lp6nCtlRa2mUQV8XV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7Wq/45k; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7Wq/45k"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5e507e778e4so1166313e0c.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 13:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791921716; x=1792526516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VW6hYhITJ+QWyRCt3/5JTfJa8aq7MKO68khIl7lYUr0=;
        b=f7Wq/45kW0+I3WlB22p2V91DiZrJca7zpnVO4eaoywWNXDwnBLvSJ5Mcit2lEv8d9C
         PBsvve+uEgwlBoQ/O83vV9FM9AdVw/hdSrILr4sJwwXvTyUdxQSCkMzW//p55NdLl3tu
         b4MBohqiFyjgbeUlQLC0j5y76nR7okaG+15WM7F0Q0rIWRy6V/f68nigcHNJWXqQBe0V
         cm79Y5DOdtOcR2OYhfEkQMxbCltSsU+Imbk9XzWM5CaqsPaNQYqxjNCbkFLSYsiyZb7X
         eIPrXMLNEaX4n6A2Sh8CNzydS/Z1wfMNnjUb3vFAJpGxLGupB4NAEZ0/2ROnL0zRYuDz
         PuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791921716; x=1792526516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VW6hYhITJ+QWyRCt3/5JTfJa8aq7MKO68khIl7lYUr0=;
        b=pwVmVWOZV4bgy/gJGJUJwv5wv8DemkyTuch/kCZ4875GSrpjrgP7S7uOhL57grX8tL
         kT9Na9lB1HhRfiwkEkdNAnNIjSUwwVniA2OO1KZWQJS5MTol759rywmwGskXq0kumLhh
         4bJdSfaOFyZDtf9MeBPxryNlMGCtRaRVAmcz2D4nMtFtUUoOD91G90XAUefS9//AqVUv
         NYaYChi3oz26eyW/4cnE9RD6SORK7JWguOts2axCuicBykVYhCRM5lDzntBBAXsBpKCT
         KNJoFmMUEyO64oWHkh1kbajbqR/EMVR45qz+EnkbJk2kksCidnHcxRTXxxw+EoYg1ERu
         CtYg==
X-Forwarded-Encrypted: i=1; AKwUvBx5sLz3Qn1WYBnUoeXNIpTn64pVJWtN902EOG/5yhwME6D460ObUg12Mu1tMF8K3wcfUBrblhkt4PrN@vger.kernel.org
X-Gm-Message-State: AFq9FYLJbL2n4XHxZJpo1Lfr79EbPCuDwMnw0P5g1vkIrtkSI3CkCp4E
	7ESDm6t7Gc11JROXg0ELE91dRsTwmOnnhsVaiXjMxxOzMqJATv9z8Qoz
X-Gm-Gg: AYBFou3EJiLr+Rau8QRetGBUn7XjU8MicZ1BsyLNEjy/QDYjbOWVew6dIp4TwpBh7ww
	Ovz2SrWL7qSVS/zpOl7UUl9oQS+PDQlwrgsA6olpqe0c6q7a6u3QGC2ibiOTyrz7R+vjNXBSEIZ
	uMCVo9vrL/bjgJl8gP9XTzN5hwv0nbG2EticsxLshmr4E3CytMS4qFSwKI4o0e48mzSOVY1xdys
	+oD1R+EwJwqGOc/SUH4Kx4vvpYvLLNagyaGfnu4JpmAuo312djbv5SZlAmcqV4rQegDuV706aY4
	ZnKKEXu9gdbNA7ZtWPrYg7ju/iQZpyYvFKY4uMdAOiEDF9KQmMjNh5TKRYqXQOlrdiY2PHjVH7Y
	Q0T8zWLFjCNSvXDvDIgln3qwTA7iXGUjGUBv5FxnmMki2axjjKXe6RVJY5nNHeCuwN23JLKbTOX
	O+6iAyBBa3bi8wFz58G3JhwdEwT0baXpn+RbbzXp40w9CNt3FpR68AV2Xf3BY/ilPErWMBv2KnN
	Tn1lIOj81HAPWGrGtbfWM24
X-Received: by 2002:a05:6122:3284:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5e91f44f6b1mr4187999e0c.6.1791921716020;
        Tue, 13 Oct 2026 13:01:56 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b3864dsm33580156d6.14.2026.10.13.13.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:01:55 -0700 (PDT)
From: Dingisoul <dingiso.kernel@gmail.com>
To: loberman@redhat.com
Cc: James.Bottomley@HansenPartnership.com,
	dingiso.kernel@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	mkp@kernel.org
Subject: Re: [BUG] scsi: st: use-after-free race between st_remove() and st_open()/scsi_tape_get()
Date: Tue, 13 Oct 2026 16:01:48 -0400
Message-Id: <20261013200148.1942808-1-dingiso.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e5312492c3d90322f362b1b148f7dce4290c2ba1.camel@redhat.com>
References: <e5312492c3d90322f362b1b148f7dce4290c2ba1.camel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Laurence,

Applied your patch, rebuilt, and reran the original reproducer.
No KASAN report, no warnings, no panic across the whole run.

Looks good to me -- feel free to send it upstream.

Best,
Dingisoul

On your patch:
> Hello
>
> Please try this patch, let me know if it fixes this and I will send a
> follow up to finalize this fix.
>
>
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index f1c3c49466..d5b90bd1c6 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4509,11 +4509,11 @@ static void st_remove(struct scsi_device *SDp)
>  	remove_cdevs(tpnt);
>
>  	mutex_lock(&st_ref_mutex);
> -	kref_put(&tpnt->kref, scsi_tape_release);
> -	mutex_unlock(&st_ref_mutex);
>  	spin_lock(&st_index_lock);
>  	idr_remove(&st_index_idr, index);
>  	spin_unlock(&st_index_lock);
> +	kref_put(&tpnt->kref, scsi_tape_release);
> +	mutex_unlock(&st_ref_mutex);
>  }
