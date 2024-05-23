Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4278C8B;
	Thu, 23 May 2024 09:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716456945; cv=none; b=rB/zrQLSEk3O7BYaCMDV77NbVq1W/6un419j8eK6qJXJ2idObyXCy7E2FnFdC5yjHkg6V9HlkolZ+Ud1ccv3mHjkJK3V0/5bwes6UGDWCJpSsQPw04fP4p5Vv6JVnyWf8F7oiY2lQ4Ys0pz4VM9RT6z+4Y9YfCY72knfow7clC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716456945; c=relaxed/simple;
	bh=gUFYD+H6fjG94sAYR9rMeCjL/q0ruoo74U+lISGMCMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUGy+2Ypb58QAfshUGgr+CXqki3FGiRVtX9lKv3JQvYy+jnA8WRUAqhcK/JWmbxKZrUyLyIkB/CNnbKrE1GdxoaLYOV6u0WJRSMrVQMrf9IXGwZY9XwlsZiWvPRci1xjrirCBDLAsbnoKq/esrseKQOmQ889IUp8JQQbxKZGEso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0i+HBp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0i+HBp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E77DC3277B;
	Thu, 23 May 2024 09:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716456944;
	bh=gUFYD+H6fjG94sAYR9rMeCjL/q0ruoo74U+lISGMCMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p0i+HBp7xrV8/YlymDXIf/TUrqbmRJ32NK0OgPTE+pqffTAkoGV5+dDGAqOwK5Hzr
	 7JNeffpuZshUweYnrZC1q7Ssis8f+OSfm8wtTJyv0qLZFn9D78MGRPFJPXhnAFrnJF
	 pCLUy60d/0F/FCuWsw1lFwGbmcufs4+4pW0HY6OI=
Date: Thu, 23 May 2024 11:35:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: yangxingui <yangxingui@huawei.com>
Cc: rafael@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	prime.zeng@hisilicon.com, liyihang9@huawei.com,
	kangfenglong@huawei.com
Subject: Re: [PATCH] driver core: Add log when devtmpfs create node failed
Message-ID: <2024052354-legibly-willow-7134@gregkh>
References: <20240522114346.42951-1-yangxingui@huawei.com>
 <2024052221-pulverize-worrisome-37fb@gregkh>
 <794b5fa3-0135-80cc-4b55-f48a430a58ca@huawei.com>
 <2024052316-confused-payback-5658@gregkh>
 <68b110da-ea20-fa03-be26-49dd3a04f835@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b110da-ea20-fa03-be26-49dd3a04f835@huawei.com>

On Thu, May 23, 2024 at 05:23:07PM +0800, yangxingui wrote:
> Hi Greg,
> 
> On 2024/5/23 15:25, Greg KH wrote:
> > On Thu, May 23, 2024 at 09:50:09AM +0800, yangxingui wrote:
> > > Hi, Greg
> > > 
> > > On 2024/5/22 20:23, Greg KH wrote:
> > > > On Wed, May 22, 2024 at 11:43:46AM +0000, Xingui Yang wrote:
> > > > > Currently, no exception information is output when devtmpfs create node
> > > > > failed, so add log info for it.
> > > > 
> > > > Why?  Who is going to do something with this?
> > > We execute the lsscsi command after the disk is connected, we occasionally
> > > find that some disks do not have dev nodes and these disks cannot be used.
> > 
> > Ok, but why do you think that devtmpfs create failed?
> I found that lsscsi will traverse the dev node and obtain device major and
> min. If no matching dev node is found, it will display "-       ".
> > 
> > > However, there is no abnormal log output during disk scanning. We analyze
> > > that it may be caused by the failure of devtmpfs create dev node, so the log
> > > is added here.
> > 
> > But is that the case?  Why is devtmpfs failing?  Shouldn't we fix that
> > instead?
> My subsequent reply touches on these points.
> > 
> > > The lscsi command query results and kernel logs as follows:
> > > 
> > > [root@localhost]# lsscsi
> > > [9:0:4:0]	disk	ATA	ST10000NM0086-2A SN05	-
> > > 
> > > kernel: [586669.541218] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0
> > > link_rate=10(sata)
> > > kernel: [586669.541341] sas: phy-9:0 added to port-9:0, phy_mask:0x1
> > > (5000000000000900)
> > > kernel: [586669.541511] sas: DOING DISCOVERY on port 0, pid:2330731
> > > kernel: [586669.541518] hisi_sas_v3_hw 0000:b4:04.0: dev[4:5] found
> > > kernel: [586669.630816] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> > > kernel: [586669.665960] hisi_sas_v3_hw 0000:b4:04.0: phydown: phy0
> > > phy_state=0xe
> > > kernel: [586669.665964] hisi_sas_v3_hw 0000:b4:04.0: ignore flutter phy0
> > > down
> > > kernel: [586669.863360] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0
> > > link_rate=10(sata)
> > > kernel: [586670.024482] ata19.00: ATA-10: ST10000NM0086-2AA101, SN05, max
> > > UDMA/133
> > > kernel: [586670.024487] ata19.00: 19532873728 sectors, multi 16: LBA48 NCQ
> > > (depth 32), AA
> > > kernel: [586670.027471] ata19.00: configured for UDMA/133
> > > kernel: [586670.027490] sas: --- Exit sas_scsi_recover_host: busy: 0 failed:
> > > 0 tries: 1
> > > kernel: [586670.037541] sas: ata19: end_device-9:0:
> > > model:ST10000NM0086-2AA101 serial:            ZA2B3PR2
> > > kernel: [586670.100856] scsi 9:0:4:0: Direct-Access     ATA ST10000NM0086-2A
> > > SN05 PQ: 0 ANSI: 5
> > > kernel: [586670.101114] sd 9:0:4:0: [sdk] 19532873728 512-byte logical
> > > blocks: (10.0 TB/9.10 TiB)
> > > kernel: [586670.101116] sd 9:0:4:0: [sdk] 4096-byte physical blocks
> > > kernel: [586670.101125] sd 9:0:4:0: [sdk] Write Protect is off
> > > kernel: [586670.101137] sd 9:0:4:0: [sdk] Write cache: enabled, read cache:
> > > enabled, doesn't support DPO or FUA
> > > kernel: [586670.101620] sd 9:0:4:0: Attached scsi generic sg10 type 0
> > > kernel: [586670.101714] sas: DONE DISCOVERY on port 0, pid:2330731, result:0
> > > kernel: [586670.101731] sas: sas_form_port: phy0 belongs to port0
> > > already(1)!
> > > kernel: [586670.152512] sd 9:0:4:0: [sdk] Attached SCSI disk
> > 
> > Looks like sdk was found properly, what's the problem?
> 
> Yes, this problem occurs occasionally. There is no exception log when
> scanning the disk, but the disk cannot be used. It has been confirmed that
> it is related to fio testing. When the dev node does not exist, fio may
> actively create this file.

So that's a userspace issue.  If a device node is to be created, and the
file is already present with that name, yes, we will fail to create it
as obviously userspace did not want us to do so.

It's not the kernel's job to protect userspace from doing foolish things
itself, right?  :)

> If we want to solve this problem, should we delete the existing files first
> when creating a dev node?

No.

> Or just print a prompt indicating that the dev node creation failed.

We can do that, but will that cause error messages to be printed out for
normal situations today where userspace does this on purpose?

Again, this isn't fixing the root problem here (which is userspace doing
something it shouldn't be doing), adding kernel log messages might be
just noise at this point in time given that it has been operating this
way for many years, if not decades.

thanks,

greg k-h
