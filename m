From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [EXT] [PATCH 2/3] scsi: ufs: Allow resetting the UFS device
Date: Tue, 4 Jun 2019 15:30:25 -0700
Message-ID: <20190604223025.GD4814@minitux>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <20190604072001.9288-3-bjorn.andersson@linaro.org>
 <BN7PR08MB568450B1EC51ABAA2E426AC0DB150@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BN7PR08MB568450B1EC51ABAA2E426AC0DB150@BN7PR08MB5684.namprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue 04 Jun 01:13 PDT 2019, Bean Huo (beanhuo) wrote:
> >@@ -6159,6 +6179,9 @@ static int ufshcd_reset_and_restore(struct ufs_hba
> >*hba)
> > 	int retries = MAX_HOST_RESET_RETRIES;
> >
> > 	do {
> >+		/* Reset the attached device */
> >+		ufshcd_device_reset(hba);
> >+
> 
> what's problem you met, and you should reset UFS device here? could you give more info?
> 
> It is true that we don't reset UFS device in case of device fatal error. According to UFS host spec,
> Host should be device reset except that in addition to resetting UIC. But as so far,
> We didn't experience any problems result from this missing reset.
> 
> We have three UFS device reset ways.  Comparing to this hardware reset, 
> I prefer to use DME_ENDPOINTRESET.req software reset.
> 

Hi Bean,

Thanks for your questions. With some memories we see issues establishing
the link during bootup, so that's the purpose of issuing this reset.

Unfortunately the downstream Qualcomm patch [1] (which I should have
remembered to attribute), does not mention why the reset during host
controller reset is needed - but I'm fairly certain that this scenario
would be similar to the handover from bootloader to kernel that we do
see an issue with.


[1] https://source.codeaurora.org/quic/la/kernel/msm-4.4/commit/?h=msm-4.4&id=0c82737188e2d63a08196e078e411032dbbc3b89

Regards,
Bjorn
