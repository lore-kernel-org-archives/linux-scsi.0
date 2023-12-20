Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2E4645F
	for <linux-scsi@vger.kernel.org>; Wed, 20 Dec 2023 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+/W2IcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD421C433C7;
	Wed, 20 Dec 2023 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703091379;
	bh=p6Lsl/vtqWUJxL81PVjouNWp7eqV6+3Q3aqucmEvmmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+/W2IcZGW7UtT2PW7oLeKQ3n6cOiAWV1F+vLrx9zlvux/DJEzMMYeiSfDnLpAn6f
	 429PJgexkGh1UkacZGcGNwUnD9ZvAGx2cxaZugbbP+nHlM5+h9KlIsq+BzCwlXXOGm
	 2mat/2l4MdYZjAEETp64JV1HZDk3H/bVYh//+z2JV27vPcOrmP+6aX4oQhPYWymN7j
	 SNefFgLZGXC6oMlUGDcf07FDyqIUpSti/xT4OgBimn+95D9gJEHerBMvcQMeehRadm
	 pbcAcW0XsqYWzc/9Fs3jGIjN7xWkqG4GLHPmYY/5ZQXVnGcw6dFJovFd6Nrspp0oUC
	 ESAXx8nL3KqYQ==
Date: Wed, 20 Dec 2023 22:26:04 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Avri Altman <avri.altman@wdc.com>, Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Remove the ufshcd_hba_exit() call from
 ufshcd_async_scan()
Message-ID: <20231220165604.GL3544@thinkpad>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-3-bvanassche@acm.org>
 <20231220144813.GH3544@thinkpad>
 <fd0b2b2e-c6f6-4b0e-a092-8ed79af1fb45@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd0b2b2e-c6f6-4b0e-a092-8ed79af1fb45@acm.org>

On Wed, Dec 20, 2023 at 08:44:21AM -0800, Bart Van Assche wrote:
> On 12/20/23 06:48, Manivannan Sadhasivam wrote:
> > On Mon, Dec 18, 2023 at 02:52:15PM -0800, Bart Van Assche wrote:
> > > Calling ufshcd_hba_exit() from a function that is called asynchronously
> > > from ufshcd_init() is wrong because this triggers multiple race
> > > conditions. Instead of calling ufshcd_hba_exit(), log an error message.
> > 
> > This also means that during failure, resources will not be powered OFF. IMO, a
> > justification is needed why it is OK to left them powered ON.
> 
> I have never seen ufshcd_async_scan() fail other than during hardware bringup.
> Has anyone else ever observed a ufshcd_async_scan() failure?
> 
> > > Reported-by: Daniel Mentz <danielmentz@google.com>
> > > Fixes: 1d337ec2f35e ("ufs: improve init sequence")
> > 
> > No need to backport this patch?
> 
> Isn't the "Fixes:" tag sufficient? I don't think that it it necessary to add a
> "Cc: stable" tag if a "Fixes:" tag is present.
> 

No. You need to explicitly CC stable list, if you want the commit to be
backported to stable releases. Even though the stable maintainers backport the
commits with Fixes tag, it is always strongly advised to explictly CC stable
list.

Here is an excerpt from Documentation/process/stable-kernel-rules.rst:

"There are three options to submit a change to -stable trees:

 1. Add a 'stable tag' to the description of a patch you then submit for
    mainline inclusion.
 2. Ask the stable team to pick up a patch already mainlined.
 3. Submit a patch to the stable team that is equivalent to a change already
    mainlined.

The sections below describe each of the options in more detail.

:ref:`option_1` is **strongly** preferred, it is the easiest and most common."

- Mani
> Thanks,
> 
> Bart.

-- 
மணிவண்ணன் சதாசிவம்
