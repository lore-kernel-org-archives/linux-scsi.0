Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDAC3CF51;
	Thu, 23 May 2024 07:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716449144; cv=none; b=fDrbt9tUwvL1uzs2z7eYY3k6dyFqNY6TUY3KAtrXNqA8gretGue6QNKy5eFzxDCbRZIL9wYulfDn/GvyoTTovzv92APVDmuZnicWEhr/XpqbVK/iy3xyk4KXgetl0FWDkFcMK+KobL2o9dODg6zcRoMV3Q4Fk8rUcEmPk7z2PXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716449144; c=relaxed/simple;
	bh=OtoMM2EnLYopfSClknn+vskVbP9LcVlEYgkZXxAy70o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSjTOXv6vn67eCfTtkH0Il/sihfgDfnfoznIAeMl/ZACq3uqn0Eu4NjQUuAPAhjOp2GZI39xBGdrtTIkWBReCgcEBZv8LcObnJOQowwQSaVBvOxm5EXVGptn2ndX5O+YRHLUxWAHVQMuZVTrMm1IfEbSFTEkctb1nm/LEyiBIYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2ra1qxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2ra1qxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD25C2BD10;
	Thu, 23 May 2024 07:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716449143;
	bh=OtoMM2EnLYopfSClknn+vskVbP9LcVlEYgkZXxAy70o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l2ra1qxB1P/JpnSBpEDFO9rzUWGpdqdI0rJMLESTsydrLtm6zEvZ1rDRQlxHxootq
	 oIm5al4hs9GIeWOLK7hRRSOZ/d8US5HPO5xVjkiiXnsyaT1aP9LxqPhSkRuSdq0MVT
	 jTSh6RT+fM5EkJuEL4KvFIK+uODE3h8jvwIi3qf4=
Date: Thu, 23 May 2024 09:25:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: yangxingui <yangxingui@huawei.com>
Cc: rafael@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	prime.zeng@hisilicon.com, liyihang9@huawei.com,
	kangfenglong@huawei.com
Subject: Re: [PATCH] driver core: Add log when devtmpfs create node failed
Message-ID: <2024052316-confused-payback-5658@gregkh>
References: <20240522114346.42951-1-yangxingui@huawei.com>
 <2024052221-pulverize-worrisome-37fb@gregkh>
 <794b5fa3-0135-80cc-4b55-f48a430a58ca@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <794b5fa3-0135-80cc-4b55-f48a430a58ca@huawei.com>

On Thu, May 23, 2024 at 09:50:09AM +0800, yangxingui wrote:
> Hi, Greg
> 
> On 2024/5/22 20:23, Greg KH wrote:
> > On Wed, May 22, 2024 at 11:43:46AM +0000, Xingui Yang wrote:
> > > Currently, no exception information is output when devtmpfs create node
> > > failed, so add log info for it.
> > 
> > Why?  Who is going to do something with this?
> We execute the lsscsi command after the disk is connected, we occasionally
> find that some disks do not have dev nodes and these disks cannot be used.

Ok, but why do you think that devtmpfs create failed?

> However, there is no abnormal log output during disk scanning. We analyze
> that it may be caused by the failure of devtmpfs create dev node, so the log
> is added here.

But is that the case?  Why is devtmpfs failing?  Shouldn't we fix that
instead?

> The lscsi command query results and kernel logs as follows:
> 
> [root@localhost]# lsscsi
> [9:0:4:0]	disk	ATA	ST10000NM0086-2A SN05	-
> 
> kernel: [586669.541218] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0
> link_rate=10(sata)
> kernel: [586669.541341] sas: phy-9:0 added to port-9:0, phy_mask:0x1
> (5000000000000900)
> kernel: [586669.541511] sas: DOING DISCOVERY on port 0, pid:2330731
> kernel: [586669.541518] hisi_sas_v3_hw 0000:b4:04.0: dev[4:5] found
> kernel: [586669.630816] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> kernel: [586669.665960] hisi_sas_v3_hw 0000:b4:04.0: phydown: phy0
> phy_state=0xe
> kernel: [586669.665964] hisi_sas_v3_hw 0000:b4:04.0: ignore flutter phy0
> down
> kernel: [586669.863360] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0
> link_rate=10(sata)
> kernel: [586670.024482] ata19.00: ATA-10: ST10000NM0086-2AA101, SN05, max
> UDMA/133
> kernel: [586670.024487] ata19.00: 19532873728 sectors, multi 16: LBA48 NCQ
> (depth 32), AA
> kernel: [586670.027471] ata19.00: configured for UDMA/133
> kernel: [586670.027490] sas: --- Exit sas_scsi_recover_host: busy: 0 failed:
> 0 tries: 1
> kernel: [586670.037541] sas: ata19: end_device-9:0:
> model:ST10000NM0086-2AA101 serial:            ZA2B3PR2
> kernel: [586670.100856] scsi 9:0:4:0: Direct-Access     ATA ST10000NM0086-2A
> SN05 PQ: 0 ANSI: 5
> kernel: [586670.101114] sd 9:0:4:0: [sdk] 19532873728 512-byte logical
> blocks: (10.0 TB/9.10 TiB)
> kernel: [586670.101116] sd 9:0:4:0: [sdk] 4096-byte physical blocks
> kernel: [586670.101125] sd 9:0:4:0: [sdk] Write Protect is off
> kernel: [586670.101137] sd 9:0:4:0: [sdk] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> kernel: [586670.101620] sd 9:0:4:0: Attached scsi generic sg10 type 0
> kernel: [586670.101714] sas: DONE DISCOVERY on port 0, pid:2330731, result:0
> kernel: [586670.101731] sas: sas_form_port: phy0 belongs to port0
> already(1)!
> kernel: [586670.152512] sd 9:0:4:0: [sdk] Attached SCSI disk

Looks like sdk was found properly, what's the problem?

> 
> > 
> > > 
> > > Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> > > ---
> > >   drivers/base/core.c | 5 ++++-
> > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > > index 5f4e03336e68..32a41e0472b2 100644
> > > --- a/drivers/base/core.c
> > > +++ b/drivers/base/core.c
> > > @@ -3691,7 +3691,10 @@ int device_add(struct device *dev)
> > >   		if (error)
> > >   			goto SysEntryError;
> > > -		devtmpfs_create_node(dev);
> > > +		error = devtmpfs_create_node(dev);
> > > +		if (error)
> > > +			pr_info("devtmpfs create node for %s failed: %d\n",
> > > +				dev_name(dev), error);
> > 
> > Why is an error message pr_info()?
> Do you recommend using pr_err()?

Do not print errors at the information level :)

> > And again, why is this needed?  If this needs to be checked, why are you
> > now checking it but ignoring the error?
> > 
> > What would this help with?
> As above, we want to get the error info when the dev node fails to be
> created. We currently haven't figured out how to handle this exception well.
> But judging from the problems we are currently encountering, some may be
> because the corresponding dev node already exists, causing the creation to
> fail, but the node information is incorrect and the device cannot be used.
> as follows:
> [root@localhost]# ll /dev/sdk
> -rw-------. 1 root root 5368709120 Jul 8 09:51 /dev/sdk

Looks like the device node is created to me.  What is incorrect about
it, the values?  What is 'll' an alias for?  And are you sure that other
tools aren't getting the device node creation uevent and doing something
with it in userspace?  How do you know this is the kernel failing?

Wait, is /dev/sdk really a device node and not a file?  Perhaps
something else wrote to it first, before it was created?  And that's why
devtmpfs couldn't create it.  That sounds like a userspace error,
nothing the kernel can do about it.

thanks,

greg k-h
