Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E0A48796;
	Wed, 20 Dec 2023 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKH/wHmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A28C433C7;
	Wed, 20 Dec 2023 16:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703091560;
	bh=4xSZvOl2jNnGPB55oT3vn5pJgGBIM38TKMk27Nc5WvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lKH/wHmjCYTt/bcUgP2JZMyhl8oXU0FjgUmRNuNi/45pEv4X92RnIfqcC5mhEEuVS
	 8CVEnymxUxsSfxdE6KrujRz3omBY8ph/SOiWoUigXwc9EdHyHhsQNmYsoaS2QNxXyx
	 Yvpk6VFvFhOn/gvOz+IzDlMeqV7SIKpmgT27setLkMRu9gOPbSn27oeaPprra2GFlz
	 A9zW10MYOFbk4bPxBu082aqAn3tmFHElhtAJ2CQlTWENTL1Rg5m3gfm6SJ1BZRdZQl
	 4hDMKjFgchERR+KUbgiIs4tx0Wv2rfMwXfxvIRzMaPgJGRivuJT2YiWjH/vOG97Txu
	 1nMoDvLkEiOMA==
Date: Wed, 20 Dec 2023 22:29:05 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, stable@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: Re: [PATCH 1/2] scsi: ufs: Simplify power management during async
 scan
Message-ID: <20231220165905.GM3544@thinkpad>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-2-bvanassche@acm.org>
 <20231220144241.GG3544@thinkpad>
 <19c10384-8b08-4f9d-af74-7f09737b02a6@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19c10384-8b08-4f9d-af74-7f09737b02a6@acm.org>

On Wed, Dec 20, 2023 at 08:36:28AM -0800, Bart Van Assche wrote:
> On 12/20/23 06:42, Manivannan Sadhasivam wrote:
> > On Mon, Dec 18, 2023 at 02:52:14PM -0800, Bart Van Assche wrote:
> > > ufshcd_init() calls pm_runtime_get_sync() before it calls
> > > async_schedule(). ufshcd_async_scan() calls pm_runtime_put_sync()
> > > directly or indirectly from ufshcd_add_lus(). Simplify
> > > ufshcd_async_scan() by always calling pm_runtime_put_sync() from
> > > ufshcd_async_scan().
> > > 
> > > Cc: stable@vger.kernel.org
> > 
> > No fixes tag?
> 
> There is no Fixes: tag because this patch does not change the behavior of
> the UFS driver. The Cc: stable tag is present because the next patch in this
> series has a Fixes: tag and depends on this patch.
> 

Ok.

- Mani

> Thanks,
> 
> Bart.

-- 
மணிவண்ணன் சதாசிவம்
