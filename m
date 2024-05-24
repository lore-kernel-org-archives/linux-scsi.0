Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE6E1AACC
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 10:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546216; cv=none; b=bxCUOlnMHTSo63cx19WoAzJ4bD4TUzhSp2LYRf6hRufz95Qa/fqbVe0VGSLe15PR+RzVuZyv8tjaJUXEnhqJaEv0V7EitAIi8NjMAQH+zbt9cFsluub47ejMUs8tteUr6ONMT3C6qa6K1XFTW4EIVxzqU9MWtTEP9YVj4AMKV3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546216; c=relaxed/simple;
	bh=Hp62JRH7fBFDHTu8z2+KieVTNS7vV6kL4JD+Ttwjm8g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RSX3Q6uB6hbLAwdiJn3yc+oWFjOBqA6kuYpjRlVlHgANjDXayPrK5u+ROFEIm6IABOxIANn67blJpeu02WUwD/MWnsOFSItlcZnfKSv9dn8UmFcPaUEGh/2IKtfsqmpm4OrVmIPIZaIavCO70/6GpLYLIBXUkCJUyT5D3qcZgSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Put+Tq49; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Put+Tq49"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-351d309bbecso5942794f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 03:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716546213; x=1717151013; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j9qYGdI05rHlt3uGBuCNSns/bXUWAMsuc0IhCnTGmHk=;
        b=Put+Tq49jpP+AFpo9pu6xteEpJqcZq+c7jIbt7p7wmp1PhX7+PbiYcgxEYlNFfhkjp
         2frbWlMLIjg2XfTb46nXS0dsSSgukHpAdjFPXP9amZDvjZCejFnTK/Y42UdmizxjiIig
         ZCej/ymXuHPbN1J17ekiHBERTx8GeyOV+p7NqNm8tV8bFO8u2BN/vJSmRxPD4UE/Q7/x
         gGB8Jdew4eOMwTLgtFaacCGsGHMASi4eiIK84mElQyk/n62zSLAs7pHW/ePiePj+7ODm
         t6gXsn/VoyvdZcM+S64nxE6YeBWjvSPD7YZlBddMjbkUOhhmlnzgXbohbHSgCb8gL5ZX
         nEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716546213; x=1717151013;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9qYGdI05rHlt3uGBuCNSns/bXUWAMsuc0IhCnTGmHk=;
        b=MwwDaZA1y4G46eGc16YMTyODdh8Bh8T0ZZ22c3H+5imm5jQqB5TsHXQEThyPeaDmDG
         cBCd7+2dMZ3jNptkTbiD8Jm879NO7TvHSwRAaBypIHNpBQojwsuICI5nwiPC7bvR8HvR
         qsuX5LMYvWSARu4oSeO2Kw1sukLxgxLVa1SCcmBcj7BqijohgSEf8BV4SYJ5PvQAZnTK
         9a9YKa97P5nCPSk49lT8oQnyhobtsHrcoL/fjmwtIloDpVm2KzoL1sjsAczEiIVCN6Gl
         BvKAPxCKQyPD4dvCajg0H9CFcu/ai9gOib35ouECC4nOMyy9WIG+CRMtzJdIYx5U4Ev5
         f0ww==
X-Forwarded-Encrypted: i=1; AJvYcCUHmtTmbPQfUoJRZMZS1TzIjYRcvRln+xx3AvZtpl+SUWcqCYlLWt5R4GScdcegFHaTmItH0gm+HDDFF3kiFJje0B6SSZL08vtsbw==
X-Gm-Message-State: AOJu0YyJHff+GKQN1DM5MU4kH4o/7K5lLPUnHj/TvW0GOsSXm3f+KQYY
	HHY3xzUAKXqa8RCXFq1O73G4UIsyVX2vurhyXd51YlUH7CaZTo7uMRKAb1ijVpM=
X-Google-Smtp-Source: AGHT+IEncD44/P2Gy3Hq3Kxz3mOKCL0EIO460sPzqVblgji/kygEVNnuVuxfLVfBfIL3bfT/t4P7Ew==
X-Received: by 2002:adf:ce06:0:b0:354:f2b0:ebda with SMTP id ffacd0b85a97d-35527056594mr1545790f8f.10.1716546213123;
        Fri, 24 May 2024 03:23:33 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35586a15c2bsm1263579f8f.113.2024.05.24.03.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 03:23:32 -0700 (PDT)
Date: Fri, 24 May 2024 13:23:29 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: thenzl@redhat.com
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpi3mr: Sanitise num_phys
Message-ID: <d5823d3c-3761-457f-82e9-a910c7c9aee2@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Tomas Henzl,

Commit 3668651def2c ("scsi: mpi3mr: Sanitise num_phys") from Feb 26,
2024 (linux-next), leads to the following Smatch static checker
warning:

	drivers/scsi/mpi3mr/mpi3mr_transport.c:1371 mpi3mr_sas_port_add()
	warn: array off by one? 'mr_sas_node->phy[i]'

drivers/scsi/mpi3mr/mpi3mr_transport.c
    1352         mr_sas_port->hba_port = hba_port;
    1353         mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
    1354             mr_sas_port->remote_identify.sas_address, hba_port);
    1355 
    1356         if (mr_sas_node->num_phys > sizeof(mr_sas_port->phy_mask) * 8)
    1357                 ioc_info(mrioc, "max port count %u could be too high\n",
    1358                     mr_sas_node->num_phys);
    1359 
    1360         for (i = 0; i < mr_sas_node->num_phys; i++) {
    1361                 if ((mr_sas_node->phy[i].remote_identify.sas_address !=
    1362                     mr_sas_port->remote_identify.sas_address) ||
    1363                     (mr_sas_node->phy[i].hba_port != hba_port))
    1364                         continue;
    1365 
    1366                 if (i > sizeof(mr_sas_port->phy_mask) * 8) {
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This check is wrong.  It should be >=.  But also ->phy_mask is a u64
when probably it should be a u32.

    1367                         ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
    1368                             i, sizeof(mr_sas_port->phy_mask) * 8);
    1369                         goto out_fail;
    1370                 }
--> 1371                 list_add_tail(&mr_sas_node->phy[i].port_siblings,
    1372                     &mr_sas_port->phy_list);
    1373                 mr_sas_port->num_phys++;
    1374                 mr_sas_port->phy_mask |= (1 << i);
                                                   ^^^^^^
There are a bunch of "1 << i" shifts in this file and they'll shift wrap
if i >= 32.  Then the ->phy_mask is tested with ffs() which takes an
int.  So everything above bit 31 is not going to work.

    1375         }
    1376 
    1377         if (!mr_sas_port->num_phys) {
    1378                 ioc_err(mrioc, "failure at %s:%d/%s()!\n",
    1379                     __FILE__, __LINE__, __func__);
    1380                 goto out_fail;
    1381         }

regards,
dan carpenter
